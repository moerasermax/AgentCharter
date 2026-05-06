#!/usr/bin/env bash
# AgentCharter — Commit Hook Checks (邏輯層 / Logic Layer)
# Canonical version: v1.1 (charter v0.10.2)
# Canonical path: tools/vendor/commons/charter-commit-checks.sh
# Deploy path:    agent-commons/_config/hooks/charter-commit-checks.sh
#                 (per-project, copied/synced via install-git-hooks.sh)
#
# ── 架構定位 ────────────────────────────────────────────────────────────────
# 本檔是 commit hook 的【邏輯層】，vendor 中立、所有 AI 廠商共用。
#
# .git/hooks/pre-commit 是【橋接層】，職責只有一件事：把 git pre-commit 事件
# 路由到本檔。
#   exec bash agent-commons/_config/hooks/charter-commit-checks.sh "$@"
#
# 兩層分離設計含義：
#   - 橋接層走 git 原生（vendor 中立、Claude/Gemini/Kiro/人類 commit 都觸發）
#   - 邏輯層只維護一份；charter 升版、所有採用方自動受益
#   - 採用方自訂邏輯只需 fork 本檔、不需動橋接層
#
# ── 校驗項（依 tools/commit-hook-spec.md §3）────────────────────────────────
# H1 reject  _role.md Status 升 ACTIVE 必含 user explicit 授權字樣
# H2 reject  commit 提 F-mode → log 必有 entry + reflection 必有對應檔
# H3 reject  reflection 檔名須 ^\d{4}-\d{2}-\d{2}_<topic>.md$
# H4 warn    reflection 含 sprint 編號（可能 project state 混入）
# H5 reject  log 加 entry 但對應 reflection 缺檔
# H6 warn    handoff 缺「致 XXX」directive header
# H7 reject  profile.yaml 缺 charter 強制必啟欄位（schema-driven via _required.yaml）
#
# ── 變更歷史 ────────────────────────────────────────────────────────────────
# v1.0 (v0.10.0): 初版 — 6 條同源 signal（#33/#35/#42-#45）binary 攔截
# v1.1 (v0.10.2): 加 H7 — schema-driven 強制必啟集合 binary 攔截
#                 對應 dogfood signal #46（≥3 次）+ #31（≥5 次）+ #52 候選（三層
#                 雙重防禦對 F6 整體 LIVE 失效）— BREAKING-LITE PATCH
#                 schema source of truth: tools/profiles/_required.yaml

set -e

PROJ_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || echo "$PWD")"
# Normalize for bash if on Windows
if [[ "$PROJ_ROOT" =~ ^[A-Za-z]: ]]; then
    PROJ_ROOT=$(echo "$PROJ_ROOT" | sed 's/\\/\//g' | sed 's/^\([A-Za-z]\):\//\/\1\//')
fi

# Read common_memory_root from mapping.yaml
MAPPING_FILE="$PROJ_ROOT/agent-commons/_config/mapping.yaml"
CMR=""
if [ -f "$MAPPING_FILE" ]; then
    CMR=$(grep -E '^\s*common_memory_root\s*:' "$MAPPING_FILE" | head -1 | sed 's/.*:\s*//' | tr -d '"' | tr -d "'" | tr -d ' ' | tr -d '/')
fi
[ -z "$CMR" ] && CMR="agent-commons"

# Get staged files (added/modified)
STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM 2>/dev/null || echo "")

# Get commit message (from prepare-commit-msg or COMMIT_EDITMSG)
COMMIT_MSG=""
if [ -f "$PROJ_ROOT/.git/COMMIT_EDITMSG" ]; then
    COMMIT_MSG=$(cat "$PROJ_ROOT/.git/COMMIT_EDITMSG" 2>/dev/null || echo "")
fi

REJECT_COUNT=0
WARN_COUNT=0

reject() {
    echo "❌ $1" >&2
    REJECT_COUNT=$((REJECT_COUNT + 1))
}

warn() {
    echo "⚠️  $1" >&2
    WARN_COUNT=$((WARN_COUNT + 1))
}

# ── H1: _role.md Status 升 ACTIVE 字樣校驗 ─────────────────────────────────
check_h1() {
    for f in $STAGED_FILES; do
        case "$f" in
            "$CMR"/roles/*/_role.md)
                # Get diff for this file
                local diff_content
                diff_content=$(git diff --cached "$f" 2>/dev/null || echo "")
                # Check if status changed PROVISIONAL → ACTIVE
                if echo "$diff_content" | grep -E '^\+.*\*\*Status\*\*.*ACTIVE' >/dev/null && \
                   echo "$diff_content" | grep -E '^-.*\*\*Status\*\*.*PROVISIONAL' >/dev/null; then
                    # Check for user explicit authorization wording in the new file content
                    local file_content
                    file_content=$(git show ":$f" 2>/dev/null || cat "$PROJ_ROOT/$f" 2>/dev/null || echo "")
                    if ! echo "$file_content" | grep -E '(user explicit 授權|user 授權|explicit 授權|由 user 於.*授權)' >/dev/null; then
                        reject "[H1 REJECT] $f Status 升 ACTIVE 缺 user explicit 授權字樣（multi-role-tracking §3.4.4 / init-template §3.3.2 step 6）"
                    fi
                fi
                ;;
        esac
    done
}

# ── H2: commit 提 F-mode → log + reflection 雙寫 ───────────────────────────
check_h2() {
    # Detect F-mode mention in commit message OR staged file content (added lines only)
    local fmode_in_msg
    fmode_in_msg=$(echo "$COMMIT_MSG" | grep -oE '\bF[1-6]\b|假宣告|捏造|未驗證即宣告' | head -1 || echo "")

    if [ -n "$fmode_in_msg" ]; then
        # Check if log has new entry
        local log_path="$CMR/state/failure_mode_log.md"
        local log_has_new_entry=false
        if echo "$STAGED_FILES" | grep -qE "^${log_path}$"; then
            local log_diff
            log_diff=$(git diff --cached "$log_path" 2>/dev/null | grep -E '^\+[^+]' | grep -vE '^\+\+\+' || echo "")
            [ -n "$log_diff" ] && log_has_new_entry=true
        fi

        # Check if reflection has new file
        local reflection_added=false
        for f in $STAGED_FILES; do
            case "$f" in
                "$CMR"/roles/*/reflections/*.md)
                    # Is it a newly added file?
                    if git diff --cached --name-only --diff-filter=A 2>/dev/null | grep -qE "^${f}$"; then
                        reflection_added=true
                        break
                    fi
                    ;;
            esac
        done

        if ! $log_has_new_entry; then
            reject "[H2 REJECT] commit 提 F-mode（$fmode_in_msg）但 $log_path 無新 entry（individual-learning-loop §2.3 雙寫缺漏）"
        fi
        if ! $reflection_added; then
            reject "[H2 REJECT] commit 提 F-mode（$fmode_in_msg）但 roles/<role>/reflections/ 無新檔（individual-learning-loop §2.3 雙寫缺漏）"
        fi
    fi
}

# ── H3: reflection 檔名 regex ──────────────────────────────────────────────
check_h3() {
    local regex='^[0-9]{4}-[0-9]{2}-[0-9]{2}_[a-z0-9_-]+\.md$'
    for f in $STAGED_FILES; do
        case "$f" in
            "$CMR"/roles/*/reflections/*.md)
                # Skip if not newly added
                if ! git diff --cached --name-only --diff-filter=A 2>/dev/null | grep -qE "^${f}$"; then
                    continue
                fi
                local basename
                basename=$(basename "$f")
                if ! echo "$basename" | grep -qE "$regex"; then
                    reject "[H3 REJECT] reflection 檔名違反 regex（^\\d{4}-\\d{2}-\\d{2}_<topic>.md$）— 實際：$basename"
                fi
                ;;
        esac
    done
}

# ── H4: reflection 含 sprint 編號邊界（warn）─────────────────────────────────
check_h4() {
    for f in $STAGED_FILES; do
        case "$f" in
            "$CMR"/roles/*/reflections/*.md)
                # Skip if not newly added
                if ! git diff --cached --name-only --diff-filter=A 2>/dev/null | grep -qE "^${f}$"; then
                    continue
                fi
                local content
                content=$(git show ":$f" 2>/dev/null || cat "$PROJ_ROOT/$f" 2>/dev/null || echo "")
                local sprint_hits
                sprint_hits=$(echo "$content" | grep -oE '\bS[0-9]+\b' | sort -u | head -3 | tr '\n' ',' || echo "")
                if [ -n "$sprint_hits" ]; then
                    warn "[H4 WARN] $f 含 sprint 編號（${sprint_hits%,}），可能誤把 project state 寫入 meta-knowledge 倉（individual-learning-loop §2.4）"
                fi
                ;;
        esac
    done
}

# ── H5: log 加 entry → reflection 必有對應檔 ───────────────────────────────
check_h5() {
    local log_path="$CMR/state/failure_mode_log.md"
    if echo "$STAGED_FILES" | grep -qE "^${log_path}$"; then
        local log_diff
        log_diff=$(git diff --cached "$log_path" 2>/dev/null | grep -E '^\+[^+]' | grep -vE '^\+\+\+' || echo "")
        if [ -n "$log_diff" ]; then
            # Check if any reflection file is newly added
            local reflection_added=false
            for f in $STAGED_FILES; do
                case "$f" in
                    "$CMR"/roles/*/reflections/*.md)
                        if git diff --cached --name-only --diff-filter=A 2>/dev/null | grep -qE "^${f}$"; then
                            reflection_added=true
                            break
                        fi
                        ;;
                esac
            done
            if ! $reflection_added; then
                reject "[H5 REJECT] $log_path 加 entry 但對應 reflection 缺檔（個體層雙寫缺漏 / individual-learning-loop §2.3）"
            fi
        fi
    fi
}

# ── H6: handoff directive header（warn）────────────────────────────────────
check_h6() {
    for f in $STAGED_FILES; do
        case "$f" in
            "$CMR"/handoffs/HANDOFF_*.md)
                # Skip if not newly added
                if ! git diff --cached --name-only --diff-filter=A 2>/dev/null | grep -qE "^${f}$"; then
                    continue
                fi
                local content
                content=$(git show ":$f" 2>/dev/null || cat "$PROJ_ROOT/$f" 2>/dev/null || echo "")
                # Check for "致 XXX" directive header pattern
                if ! echo "$content" | head -20 | grep -qE '^致 [^[:space:]]+'; then
                    warn "[H6 WARN] $f 缺 directive header「致 XXX」起始（cross-ai-handoff §6）"
                fi
                ;;
        esac
    done
}

# ── H7: 強制必啟集合校驗（schema-driven via _required.yaml）─────────────────
# Source of truth: $CHARTER_DIR/tools/profiles/_required.yaml（charter 端）
# 升版紀律：charter 加新 entry → 補對應 inline check function（本段下方）→
#           採用方 git pull → 下次 commit 自動驗、採用方無需任何動作
# 觸發：每次 commit 都跑（profile.yaml 不存在則跳過、pre-init 採用方 graceful skip）
check_h7() {
    local profile_file="$PROJ_ROOT/$CMR/_config/profile.yaml"
    if [ ! -f "$profile_file" ]; then
        return  # Pre-init / 採用方專案 profile.yaml 尚未生成、跳過
    fi

    # H7 entries — 對應 _required.yaml required_in_profile_yaml 集合
    h7_check_f6_enabled "$profile_file"

    # 未來 F7 加進來時、charter maintainer 對齊以下範本加 inline check：
    # h7_check_f7_enabled "$profile_file"
}

# REQ-001-F6: parameters.failure-modes.enable_modes 必含 F6（v0.7.0+）
# 對應條款: core/failure-modes §F6 / doctor §3.7 E605 / verify §3.2 B002 / init Phase 5b CHECK 7
h7_check_f6_enabled() {
    local profile_file="$1"

    # Extract enable_modes block — supports both inline list 和 multi-line list YAML
    # Inline:    enable_modes: ["F1", "F2", ..., "F6"]
    # Multi-line:enable_modes:
    #              - F1
    #              - F6
    local enable_modes_block
    enable_modes_block=$(awk '
        /^[[:space:]]*enable_modes[[:space:]]*:/ {
            in_block=1
            print
            if ($0 ~ /\[/) {in_block=0; exit}
            next
        }
        in_block {
            # Stop at next yaml key (any line starting with non-list non-comment + colon)
            if ($0 ~ /^[[:space:]]*[a-zA-Z_][a-zA-Z0-9_-]*[[:space:]]*:/) {in_block=0; exit}
            print
        }
    ' "$profile_file")

    # Strip yaml comments so commented-out F6 (e.g., "# F6 added later") doesn't false-pass
    local enable_modes_clean
    enable_modes_clean=$(echo "$enable_modes_block" | sed 's/#.*$//')

    if ! echo "$enable_modes_clean" | grep -qE '\bF6\b'; then
        reject "[H7 REJECT] profile.yaml parameters.failure-modes.enable_modes 缺 F6 — 見 \$CHARTER_DIR/tools/profiles/_required.yaml REQ-001-F6（v0.7.0+ standard/strict 強制必啟、對應 doctor §3.7 E605 / verify §3.2 B002 / init Phase 5b CHECK 7）"
    fi
}

# Run all checks
check_h1
check_h2
check_h3
check_h4
check_h5
check_h6
check_h7

# Summary
if [ "$WARN_COUNT" -gt 0 ]; then
    echo "" >&2
    echo "⚠️  $WARN_COUNT warning(s) — commit allowed but review above" >&2
fi

if [ "$REJECT_COUNT" -gt 0 ]; then
    echo "" >&2
    echo "❌ $REJECT_COUNT rejection(s) — commit blocked" >&2
    echo "   bypass: git commit --no-verify (記錄繞過事件 / commit-hook-spec §6)" >&2
    exit 1
fi

exit 0
