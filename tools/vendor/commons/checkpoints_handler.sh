#!/usr/bin/env bash
# AgentCharter — Checkpoints Handler (邏輯層 / Logic Layer)
# Canonical version: v2.1 (charter v0.9.5+)
# Canonical path: tools/vendor/commons/checkpoints_handler.sh
# Deploy path:    ~/.gemini/checkpoints_handler.sh  (或其他 vendor 對應位置)
#
# ── 架構定位 ────────────────────────────────────────────────────────────────
# 本檔是 /checkpoints 機制的【邏輯層】，vendor 中立，所有 AI 廠商共用。
#
# Slash command（.gemini/commands/checkpoints.toml 等）是【橋接層】，
# 職責只有一件事：把使用者動作路由到本檔。
#   run_shell_command("bash ~/.gemini/checkpoints_handler.sh <action>")
#
# 兩層分離的設計含義：
#   - 橋接層依廠商格式各自實作（Gemini .toml / Claude Code .md / Cursor ...）
#   - 邏輯層只維護一份；handler 升版，所有廠商自動受益
#   - 採用方自訂邏輯只需 fork 本檔，不需動橋接層
#
# ── 變更歷史 ────────────────────────────────────────────────────────────────
# v2.1 (v0.9.5): copy draft to HIST_DIR/HANDOFF_N.md before clearing
#                (commit_save was committing but never writing the file)
# v2.0 (v0.9.2): paths read from mapping.yaml (core/charter-config §3)
#                instead of hardcoded management/ (dogfood signal #3 fix)
# v1.0 origin:   CryptoBot management/history/ structure

PROJ_ROOT="$PWD"
# Normalize for bash if on Windows
if [[ "$PROJ_ROOT" =~ ^[A-Za-z]: ]]; then
    PROJ_ROOT=$(echo "$PROJ_ROOT" | sed 's/\\/\//g' | sed 's/^\([A-Za-z]\):\//\/\1\//')
fi

# Read common_memory_root from mapping.yaml (core/charter-config §3)
# Falls back to legacy management/ for pre-v0.5.0 projects
MAPPING_FILE="$PROJ_ROOT/agent-commons/_config/mapping.yaml"
CMR=""
if [ -f "$MAPPING_FILE" ]; then
    CMR=$(grep -E '^\s*common_memory_root\s*:' "$MAPPING_FILE" | head -1 | sed 's/.*:\s*//' | tr -d '"' | tr -d "'" | tr -d ' ')
fi

if [ -n "$CMR" ]; then
    # Charter v0.5.0+ standard paths
    MGMT_DIR="$PROJ_ROOT/$CMR"
    HIST_DIR="$MGMT_DIR/handoffs"
    NEXTWORK_FILE="$MGMT_DIR/nextwork.md"
else
    # Legacy fallback (management/ structure, pre-v0.5.0)
    MGMT_DIR="$PROJ_ROOT/management"
    HIST_DIR="$MGMT_DIR/history"
    NEXTWORK_FILE="$HIST_DIR/NextWork.md"
fi

ARCH_DIR="$HIST_DIR/archive"
DRAFT_FILE="$MGMT_DIR/DRAFT_CONTEXT.md"

get_latest_n() {
    local max_n=0
    if [ -d "$HIST_DIR" ]; then
        for f in "$HIST_DIR"/HANDOFF_*.md; do
            if [ -f "$f" ]; then
                n=$(basename "$f" | sed 's/HANDOFF_//; s/.md//')
                if [[ "$n" =~ ^[0-9]+$ ]]; then
                    ((n > max_n)) && max_n=$n
                fi
            fi
        done
    fi
    echo "$max_n"
}

is_git_repo() {
    git -C "$PROJ_ROOT" rev-parse --is-inside-work-tree >/dev/null 2>&1
}

ARG=$(echo "$1" | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]')
SUBARG=$(echo "$2" | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]')

case "$ARG" in
    status)
        LATEST=$(get_latest_n)
        DRAFT_SIZE=0
        [ -f "$DRAFT_FILE" ] && DRAFT_SIZE=$(stat -c%s "$DRAFT_FILE" 2>/dev/null || wc -c < "$DRAFT_FILE")

        HAS_GIT="no"
        is_git_repo && HAS_GIT="yes"

        if [ "$DRAFT_SIZE" -eq 0 ] || [ "$DRAFT_SIZE" -le 16 ]; then
            echo "STATUS: DRAFT_CONTEXT is empty, Latest HANDOFF: N=$LATEST, Git: $HAS_GIT"
        else
            echo "STATUS: DRAFT_CONTEXT has $DRAFT_SIZE bytes, Latest HANDOFF: N=$LATEST, Git: $HAS_GIT"
        fi
        ;;

    config)
        echo "Draft: $DRAFT_FILE"
        echo "History: $HIST_DIR"
        echo "Archive: $ARCH_DIR"
        echo "NextWork: $NEXTWORK_FILE"
        ;;

    save|prepare_save)
        # Check draft
        DRAFT_SIZE=0
        [ -f "$DRAFT_FILE" ] && DRAFT_SIZE=$(stat -c%s "$DRAFT_FILE" 2>/dev/null || wc -c < "$DRAFT_FILE")
        if [ "$DRAFT_SIZE" -eq 0 ] || [ "$(tr -d '[:space:]' < "$DRAFT_FILE")" = "#DRAFT_CONTEXT" ]; then
            echo "ERROR:EMPTY_DRAFT"
            exit 0
        fi

        LATEST=$(get_latest_n)
        NEXT_N=$((LATEST + 1))
        echo "NEXT_N:$NEXT_N"
        echo "LATEST_PATH:$HIST_DIR/HANDOFF_$LATEST.md"
        echo "DRAFT_PATH:$DRAFT_FILE"
        ;;

    commit_save)
        N="$2"
        if [ -z "$N" ]; then echo "ERROR:MISSING_N"; exit 1; fi

        # Git Commit
        GIT_HASH="skipped"
        if is_git_repo; then
            git -C "$PROJ_ROOT" add -A
            if git -C "$PROJ_ROOT" commit -m "checkpoint: HANDOFF_$N" >/dev/null 2>&1; then
                GIT_HASH=$(git -C "$PROJ_ROOT" rev-parse --short HEAD)
            else
                GIT_HASH="no changes"
            fi
        else
            GIT_HASH="skipped (Not a git repository)"
        fi

        # Backup Draft to History
        mkdir -p "$HIST_DIR"
        cp "$DRAFT_FILE" "$HIST_DIR/HANDOFF_$N.md"

        # Clear Draft
        echo "# DRAFT_CONTEXT" > "$DRAFT_FILE"

        echo "GIT_HASH:$GIT_HASH"
        ;;

    load|load_info)
        LATEST=$(get_latest_n)
        if [ "$LATEST" -eq 0 ]; then
            echo "ERROR:NO_HANDOFF"
        else
            echo "PATH:$HIST_DIR/HANDOFF_$LATEST.md"
        fi
        ;;

    *)
        echo "Usage: checkpoints [save | status | load | config]"
        echo "Unknown: $ARG"
        ;;
esac
