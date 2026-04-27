#!/usr/bin/env python3
"""
charter-doctor — AgentCharter 健康檢查 + 升版 dry-run 工具（MVP）

Phase 1 reference impl，對應 versioning-migration §3.1 第 3 步「跑
/charter-doctor --target-version=<new>」的落實。

用法：
    # 健康檢查當前狀態
    python charter-doctor.py

    # 升版 dry-run（對照 CHANGELOG 找 BREAKING）
    python charter-doctor.py --target-version 0.6.0 --dry-run

    # 指定 common memory root（預設 agent-commons/）
    python charter-doctor.py --common-root management/

依賴：PyYAML + Python 3.8+ stdlib

退出碼：
    0 = 全綠
    1 = 有 ERROR
    2 = 引數 / 環境問題
"""

from __future__ import annotations
import argparse
import re
import sys
from pathlib import Path
from typing import Any

try:
    import yaml
except ImportError:
    print("❌ 需要 PyYAML：pip install pyyaml", file=sys.stderr)
    sys.exit(2)

# Windows console 預設可能是 cp950 / cp1252；強制 UTF-8 才能輸出 emoji
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
CHANGELOG_PATH = CHARTER_ROOT / "CHANGELOG.md"

# v0.5.7 已知強制條款（架構級前提，無 enabled 開關）
ARCHITECTURAL_PRECONDITIONS = {"common-memory-root", "charter-config"}

# v0.5.7 全部條款集（用於檢測 enabled 清單拼字錯誤）
KNOWN_CONDITIONS = {
    "role-separation", "audit-rights", "failure-modes",
    "structural-anti-fabrication", "violation-reflection",
    "escalation-protocol", "evidence-first", "output-mode-protocol",
    "completion-delivery", "handoff-chain", "cross-ai-handoff",
    "role-conflict-resolution", "multi-role-tracking",
    "domain-axiom-slot", "versioning-migration",
    "working-stack-discipline", "init-template",
}


# ──────────────────────────────────────────────
# SemVer 工具
# ──────────────────────────────────────────────

SEMVER_RE = re.compile(r"^(\d+)\.(\d+)\.(\d+)$")


def parse_semver(s: str) -> tuple[int, int, int] | None:
    m = SEMVER_RE.match(s.strip())
    return tuple(int(x) for x in m.groups()) if m else None  # type: ignore[return-value]


def cmp_semver(a: str, b: str) -> int:
    """回傳 -1 / 0 / 1。無法解析回傳 0。"""
    pa, pb = parse_semver(a), parse_semver(b)
    if pa is None or pb is None:
        return 0
    return (pa > pb) - (pa < pb)


def is_cross_major_jump(current: str, target: str) -> bool:
    """跳超過一個 MAJOR（如 0.x → 2.x）視為違反 versioning-migration §3.3。"""
    pc, pt = parse_semver(current), parse_semver(target)
    if pc is None or pt is None:
        return False
    return pt[0] - pc[0] > 1


# ──────────────────────────────────────────────
# 報告器
# ──────────────────────────────────────────────


class Report:
    def __init__(self) -> None:
        self.errors: list[str] = []
        self.warnings: list[str] = []
        self.infos: list[str] = []

    def err(self, msg: str) -> None:
        self.errors.append(msg)
        print(f"   ❌ {msg}")

    def warn(self, msg: str) -> None:
        self.warnings.append(msg)
        print(f"   ⚠️  {msg}")

    def ok(self, msg: str) -> None:
        print(f"   ✅ {msg}")

    def info(self, msg: str) -> None:
        self.infos.append(msg)
        print(f"   ℹ️  {msg}")

    def summary(self) -> int:
        print()
        print(f"📊 Summary: {len(self.errors)} errors / "
              f"{len(self.warnings)} warnings / {len(self.infos)} infos")
        return 1 if self.errors else 0


# ──────────────────────────────────────────────
# YAML 載入
# ──────────────────────────────────────────────


def load_yaml(path: Path) -> dict[str, Any] | None:
    if not path.exists():
        return None
    try:
        with path.open(encoding="utf-8") as f:
            return yaml.safe_load(f)
    except Exception as e:
        print(f"❌ 解析 {path} 失敗：{e}", file=sys.stderr)
        sys.exit(2)


# ──────────────────────────────────────────────
# CHANGELOG 解析（簡化版）
# ──────────────────────────────────────────────


VERSION_HEADER_RE = re.compile(r"^## \[(\d+\.\d+\.\d+)\]")
SECTION_HEADER_RE = re.compile(r"^### (.+?)$")


def parse_changelog(path: Path, from_version: str, to_version: str) -> list[dict]:
    """從 CHANGELOG 拉出 (from_version, to_version] 區間的條目。
    不做 BREAKING 自動判斷，只返回原文段落讓人類過目。"""
    if not path.exists():
        return []

    entries: list[dict] = []
    current: dict | None = None
    current_section: str | None = None

    with path.open(encoding="utf-8") as f:
        for line in f:
            ver_match = VERSION_HEADER_RE.match(line)
            if ver_match:
                if current is not None:
                    entries.append(current)
                ver = ver_match.group(1)
                # 只收集 from < ver <= to
                if cmp_semver(ver, from_version) > 0 and cmp_semver(ver, to_version) <= 0:
                    current = {"version": ver, "sections": {}}
                    current_section = None
                else:
                    current = None
                continue

            if current is None:
                continue

            sec_match = SECTION_HEADER_RE.match(line)
            if sec_match:
                current_section = sec_match.group(1).strip()
                current["sections"].setdefault(current_section, [])
                continue

            if current_section:
                current["sections"][current_section].append(line.rstrip("\n"))

    if current is not None:
        entries.append(current)

    return entries


def detect_breaking_signals(sections: dict[str, list[str]]) -> list[str]:
    """偵測 BREAKING / BREAKING-LITE — 只認 section 標題，不掃內文（避免
    false-positive：CHANGELOG 內文常引用 BREAKING 概念但本版未實際破壞）。

    CHANGELOG 風格約定：本版含 BREAKING 變更須在 ### 標題明示，如：
      ### BREAKING
      ### BREAKING — schema 不相容變更
      ### BREAKING-LITE — 架構級小破壞
    """
    signals: list[str] = []
    for sec_name in sections:
        upper = sec_name.upper()
        # 只看開頭 — 「### BREAKING ...」算，「### Modified — 引用 BREAKING 條款」不算
        if upper.startswith("BREAKING"):
            signals.append(f"§{sec_name}")
    return signals


# ──────────────────────────────────────────────
# 健康檢查（基本）
# ──────────────────────────────────────────────


def check_basic(common_root: Path, report: Report) -> tuple[dict | None, dict | None]:
    print("\n📦 Common Memory Root 結構檢查")

    if not common_root.exists():
        report.err(f"Common Memory Root '{common_root}' 不存在 — 採用方未接入 charter")
        return None, None
    report.ok(f"Common Memory Root: {common_root}/")

    config_dir = common_root / "_config"
    if not config_dir.exists():
        report.err(f"_config/ 目錄不存在於 {common_root}")
        return None, None

    profile = load_yaml(config_dir / "profile.yaml")
    mapping = load_yaml(config_dir / "mapping.yaml")

    if profile is None:
        report.err("profile.yaml 不存在")
    else:
        report.ok("profile.yaml 存在")

    if mapping is None:
        report.err("mapping.yaml 不存在")
    else:
        report.ok("mapping.yaml 存在")

    return profile, mapping


def check_profile(profile: dict, report: Report) -> str | None:
    print("\n📋 profile.yaml 檢查")

    schema_ver = profile.get("version")
    charter_ver = profile.get("charter_version")
    preset = profile.get("preset")

    if not schema_ver:
        report.err("profile.yaml 缺 version 欄位（profile schema 自身版本）")
    else:
        report.ok(f"profile schema version: {schema_ver}")

    if not charter_ver:
        report.err("profile.yaml 缺 charter_version 欄位")
        return None
    report.ok(f"charter_version: {charter_ver}")

    if not preset:
        report.warn("preset 欄位缺（建議標明 minimal / standard / strict / custom）")
    else:
        report.ok(f"preset: {preset}")

    enabled = profile.get("enabled", {})
    if not isinstance(enabled, dict):
        report.err("profile.yaml.enabled 不是 mapping")
    else:
        unknown = set(enabled.keys()) - KNOWN_CONDITIONS
        if unknown:
            report.warn(f"未知條款名（可能拼字錯或新版條款）：{sorted(unknown)}")
        active = sum(1 for v in enabled.values() if v)
        report.ok(f"enabled 條款：{active}/{len(enabled)} 啟用")

    return charter_ver


def check_mapping(common_root: Path, mapping: dict, profile: dict | None,
                  report: Report) -> None:
    print("\n🗺️  mapping.yaml 檢查")

    schema_ver = mapping.get("version")
    if not schema_ver:
        report.warn("mapping.yaml 缺 version 欄位")
    else:
        report.ok(f"mapping schema version: {schema_ver}")

    cmr = mapping.get("common_memory_root")
    if not cmr:
        report.err("mapping.yaml 缺 common_memory_root（v0.4.1 起必填）")
    else:
        report.ok(f"common_memory_root: {cmr}")

    # domain_axioms.primary（charter-config §3 必填）
    da = mapping.get("domain_axioms", {})
    primary = da.get("primary") if isinstance(da, dict) else None
    if not primary:
        report.err("mapping.yaml 缺 domain_axioms.primary（charter-config §3 必填）")
    else:
        primary_path = common_root / primary if not Path(primary).is_absolute() else Path(primary)
        # 也試試直接從專案根
        if not primary_path.exists():
            project_relative = Path.cwd() / primary
            if project_relative.exists():
                primary_path = project_relative
        if primary_path.exists():
            report.ok(f"domain_axioms.primary 路徑存在: {primary_path}")
        else:
            report.err(f"domain_axioms.primary 路徑不存在: {primary} "
                       f"(違反 domain-axiom-slot.md §3.1 位置存在)")

    # shared.draft_context（working-stack-discipline 啟用時必填）
    enabled = (profile or {}).get("enabled", {})
    shared = mapping.get("shared", {})

    if enabled.get("working-stack-discipline"):
        draft = shared.get("draft_context") if isinstance(shared, dict) else None
        if not draft:
            report.err("mapping.yaml 缺 shared.draft_context "
                       "(working-stack-discipline 啟用時必填)")
        else:
            draft_path = common_root / draft if not Path(draft).is_absolute() else Path(draft)
            if draft_path.exists():
                report.ok(f"DRAFT_CONTEXT 存在: {draft_path}")
            else:
                report.warn(f"shared.draft_context 路徑不存在: {draft_path}（建議建空檔）")

        archive = shared.get("archive") if isinstance(shared, dict) else None
        if archive:
            report.ok(f"shared.archive: {archive}")
        else:
            report.info("shared.archive 未填（建議填，save 觸發歸檔位置）")


# ──────────────────────────────────────────────
# 升版 dry-run
# ──────────────────────────────────────────────


def upgrade_dry_run(current_ver: str, target_ver: str, report: Report) -> None:
    print(f"\n🔍 升版 dry-run：{current_ver} → {target_ver}")

    if cmp_semver(target_ver, current_ver) <= 0:
        report.err(f"目標版本 {target_ver} 不大於當前 {current_ver}")
        return

    if is_cross_major_jump(current_ver, target_ver):
        report.err(
            f"跨 MAJOR 跳升不允許（versioning-migration §3.3）— "
            f"{current_ver} → {target_ver} 跳超過一個主版號"
        )
        return

    entries = parse_changelog(CHANGELOG_PATH, current_ver, target_ver)
    if not entries:
        report.warn(
            f"CHANGELOG.md 中無 ({current_ver}, {target_ver}] 區間的條目 — "
            f"可能 CHANGELOG 未含目標版本，或 charter repo 未更新到該版"
        )
        return

    breaking_total = 0
    for entry in entries:
        ver = entry["version"]
        sections = entry["sections"]
        signals = detect_breaking_signals(sections)

        print(f"\n   📌 v{ver}")
        for sec in sections:
            print(f"      § {sec}")

        if signals:
            for sig in signals:
                report.err(f"v{ver} 含 BREAKING 訊號：{sig}")
                breaking_total += 1
        else:
            report.ok(f"v{ver} 未偵測到 BREAKING 訊號（仍建議人工 review）")

    print()
    if breaking_total > 0:
        report.warn(
            f"共 {breaking_total} 個 BREAKING 訊號 — 升版前須讀完 CHANGELOG 對應段，"
            f"並依 versioning-migration §3.1 走完 7 步流程"
        )
    else:
        report.info(
            "無 BREAKING 訊號 — 預期為 PATCH/MINOR 升級；仍建議走 versioning-migration "
            "§3.1 第 5-7 步（doctor 確認 → 升 charter_version → commit）"
        )


# ──────────────────────────────────────────────
# 主流程
# ──────────────────────────────────────────────


def main() -> int:
    parser = argparse.ArgumentParser(
        description="AgentCharter 健康檢查 + 升版 dry-run（MVP）"
    )
    parser.add_argument(
        "--common-root",
        default="agent-commons",
        help="Common Memory Root 目錄（預設: agent-commons/）"
    )
    parser.add_argument(
        "--target-version",
        help="升版目標 charter_version（如 0.6.0）。指定則進入 dry-run 模式"
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="dry-run 旗標（與 --target-version 配合）"
    )
    args = parser.parse_args()

    common_root = Path(args.common_root).resolve()

    print("📋 Charter Doctor")
    print("=" * 50)
    print(f"  charter repo:   {CHARTER_ROOT}")
    print(f"  common root:    {common_root}")
    print(f"  目標版本:       {args.target_version or '(未指定，僅健康檢查)'}")
    print()

    report = Report()

    profile, mapping = check_basic(common_root, report)
    if profile is None or mapping is None:
        return report.summary()

    current_ver = check_profile(profile, report)
    check_mapping(common_root, mapping, profile, report)

    if args.target_version and current_ver:
        upgrade_dry_run(current_ver, args.target_version, report)

    return report.summary()


if __name__ == "__main__":
    sys.exit(main())
