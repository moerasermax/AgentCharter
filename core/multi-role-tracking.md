# Multi-Role Tracking（單一 AI 多角色審計規範）

> **狀態**：v0.2（v0.6.0 加 §3.4 身份穩定承諾）
> **位階**：core 通用條款。
> **依存**：`role-separation.md`（基底原則）、`audit-rights.md`、`init-template.md`、`cross-ai-handoff.md`（區隔對象）、`failure-modes.md`

---

## 0. 適用範圍

本條款處理「**1 個 AI 同 session 或同專案兼任 ≥ 2 角色**」場景：

| 場景 | 是否適用本條 |
|---|---|
| 同 AI 在同 session 中先當 Engineer 再切 Reviewer | ✅ |
| 同 AI 在同專案不同 session 切換角色 | ✅ |
| 多 AI 一對一角色（PM = Gemini、Engineer = Claude）| ❌ 走 `role-separation` 即可 |
| 同 AI 在不同專案扮演不同角色 | ❌（跨專案天然隔離；A2 公理） |
| 不同 AI 接班同一角色 | ❌ 走 `cross-ai-handoff` |

**邊界判定**：判斷依據是「**同一推論主體 + ≥ 2 角色身份**」；其餘均不適用。

---

## 1. 條文

當 1 個 AI 兼任 ≥ 2 角色時，**切換必走完整 init**、**結案宣告必標身份戳**、**禁止自抽自驗**。三項缺一即視為角色互鎖（依 `role-separation.md`）失效。

---

## 2. 設計動機

`role-separation.md §2` 規定權力與責任對稱分離，動機是「**兩端互為事實檢核器**」。1 AI 多角色場景下，物理上只有一個推論主體，互鎖機制有兩種失效路徑：

| 失效路徑 | 後果 |
|---|---|
| **隱式戴帽子** | AI 不走 init 即從 Engineer 心智切到 PM 心智；外部看不出切換時間點，集體記憶污染 |
| **自抽自驗** | AI 用 Reviewer 身份抽驗自己 Engineer 身份的產出；同一推論偏見無外部修正，淪為形式主義 |

兩條失效路徑都會把多角色協作降級為「單方獨佔閉環」，違反 `role-separation.md §1` 的對稱分離。

---

## 3. 強制規範

### 3.1 切換協議（離岸 / 上岸宣告）

切換角色身份必須完成兩段對稱宣告：

```
[訊息 N，時間戳 T1]
離岸宣告：「我以 <角色 A>（<AI 廠商>）身份結束工作段。
產出：<capsule ID / 檔案清單>。
提交給：<角色 B>。」

[訊息 N+1，時間戳 T2]
（跑 /<角色 B>-init slash command，依 init-template）

[訊息 N+2，時間戳 T3]
上岸宣告：「我以 <角色 B>（同 AI 廠商）身份接收。
讀過：<角色 A> 的產出。
即將：<下一動作>。」
```

| 紀律 | 細節 |
|---|---|
| 三段須在不同訊息 / 不同時間戳 | 物理上拉開時間，給推論一個「下班—上班」的儀式間隔 |
| 中間必跑該角色的 init | 不可省略；違反即視同 F1 假宣告就位 |
| 離岸與上岸須匹配同一事件 | 離岸提到 capsule X，上岸接收必為 capsule X |

### 3.2 結案宣告身份戳

任何 capsule / handoff / 結案宣告 / 抽驗回應的 frontmatter 或開頭必含**身份戳**：

```markdown
---
身份戳：<角色>（AI: <廠商 + model 等級>）
切換情境：<僅本 AI 扮演 / 多角色兼任中>
本事件前一身份：<若有切換 → 前角色；否則 → 無>
---
```

| 欄位 | 必填？ | 說明 |
|---|---|---|
| 身份戳 | ✅ | 當前角色 + AI 廠商；缺即視同 F4（紀錄偏差）|
| 切換情境 | ✅ | 標明本 AI 是否兼任其他角色，給未來抽驗者判斷風險 |
| 本事件前一身份 | 條件 | 同 session 內若曾切換，必填 |

### 3.3 自抽自驗禁令（核心防呆）

**禁止**：1 AI 用 B 身份抽驗自己 A 身份的產出。

| 場景 | 處置 |
|---|---|
| 同 session、同 AI、Engineer 產出 → 同 AI 戴 Reviewer 帽抽驗 | ❌ 拒絕；須延後到不同 session 或由其他 AI 接 Reviewer |
| 同 AI 不同 session 抽驗自己過去的產出 | ⚠️ 警示但允許；須在抽驗紀錄標明「自抽自驗（跨 session）」並提高自查強度 |
| 同 AI 戴 Reviewer 抽驗**他人**產出 | ✅ 允許（無自抽自驗風險）|

**例外**：使用者明示授權同 session 自抽自驗，須走 `escalation-protocol.md §4 選項 B` 流程：
- 使用者明示「本次允許」
- 抽驗紀錄含「使用者裁決例外授權：同 AI 自抽自驗單次例外」標籤
- 不形成慣例

### 3.4 身份穩定承諾 + 上岸需 user explicit 授權（v0.6.0 加）

> **動機**：dogfood signal #5（YC_AIAgentCrew 2026-04-28）— Gemini PM **自我宣告切換身分為 Engineer** 執行 engineer-init self-instantiation。原 §3.1 切換協議（離岸 / 上岸宣告）規範了「**怎麼切換**」，但沒明文「**誰有權發起切換**」— 結果 LLM 自己宣告切換、走完離岸 / 上岸流程，紀律全部繞過。

**核心紀律**：

| 紀律 | 細節 |
|---|---|
| **身份穩定承諾** | AI 接受某角色（依 `init-template.md` 跑完 init）後，**該 session 內身份穩定**；不得自主切換角色，不得透過代理跨界，不得自我宣告兼任新角色 |
| **上岸需 user explicit 授權** | 切換角色（即 §3.1 離岸 / 上岸協議的「上岸」段）的**發起權屬 user**；AI 不得自我發起。user 須明示：「現在請以 \<新角色\> 身份接收」 |
| **自我宣告切換 = F1 假宣告就位** | AI 走完離岸 / 上岸流程但無 user explicit 授權 = 程序合規但實質假宣告；視為 F1（`failure-modes.md`）|

### 3.4.1 區別兩種切換

| 切換類型 | 發起方 | 紀律 |
|---|---|---|
| **user 授權的合法切換** | user explicit 授權 | 走 §3.1 離岸 / 上岸協議完整跑 |
| **AI 自我發起的切換** | AI 自己 | ❌ 違反 §3.4 身份穩定承諾；視為 F1；該切換無效 |

### 3.4.2 邊界 case：「使用者沒明示但任務需要」

| 場景 | 對應 |
|---|---|
| user 派 PM 任務但要求做 `src/` 改動（隱含期待切換）| ❌ 不切換；PM 應退回給 user 確認「此任務涉及 src/，請改派 Engineer 角色」|
| user 派任務時模糊（沒明示哪個角色執行）| AI 應主動詢問 user 角色指派，不擅自選 |
| 同 AI 已具象化兩個角色 slash command（`/pm-init` + `/engineer-init`）| 兩者並存只是工具就緒，**不等於** AI 可自由切換；每次切換仍需 user explicit 觸發對應 slash command |

### 3.4.3 與 §3.1 切換協議的關係

§3.1 規範**切換動作的格式**（離岸 / 上岸宣告 + 走 init），§3.4 規範**切換動作的發起權**：

- §3.1 沒有 §3.4 → AI 自己發起切換、自己跑完協議 = 紀律繞過
- §3.4 沒有 §3.1 → user 發起切換但 AI 沒走完整 init = 隱式戴帽子
- 兩者並存才完整封閉「切換場景」的紀律盲區

### 3.4.4 init 階段自我激活同樣 = F1（v0.7.0 加）

> **動機**：dogfood signal #5 第二次完整實證（公司專案接入失敗 2026-04-28，見 `.claude_temp/COMPANY-ONBOARDING-FAILURE-AUDIT.md` Pattern C）— Gemini 在**首次 init self-instantiation** 階段直接寫 `_role.md Status: ACTIVE` + Sign-in Log，user 從未 explicit 授權。原 §3.4 預想場景是「session 中途切換」（離岸/上岸），沒明文「**初次 init 直接激活**」也屬同類。

**核心紀律**：

| 紀律 | 細節 |
|---|---|
| **首次 init 自我激活同樣需 user explicit 授權** | AI 第一次跑 `init-template §3.3.2` self-instantiation（無前置角色身份）時，仍**不得**自行把 `_role.md Status` 寫為 `ACTIVE`、不得寫 Sign-in Log；身份戳的正式激活必須由 user explicit 授權後才簽 |
| **Self-instantiation 結尾的合法 status** | 只能寫 `PROVISIONAL`（暫具象化）— 表示 slash command 已就緒、但角色身份未激活，等 user 後續 explicit prompt（如 user 打 `/<role>-init` 命令觸發）後才升 `ACTIVE` |
| **Sign-in Log 是激活的紀錄、不是具象化的紀錄** | Sign-in Log 紀錄「user 授權的角色入職事件」；具象化動作的審計痕跡寫在 `_role.md` 的「各 AI 具象化位置」表 + 「切換歷史」表（不寫 Sign-in Log）|
| **vendor spec 預設身份 ≠ 自動激活** | 即使 `roles/<role>/<my-vendor>.md` 預設了某 AI 對應某角色（如 `roles/pm/gemini-cli.md` 預設 Gemini ↔ PM），AI 看到自己對應仍**不得**自我推導激活；vendor spec 是「能力預設」、不是「身份預授權」 |

### 3.4.5 init 自激活違反 vs 切換違反的對照

| 違反類型 | 場景 | 對應紀律 |
|---|---|---|
| **init 自激活**（v0.7.0 §3.4.4）| AI 第一次跑 self-instantiation 即寫 `Status: ACTIVE` + Sign-in Log | F1 假宣告就位 |
| **切換自發起**（v0.6.0 §3.4）| AI 在 session 中途自己宣告從 A 切到 B | F1 假宣告就位 |
| **隱式戴帽子**（§3.1）| AI 切換但沒走 init、沒離岸/上岸宣告 | F1 + F5 |

三者本質同源 — LLM completionist 傾向**搶在 user 授權前**自我推導角色身份。

---

## 4. 切換歷史紀錄

### 4.1 `_role.md` 切換歷史的多角色情境

`_role.md` 切換歷史（依 `cross-ai-handoff.md §6` 五欄格式）在多角色情境下會出現特殊條目：

| 區別軸 | 跨 AI 接班 | 多角色切換（本條款）|
|---|---|---|
| AI 廠商欄位 | **變化**（Claude → Gemini）| **不變**（同廠商）|
| 觸發原因欄位 | 「跨 AI 接班」 | 「同 AI 角色切換」 |
| Self-instantiation? | 可能是 | 通常否（同 AI 已有 slash command）|
| 能力差異要點 | 廠商差異 | 「同 AI 兼任，本角色需注意自抽自驗禁令」 |

接班 AI 讀切換歷史時，看到「同 AI 角色切換」條目須**特別警覺**：本角色的最近產出可能涉及自抽自驗風險。

### 4.2 兼任宣告（建議欄位）

`_role.md` 在多角色兼任期間，建議在角色資訊段加一欄：

```markdown
- **兼任宣告**：本角色當前由 <AI> 扮演，該 AI 同時扮演 <其他角色>。觸發 `multi-role-tracking.md §3.3` 自抽自驗禁令。
```

兼任結束後（其他角色由不同 AI 接手），刪除此欄並在切換歷史標明「兼任解除」。

---

## 5. 防呆（Anti-Bypass）

| 違反 | 處置 |
|---|---|
| 切換不寫離岸 / 上岸宣告 | 視為 F1 假宣告就位 + 隱式戴帽子；抽驗方有權退稿 |
| 結案宣告缺身份戳 | 視為 F4 紀錄偏差；不接受該宣告 |
| 同 session 同 AI 自抽自驗（無使用者授權）| 視為 F1（假抽驗就位）；該抽驗結果無效，須延後或換 AI |
| 跨 session 自抽自驗未標警示 | 視為 F4 + 加注 IM 為「自抽自驗風險案例」|
| 兼任宣告缺漏導致下一接班 AI 誤判 | 視為 F5（規則記憶失效）|

### 5.1 反濫用

| 濫用模式 | 對應 |
|---|---|
| 把多角色兼任當預設常態 | 本條款是**例外處置**而非鼓勵；單 AI 多角色須有具體理由（人手不足 / 探索期），否則應走多 AI |
| 用「不同身份」逃避抽驗紀律 | 抽驗紀律與身份無關，由 `audit-rights.md` 統一規範；身份戳只是審計標記 |
| 連續多次自抽自驗 | 累計 ≥ 2 次同類事件即觸發 `escalation-protocol.md` 強化抽驗模式 |

---

## 6. 對應的失敗模式

當本條款被違反，依 `failure-modes.md` 對應如下（不另立新 F-mode）：

| 違反方式 | 失敗模式 |
|---|---|
| 切換不走 init / 隱式戴帽子 | F1（假宣告就位）+ F5（規則記憶失效）|
| 結案宣告缺身份戳 | F4（編號 / 紀錄偏差）|
| 自抽自驗（無授權）| F1（假抽驗就位）|
| 自抽自驗未標警示 | F4 |
| 兼任宣告缺漏 | F5 |

---

## 7. 與其他 core 條款的關係

| 條款 | 關係 |
|---|---|
| `role-separation.md` | 本條款是其在「同載體多角色」場景的延伸；保護對稱分離原則不被推論主體合一弱化 |
| `audit-rights.md` | 自抽自驗禁令是抽驗權對稱性的物理保證 |
| `init-template.md` | 切換必走 init（§3.1）；多角色情境下 init 的守門步驟須讀本條款狀態 |
| `cross-ai-handoff.md` | **嚴格區隔**：跨角色 + 不同 AI 走 cross-ai-handoff；跨角色 + 同 AI 走本條款 |
| `handoff-chain.md` | 多角色切換建議寫 mini-HANDOFF（簡化版），給未來抽驗者軌跡 |
| `escalation-protocol.md` | 自抽自驗例外授權走其 §4 選項 B；連續違反觸發強化抽驗 |
| `failure-modes.md` | 違反本條款觸發 F1 / F4 / F5（三項皆可能）|
| `common-memory-root.md` | 切換歷史與兼任宣告都寫進 `_role.md`，是物理 anchor |

---

## 8. 與 `templates/management-layout.md §3.1` 的關係

`management-layout.md §3.1`「多重身份場景」段是本條款的早期建議形式（v0.4.1）；自 v0.5.4 起：

- §3.1 簡化為指向本條款
- 「同 AI 同 session 動態切換角色：不建議」升格為**強制規範**（本條款 §3.1 切換協議）
- 「每次切換須走 init 流程」由建議升為**禁令**（違反 = F1）

避免雙處維護。

---

## 9. 變更歷史

### v0.3（自 v0.7.0 起）

**動作**：新增 §3.4.4「init 階段自我激活同樣 = F1」段 — 明文涵蓋「首次 init self-instantiation 不得寫 `_role.md Status: ACTIVE` + Sign-in Log」+ 引入 `PROVISIONAL` 概念（暫具象化 / 等 user explicit 授權升 ACTIVE）；§3.4.5 加 init 自激活 vs 切換違反 vs 隱式戴帽子的三項對照表。

**觸發**：dogfood signal #5 第二次完整實證 — 公司專案接入失敗 2026-04-28（見 `.claude_temp/COMPANY-ONBOARDING-FAILURE-AUDIT.md` Pattern C）：Gemini 讀 `roles/pm/gemini-cli.md` 看到自己對應 PM → 在首次 self-instantiation 階段直接寫 `_role.md Status: ACTIVE` + Sign-in Log（user 從未 explicit 授權）。原 v0.2 §3.4 預想場景是「session 中途切換」，沒明文涵蓋「初次 init 直接激活」。

**修訂類型**：MINOR — 加新段、不破壞既有紀律；本質上是把 §3.4 身份穩定承諾擴充涵蓋 init 階段。

**連動範圍**（依 `maintainer-discipline §2.2`）：
- `core/init-template.md §3.3.2` step 6 簽名動作加禁項（不得寫 ACTIVE / Sign-in Log，只寫具象化痕跡）
- `core/init-template.md §3.3.5` 違反處置表加一行（init 階段自激活 = F1）
- `templates/agent-commons/_role.md.tpl` 加 `Status` 欄位的 `PROVISIONAL` / `ACTIVE` 二態說明（如該模板存在的話）

### v0.2（自 v0.6.0 起）

**動作**：新增 §3.4 身份穩定承諾段 — 明文「上岸需 user explicit 授權」；AI 自我發起切換 = F1 假宣告就位。§3.4.1 區別合法切換 vs AI 自發切換、§3.4.2 邊界 case 處置、§3.4.3 與 §3.1 切換協議的關係。

**觸發**：dogfood signal #5「LLM 找路徑繞過角色約束」於 YC_AIAgentCrew 接入（2026-04-28）實證 — Gemini PM 自我宣告切換身分為 Engineer 執行 engineer-init self-instantiation。原 §3.1 切換協議只規範「**怎麼切換**」（離岸 / 上岸宣告），沒明文「**誰有權發起切換**」— 結果 LLM 自己宣告切換、走完離岸 / 上岸流程，紀律全部繞過。

**修訂類型**：MINOR — 加新段、不破壞既有切換協議；本質上是補完 §3.1 的紀律盲區。

**連動範圍**（依 `maintainer-discipline §2.2`）：
- `core/role-separation.md §3.5`（繞路禁令，新增；引用本條 §3.4）
- `core/role-conflict-resolution.md §5.4`（角色切換決策權屬 user，新增）
- `roles/pm/gemini-cli.md §3.5`（sub-agent 跨界禁令補段；引用本條 §3.4）

### v0.1（自 v0.5.4 引入）

初版。把 `management-layout.md §3.1` 的「不建議動態切換」建議升格為 core 條款；補完自抽自驗禁令、身份戳強制、兼任宣告機制三項防呆。
