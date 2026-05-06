#!/usr/bin/env bash
# AgentCharter — Charter Spec Lint (maintainer-only)
# Canonical version: v1.0 (charter v0.10.3)
# Canonical path: tools/charter-spec-lint.sh
#
# ── 用途 ────────────────────────────────────────────────────────────────────
# Lint charter spec / condition 結構合規（maintainer-only、採用方不需跑）。
# 對應 dogfood signal #46 family（spec 缺四欄結構 LLM simulated PASS）+ 雙軸
# matrix framing 第三段（v0.10.3 ship）。
#
# ── 校驗集 ────────────────────────────────────────────────────────────────
#
# L1: tools/*-spec.md 檢項 section 四欄結構偵測
#   每個 #### XXXX section（E\d+ / W\d+ / H\d+ / [A-E]\d{3+}）必含：
#     - 合規規定
#     - 修補方向
#     - 反例
#     - 真實 stdout 證據要求（或全 §3 段首通用紀律段）
#
# L2: core/*.md 雙軸 blockquote 偵測
#   每條 condition 檔案開頭 30 行 blockquote 必含：
#     - 保證強度 / 保證
#     - 檢測時點
#     - since
#
# ── 執行紀律 ──────────────────────────────────────────────────────────────
#
# maintainer 加新 condition / spec / hook 時、ship 前必跑本 lint 確認結構合規：
#   bash tools/charter-spec-lint.sh           # 跑全 lint（advisory）
#   bash tools/charter-spec-lint.sh --strict  # warn 升 error、CI 模式
#
# 0 violation 才 ship、對齊 maintainer-discipline §3 三層機制（工具層升維）。
# 採用方不裝、不跑、不影響 — 純 maintainer-side 工具。
#
# ── 變更歷史 ──────────────────────────────────────────────────────────────
# v1.0 (v0.10.3): 初版 — L1 (tool spec 四欄) + L2 (core 雙軸 blockquote)

set -e

CHARTER_DIR="$(git rev-parse --show-toplevel 2>/dev/null || echo "$PWD")"
STRICT_MODE=0

if [ "${1:-}" = "--strict" ]; then
    STRICT_MODE=1
fi

ERRORS=0
WARNINGS=0

red()    { printf "\033[31m%s\033[0m\n" "$1"; }
yellow() { printf "\033[33m%s\033[0m\n" "$1"; }
green()  { printf "\033[32m%s\033[0m\n" "$1"; }

# ── L1: Tool spec four-column structure check ───────────────────────────────
# Check each #### section in tools/*-spec.md has 合規規定 / 修補方向 / 反例 /
# 真實 stdout 證據要求（or doctor-spec §3 global stdout discipline applies）
lint_l1_tool_spec_four_columns() {
    echo "=== L1: tools/*-spec.md 四欄結構偵測 ==="

    local found_issue=0

    for spec in "$CHARTER_DIR/tools"/*-spec.md; do
        [ -f "$spec" ] || continue
        local rel_path="${spec#$CHARTER_DIR/}"

        # Check if spec has global stdout discipline段 (covers all checks below)
        local has_global_stdout=0
        if head -200 "$spec" | grep -qE "全.*§3.*適用紀律|全.*§3.*真實 stdout|stdout 證據要求.*全"; then
            has_global_stdout=1
        fi

        # Find sections matching ID pattern (e.g., #### E601 詳盡引導 / #### H1 — / #### A001)
        # Pattern: starts with "#### " then ID like E601, W901, H1, A001, B002, C003, D004
        local sections_found=0

        while IFS= read -r line; do
            [ -z "$line" ] && continue
            local line_num="${line%%:*}"
            local section_header="${line#*:}"
            sections_found=$((sections_found + 1))

            # Extract section ID
            local section_id
            section_id=$(echo "$section_header" | grep -oE "(E[0-9]+|W[0-9]+|H[0-9]+|[A-E][0-9]{3,}|REQ-[0-9]+)" | head -1)
            [ -z "$section_id" ] && continue

            # Read 80 lines after this section header (look in section body)
            local section_content
            section_content=$(sed -n "${line_num},$((line_num + 80))p" "$spec")

            local missing=""
            echo "$section_content" | grep -q "合規規定" || missing="$missing 合規規定"
            echo "$section_content" | grep -q "修補方向" || missing="$missing 修補方向"
            echo "$section_content" | grep -qE "反例|❌" || missing="$missing 反例"

            # 真實 stdout 證據要求 — 接受 section-local OR global discipline
            if ! echo "$section_content" | grep -qE "真實 stdout 證據要求|stdout 證據"; then
                if [ "$has_global_stdout" -eq 0 ]; then
                    missing="$missing 真實stdout"
                fi
            fi

            if [ -n "$missing" ]; then
                if [ "$found_issue" -eq 0 ]; then
                    echo ""
                    echo "  → $rel_path"
                    found_issue=1
                fi
                yellow "    ⚠️ $section_id (line $line_num) 缺欄位:$missing"
                WARNINGS=$((WARNINGS + 1))
            fi
        done < <(grep -nE "^####\s+(E[0-9]+|W[0-9]+|H[0-9]+|[A-E][0-9]{3,}|REQ-[0-9]+)" "$spec")

        # Reset found_issue flag for next file
        if [ "$found_issue" -eq 0 ] && [ "$sections_found" -gt 0 ]; then
            green "  ✅ $rel_path ($sections_found check items)"
        fi
        found_issue=0
    done
}

# ── L2: Core condition 雙軸 blockquote check ────────────────────────────────
# Each core/*.md should have blockquote in first 30 lines containing:
#   - 保證強度 (or 保證)
#   - 檢測時點
#   - since
lint_l2_core_dual_axis() {
    echo ""
    echo "=== L2: core/*.md 雙軸 blockquote 偵測 ==="

    local pass_count=0
    local fail_count=0

    for cond in "$CHARTER_DIR/core"/*.md; do
        [ -f "$cond" ] || continue
        local rel_path="${cond#$CHARTER_DIR/}"

        # Read first 30 lines
        local head_content
        head_content=$(head -30 "$cond")

        local missing=""
        echo "$head_content" | grep -qE "保證強度|保證" || missing="$missing 保證強度"
        echo "$head_content" | grep -q "檢測時點" || missing="$missing 檢測時點"
        echo "$head_content" | grep -qE "since|Since" || missing="$missing since"

        if [ -n "$missing" ]; then
            yellow "  ⚠️ $rel_path 缺雙軸 blockquote:$missing"
            WARNINGS=$((WARNINGS + 1))
            fail_count=$((fail_count + 1))
        else
            pass_count=$((pass_count + 1))
        fi
    done

    echo ""
    green "  ✅ Core conditions with dual-axis blockquote: $pass_count"
    if [ "$fail_count" -gt 0 ]; then
        yellow "  ⚠️ Core conditions missing dual-axis blockquote: $fail_count"
    fi
}

# Run all lints
lint_l1_tool_spec_four_columns
lint_l2_core_dual_axis

echo ""
echo "==============================================="
if [ "$STRICT_MODE" -eq 1 ] && [ "$WARNINGS" -gt 0 ]; then
    ERRORS=$((ERRORS + WARNINGS))
    WARNINGS=0
fi

if [ "$ERRORS" -gt 0 ]; then
    red "❌ Lint failed: $ERRORS errors / $WARNINGS warnings"
    echo "   修補後重跑：bash tools/charter-spec-lint.sh"
    exit 1
elif [ "$WARNINGS" -gt 0 ]; then
    yellow "⚠️ Lint completed with warnings: $WARNINGS warnings (advisory mode)"
    echo "   strict 模式跑：bash tools/charter-spec-lint.sh --strict"
    exit 0
else
    green "✅ Lint passed: 0 errors / 0 warnings"
    exit 0
fi
