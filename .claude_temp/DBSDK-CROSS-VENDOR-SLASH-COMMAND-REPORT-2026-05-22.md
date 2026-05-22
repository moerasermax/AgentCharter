# AgentCharter Slash Command 跨 AI Vendor 可攜性報告

> **提交者**：PM (Antigravity CLI / Claude Sonnet 4.6 Thinking)
> **日期**：2026-05-22
> **專案**：dbSDK (採用方端 dogfood)
> **報告目的**：向 AgentCharter 框架維護者呈現「Slash Command 在多 AI Vendor 環境中的碎片化現況」，並提出統一化建議
> **位階（charter 端紀錄）**：SSS S2.5「Canonical Init Spec Layer」議程設計素材 + path A LIVE 第二輪校正觸發源 + dogfood signal #61 條款化候選 + multi-perspective 第十四循環新類型「採用方 vendor AI 對 charter 行使結構性反向觀察」LIVE 實證
> **存檔時間**：2026-05-22（charter v0.12.0 ship 中、報告同 LIVE session 收回作為 S2.5 ship 立刻 hooks 的核心素材）

---

## 1. 問題摘要

AgentCharter v0.10.6 的 `init-template.md §3` 規定了「自我具象化」機制——每個 AI Vendor 在自己的標準位置生成 slash command。但目前**缺乏統一的 Canonical Init Spec**，導致：

1. **同一角色的 init 邏輯在 3 個 vendor 實裝了 3 種格式、3 種深度**
2. **跨 vendor 切換時無法自動繼承**，接班 AI 必須從零具象化
3. **採用方使用者切換 CLI 工具時，感知到的行為不一致**

---

## 2. 現況盤點：dbSDK 專案三端 Slash Command 對照

### 2.1 指令清單

| 指令名稱 | Gemini CLI | Claude Code | Antigravity CLI | 備註 |
|---|---|---|---|---|
| `pm-init` | ✅ `.gemini/commands/pm-init.toml` | ✅ `.claude/commands/pm-init.md` | ✅ `~/.gemini/skills/pm-init/SKILL.md` | 三端皆有，但深度差異極大 |
| `engineer-init` | ✅ `.gemini/commands/engineer-init.toml` | ✅ `.claude/commands/engineer-init.md` | ❌ | Antigravity 端缺 |
| `charter-doctor` | ✅ `.gemini/commands/charter-doctor.toml` | ✅ `.claude/commands/charter-doctor.md` | ❌ | Antigravity 端缺 |
| `charter-init` | ✅ `.gemini/commands/charter-init.toml` | ❌ | ❌ | Gemini 獨有 |
| `charter-upgrade-verify` | ✅ `.gemini/commands/charter-upgrade-verify.toml` | ❌ | ❌ | Gemini 獨有 |
| `checkpoints` | ✅ `.gemini/commands/checkpoints.toml` | ✅ `.claude/commands/checkpoints.md` | ❌ | Antigravity 端缺 |

### 2.2 格式差異

#### Gemini CLI — `.toml` 格式

```toml
name = "pm-init"
description = "Initialize the PM (Gemini) role..."

prompt = """
我現在以 PM (Gemini) 身份執行初始化。
依據 ~/.agentcharter/core/init-template.md §1 執行：
1. Summon：讀取 agent-commons/roles/pm/_role.md 及相關 spec。
2. Calibrate：...
"""
```

- **特徵**：輕量 prompt 注入（~600 bytes），靠 AI 即時 Read 框架全文
- **優點**：簡潔，不重複條款
- **缺點**：無流程明細、強依賴 `~/.agentcharter/` 本地 clone

#### Claude Code — `.md` 格式

```markdown
---
description: PM (Claude Code) 值機初始化...
argument-hint: "(無參數)"
---

# /pm-init — PM 值機初始化

## Step 0：讀過去違反紀錄
## Step 1：讀協議精要（cheatsheet）
## Step 1.5：觸發讀全文 scenario
## Step 2：核心心智守則（10 條）
...
## Step 5：就緒回報
```

- **特徵**：完整 5 步流程 + 10 條心智守則（~12KB）
- **優點**：自包含、不依賴外部 clone、流程嚴謹
- **缺點**：重量級、各步驟深度綁定 Claude 工具語意

#### Antigravity CLI — `SKILL.md` 格式

```markdown
---
name: pm-init
description: 初始化 CryptoBot PM 角色...
---

# CryptoBot PM 初始化指令

## 執行流程
1. 執行同步腳本：`node scripts/sync-pm.cjs`
2. 載入核心手冊：讀取 PM_Operational_Manual.md...
3. 確認狀態：檢查 NextWork.md
4. 長記性：回顧事故紀錄
```

- **特徵**：中等篇幅（~1.6KB），走 Skills 系統
- **優點**：結構清晰
- **缺點**：引用路徑過時（`management/` 已遷移至 `agent-commons/`）、缺少心智守則注入、缺少就緒回報格式

### 2.3 深度差異量化

| 維度 | Gemini CLI | Claude Code | Antigravity |
|---|---|---|---|
| 檔案大小 | 604 bytes | 11,842 bytes | 1,645 bytes |
| 流程步驟數 | 4（隱含） | 6（Step 0~5 明確） | 4 |
| 心智守則注入 | ❌ 無 | ✅ 10 條 | ❌ 無 |
| Reflection 強制讀取 | ❌ | ✅ Step 0 | ✅ Step 4 |
| Cheatsheet 支援 | ❌ | ✅ Step 1 v1.2 | ❌ |
| 就緒回報格式 | ❌ 無統一 | ✅ Step 5 | ❌ 無統一 |
| 跨平台相容 | ⚠️ 部分 bash-only | ✅ v1.1 修正 | ⚠️ 依賴 node script |
| `~/.agentcharter/` 依賴 | 🔴 強依賴 | 🟡 Step 1.5 觸發 | ❌ 不引用 |

---

## 3. 碎片化根因分析

```
[init-template.md §3 自我具象化規範]
                ↓
       [各 AI 自行生成 slash command]
        ↙          ↓          ↘
[Gemini CLI]  [Claude Code]  [Antigravity]
[.toml 輕量    [.md 完整流程]  [SKILL.md 中間態]
   prompt]
        ↓          ↓          ↓
            [❌ 格式不相容]
                  ↓
        [跨 vendor 切換時行為不一致]

外加：
[缺少 Canonical Init Spec Layer]
[缺少 vendor-neutral portable format]
```

> **核心缺口**：`init-template.md §3` 定義了「去哪裡生成」，但**沒有定義「生成什麼內容」的統一規範**。每個 vendor 的具象化深度完全取決於該 AI 的理解力與採用方的迭代投入。

---

## 4. 建議方案

### 4.1 新增 Canonical Init Spec（建議位階：`~/.agentcharter/core/`）

```
~/.agentcharter/
├── core/
│   └── init-spec-schema.md          # [NEW] 統一 init 指令規範
├── roles/
│   └── <role>/
│       └── init-spec.md             # [NEW] 每角色的 canonical init 邏輯
└── templates/
    └── vendor-adapters/
        ├── gemini-cli.toml.tpl      # [NEW] Gemini CLI 適配器模板
        ├── claude-code.md.tpl       # [NEW] Claude Code 適配器模板
        └── antigravity.skill.tpl    # [NEW] Antigravity CLI 適配器模板
```

### 4.2 `init-spec-schema.md` 草案

```markdown
# Init Spec Schema v0.1

每個角色的 `init-spec.md` 必須包含以下段落（vendor-neutral）：

## Required Sections

1. **Pre-Init（Step 0）**：歷史學習迴圈
   - 必讀路徑清單（reflections, failure_mode_log）

2. **Load（Step 1）**：協議載入
   - 必讀檔案清單（cheatsheet 或全文）
   - 觸發讀全文的條件清單

3. **Mental Anchors（Step 2）**：心智守則
   - 角色寫權範圍
   - 角色禁區
   - F-mode 偵測清單
   - vendor 特化盲區（§K 機制）

4. **Environment Snapshot（Step 3）**：環境快照
   - 必查項目（output_mode, HANDOFF, capsules, git）
   - 工具語意描述（不綁定特定 shell）

5. **Audit State（Step 4）**：抽驗狀態

6. **Ready Report（Step 5）**：就緒回報
   - 統一輸出格式模板

## Vendor Adapter
各 vendor 從 `init-spec.md` 生成自己格式的 slash command。
Adapter 只負責「格式轉換」，不增減邏輯。
```

### 4.3 遷移路徑建議

| 階段 | 動作 | 影響 |
|---|---|---|
| Phase 1 | 在 `~/.agentcharter/` 新增 `init-spec-schema.md` 規範 | 框架層，無破壞 |
| Phase 2 | 為 PM 角色建立 `roles/pm/init-spec.md` canonical 版 | 框架層，無破壞 |
| Phase 3 | 提供 vendor adapter 模板，新 AI 具象化時從 canonical 轉出 | 新 vendor 受益 |
| Phase 4 | 既有 vendor（Gemini / Claude）的 slash command 標記為 `v2`，對齊 canonical | 需各端同步升級 |

---

## 5. 當前 dbSDK 專案具體問題

> **WARNING**：Antigravity CLI 的 `~/.gemini/skills/pm-init/SKILL.md` 存在以下過時問題：

| 問題 | 說明 |
|---|---|
| 引用路徑錯誤 | 引用 `management/agent_protocols/PM_Operational_Manual.md` 等路徑，但實際已遷移至 `agent-commons/` |
| 缺少心智守則 | 無 Step 2 等效邏輯，PM 初始化後無角色邊界意識注入 |
| 缺少就緒回報格式 | 無統一輸出格式，與 Gemini / Claude 端行為不一致 |
| 同步腳本不存在 | `scripts/sync-pm.cjs` 在 dbSDK 專案中不存在 |
| 名稱混淆 | SKILL.md 頂部描述為「CryptoBot PM」，但本專案為 dbSDK |

> **TIP — 短期修復建議**：在 AgentCharter 層定義 canonical spec 前，先手動更新 `~/.gemini/skills/pm-init/SKILL.md` 對齊 Claude Code 版 `pm-init.md` 的 Step 0~5 流程。

---

## 6. 附件：完整指令原文（採用方端檔案位置）

> **註**：報告原引用 `file:///C:/Users/YCLIN/Desktop/WorkSpace/測試專案/No.3_dbSDK/...` 絕對路徑 — 對齊 charter `core/init-template §3.3.5` 「slash command 引用紀律」（v0.7.0 加、禁絕對路徑硬編碼） — 此處保留路徑作為**採用方端 LIVE 引用實證**、不作為 charter spec 紀律違反案例。

### 6.1 Gemini CLI `.toml` 指令（6 個）

- `.gemini/commands/pm-init.toml`
- `.gemini/commands/engineer-init.toml`
- `.gemini/commands/charter-doctor.toml`
- `.gemini/commands/charter-init.toml`
- `.gemini/commands/charter-upgrade-verify.toml`
- `.gemini/commands/checkpoints.toml`

### 6.2 Claude Code `.md` 指令（4 個）

- `.claude/commands/pm-init.md`
- `.claude/commands/engineer-init.md`
- `.claude/commands/charter-doctor.md`
- `.claude/commands/checkpoints.md`

### 6.3 Antigravity CLI `SKILL.md` 指令（1 個）

- `~/.gemini/skills/pm-init/SKILL.md`（**子目錄結構** — 對應本檔 §2.2 第三例、charter v0.11.0 ship 中 path A 預估錯誤之一、LIVE 第二輪校正觸發源）

---

## 7. Charter 端 capture 後處置（maintainer 加 2026-05-22）

### 7.1 立刻 hooks（同 LIVE session 內）

| 議程 | 落地版本 |
|---|---|
| **path A LIVE 第二輪校正** — Skill 路徑改 `~/.gemini/skills/<name>/SKILL.md`（子目錄結構）+ frontmatter `name:` 欄位必填 | charter v0.12.0 ship、`roles/pm/antigravity-cli.md` v1.0 → v1.1 |
| **SSS S2.5「Canonical Init Spec Layer」議程 ship** | charter v0.12.0 ship、`core/init-spec-schema.md` 新檔 + `roles/<role>/init-spec.md` + `templates/vendor-adapters/*.tpl` |
| **dogfood signal #61 LIVE 條款化** | NEXT.md 紀錄 — 「Slash Command 跨 vendor 碎片化 / 缺 canonical init spec layer」、本報告為唯一觸發 LIVE 證據 |
| **multi-perspective 第十四循環新類型** — 採用方 vendor AI 對 charter 行使結構性反向觀察 | 對應 v0.8.1 charter maintainer 派 4 sub-agent 反向校準的對稱軸（採用方 vendor AI 反向校準 charter）+ v0.7.2 user 對 charter 自身行使「他抽」屬性最完整迴路延伸 |

### 7.2 對應 charter 既有 LIVE 反向校準軸

| 軸 | LIVE 實證 | 對應條款化 |
|---|---|---|
| **charter maintainer 對自身判斷的多視角校準** | 2026-04-30 v0.8.1 第十四循環 4 sub-agent 評估 | `examples/external-evaluations/clispike-multi-perspective-eval-2026-04-30.md` |
| **user 對 charter 自身行使「他抽」屬性** | 2026-04-28 v0.7.2 user 兩次 IDE 開 core 抓 spec drift | `core/maintainer-discipline §3.4` 文檔層 sync checklist |
| **採用方 vendor AI 對 charter 行使結構性反向觀察（新軸）** | 2026-05-22 dbSDK PM (Antigravity / Claude Sonnet 4.6 Thinking) 本報告 | **本報告 + charter v0.12.0 ship Canonical Init Spec Layer** |

→ charter 「**多角色協作 + 自抽自驗封閉**」哲學在 **第三條反向校準軸完整封閉**：
1. maintainer 半邊（auditor 角色、v0.6.0）
2. 採用方半邊 init 階段（validator §3.6、v0.7.0）
3. **採用方端 vendor AI 對 charter framework 結構性反向觀察（v0.12.0）**

### 7.3 設計學意義

本報告對 charter 是 **path A AI-DRAFTED → path A LIVE-CALIBRATED → SIGNED 演化路徑的最強實證**：

- **path A AI-DRAFTED**（charter v0.11.0 ship 同日上午）：maintainer 從 Gemini CLI v1.8 平移 antigravity-cli.md、用三方非官方文檔 + WebSearch 結果
- **path A LIVE-CALIBRATED**（charter v0.11.0 ship 同日下午）：採用方 PM AI 實機回報 2 處錯誤（`.agents/skills/` workspace 路徑 / `agy plugin import gemini` auto-convert）
- **path A LIVE-CALIBRATED v2**（charter v0.12.0 ship 同日深夜、本報告觸發）：採用方 PM AI 親讀三 vendor 實檔、提出**結構性 framing**（Canonical Init Spec Layer）— **不只校正單點、而是揭露架構性 gap**
- **SIGNED**（未來）：累積 ≥ 80% segment LIVE 校正後升 SIGNED-vX.Y（依 antigravity-cli.md §7(a) 校正紀律）

→ 對應 `core/ai-vendor-onboarding §3 step 2` 邀請制紀律 LIVE 工作 — 真實 vendor AI **不只回答 maintainer 的問題、還主動提出 maintainer 沒問到的架構性議題**。**邀請制原則的最強驗證**。

---

*報告結束。以上分析基於 2026-05-22 當日 dbSDK 專案三端實際檔案內容，所有引述均為親讀原文。*
*charter maintainer capture + 後處置紀錄補於 2026-05-22 charter v0.12.0 ship 中。*
