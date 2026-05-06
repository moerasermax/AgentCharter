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

## 工具清單（採用方視角 — 我想用 X 怎麼裝）

### 1. `/checkpoints` — 跨 session 存檔機制（救你 context 清空）

#### 它做什麼

裝這個之後、你的 AI 每次工作結束打 `/checkpoints save`、charter 自動：
- 把當前草稿（`DRAFT_CONTEXT.md`）轉成 `HANDOFF_<N>.md`
- git commit 自動 tag
- 下次接班打 `/checkpoints load` → 30 秒對齊脈絡、不怕 context 清空

#### 三個指令日常使用

| 指令 | 何時用 | 結果 |
|---|---|---|
| `/checkpoints save` | 工作結束、要 session 中斷 | 生成 HANDOFF + git commit + clear draft |
| `/checkpoints load` | 接班 / 新 session 起手 | 讀最新 HANDOFF、30 秒對齊脈絡 |
| `/checkpoints status` | 想看當前進度 | 顯示草稿大小、最新 HANDOFF 編號、git 狀態 |

#### 安裝（給 Gemini PM 貼這個 prompt）

```
請依 ~/.agentcharter/roles/pm/gemini-cli.md §3.7 安裝 /checkpoints
```

或者**直接自然語言問 AI**（v0.10.4 起 Gemini PM 會自動觸發安裝流程）：

```
我想裝 charter 的 /checkpoints 跨 session 存檔機制
```

PM 會：
1. 介紹三指令用法（同上表）
2. 詢問「需要現在幫你裝嗎？」
3. 你說「好」→ PM 自動跑三分支偵測（MISSING 安裝 / STALE 升版 / CURRENT 跳過）+ 建 `.gemini/commands/checkpoints.toml`
4. 完成、不到 1 分鐘

#### 技術細節（給設計者看）

| 屬性 | 內容 |
|---|---|
| **版本** | v2.2（charter v0.9.6+）|
| **canonical 路徑** | `~/.agentcharter/tools/vendor/commons/checkpoints_handler.sh` |
| **deploy 路徑** | `~/.gemini/checkpoints_handler.sh`（Gemini PM 私有目錄）|
| **對應 spec** | `roles/pm/gemini-cli.md §3.7`（save/load/status/config 流程） |
| **handler 動作**（內部）| `save` / `load` / `commit_save` / `deactivate_all_active` |
| **何時建立** | v0.9.2（dogfood signal #3 — 原 management/ 路徑硬編碼修正）|
| **跨 vendor 預期** | 邏輯層 vendor 中立、橋接層 vendor 特定（Claude Code / Cursor 邀請制接入）|

---

### 2. Commit Hook — 每次 git commit 自動擋紀律違反

#### 它做什麼

裝這個之後、**每次 `git commit` charter 自動跑 H1-H7 binary 攔截**、發現紀律違反就擋住、要修補才能 commit、避免有問題的東西進 git 歷史。

#### 7 條 binary 攔截紀律 + 具體例子

| 校驗 | 違反例 | 擋了會發生 | 嚴格度 |
|---|---|---|---|
| **H1** _role.md Status 升 ACTIVE 沒寫授權字樣 | AI init 完自改 Status: ACTIVE、沒 user 對話痕跡 | commit 被擋 + 要求補「由 user 於 X 日授權」字樣 | reject |
| **H2** commit 提 F-mode 但 log + reflection 沒雙寫 | commit message 寫「fix F1 假宣告」但 `state/failure_mode_log.md` 沒新 entry | 擋 + 要求補 log entry + reflection 個體層檔 | reject |
| **H3** reflection 檔名 regex 違反 | 檔名寫 `PROTOCOLS.md` / `reflection-on-s36.md`（沒日期前綴）| 擋 + 改 `2026-05-06_f1_pm_coordination.md` 才能 commit | reject |
| **H4** reflection 含 sprint 編號 | reflection 內文寫「S36 決策：先做 X」（project state 寫進 meta-knowledge）| warn 不擋、提示搬到 capsule | warn |
| **H5** failure_mode_log 加 entry 但沒對應 reflection 檔 | 只在集體 log 寫、漏個體 reflection | 擋 + 要求補 reflection 個體層檔 | reject |
| **H6** handoff 缺「致 XXX」directive header | HANDOFF_5.md 直接列任務、沒 `致 Kiro (Engineer)` 起始 | warn 不擋、提示加 header | warn |
| **H7** profile.yaml 缺強制必啟欄位（如 F6）| `enable_modes: ["F1","F2","F3","F4","F5"]`（缺 F6）| 擋 + 要求補 F6（v0.10.2 加、schema-driven） | reject |

→ **白話總結**：裝了 hook 之後、AI 想偷懶（自激活 / 不自報 / 漏雙寫 / 編造）→ commit 直接擋、強制守紀律。

#### 安裝（一行 bash 命令）

```bash
# 在採用方專案根目錄跑（dbSDK / CryptoBot / 你的專案）
bash ~/.agentcharter/tools/vendor/commons/install-git-hooks.sh
```

或對 AI 貼這個 prompt：

```
我想裝 charter commit hook（H1-H7 binary 攔截）
```

AI 會跑上面那行 bash + 確認安裝結果。

#### 升版 / 移除

```bash
# charter pull 拿新版邏輯後同步
bash ~/.agentcharter/tools/vendor/commons/install-git-hooks.sh --update

# 不想用了
bash ~/.agentcharter/tools/vendor/commons/install-git-hooks.sh --uninstall
```

#### 安裝後驗證 — 故意違反看看擋不擋

```bash
# 故意違反 H3（檔名沒日期前綴）
mkdir -p agent-commons/roles/engineer/reflections
echo "test" > agent-commons/roles/engineer/reflections/test.md
git add agent-commons/roles/engineer/reflections/test.md
git commit -m "test"
# 預期：❌ [H3 REJECT] reflection 檔名違反 regex（^\d{4}-\d{2}-\d{2}_<topic>.md$）— 實際：test.md
```

#### 不裝會怎樣？

不裝 hook 也能用 charter — H1-H7 退化成 spec 紀律 advisory（LLM 跑 doctor / verify 時 scan）、但**不 binary 攔截**。對應 v0.10.0「opt-in 邀請制原則」。

#### 想暫時繞過（緊急情況）？

```bash
git commit --no-verify -m "..."   # git 既有逃生口、user 知情前提下合法
```

→ 但 **AI 自主用 --no-verify 繞過 = `core/role-separation §3.5` 結構性繞路 = F1**。

#### 技術細節（給設計者看）

| 屬性 | 內容 |
|---|---|
| **canonical 邏輯層** | `~/.agentcharter/tools/vendor/commons/charter-commit-checks.sh`（v1.1 / charter v0.10.2+ 含 H7）|
| **deploy 邏輯層** | `<project>/agent-commons/_config/hooks/charter-commit-checks.sh`（**入 git**、跟專案分發、charter pull 後 `--update` sync）|
| **canonical 安裝器** | `~/.agentcharter/tools/vendor/commons/install-git-hooks.sh`（v1.0 / charter v0.10.0+）|
| **shim 位置** | `<project>/.git/hooks/pre-commit`（local-only、安裝器寫 3 行 thin shim）|
| **強制必啟集合 schema** | `tools/profiles/_required.yaml`（v0.10.2 加、H7 source of truth）|
| **對應 spec** | `tools/commit-hook-spec.md §3`（H1-H7 spec-as-data 四欄結構）|
| **何時建立** | v0.10.0 ship H1-H6 / v0.10.2 加 H7 schema-driven |

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
