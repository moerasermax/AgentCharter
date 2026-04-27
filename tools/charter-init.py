#!/usr/bin/env python3
"""
charter-init — AgentCharter 初次接入工具（MVP）

對應 tools/init-spec.md Phase 1〜3 + 5。Phase 4（生成 slash command）
不做 — 依 v0.5.1「框架不代生成」原則，由各 AI 自我具象化。

用法（在你專案的 working dir 跑）：

    python /path/to/AgentCharter/tools/charter-init.py \\
      --preset standard \\
      --domain-axioms-path protocols/RECON.md \\
      --domain-axioms-alias RECON

    # 預設 common-root = agent-commons/，可用 --common-root 覆寫
    # 可選 --dry-run 預覽動作不執行

依賴：PyYAML + Python 3.8+ stdlib

退出碼：
    0 = 完成
    1 = 失敗 / 中止
    2 = 引數 / 環境問題
"""

from __future__ import annotations
import argparse
import re
import sys
import shutil
from pathlib import Path

try:
    import yaml
except ImportError:
    print("❌ 需要 PyYAML：pip install pyyaml", file=sys.stderr)
    sys.exit(2)

# Windows console UTF-8
if hasattr(sys.stdout, "reconfigure"):
    try:
        sys.stdout.reconfigure(encoding="utf-8")
        sys.stderr.reconfigure(encoding="utf-8")
    except Exception:
        pass

# ──────────────────────────────────────────────
# 常量
# ──────────────────────────────────────────────

CHARTER_ROOT = Path(__file__).resolve().parent.parent
PROFILES_DIR = CHARTER_ROOT / "tools" / "profiles"
DOMAIN_AXIOMS_TEMPLATE = (
    CHARTER_ROOT / "templates" / "agent-commons" / "domain-axioms.md.tpl"
)

VALID_PRESETS = {"minimal", "standard", "strict"}

# 必含子目錄（依 ADOPTION §4 + common-memory-root §3）
SUBDIRS = [
    "_config",
    "capsules",
    "handoffs",
    "handoffs/archive",
    "protocols",
    "institutional-memory",
    "state",
    "roles/engineer/sessions",
    "roles/engineer/drafts",
    "roles/engineer/reflections",
    "roles/engineer/private",
    "roles/pm/sessions",
    "roles/pm/drafts",
    "roles/pm/reflections",
    "roles/pm/private",
]

# 必含空檔（提示性 placeholder）
PLACEHOLDER_FILES = {
    "DRAFT_CONTEXT.md": (
        "# DRAFT_CONTEXT\n\n"
        "> 暫存堆疊（依 working-stack-discipline.md §1）。session 內累積\n"
        "> 關鍵證據；save 觸發時 → HANDOFF。\n\n"
        "（空，等待累積）\n"
    ),
    "nextwork.md": (
        "# NextWork\n\n"
        "> 任務追蹤主檔。Active / Up Next / Completed 三段。\n\n"
        "## Active\n\n（無）\n\n## Up Next\n\n（無）\n\n## Completed\n\n（無）\n"
    ),
    "institutional-memory/_root.md": (
        "# Institutional Memory（索引）\n\n"
        "> 跨事件知識沉澱。每章五段格式：症狀 → 根因 → 診斷 → 修法 → 預防。\n\n"
        "（無紀錄）\n"
    ),
    "state/output_mode": "verbose\n",  # 預設 verbose（依 standard preset）
    "state/failure_modes.log": "",  # 空 log
}


def parse_semver(s: str) -> tuple[int, int, int] | None:
    m = re.match(r"^(\d+)\.(\d+)\.(\d+)$", s.strip())
    return tuple(int(x) for x in m.groups()) if m else None  # type: ignore[return-value]


def detect_charter_version() -> str:
    """從 CHARTER_ROOT 的 standard.yaml 讀當前 charter version（依約定，
    standard preset 的 charter_version 為 charter repo 當前最新值）。"""
    standard = PROFILES_DIR / "standard.yaml"
    with standard.open(encoding="utf-8") as f:
        data = yaml.safe_load(f)
    return data.get("charter_version", "0.0.0")


# ──────────────────────────────────────────────
# 動作
# ──────────────────────────────────────────────


def check_environment(common_root: Path, force: bool) -> None:
    """前置檢查：目標 common-root 是否已存在 / charter repo 完整性。"""
    print("\n📦 前置檢查")

    if not PROFILES_DIR.exists():
        print(f"   ❌ charter repo 路徑不對 — 找不到 {PROFILES_DIR}")
        sys.exit(2)
    print(f"   ✅ charter repo: {CHARTER_ROOT}")

    if common_root.exists():
        if not force:
            print(f"   ❌ {common_root} 已存在 — 加 --force 覆寫，或選別的 --common-root")
            sys.exit(1)
        print(f"   ⚠️  {common_root} 已存在（--force 覆寫中）")
    else:
        print(f"   ✅ 目標位置乾淨: {common_root}")


def make_subdirs(common_root: Path, dry_run: bool) -> None:
    print(f"\n📁 建立子目錄結構（{len(SUBDIRS)} 項）")
    for sub in SUBDIRS:
        target = common_root / sub
        if dry_run:
            print(f"   [dry-run] mkdir -p {target}")
        else:
            target.mkdir(parents=True, exist_ok=True)
    if not dry_run:
        print(f"   ✅ 子目錄建立完成")


def write_placeholder_files(common_root: Path, dry_run: bool) -> None:
    print(f"\n📄 建立 placeholder 檔（{len(PLACEHOLDER_FILES)} 項）")
    for rel_path, content in PLACEHOLDER_FILES.items():
        target = common_root / rel_path
        if dry_run:
            print(f"   [dry-run] write {target} ({len(content)} bytes)")
        else:
            target.parent.mkdir(parents=True, exist_ok=True)
            if not target.exists():
                target.write_text(content, encoding="utf-8")
                print(f"   ✅ {rel_path}")
            else:
                print(f"   ⚠️  {rel_path} 已存在，保留")


def copy_profile(common_root: Path, preset: str, charter_version: str,
                 dry_run: bool) -> None:
    print(f"\n📋 套用 profile preset: {preset}")
    src = PROFILES_DIR / f"{preset}.yaml"
    dst = common_root / "_config" / "profile.yaml"

    if not src.exists():
        print(f"   ❌ preset 模板不存在: {src}")
        sys.exit(1)

    with src.open(encoding="utf-8") as f:
        data = yaml.safe_load(f)

    # 確保 charter_version 對齊當前 charter repo
    data["charter_version"] = charter_version

    if dry_run:
        print(f"   [dry-run] write {dst} (preset={preset}, charter_version={charter_version})")
        return

    with dst.open("w", encoding="utf-8") as f:
        f.write(f"# AgentCharter Profile — generated by charter-init\n")
        f.write(f"# preset: {preset}\n")
        f.write(f"# 詳見: tools/profiles/{preset}.yaml（charter repo）\n\n")
        yaml.safe_dump(data, f, allow_unicode=True, sort_keys=False)
    print(f"   ✅ {dst}")


def write_mapping(common_root: Path, common_root_name: str,
                  domain_axioms_path: str, domain_axioms_alias: str,
                  enabled_working_stack: bool, dry_run: bool) -> None:
    print(f"\n🗺️  生成 mapping.yaml")

    mapping = {
        "version": "0.5.7",
        "common_memory_root": f"{common_root_name}/",
        "shared": {
            "capsules": "capsules/",
            "handoffs": "handoffs/",
            "protocols": "protocols/",
            "institutional_memory": ["institutional-memory/_root.md"],
            "nextwork": "nextwork.md",
        },
        "roles": {
            "engineer": {
                "sessions": "roles/engineer/sessions/",
                "drafts": "roles/engineer/drafts/",
                "reflections": "roles/engineer/reflections/",
                "private": "roles/engineer/private/",
            },
            "pm": {
                "sessions": "roles/pm/sessions/",
                "drafts": "roles/pm/drafts/",
                "reflections": "roles/pm/reflections/",
                "private": "roles/pm/private/",
            },
        },
        "domain_axioms": {
            "primary": domain_axioms_path,
            "alias": domain_axioms_alias,
        },
        "state": {
            "output_mode_file": "state/output_mode",
            "failure_mode_log": "state/failure_modes.log",
        },
    }

    # standard / strict 啟用 working-stack-discipline → mapping 加 draft / archive
    if enabled_working_stack:
        mapping["shared"]["draft_context"] = "DRAFT_CONTEXT.md"
        mapping["shared"]["archive"] = "handoffs/archive/"

    dst = common_root / "_config" / "mapping.yaml"
    if dry_run:
        print(f"   [dry-run] write {dst}")
        print(yaml.safe_dump(mapping, allow_unicode=True, sort_keys=False))
        return

    with dst.open("w", encoding="utf-8") as f:
        f.write("# AgentCharter Mapping — generated by charter-init\n")
        f.write("# 路徑相對於 common_memory_root\n\n")
        yaml.safe_dump(mapping, f, allow_unicode=True, sort_keys=False)
    print(f"   ✅ {dst}")


def copy_domain_axioms_template(common_root: Path, axioms_path: str,
                                axioms_alias: str, dry_run: bool) -> None:
    """複製 domain-axioms.md.tpl 到指定位置，作為 placeholder。"""
    print(f"\n🛡️  領域公理 placeholder")

    dst = common_root / axioms_path
    if dry_run:
        print(f"   [dry-run] copy {DOMAIN_AXIOMS_TEMPLATE} → {dst}")
        return

    if dst.exists():
        print(f"   ⚠️  {dst} 已存在，保留（不覆寫實際公理檔）")
        return

    if not DOMAIN_AXIOMS_TEMPLATE.exists():
        print(f"   ❌ template 不存在: {DOMAIN_AXIOMS_TEMPLATE}")
        sys.exit(1)

    dst.parent.mkdir(parents=True, exist_ok=True)
    content = DOMAIN_AXIOMS_TEMPLATE.read_text(encoding="utf-8")
    # 簡單變數替換
    content = content.replace("<PROJECT_NAME>", axioms_alias)
    dst.write_text(content, encoding="utf-8")
    print(f"   ✅ {dst}（template 複製，請依 domain-axiom-slot §3 填寫實際條款）")


def post_init_message(common_root: Path, preset: str,
                      charter_version: str) -> None:
    print(f"""
═══════════════════════════════════════════════════
✅ charter-init 完成（preset={preset}, charter_version={charter_version}）
═══════════════════════════════════════════════════

下一步：

1. 寫實際領域公理（依 domain-axiom-slot §3 強制要求）
   編輯：{common_root}/<domain-axioms-path>
   至少含：每條鐵律有「後果」段、可被驗證、有編號

2. 通知各 AI 自我具象化（依 init-template §3.3）
   - Claude Code → 「請接 PM/Engineer 角色，依 AgentCharter charter
     讀 init-template.md §3.3 自我具象化到 .claude/commands/<role>-init.md」
   - Gemini CLI → 同樣概念，依 §3.3 在 .gemini/commands/ 具象化

3. 跑 charter-doctor 驗證
   python {CHARTER_ROOT}/tools/charter-doctor.py --common-root {common_root}

4. PM 寫第一個任務膠囊（capsule.md.tpl 在 charter repo 內）
   位置：{common_root}/capsules/CAP-001-<topic>.md

完整流程見：{CHARTER_ROOT}/ADOPTION.md
""")


# ──────────────────────────────────────────────
# 主流程
# ──────────────────────────────────────────────


def main() -> int:
    parser = argparse.ArgumentParser(
        description="AgentCharter 初次接入工具（建 agent-commons/ + 套 preset + 寫 yaml）"
    )
    parser.add_argument(
        "--preset", choices=sorted(VALID_PRESETS), required=True,
        help="profile preset"
    )
    parser.add_argument(
        "--common-root", default="agent-commons",
        help="common memory root 目錄名（預設: agent-commons）"
    )
    parser.add_argument(
        "--domain-axioms-path", required=True,
        help="領域公理檔路徑（相對於 common-root，如 protocols/RECON.md）"
    )
    parser.add_argument(
        "--domain-axioms-alias", required=True,
        help="領域公理短名稱（如 RECON / IRON / HIPAA）"
    )
    parser.add_argument(
        "--charter-version",
        help="採用的 charter version（預設讀 charter repo 的 standard.yaml）"
    )
    parser.add_argument(
        "--force", action="store_true",
        help="目標 common-root 已存在時覆寫"
    )
    parser.add_argument(
        "--dry-run", action="store_true",
        help="預覽動作不執行"
    )
    args = parser.parse_args()

    common_root = Path(args.common_root).resolve()
    charter_version = args.charter_version or detect_charter_version()

    print("📋 AgentCharter Init")
    print("=" * 50)
    print(f"  charter repo:        {CHARTER_ROOT}")
    print(f"  charter version:     {charter_version}")
    print(f"  preset:              {args.preset}")
    print(f"  common root:         {common_root}")
    print(f"  domain axioms path:  {args.domain_axioms_path}")
    print(f"  domain axioms alias: {args.domain_axioms_alias}")
    if args.dry_run:
        print(f"  mode:                dry-run")

    check_environment(common_root, args.force)

    # 啟用 working-stack-discipline → mapping 加 draft / archive 欄
    enabled_working_stack = args.preset in {"minimal", "standard", "strict"}

    make_subdirs(common_root, args.dry_run)
    write_placeholder_files(common_root, args.dry_run)
    copy_profile(common_root, args.preset, charter_version, args.dry_run)
    write_mapping(
        common_root,
        common_root_name=args.common_root,
        domain_axioms_path=args.domain_axioms_path,
        domain_axioms_alias=args.domain_axioms_alias,
        enabled_working_stack=enabled_working_stack,
        dry_run=args.dry_run,
    )
    copy_domain_axioms_template(
        common_root,
        axioms_path=args.domain_axioms_path,
        axioms_alias=args.domain_axioms_alias,
        dry_run=args.dry_run,
    )

    if args.dry_run:
        print("\n[dry-run] 結束 — 未實際寫入任何檔案")
        return 0

    post_init_message(common_root, args.preset, charter_version)
    return 0


if __name__ == "__main__":
    sys.exit(main())
