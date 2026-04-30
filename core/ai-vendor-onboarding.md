# AI Vendor Onboarding（新 AI 廠商 / 新角色接入「邀請制」）

> **狀態**：v0.1（自 v0.6.0 引入）
> **位階**：core 通用條款。位階上位於 `init-template.md §3.3 self-instantiation` — 後者解「接班方半邊」（既有 vendor spec、AI 自具象化），本條款解「**新 vendor 廠商從未接過此角色**」 + 「**新角色誕生**」兩個前置場景。
> **依存**：`init-template.md`（self-instantiation 是本條款 step 4 的執行端入口）、`role-separation.md`（角色概念層 spec 是邀請制 step 1 的產物）、`maintainer-discipline.md`（charter maintainer 的接入簽收職責）
> **保證強度**：多 actor 互檢（邀請制四步驟、charter + vendor + 既有 vendor + maintainer 多方互檢）
> **檢測時點**：init
> **since**：v0.6.0

---

## 0. 概念定位（為何引入）

### 0.1 兩個觸發背景

charter v0.5.7〜v0.5.10 期間累積以下接入議題：

| # | 日期 | 事件 | 揭露的 framework gap |
|---|---|---|---|
| 1 | 2026-04-27 | `roles/pm/gemini-cli.md` 由 Gemini CLI PM 親自提交（Round 1 實證 + Round 2 三層重整 + Claude 校正補回 5 處 regression）| charter 沒明文「**新 vendor 接入既有角色**」流程；Gemini 走過的 Round 1 / Round 2 / 校正三段是隱性流程，沒被 framework 規範化 |
| 2 | 2026-04-27 | `/maintainer-selfcheck` skill 落地討論延伸出「`auditor` 角色誕生」議題（DRAFT 在 `.claude_temp/MAINTAINER-SELFCHECK-DRAFT.md`）| charter 沒明文「**新角色誕生**」流程 — 既有 `pm` / `engineer` 是 v0.4 一次性給的，新加 `auditor` / `validator` 等需要什麼流程沒規範 |
| 3 | 2026-04-27〜2026-04-28 | NEXT.md ⚪ 待對話一直有 `core/ai-vendor-onboarding.md` 候選（從「AI 自我具象化能力評估盲區」演化）| 上位 pattern 持續累積，至 v0.6.0 達成條款化門檻 |

兩個議題同源：「**charter 接新東西（新 vendor / 新角色）時的接入哲學**」。

### 0.2 對應的 framework 設計矛盾

charter `init-template §3.3 self-instantiation` 解的是 **「接班方半邊」**：當某 vendor 已經有 `roles/<role>/<vendor>.md` vendor spec、AI 第一次扮演該角色時，AI 自己讀 charter → 自己生成 slash command → 自己簽名。

但這假設了**前置動作已完成**：vendor spec 已經存在。

實際接入時序：

| 時序 | 動作 | 既有 framework 機制 |
|---|---|---|
| T-1 | 角色概念層 `_spec.md` 須先存在 | ❌ **無條款規範**（v0.4 給定 pm + engineer，新角色從哪來？）|
| T0 | 該 vendor 對該角色的 `<vendor>.md` 須先存在 | ❌ **無條款規範**（Gemini PM 的 vendor spec 怎麼出現的？）|
| T1 | AI 讀 charter → self-instantiation | ✅ `init-template §3.3` |
| T2 | AI 第一次跑 init | ✅ `init-template §6` 五步驟 |

T-1 / T0 是 framework 的盲區。本條款解此盲區。

### 0.3 「邀請制」原則的核心

> **charter 不假裝知道沒接觸過的 vendor / 新角色**。

當 framework 要接觸新 vendor 廠商或創造新角色時，**禁止 charter 預先寫死 vendor 層內容** — 等被邀請的 vendor 自己貢獻 vendor spec，既有 vendor 校正 regression，charter maintainer 簽收後才入 main。

「**慢慢強而有力**」= charter 透過真實接觸累積差異，不假裝知道。同源於 `init-template §3.3` 「框架不代生成」原則 — 從接班方半邊延伸到 vendor 接入半邊。

---

## 1. 條文

當 charter 要接觸**新 AI vendor 廠商**（既有角色 + 該 vendor 從未接過）或**創造新角色**（無既有概念層 spec）時：

**charter maintainer 禁止預先寫死 vendor 層內容**。必須走 §3 邀請制四步驟：charter 寫**概念層**（AI 中立）→ 邀請目標 vendor 寫**vendor 層** → 既有 vendor 校正 regression → maintainer 三層結構簽收。

違反條文（charter 預先寫死 vendor 層）→ vendor spec 內容**僅限維護者個人臆測**，會踩到該 vendor 的盲區 / 過度假設能力 / 漏掉該 vendor 特有的工具，產生錯誤指引。

---

## 2. 範圍

### 2.1 適用場景

| 場景 | 觸發條件 | 範例 |
|---|---|---|
| **A. 新 vendor 接入既有角色** | 角色 `_spec.md` 已存在；該 vendor 從未提交過 `<vendor>.md` | Gemini PM 接入（v0.5）/ 未來 Codex Engineer 接入 |
| **B. 新角色誕生** | 該角色無 `_spec.md`（新概念層） | `auditor` 誕生（v0.6）/ `validator` 誕生（v0.6+）/ 未來 `release-coordinator` 等 |

### 2.2 不適用場景

| 場景 | 為何不適用 | 既有機制 |
|---|---|---|
| 既有 vendor 接班同角色（如 Claude 接班 Gemini PM）| 已有 vendor spec、走 self-instantiation 即可 | `init-template §3.3` |
| 同 AI 兼多角色（如 Gemini 兼 PM + validator）| 兩個角色都有 vendor spec、走 multi-role-tracking 即可 | `multi-role-tracking` |
| Vendor spec 修訂（如 Gemini PM v1.0 → v1.1）| 不是新接入，是維護 | `maintainer-discipline §2.2` 引用範圍 sweep |

---

## 3. 邀請制四步驟

### Step 1：charter 寫概念層 `_spec.md`（AI 中立）

**對象**：charter maintainer

**動作**：
- 在 `roles/<role>/_spec.md` 寫**只描述職能、權力槽位、職責、不職責、心智守則**的 AI 中立 spec
- 禁止提任何 vendor 特有的工具名（`Read` / `Bash` / `Custom GPT` 等）
- 禁止提任何 vendor 特有的檔案路徑（`.claude/commands/` / `.gemini/commands/` 等）
- 模板：參照 `roles/engineer/_spec.md`（v0.5 已有）/ `roles/pm/_spec.md`（v0.5 已有）

**完成條件**：
- 七段結構齊備（職能定義 / 權力槽位 / 職責 / 不職責 / 心智守則 / 失敗模式 / 對應 AI 表）
- 「對應 AI 表」最後一段全部 placeholder（`待提交`）— 因為這時還沒邀請任何 vendor

**典型工件**：
```markdown
## 7. 對應 AI 實作

| AI | 檔案 |
|---|---|
| Claude Code | `claude-code.md.placeholder`（待邀請）|
| Gemini CLI | `gemini-cli.md.placeholder`（待邀請）|
| Cursor | `cursor.md.placeholder`（待邀請）|
```

### Step 2：邀請目標 vendor 寫 vendor 層

**對象**：charter maintainer + 被邀請的 vendor 廠商 AI

**動作**：

1. **maintainer 提供 onboarding prompt** 給目標 vendor AI：
   ```
   我是 AgentCharter charter maintainer。
   邀請你接 <role> 角色，依 ~/.agentcharter/core/ai-vendor-onboarding.md §3 step 2 流程：

   1. 讀 roles/<role>/_spec.md（概念層）
   2. 寫 roles/<role>/<my-vendor>.md（vendor 層），含：
      - 你的工具能力清單（hook / shell / persistent memory / sub-agent / 其他）
      - 對 _spec.md 各職責的執行細節（你怎麼做職責 3.1 / 3.2 / ...）
      - 已知的能力盲區與 fallback
      - sub-agent 跨界禁令段（依 role-separation 精神，若你有 sub-agent 能力）
   3. 不要動 _spec.md（那是 charter 統治區）
   4. 寫完提交 PR / patch 給 charter maintainer
   ```

2. **vendor AI 行使主動權**：
   - 自評能力（不誇大 / 不貶低）
   - 寫自己最熟悉自己廠商的 vendor spec
   - 主動指出 _spec.md 中該 vendor 無法實現的部分（fallback 設計）

3. **典型回合（依 Gemini PM 接入歷程）**：
   - Round 1：vendor 寫初版（資訊豐富但結構可能未對齊 framework 抽象）
   - Round 2：maintainer review 指出三層結構（概念 / vendor / 跨 AI 對應）需重整
   - Round 3：vendor 重整 + maintainer 校正補回 regression（避免 Round 2 覆寫掉 Round 1 的 hard-won 觀察）

### Step 3：既有 vendor 校正 regression

**對象**：既有已有 vendor spec 的 AI（若有）

**動作**：

- 既有 vendor 對新 vendor spec 行使**抽驗權**：
  - 新 vendor 的職責執行細節是否覆蓋 _spec.md 的所有職責點？
  - 新 vendor 對「跨 AI 接班」段是否清楚（cross-AI handoff 互通）？
  - 新 vendor 自宣告的能力盲區是否合理（不是藉口式 disclaim）？

- 若新 vendor 是該角色的**第一個 vendor**（場景 B 新角色誕生）：
  - 此 step 跳過（無既有 vendor 可校正）
  - 但 maintainer 仍須跑 step 4 簽收 + 邀請其他 vendor 補（將來）

### Step 4：三層結構簽收

**對象**：charter maintainer

**動作**：

驗證三層結構齊備（對齊 A1「角色 ⊥ AI」公理）：

| 層 | 位置 | 驗證 |
|---|---|---|
| 概念層 | `roles/<role>/_spec.md` | 七段結構齊備、AI 中立 |
| Vendor 層 | `roles/<role>/<vendor>.md` | 工具能力 / 職責執行細節 / 盲區 / sub-agent 跨界禁令（若適用）|
| 跨 AI 對應 | vendor spec 末段「跨 AI 對應」表 | 標明 vendor X 怎麼對應其他 vendor Y 的執行（同 _spec.md 職責下的差異）|

驗證通過 → maintainer commit + 更新 `_spec.md §7 對應 AI 表`（placeholder → ✅ vX.Y）+ CHANGELOG entry。

---

## 4. 違反處置

| 違反方式 | 處置 |
|---|---|
| charter maintainer 預先寫死 vendor 層內容（不走邀請）| 該 vendor spec 視為**未驗證臆測**；下個被邀請的真 vendor 進場時若打臉，須整段重寫 + 記為 dogfood signal（charter maintainer 違反本條款）|
| 邀請後 vendor 沒走 step 2 流程（直接抄其他 vendor spec）| 視為新 vendor 沒實際接觸 charter；vendor spec 不入 main，要求重做 |
| step 3 既有 vendor 校正後 step 4 maintainer 漏簽收 | `cross-ai-handoff` 流程會踩到（接班方讀不一致 vendor spec 集合）；發現時補簽收 + dogfood signal |
| 跳過 step 1 直接寫 vendor 層（場景 B 新角色誕生）| 違反 A1「角色 ⊥ AI」公理 — 角色定義被 vendor 綁死；要求補寫概念層 |

---

## 5. 與既有條款的關係 / 互補矩陣

本條款與既有 self-instantiation 機制**互補不衝突**。三條款各自負責接入鏈的一段：

| 接入時序 | 條款 | 動作主體 | 工件 |
|---|---|---|---|
| **T-1** 角色概念層 | **`ai-vendor-onboarding.md §3 step 1`** | charter maintainer | `roles/<role>/_spec.md` |
| **T0** vendor 接入 | **`ai-vendor-onboarding.md §3 step 2-4`** | 被邀請 vendor + maintainer | `roles/<role>/<vendor>.md` |
| **T1** AI 第一次扮演角色 | `init-template §3.3 self-instantiation` | AI 自己 | `.{vendor}/commands/<role>-init.{md,toml}` |
| T2 跨 AI 接班 | `cross-ai-handoff` | 退出 vendor + 接班 vendor | `_role.md` 切換歷史 + handoff |
| T3 同 AI 兼多角色 | `multi-role-tracking` | 該 AI 自己 | 離岸 / 上岸宣告 + 身份戳 |

→ 本條款**只負責 T-1 + T0**。一旦 vendor spec 進 main，T1 之後完全是既有條款的領域。

### 與 maintainer-discipline 的關係

本條款 step 4「maintainer 簽收」屬於 `maintainer-discipline §1` spec sync check 的具體應用 — 邀請新 vendor 入 main 是 charter 修訂事件，須走同步檢查（CHANGELOG / `_spec.md §7` 對應表 / 三 preset 是否需要新 enabled key 等）。

---

## 6. 與其他 core 條款的關係

| 條款 | 關係 |
|---|---|
| `init-template.md` | §3.3 self-instantiation 是本條款 step 4 簽收後的執行端入口；兩條款互補 |
| `role-separation.md` | 概念層 `_spec.md` 是角色互鎖原則的具體展開 |
| `cross-ai-handoff.md` | 接班 vendor 須有對應 vendor spec 才能跑 self-instantiation；本條款保證 vendor spec 透過邀請制產出 |
| `maintainer-discipline.md` | 簽收動作是 maintainer 紀律的應用；§3.2 PR checklist 應加「邀請制 step 4 完成」項 |
| `versioning-migration.md` | 新 vendor 加入 = MINOR 修訂（_spec.md §7 表加一行）；新角色誕生 = MINOR 或 architectural（charter-config enabled 加一行）|
| `charter-config.md` | 新角色誕生時 `enabled` 清單加 `<role>` 槽位需在本條款 step 4 同步 |

---

## 7. 對應 dogfood signal / 觸發背景

| Signal / 事件 | 日期 | 對應本條款段 |
|---|---|---|
| Gemini PM 接入歷程（Round 1 / Round 2 / 校正三段，2026-04-27 完成）| 2026-04-27 | §3 step 2 典型回合（隱性流程顯性化的素材）|
| `auditor` 角色誕生議題（從 `/maintainer-selfcheck` DRAFT 延伸）| 2026-04-27 | §2.1 場景 B（新角色誕生）|
| `validator` 角色誕生議題（YC_AIAgentCrew 場景觸發）| 2026-04-28 | §2.1 場景 B + 對 PM 漸進 deprecate 抽驗職責 |

未來再撞到同類事件：

- 若新 vendor 接入順利依 §3 流程跑通 → 本條款生效驗證
- 若 vendor 寫 vendor spec 時持續踩坑（如自評能力不準、隱性抄其他 vendor）→ 累積到 NEXT.md 評估是否擴 §3 step 2 子細節

---

## 8. 變更歷史

### v0.1（自 v0.6.0 引入）

**動作**：新增本條款 — 將 v0.5 隱性的 Gemini PM 接入歷程顯性化為「邀請制四步驟」+ 處理 v0.6 新角色誕生（auditor / validator）議題。

**觸發**：
- v0.5.7 NEXT.md ⚪ 待對話「AI 自我具象化的能力評估盲區（Codex walkthrough 浮現）— 是否該補一個 `core/ai-vendor-onboarding.md` 條款」 持續累積至 v0.6
- 2026-04-27 對話浮現「角色擴展走『邀請制』原則」上位 pattern（從 `/maintainer-selfcheck` DRAFT 延伸出 `auditor` 角色誕生議題）
- v0.6.0 大工程批次第二階段達成條款化門檻

**修訂類型**：MINOR（新增條款 — 對既有採用方無破壞、但對 charter maintainer 加新流程紀律）；條款數 20 → 21；架構級概念 9 → 10（新增「角色擴展邀請制 / vendor 不代寫」原則）。

**連動範圍**（依 `maintainer-discipline §2.2`）：
- `core/charter-config.md §5` 相依表加 ai-vendor-onboarding entry
- `tools/profiles/{minimal,standard,strict}.yaml` enabled 加 ai-vendor-onboarding（三 preset 都啟用）
- `roles/auditor/_spec.md` 新增（場景 B 首例 — auditor 角色誕生，maintainer-only 位階）
- `README.md` / `ADOPTION.md` / `TUTORIAL.md` 條款數 20 → 21
- `CHANGELOG.md` v0.6.0 段
