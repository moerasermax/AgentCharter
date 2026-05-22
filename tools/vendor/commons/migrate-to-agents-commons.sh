#!/bin/bash
# migrate-to-agents-commons.sh v1.0
#
# AgentCharter v0.12.0 BREAKING-MEDIUM rename migration script
# agent-commons/ → agents-commons/
#
# 三 phase 互動式（對齊 core/uninstall-spec + maintainer-discipline §3 紀律）
#   Phase 1: dry-run preview（無破壞、純預覽）
#   Phase 2: confirmation（git status 必乾淨 + 3x user 確認）
#   Phase 3: execute（git mv + sed mapping.yaml + sed 內文 + 後續手動動作提示）
#
# 對應條款：
#   - core/common-memory-root.md §10
#   - core/versioning-migration.md §2.3.5
#   - tools/doctor-spec.md §3.14 W1401
#
# 採用方完整 walkthrough：
#   examples/upgrades/v0.10.6-to-v0.12.0-antigravity-canonical-rename.md
#
# Usage:
#   bash ~/.agentcharter/tools/vendor/commons/migrate-to-agents-commons.sh
#   bash ~/.agentcharter/tools/vendor/commons/migrate-to-agents-commons.sh --dry-run
#   bash ~/.agentcharter/tools/vendor/commons/migrate-to-agents-commons.sh --force   # DANGEROUS

set -e

VERSION="v1.0"
SRC_NAME="agent-commons"    # detect target、勿改名
DST_NAME="agents-commons"

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

TOTAL_FILES=0
TOTAL_OCCURRENCES=0

usage() {
  cat <<EOF
AgentCharter Migration Script $VERSION
Rename common_memory_root: ${SRC_NAME}/ → ${DST_NAME}/

Usage:
  $0 [--dry-run|--force|--help]

Flags:
  --dry-run    Only show Phase 1 preview (no changes)
  --force      Skip Phase 2 confirmations (DANGEROUS)
  --help       Show this help

References:
  - core/common-memory-root.md §10 (BREAKING-MEDIUM rename 紀律)
  - core/versioning-migration.md §2.3.5 (v0.5.9 承諾例外處置)
  - tools/doctor-spec.md §3.14 W1401 (漏跑偵測 + 自動引導)

EOF
  exit 0
}

phase1_dry_run() {
  echo ""
  echo -e "${BLUE}========================================${NC}"
  echo -e "${BLUE}=== Phase 1: dry-run (preview only) ===${NC}"
  echo -e "${BLUE}========================================${NC}"
  echo ""

  if [ ! -d "$SRC_NAME" ]; then
    echo -e "${RED}❌ ${SRC_NAME}/ not found in current directory.${NC}"
    echo "    Run this script from project root (where ${SRC_NAME}/ exists)."
    echo "    Current directory: $(pwd)"
    exit 1
  fi

  if [ -d "$DST_NAME" ]; then
    echo -e "${RED}❌ ${DST_NAME}/ already exists.${NC}"
    echo "    Migration would overwrite. Aborting."
    exit 1
  fi

  echo -e "${GREEN}✅ Pre-checks pass: ${SRC_NAME}/ found, ${DST_NAME}/ free${NC}"
  echo ""

  echo -e "${BLUE}Impact scan: grep '${SRC_NAME}' (excluding .git/):${NC}"
  TOTAL_FILES=$(git grep -l "${SRC_NAME}" -- ':!.git' 2>/dev/null | wc -l | tr -d ' ')
  TOTAL_OCCURRENCES=$(git grep -c "${SRC_NAME}" -- ':!.git' 2>/dev/null | awk -F: '{sum+=$NF} END {print sum}')
  echo "  Total files affected: $TOTAL_FILES"
  echo "  Total occurrences: $TOTAL_OCCURRENCES"
  echo ""

  echo -e "${BLUE}First 20 affected files:${NC}"
  git grep -l "${SRC_NAME}" -- ':!.git' 2>/dev/null | head -20 | sed 's/^/    /'
  if [ "$TOTAL_FILES" -gt 20 ]; then
    echo "    ... and $((TOTAL_FILES - 20)) more"
  fi
  echo ""

  echo -e "${BLUE}Preview action 1 — git mv:${NC}"
  echo "    git mv ${SRC_NAME} ${DST_NAME}"
  echo ""

  if [ -f "${SRC_NAME}/_config/mapping.yaml" ]; then
    echo -e "${BLUE}Preview action 2 — mapping.yaml common_memory_root:${NC}"
    grep -n "common_memory_root" "${SRC_NAME}/_config/mapping.yaml" 2>/dev/null | sed 's/^/    /' || echo "    (no match)"
    echo "    → will change to: common_memory_root: ${DST_NAME}/"
    echo ""
  fi

  echo -e "${BLUE}Preview action 3 — sed internal references:${NC}"
  echo "    find . -type f (with .md/.yaml/.toml/.sh/.py/.js/.ts/.cjs/.ps1)"
  echo "         -not -path './.git/*'"
  echo "    → sed s|${SRC_NAME}/|${DST_NAME}/|g"
  echo ""
  echo -e "${YELLOW}    ⚠️ Script does NOT exclude historical files automatically.${NC}"
  echo "       To preserve historical entries (CHANGELOG / past walkthroughs):"
  echo "       review and 'git restore' those files after Phase 3, before commit."
  echo ""

  echo -e "${YELLOW}⚠️ Manual post-migration actions required:${NC}"
  echo "    1. bash ~/.agentcharter/tools/vendor/commons/install-git-hooks.sh --update"
  echo "    2. Re-self-instantiate vendor slash commands"
  echo "    3. Update ${DST_NAME}/_config/profile.yaml: charter_version: \"0.12.0\""
  echo "    4. Run doctor + post-upgrade-verify"
  echo ""
}

phase2_confirm() {
  echo ""
  echo -e "${BLUE}========================================${NC}"
  echo -e "${BLUE}=== Phase 2: confirmation ===${NC}"
  echo -e "${BLUE}========================================${NC}"
  echo ""

  if [ -n "$(git status --porcelain)" ]; then
    echo -e "${RED}❌ git status is not clean.${NC}"
    echo "    Commit or stash your changes before running migration."
    git status --short | head -10 | sed 's/^/      /'
    exit 1
  fi
  echo -e "${GREEN}✅ git status clean${NC}"
  echo ""

  echo -e "${YELLOW}This script will:${NC}"
  echo "    1. git mv ${SRC_NAME} ${DST_NAME}"
  echo "    2. sed mapping.yaml common_memory_root"
  echo "    3. sed -i in $TOTAL_FILES files ($TOTAL_OCCURRENCES occurrences)"
  echo ""
  echo -e "${GREEN}    ✓ Reversible: git revert HEAD undoes everything if you commit after.${NC}"
  echo ""

  read -p "Confirm 1/3: Proceed with migration? (y/N): " ans1
  if [ "$ans1" != "y" ] && [ "$ans1" != "Y" ]; then
    echo "Aborted."
    exit 0
  fi

  read -p "Confirm 2/3: You have read core/common-memory-root.md §10? (y/N): " ans2
  if [ "$ans2" != "y" ] && [ "$ans2" != "Y" ]; then
    echo "Aborted."
    exit 0
  fi

  read -p "Confirm 3/3: Final confirmation, execute Phase 3? (y/N): " ans3
  if [ "$ans3" != "y" ] && [ "$ans3" != "Y" ]; then
    echo "Aborted."
    exit 0
  fi

  echo -e "${GREEN}✅ All 3 confirmations passed${NC}"
  echo ""
}

phase3_execute() {
  echo ""
  echo -e "${BLUE}========================================${NC}"
  echo -e "${BLUE}=== Phase 3: execute ===${NC}"
  echo -e "${BLUE}========================================${NC}"
  echo ""

  echo -e "${BLUE}Step 1: git mv ${SRC_NAME} ${DST_NAME}${NC}"
  git mv "$SRC_NAME" "$DST_NAME"
  echo -e "${GREEN}  ✅ directory renamed${NC}"
  echo ""

  if [ -f "${DST_NAME}/_config/mapping.yaml" ]; then
    echo -e "${BLUE}Step 2: sed mapping.yaml common_memory_root${NC}"
    if sed --version >/dev/null 2>&1; then
      sed -i "s|common_memory_root:[[:space:]]*${SRC_NAME}/|common_memory_root: ${DST_NAME}/|g" "${DST_NAME}/_config/mapping.yaml"
    else
      sed -i '' "s|common_memory_root:[[:space:]]*${SRC_NAME}/|common_memory_root: ${DST_NAME}/|g" "${DST_NAME}/_config/mapping.yaml"
    fi
    echo -e "${GREEN}  ✅ mapping.yaml updated${NC}"
    grep -n "common_memory_root" "${DST_NAME}/_config/mapping.yaml" 2>/dev/null | sed 's/^/      /'
    echo ""
  fi

  echo -e "${BLUE}Step 3: sed internal references (excludes .git/)${NC}"
  if sed --version >/dev/null 2>&1; then
    find . -type f \( -name '*.md' -o -name '*.yaml' -o -name '*.toml' -o -name '*.sh' -o -name '*.py' -o -name '*.js' -o -name '*.ts' -o -name '*.cjs' -o -name '*.ps1' \) -not -path './.git/*' -exec sed -i "s|${SRC_NAME}/|${DST_NAME}/|g" {} +
  else
    find . -type f \( -name '*.md' -o -name '*.yaml' -o -name '*.toml' -o -name '*.sh' -o -name '*.py' -o -name '*.js' -o -name '*.ts' -o -name '*.cjs' -o -name '*.ps1' \) -not -path './.git/*' -exec sed -i '' "s|${SRC_NAME}/|${DST_NAME}/|g" {} +
  fi
  echo -e "${GREEN}  ✅ internal references swept${NC}"
  echo ""

  echo -e "${BLUE}Step 4: git status after migration${NC}"
  git status --short | head -20 | sed 's/^/    /'
  echo ""

  echo -e "${YELLOW}Suggested commit:${NC}"
  echo "    git add -A"
  echo "    git commit -m \"chore: migrate ${SRC_NAME} → ${DST_NAME} (charter v0.12.0 BREAKING-MEDIUM rename)\""
  echo ""

  echo -e "${YELLOW}⚠️ MANUAL post-migration actions required:${NC}"
  echo ""
  echo "  1. bash ~/.agentcharter/tools/vendor/commons/install-git-hooks.sh --update"
  echo ""
  echo "  2. Re-self-instantiate vendor slash commands (內含路徑更新):"
  echo "     對 vendor AI 下 prompt：「請依 charter v0.12.0 重新具象化 /pm-init / /engineer-init 等」"
  echo ""
  echo "  3. Update profile.yaml charter_version:"
  echo "     編 ${DST_NAME}/_config/profile.yaml: charter_version: \"0.12.0\""
  echo ""
  echo "  4. Run doctor + post-upgrade-verify"
  echo ""
  echo -e "${GREEN}🎉 Migration Phase 3 completed${NC}"
}

case "${1:-}" in
  --help|-h) usage ;;
  --dry-run) phase1_dry_run; exit 0 ;;
  --force) phase1_dry_run; phase3_execute; exit 0 ;;
  "") phase1_dry_run; phase2_confirm; phase3_execute ;;
  *) echo -e "${RED}Unknown flag: $1${NC}"; usage ;;
esac
