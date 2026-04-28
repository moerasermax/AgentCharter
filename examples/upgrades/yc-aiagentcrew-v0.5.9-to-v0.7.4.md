# 升版實證 walkthrough：YC_AIAgentCrew v0.5.9 → v0.7.4

> **建立**：2026-04-28
> **位階**：採用方升版實證範例 — 對應 charter [`core/versioning-migration.md §3.4`](../../core/versioning-migration.md) 跨多版本升級指引
> **觸發**：YC_AIAgentCrew（2026-04-28 v0.5.9 接入）同日 charter 演化到 v0.7.4 + Gemini CLI v0.39.1 載入器升級導致 toml 失效 → 觸發 user 提「**回鍋開發者無痛**」設計北極星 + 具體升版指引請求
> **對應北極星**：README §設計哲學 — 「**回鍋開發者無痛**」（不管採用方遇到什麼狀態 — 全新接入 / 升版 / 棄用 / 停用一段時間後重新採用 — charter 都隨時支援、無摩擦銜接）

---

## 0. 為什麼這個 walkthrough 重要

YC_AIAgentCrew 的情境是 charter 設計的**真實 stress test**：

| 維度 | 狀態 |
|---|---|
| 接入版本 | v0.5.9（2026-04-28 上午） |
| 當前 charter 版本 | v0.7.4（2026-04-28 晚上） |
| 跨 release 數 | 8 個（v0.5.10 / v0.6.0 / v0.6.1 / v0.7.0 / v0.7.1 / v0.7.2 / v0.7.3 / v0.7.4）|
| 含 BREAKING-LITE | 1 個（v0.7.0，已追溯標明）|
| vendor 端問題 | Gemini CLI v0.39.1 載入器拒絕舊 toml schema（nested 結構）|

→ 這個 case **同時測試**：
1. charter 自身升版機制（cross-version migration）
2. v0.5.9 引入的「agent-commons 結構穩定性承諾」（[versioning-migration §2.3](../../core/versioning-migration.md)）
3. v0.7.4 加的 vendor schema 規範（[roles/pm/gemini-cli.md §3.6](../../roles/pm/gemini-cli.md)）
4. 北極星紀律「回鍋開發者無痛」

---

## 1. 升版前狀態（v0.5.9 接入時）

YC_AIAgentCrew 在 v0.5.9 接入時的 baseline 狀態：

### 1.1 結構

```
YC_AIAgentCrew/
├── management/                       ← 採用方覆寫 common_memory_root（v0.5.9 純規範化、結構穩定承諾）
│   ├── _config/
│   │   ├── profile.yaml              ← charter_version: "0.5.9"
│   │   └── mapping.yaml
│   ├── capsules/
│   ├── handoffs/                     ← HANDOFF_15.md 等歷史 handoff
│   ├── institutional-memory/
│   ├── protocols/
│   │   └── Dev_Protocol_IRON.md      ← 領域公理 alias = IRON
│   ├── PM_Operational_Manual.md
│   ├── NextWork.md
│   ├── state/
│   └── roles/
│       ├── pm/_role.md
│       └── engineer/_role.md
├── .gemini/commands/
│   ├── charter-init.toml             ← v0.5.9 接入時 Gemini 自具象化（nested schema、被 v0.39.1 拒絕）
│   ├── engineer-init.toml            ← 同上
│   └── pm-init.toml                  ← 同上
├── .claude/commands/                  ← Claude Code 接 Engineer 角色
│   └── engineer-init.md
└── src/                              ← 採用方專案 src
```

### 1.2 profile.yaml（v0.5.9 接入時）

```yaml
version: "0.4.0"
charter_version: "0.5.9"
preset: standard

enabled:
  role-separation: true
  audit-rights: true
  failure-modes: true
  structural-anti-fabrication: true
  violation-reflection: true
  escalation-protocol: true
  evidence-first: true
  output-mode-protocol: true
  completion-delivery: true
  handoff-chain: true
  cross-ai-handoff: true
  role-conflict-resolution: true
  multi-role-tracking: true
  domain-axiom-slot: true
  versioning-migration: true
  working-stack-discipline: true
  maintainer-discipline: false
  init-template: true
  # ai-vendor-onboarding: 不存在（v0.6.0 才加）

parameters:
  failure-modes:
    enable_modes: [F1, F2, F3, F4, F5]   # 缺 F6（v0.5.10 加 F6 但 preset 漏改）
  # ...
```

### 1.3 vendor toml（被 Gemini CLI v0.39.1 拒絕的 schema）

```toml
# .gemini/commands/pm-init.toml — v0.5.9 接入時 Gemini 自編格式
name = "pm-init"

[command]
description = "PM 值機初始化"

[command.instruction]
prompt = """
你現在扮演 PM...
"""
```

→ 觸發 Gemini CLI v0.39.1 的：
```
✕ [FileCommandLoader] Skipping invalid command file: pm-init.toml
```

---

## 2. 跨 8 個 release 的演化軸（user 認知地圖）

依 [versioning-migration §3.4](../../core/versioning-migration.md)「跨多版本升級」精神，user **不必逐版執行升級**、但要對演化軸**有認知**：

| Release | 對採用方影響 | YC 是否需動作 | charter migration 級別 |
|---|---|---|---|
| **v0.5.10** | self-instantiation 6 → 7 步、加 F6 | ⚪ 既有 _role.md 不溯及；下次重做 self-instantiation 自然走 7 步 | MINOR |
| **v0.6.0** | 邀請制條款 + auditor + validator + LLM 繞路紀律 gap 封閉 | 🟡 profile.yaml `enabled` 加 `ai-vendor-onboarding: true`（採用方接新 vendor 時須遵守邀請制）| MINOR |
| **v0.6.1** | 文檔層 sync 修補（auditor 第一次實戰）| ⚪ 0 動作 | PATCH |
| **v0.7.0** | **BREAKING-LITE** — Phase 5b 採用方半邊封閉 + namespace 校驗 + step 6 PROVISIONAL/ACTIVE + F6 強制必啟 | 🔴 兩個 migration 點：(a) `enable_modes` 加 F6 (b) mapping `shared/` 中介層 migration（YC 不適用、無此問題）| BREAKING-LITE（追溯標明）|
| **v0.7.1** | 領域公理雙路徑 + frontmatter scaffold（mutability + Status）| ⚪ 既有 axiom 檔可選加 frontmatter；不加也 work | PATCH |
| **v0.7.2** | 文檔層 sync condition 化（maintainer-discipline §3.4）+ structural-anti-fabrication §5 補引用 | ⚪ 0 動作（純 maintainer 紀律 + 反向引用）| PATCH |
| **v0.7.3** | 完整文檔層 sync sweep + README 設計哲學北極星顯化 | ⚪ 0 動作（純文檔對齊）| PATCH |
| **v0.7.4** | **vendor 端 schema 規範條款化** | 🔴 三個 toml 改扁平結構（Gemini CLI v0.39.1 載入器要求）| PATCH（純擴增、實作 defer v0.8+）|

### 2.1 YC 必做動作摘要

| # | 動作 | 觸發 release | 風險級別 |
|---|---|---|---|
| 1 | profile.yaml `parameters.failure-modes.enable_modes` 加 F6 | v0.7.0 BREAKING-LITE | 必修 |
| 2 | profile.yaml `enabled.ai-vendor-onboarding` 加（如未來要邀請新 vendor）| v0.6.0 | 建議 |
| 3 | 三個 vendor toml 改扁平結構 | v0.7.4 | 必修（Gemini CLI v0.39.1 已拒絕舊格式）|
| 4 | profile.yaml + ADOPTION/TUTORIAL/maintainer-load 引用版號 → v0.7.4 | 純文字 | 必修 |
| 5 | （可選）axiom 檔加 frontmatter（status / mutability_default / created_by / created_at）| v0.7.1 | 可選（既有採用方繼續用無 frontmatter 也 work）|

### 2.2 YC 不適用的 migration 點

- **mapping `shared/` 中介層 migration**（v0.7.0 doctor §3.7 E601/E602）— YC 用 `management/` 結構、未踩 namespace 誤翻譯坑（這個 trap 是 v0.7.0 公司接入失敗才出現的、charter v0.5.9 沒這個錯誤）
- **agent-commons 結構重建** — v0.5.9 引入「結構穩定性承諾」（[versioning-migration §2.3](../../core/versioning-migration.md)）保證 v0.5.9 後採用方結構零變更

---

## 3. YC v0.5.9 → v0.7.4 升版步驟（依 [versioning-migration §3.1](../../core/versioning-migration.md) 7 步流程）

### Step 1：讀 CHANGELOG.md（特別 BREAKING-LITE 段）

採用方 user prompt：

```
請讀 ~/.agentcharter/CHANGELOG.md 的 v0.6.0 / v0.7.0 / v0.7.4 段
（本次升版範圍含的 MINOR + BREAKING-LITE + 對採用方有 migration 動作的 PATCH），
摘述對 YC_AIAgentCrew 的具體影響：
- 哪些 schema 欄位需新增？
- 哪些紀律須對應啟用？
- 哪些既有檔需改寫？
```

預期 AI 回報摘要對齊 §2.1 的 YC 必做動作摘要表。

### Step 2：（MAJOR 才需 migration script）— 本次跨 v0.x 多版本不需要

依 versioning-migration §3.3，跨 MAJOR 跳升禁止；但 v0.x 階段同主版號內跨多 MINOR 升級**允許**（agent-commons 結構穩定承諾保證）。

### Step 3：跑 doctor dry-run 抓問題

採用方 user prompt：

```
請依 ~/.agentcharter/tools/doctor-spec.md 對 YC_AIAgentCrew/management/ 跑
dry-run（target-version=0.7.4），列出本專案在 v0.7.4 下會踩到的問題：
- §3.1 結構完整性（management/ 下必要目錄）
- §3.5 領域公理（IRON.md 存在 + 結構非空）
- §3.7 結構頂層 + namespace 校驗（v0.7.0 加，YC 用 management/ 不踩此坑）
- §3.8 vendor schema check（v0.7.4 spec 層加、實作 defer v0.8+；YC 三個 toml
  目前在 Gemini CLI v0.39.1 已被拒絕）
- profile.yaml `enable_modes` 是否含 F6
```

預期 doctor 回報：
- ✅ 結構完整性 / 領域公理 / namespace 校驗：通過
- ❌ profile.yaml `enable_modes` 缺 F6（E605）
- ⚠️ vendor toml schema 未對齊扁平結構（v0.7.4 §3.8 spec 層警告、實作待 v0.8+；當前已被 Gemini CLI 端拒絕）

### Step 4：應用 migration（YC 三個必做動作）

#### 4.1 profile.yaml 修補

```yaml
# YC_AIAgentCrew/management/_config/profile.yaml
# 改 1：升 charter_version
charter_version: "0.7.4"   # 原 "0.5.9"

# 改 2：parameters.failure-modes.enable_modes 加 F6
parameters:
  failure-modes:
    enable_modes: [F1, F2, F3, F4, F5, F6]   # 原 [F1, F2, F3, F4, F5]

# 改 3（建議）：enabled 加 ai-vendor-onboarding（未來接新 vendor 時生效）
enabled:
  # ...既有 18 條...
  ai-vendor-onboarding: true   # v0.6.0 加；YC 接新 vendor / 新角色時走邀請制
```

#### 4.2 三個 vendor toml 改扁平結構

依 [`roles/pm/gemini-cli.md §3.6`](../../roles/pm/gemini-cli.md) 強制紀律：

```toml
# .gemini/commands/charter-init.toml — 改後（扁平結構）
description = "Charter 接入初始化"

prompt = """
（既有 prompt 內容、純複製過來）
"""
```

```toml
# .gemini/commands/engineer-init.toml — 改後
description = "Engineer 角色 init"

prompt = """
（既有 prompt 內容）
"""
```

```toml
# .gemini/commands/pm-init.toml — 改後
description = "PM 角色 init"

prompt = """
（既有 prompt 內容）
"""
```

採用方 user prompt（給 Gemini 自己改）：

```
依 ~/.agentcharter/roles/pm/gemini-cli.md §3.6 強制紀律，把
.gemini/commands/{charter,engineer,pm}-init.toml 三個檔改成扁平結構：
- 移除 [command] / [command.instruction] 等 nested table
- 移除 name 欄位（檔名 = 指令名）
- description + prompt 直接寫在 root level

完成後在 Gemini CLI 跑 /pm-init 等驗證能正常載入。
```

#### 4.3 （可選）axiom 檔加 frontmatter

依 [`templates/agent-commons/domain-axioms.md.tpl`](../../templates/agent-commons/domain-axioms.md.tpl) v0.7.1 加 frontmatter：

```yaml
---
status: USER-RATIFIED
mutability_default: APPEND-ONLY
created_by: user
created_at: 2026-04-28
---

# IRON Domain Axioms
（既有 IRON.md 內容、純複製過來）
```

→ 不加也 work（向下兼容）；加了未來 v0.8+ condition mutability 紀律本體 ship 時可無痛升級。

### Step 5：重跑 doctor 確認 0 ERROR

採用方 user prompt：

```
重跑 ~/.agentcharter/tools/doctor-spec.md 對 YC_AIAgentCrew/management/ 的健康檢查，
確認所有 ERROR 已消除、WARN 都被理解。
```

預期 doctor 回報：
- ✅ 結構 / 公理 / namespace / enable_modes（含 F6）/ vendor schema：全綠

### Step 6：升 profile.yaml.charter_version

```yaml
charter_version: "0.7.4"   # 已在 Step 4.1 改好、再次確認
```

### Step 7：commit 升版軌跡

```bash
git add management/_config/profile.yaml
git add .gemini/commands/charter-init.toml
git add .gemini/commands/engineer-init.toml
git add .gemini/commands/pm-init.toml
# （可選）git add management/protocols/Dev_Protocol_IRON.md（如加 frontmatter）

git commit -m "chore: bump charter_version v0.5.9 → v0.7.4

依 ~/.agentcharter/examples/upgrades/yc-aiagentcrew-v0.5.9-to-v0.7.4.md
跨多版本升級。

主要 migration:
- profile.yaml enable_modes 加 F6（v0.7.0 BREAKING-LITE）
- profile.yaml enabled 加 ai-vendor-onboarding（v0.6.0 邀請制）
- .gemini/commands/*.toml 改扁平結構（v0.7.4 vendor schema 規範）

對應 charter 8 release: v0.5.10 / v0.6.0 / v0.6.1 / v0.7.0 / v0.7.1 /
v0.7.2 / v0.7.3 / v0.7.4
"

# HANDOFF 第 3 項加升版紀錄（依 handoff-chain §2-3）
```

---

## 4. 升版後 self-check 清單

對齊 [ADOPTION.md §12 採用就緒檢查](../../ADOPTION.md)（升 v0.7.4 後新加的 5 條 v0.7.x 必查項）：

- [ ] `agent-commons/`（YC 為 `management/`）目錄結構齊全 + **management/shared/ 不存在**（v0.7.0 doctor §3.7 E602；YC 不踩此坑）
- [ ] `_config/profile.yaml` 含 `charter_version: "0.7.4"` + 選定 preset
- [ ] `_config/profile.yaml` 內 `parameters.failure-modes.enable_modes` **含 F6**（v0.7.0 強制必啟、E605）
- [ ] `_config/mapping.yaml` 含 `common_memory_root` + `domain_axioms.primary` + `working_stack_discipline.shared.draft_context`
- [ ] `_config/mapping.yaml` 內 `layout.<key>` 不含 `shared/` / `roles/` 等 namespace 同名中介層（YC 不踩此坑）
- [ ] `protocols/IRON.md` 已寫且符合 [domain-axiom-slot §3.1](../../core/domain-axiom-slot.md) 強制要求
- [ ] 每個被指派角色的 AI 已自我具象化（`_role.md` 切換歷史首版到位）
  - **v0.7.0 加：`_role.md` Status 為 PROVISIONAL/ACTIVE 正確態**（user explicit 授權後才升 ACTIVE）
- [ ] **v0.7.4 加：vendor toml 對齊扁平結構**（`.gemini/commands/*.toml`）— Gemini CLI v0.39.1 載入無錯誤
- [ ] 至少 1 個 capsule 跑完整生命週期
- [ ] 第一份 HANDOFF 寫成（含升版紀錄、依 [handoff-chain §2-3](../../core/handoff-chain.md)）
- [ ] AI 與 PO 都能引用至少 5 條 core 條款 + 1 條領域公理 + 1 個 F-mode（**含 F6**）

---

## 5. 對「回鍋開發者無痛」的設計學意義

YC_AIAgentCrew 的 case 證明 charter 北極星紀律「**回鍋開發者無痛**」可達成、但**仍需具體升版指引顯化**：

### 5.1 北極星對齊狀態

| 北極星 | YC 案例對齊 |
|---|---|
| 全新接入 | ✅ 既有 v0.5.9 接入流程 |
| **升版** | ✅ 本 walkthrough（**v0.7.5 加**） |
| 棄用 | ❌ 留 v0.8.0 [`core/adoption-lifecycle.md`](../../core/) 完整化 |
| 停用一段時間後重新採用 | ✅ 等同跨多版本升版（本 walkthrough）|

### 5.2 對 charter 的設計學意義

1. **agent-commons 結構穩定性承諾（v0.5.9）發揮作用**：YC 跨 8 個 release 結構零變更、只動 schema 欄位 + vendor toml
2. **BREAKING-LITE 標籤的價值**（v0.7.0 / v0.7.3 追溯）：採用方明確知道哪一版有 migration 動作、不必逐版檢視
3. **vendor 端 schema 規範條款化（v0.7.4）的價值**：未來 charter 升版觸發 vendor 端 schema 變動時，採用方有 charter 級依據（不只 vendor doc）
4. **跨多版本升級可行**：v0.x 階段同主版號內、跨多 MINOR 升級**允許**（不必走 MAJOR migration）

### 5.3 對未來採用方的啟示

如果你是「**回鍋開發者**」（停用 charter 一段時間、現在要回來）：

1. 讀 `agent-commons/_config/profile.yaml.charter_version` 確認你停在哪版
2. 讀 charter `CHANGELOG.md` 從停的版本到當前最新
3. 對照 `examples/upgrades/<closest-case>.md`（如 YC walkthrough）找最接近的升版實證
4. 跑 [`tools/doctor-spec.md`](../../tools/doctor-spec.md) dry-run 抓你專案的具體 migration 點
5. 走 [`versioning-migration §3.1`](../../core/versioning-migration.md) 7 步流程

→ **charter 的價值在「規範跨時間穩定」**（[versioning-migration §2.3.3](../../core/versioning-migration.md)）— 你停了一年回來、charter 結構承諾仍然 hold；只是條款 / vendor schema / 紀律有累積、走 migration 升上來。

---

## 6. 變更歷史

- **v1.0（2026-04-28，charter v0.7.5）** — 初版。對應 user 在 v0.7.4 ship 後直接要求「文件上記得補充如何更新、以 YC_AIAgentCrew 為例該如何從 v0.5.9 → v0.7.4」。本檔作為 charter「回鍋開發者無痛」北極星紀律的第一個實證範例。
