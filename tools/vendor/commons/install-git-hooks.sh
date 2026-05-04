#!/usr/bin/env bash
# AgentCharter — Git Hooks Installer
# Canonical version: v1.0 (charter v0.10.0)
# Canonical path: tools/vendor/commons/install-git-hooks.sh
#
# ── 用途 ────────────────────────────────────────────────────────────────────
# 在採用方專案安裝 charter commit hook（vendor 中立、走 git 原生 pre-commit）。
#
# 安裝動作：
#   1. 把 charter canonical 的 charter-commit-checks.sh 複製到
#      <project>/agent-commons/_config/hooks/charter-commit-checks.sh（入 git）
#   2. 寫 thin shim 到 <project>/.git/hooks/pre-commit（local-only、不入 git）
#      shim 內容只一行：exec bash agent-commons/_config/hooks/charter-commit-checks.sh "$@"
#
# 升版動作（--update）：
#   1. 重新從 charter canonical 拉最新 charter-commit-checks.sh
#   2. 不改動 .git/hooks/pre-commit shim（已 stable、不需更新）
#
# ── 用法 ────────────────────────────────────────────────────────────────────
# 在採用方專案根目錄跑：
#   bash ~/.agentcharter/tools/vendor/commons/install-git-hooks.sh
#   bash ~/.agentcharter/tools/vendor/commons/install-git-hooks.sh --update
#   bash ~/.agentcharter/tools/vendor/commons/install-git-hooks.sh --uninstall
#
# ── 變更歷史 ────────────────────────────────────────────────────────────────
# v1.0 (v0.10.0): 初版 — 對應 commit-hook-spec.md ship

set -e

ACTION="${1:-install}"

# Locate charter canonical path
CHARTER_DIR="${AGENTCHARTER_HOME:-$HOME/.agentcharter}"
if [ ! -d "$CHARTER_DIR" ]; then
    echo "❌ charter 不存在於 $CHARTER_DIR" >&2
    echo "   set AGENTCHARTER_HOME 或 git clone https://github.com/moerasermax/AgentCharter ~/.agentcharter" >&2
    exit 1
fi

CANONICAL_SCRIPT="$CHARTER_DIR/tools/vendor/commons/charter-commit-checks.sh"
if [ ! -f "$CANONICAL_SCRIPT" ]; then
    echo "❌ canonical script 不存在：$CANONICAL_SCRIPT" >&2
    echo "   charter 版本可能 < v0.10.0、跑 git pull 升版" >&2
    exit 1
fi

# Locate project root
PROJ_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || echo "")"
if [ -z "$PROJ_ROOT" ]; then
    echo "❌ 不在 git repo 內、請在採用方專案根目錄跑" >&2
    exit 1
fi

HOOKS_DIR="$PROJ_ROOT/agent-commons/_config/hooks"
DEPLOY_SCRIPT="$HOOKS_DIR/charter-commit-checks.sh"
GIT_HOOKS_DIR="$PROJ_ROOT/.git/hooks"
SHIM_PATH="$GIT_HOOKS_DIR/pre-commit"

case "$ACTION" in
    install)
        echo "📦 charter commit hook installer (v0.10.0)"
        echo ""
        echo "  charter source: $CANONICAL_SCRIPT"
        echo "  project:        $PROJ_ROOT"
        echo ""

        # Step 1: Copy canonical to project
        mkdir -p "$HOOKS_DIR"
        cp "$CANONICAL_SCRIPT" "$DEPLOY_SCRIPT"
        chmod +x "$DEPLOY_SCRIPT"
        echo "✅ deployed: agent-commons/_config/hooks/charter-commit-checks.sh"

        # Step 2: Install thin shim
        if [ -f "$SHIM_PATH" ]; then
            # Detect if existing hook is our shim
            if grep -q 'charter-commit-checks.sh' "$SHIM_PATH" 2>/dev/null; then
                echo "✅ shim already installed at .git/hooks/pre-commit (no change)"
            else
                BACKUP_PATH="${SHIM_PATH}.charter-backup-$(date +%s)"
                mv "$SHIM_PATH" "$BACKUP_PATH"
                echo "⚠️  既有 .git/hooks/pre-commit 已備份至 $BACKUP_PATH"
                cat > "$SHIM_PATH" <<'SHIM_EOF'
#!/bin/sh
# AgentCharter pre-commit shim (charter v0.10.0+)
# 邏輯層在 agent-commons/_config/hooks/charter-commit-checks.sh
exec bash agent-commons/_config/hooks/charter-commit-checks.sh "$@"
SHIM_EOF
                chmod +x "$SHIM_PATH"
                echo "✅ shim installed at .git/hooks/pre-commit"
                echo "   舊 hook 邏輯如需保留、手動合併 $BACKUP_PATH"
            fi
        else
            cat > "$SHIM_PATH" <<'SHIM_EOF'
#!/bin/sh
# AgentCharter pre-commit shim (charter v0.10.0+)
# 邏輯層在 agent-commons/_config/hooks/charter-commit-checks.sh
exec bash agent-commons/_config/hooks/charter-commit-checks.sh "$@"
SHIM_EOF
            chmod +x "$SHIM_PATH"
            echo "✅ shim installed at .git/hooks/pre-commit"
        fi

        echo ""
        echo "🎉 charter commit hook 安裝完成"
        echo ""
        echo "   下次 git commit 會自動跑 H1-H6 校驗"
        echo "   bypass: git commit --no-verify（依 commit-hook-spec §6 記錄繞過事件）"
        echo "   升版:   bash $0 --update"
        ;;

    --update)
        echo "🔄 charter commit hook update (v0.10.0+)"
        if [ ! -f "$DEPLOY_SCRIPT" ]; then
            echo "❌ $DEPLOY_SCRIPT 不存在、請先跑 install" >&2
            exit 1
        fi
        cp "$CANONICAL_SCRIPT" "$DEPLOY_SCRIPT"
        chmod +x "$DEPLOY_SCRIPT"
        echo "✅ updated: agent-commons/_config/hooks/charter-commit-checks.sh"
        # No need to update shim; it just calls the script
        ;;

    --uninstall)
        echo "🗑️  charter commit hook uninstall"
        if [ -f "$SHIM_PATH" ] && grep -q 'charter-commit-checks.sh' "$SHIM_PATH" 2>/dev/null; then
            rm "$SHIM_PATH"
            echo "✅ removed shim: .git/hooks/pre-commit"
        else
            echo "⚠️  .git/hooks/pre-commit 不是 charter shim、不動"
        fi
        if [ -f "$DEPLOY_SCRIPT" ]; then
            echo "ℹ️  agent-commons/_config/hooks/charter-commit-checks.sh 保留（入 git、user 自行 git rm 決定）"
        fi
        echo "🎉 uninstall 完成"
        ;;

    --help|-h)
        cat <<EOF
AgentCharter Commit Hook Installer (charter v0.10.0)

Usage:
  bash install-git-hooks.sh             安裝 commit hook 到當前專案
  bash install-git-hooks.sh --update    更新 charter-commit-checks.sh 到最新版
  bash install-git-hooks.sh --uninstall 移除 .git/hooks/pre-commit shim

Architecture:
  charter canonical → agent-commons/_config/hooks/charter-commit-checks.sh （入 git）
                    → .git/hooks/pre-commit shim（local-only、3 行轉發）

依據：tools/commit-hook-spec.md
EOF
        ;;

    *)
        echo "❌ 未知動作：$ACTION" >&2
        echo "   bash $0 --help 看用法" >&2
        exit 1
        ;;
esac
