# `tools/vendor/commons/` — vendor 中立共用工具集

> **位階**：tools / vendor 邊界例外集合
> **設計原則**：v0.5.9「framework 不附 binary」紀律的**例外情境**集中管理 — 凡屬「**vendor 中立 + git 通用層 + 無法用 AI spec 表達**」的小工具放這裡
> **保證**：跟隨 charter 升版 / canonical 一份維護 / 跨 vendor 共用 / 採用方靠 deploy 機制使用

---

## 為什麼存在這個目錄

charter 從 v0.5.9 起改為**純規範框架**（不附 python / npm 等實作工具），絕大多數動作由 AI 依 spec 自具象化。

但有少數情境**無法**用 AI spec 表達：

| 情境 | 為何不能走 spec | 走實作層的理由 |
|---|---|---|
| git pre-commit hook 接口 | git 觸發時機是 binary 事件、AI 無法在 commit 瞬間介入 | 必須走 git 原生 hook 接口 = 必須是 shell script |
| checkpoints save/load 跨 session 鎖定 | 需要 atomic 檔案操作 + git commit 序列保證 | shell script 比 AI 動作更可靠 |
| 一次性 install 流程（裝 hook 等）| 採用方用一次的便利化動作、不該每次都讓 AI 推 spec | 一鍵 install 比 prompt 高效 |

這些工具的共同特性：
- ✅ **vendor 中立**（Claude / Gemini / Kiro / Cursor 都能用）
- ✅ **git 通用層**（不寫進 `.claude/` / `.gemini/` 等 vendor 私有目錄）
- ✅ **canonical 一份維護**（charter 升版可傳播）
- ✅ **採用方靠 deploy 機制使用**（不直接從 charter 路徑跑、deploy 到專案內）

→ 對齊 `core/ai-vendor-onboarding §1`「framework 不代寫 vendor 層」精神：這些工具不在任何 vendor 私有目錄、跨 vendor 共用。

---

## 目錄結構

```
tools/vendor/commons/
├── README.md                         ← 本檔
├── checkpoints_handler.sh            ← /checkpoints save/load 邏輯層（v2.2）
├── charter-commit-checks.sh          ← commit hook H1-H6 校驗邏輯層（v1.0）
└── install-git-hooks.sh              ← commit hook 安裝器（v1.0）
```

---

## 工具清單

### 1. `checkpoints_handler.sh` — /checkpoints 邏輯層

| 屬性 | 內容 |
|---|---|
| **版本** | v2.2（charter v0.9.6+） |
| **對應 spec** | `roles/pm/gemini-cli.md §3.7`（PM /checkpoints save/load 流程） |
| **canonical 路徑** | `~/.agentcharter/tools/vendor/commons/checkpoints_handler.sh` |
| **deploy 路徑** | `~/.gemini/checkpoints_handler.sh`（Gemini PM）/ 其他 vendor 對應位置 |
| **動作** | `save` / `load` / `commit_save` / `deactivate_all_active` |
| **何時建立** | v0.9.2（dogfood signal #3 條款化、原 management/ 路徑硬編碼修正）|

**用途**：跨 session checkpoint save / load + 強制離線 active role 釋放（save 觸發 deactivate）。

**升版**：透過 PM init `§3.7 Step 1` 三分支版本偵測自動引導（MISSING 自動安裝 / STALE user 確認後升 / CURRENT 跳過）。

---

### 2. `charter-commit-checks.sh` — commit hook H1-H6 邏輯層

| 屬性 | 內容 |
|---|---|
| **版本** | v1.0（charter v0.10.0） |
| **對應 spec** | `tools/commit-hook-spec.md §3`（H1-H6 校驗紀律 + spec-as-data 結構） |
| **canonical 路徑** | `~/.agentcharter/tools/vendor/commons/charter-commit-checks.sh` |
| **deploy 路徑** | `<採用方專案>/agent-commons/_config/hooks/charter-commit-checks.sh`（**入 git**、跟專案分發） |
| **動作** | git pre-commit 觸發、跑 H1/H2/H3/H5 reject + H4/H6 warn |
| **何時建立** | v0.10.0（dogfood signal #33/#35/#42-#45 同源條款化）|

**用途**：commit 時 binary 攔截 6 條同源紀律違反（自激活 / 不自報 / 雙寫漏 / 檔名漂浮 / state 混 reflection / handoff 缺 directive header）。

**升版**：透過 `install-git-hooks.sh --update` 從 canonical 重 copy。

---

### 3. `install-git-hooks.sh` — commit hook 安裝器

| 屬性 | 內容 |
|---|---|
| **版本** | v1.0（charter v0.10.0） |
| **對應 spec** | `tools/commit-hook-spec.md §5`（採用方安裝步驟） |
| **canonical 路徑** | `~/.agentcharter/tools/vendor/commons/install-git-hooks.sh` |
| **deploy 路徑** | 採用方不需要 deploy（直接從 canonical 跑）|
| **動作** | `install` / `--update` / `--uninstall` / `--help` |
| **何時建立** | v0.10.0（commit hook ship 配套）|

**用途**：採用方一鍵裝 commit hook（copy `charter-commit-checks.sh` 到專案 + 寫 thin shim 到 `.git/hooks/pre-commit`）。

**用法**：

```bash
# 採用方專案根目錄跑
bash ~/.agentcharter/tools/vendor/commons/install-git-hooks.sh           # 首次安裝
bash ~/.agentcharter/tools/vendor/commons/install-git-hooks.sh --update  # charter 升版後 sync 邏輯
bash ~/.agentcharter/tools/vendor/commons/install-git-hooks.sh --uninstall  # 移除
```

---

## 共通設計 pattern

### Pattern 1：canonical / deploy 兩層分離

| 工具 | canonical（charter 維護） | deploy（採用方使用） |
|---|---|---|
| checkpoints_handler.sh | `~/.agentcharter/tools/vendor/commons/` | `~/.gemini/`（vendor 對應位置） |
| charter-commit-checks.sh | `~/.agentcharter/tools/vendor/commons/` | `<project>/agent-commons/_config/hooks/`（**入 git**） |
| install-git-hooks.sh | `~/.agentcharter/tools/vendor/commons/` | （採用方直接從 canonical 跑、無 deploy）|

**設計含義**：
- canonical 一份、charter 升版同步維護
- deploy 機制各工具略不同（部分入 git 跟專案、部分裝 user-home、部分不 deploy）
- 採用方靠 install / sync 機制使用、不直接從 canonical 路徑跑（除非工具設計就是這樣，如 install-git-hooks.sh）

### Pattern 2：vendor 中立（不寫 vendor 私有目錄）

對齊 `core/ai-vendor-onboarding §1`「framework 不代寫 vendor 層」紀律：

- ❌ **不放這裡**：`.claude/hooks/*.sh` / `.gemini/commands/*.toml` / `.cursor/rules/*.mdc`（vendor 私有 = 各 vendor 自己管）
- ✅ **放這裡**：`charter-commit-checks.sh` / `install-git-hooks.sh`（vendor 中立 + git 通用層）

例外：`checkpoints_handler.sh` deploy 路徑是 `~/.gemini/`（v0.9.6 起、Gemini PM 專屬使用）— 但 canonical 仍在這裡（charter 維護單一真實源、cross-vendor 未來邀請接入時也走同一邏輯層）。

### Pattern 3：版本內建 + 升版偵測

每個工具開頭 frontmatter 含：

```bash
# Canonical version: v<X> (charter v<Y>+)
# Canonical path: tools/vendor/commons/<name>.sh
# Deploy path:    <where-it-lands>
```

採用方端工具（如 PM init）會偵測 deploy 版本是否落後 canonical、引導升版（如 `roles/pm/gemini-cli.md §3.7 Step 1` 三分支偵測）。

### Pattern 4：升版傳播

| 工具 | 升版傳播機制 |
|---|---|
| checkpoints_handler.sh | PM init `§3.7 Step 1` 三分支偵測（MISSING 自動安裝 / STALE 詢問升版 / CURRENT 跳過）|
| charter-commit-checks.sh | `install-git-hooks.sh --update`（採用方 charter pull 後跑一次）|
| install-git-hooks.sh | 不需傳播（採用方直接從 charter 路徑跑、charter pull 後就是最新）|

---

## 何時新增到本目錄

新增工具到 `tools/vendor/commons/` 前，先確認以下三條全符合：

| 條件 | 必須符合？ | 說明 |
|---|---|---|
| **vendor 中立** | ✅ 必須 | 寫進 `.claude/` / `.gemini/` 等 vendor 私有目錄的、不放這裡（讓 vendor 自己管）|
| **無法用 AI spec 表達** | ✅ 必須 | 能用 `tools/<name>-spec.md` 由 AI 自具象化執行的、不放這裡（保留純規範精神）|
| **canonical 一份維護有意義** | ✅ 必須 | 採用方專案各自寫的、不放這裡（除非有 cross-project 共用價值）|

不符合 ↑ 任一條 → 不該放這裡。對應 `core/ai-vendor-onboarding §1` 邀請制原則 + v0.5.9「不附 binary」紀律例外管理。

---

## 與其他 charter 結構的關係

| 路徑 | 角色 | 與本目錄關係 |
|---|---|---|
| `tools/*-spec.md` | spec 層（init / doctor / commit-hook / uninstall / scan / post-upgrade-verify）| 本目錄是 spec 層的 reference 實作層（spec 寫紀律、本目錄寫實作）|
| `templates/agent-commons/*.tpl` | 採用方產出物範本（capsule / handoff / reflection 等）| 本目錄不是範本、是工具腳本（兩者軸不同）|
| `tools/profiles/*.yaml` | preset 配置（minimal / essential / standard / strict）| 本目錄不是配置、是執行邏輯 |
| `roles/<role>/<vendor>.md` | vendor 層 spec（claude-code / gemini-cli / cursor）| 本目錄是 vendor 中立 — 各 vendor 在自家 init 流程**呼叫**本目錄工具、不在 vendor.md 內重寫工具邏輯 |

---

## 變更歷史

- **v1.0（2026-05-05，charter v0.10.0）** — 初版 README：3 個既有工具（checkpoints_handler v2.2 / charter-commit-checks v1.0 / install-git-hooks v1.0）導覽 + 4 個共通設計 pattern + 新工具加入決策三條件。對應 charter v0.10.0 ship 時 user 提議「`tools/vendor/commons/` 應有專屬說明檔」。
