# Condition Mutability（條款可變性紀律）

> **狀態**：v0.1（自 v0.9.0 引入）
> **位階**：core 通用條款。**紀律本體** — v0.7.1 frontmatter scaffold 已 ship，但紀律本體（三層含義 / 3-strike / consolidation / AI 修訂權限分層）未條款化、本條款補完。
> **依存**：`domain-axiom-slot.md`（mutability frontmatter scaffold prior art）、`role-conflict-resolution.md`（決策權屬 user 精神）、`escalation-protocol.md`（3-strike 升級三段式對齊）、`multi-role-tracking.md`（user explicit 授權精神延伸）、`maintainer-discipline.md`（修訂權限分層維護者半邊）
> **保證強度**：結構強制（三層 mutability 在 frontmatter scaffold 寫死、AI 不得自升層級；3-strike 刪除協議走 user 親決）
> **檢測時點**：runtime（修訂條款時校驗 mutability）+ post-upgrade（升版後校驗 mutability frontmatter 完整性）
> **since**：v0.9.0（v0.7.1 frontmatter scaffold prior art）

---

## 0. 概念位階（紀律本體 vs scaffold）

### 0.1 v0.7.1 frontmatter scaffold 已 ship

charter v0.7.1 在 `templates/agent-commons/domain-axioms.md.tpl` ship frontmatter scaffold（含 `mutability_default` 欄位、依 `core/domain-axiom-slot §3.3`），但**紀律本體未條款化**：

| 已 ship（v0.7.1）| 未 ship（v0.9.0 補完）|
|---|---|
| frontmatter scaffold（`mutability_default` 欄位存在）| 三層 mutability 含義（IMMUTABLE-by-AI / APPEND-ONLY / FULL-MUTABLE）|
| `Status` 欄位（AI-DRAFTED / USER-RATIFIED）| 3-strike 刪除協議（哪些條件下可刪某條 condition）|
| 路徑 A / 路徑 B 雙路徑（user 主筆 / AI 代產）| user-initiated consolidation（多條條款合併紀律）|
| Status 升維紀律（AI 不可自升）| AI 對 condition 的修訂權限分層 |

→ frontmatter scaffold 是「**紀律的容器**」、本條款是「**紀律的內容**」。

### 0.2 對應 dogfood signal #11

dogfood signal #11（v0.7.1 user 直接提議、v0.9.0 紀律本體條款化）：user 公司接入痛點對話 2026-04-28 提議「**condition mutability 三層**（IMMUTABLE-by-AI / APPEND-ONLY / FULL-MUTABLE）+ **3-strike 刪除**」。

v0.7.1 ship frontmatter scaffold 預備（對齊 user 「想法碰撞、frontmatter 先 ship、紀律本體留更深迭代」精神），紀律本體留 v0.8.0 / v0.9.0 完整條款化（依 STATUS §A v0.8.0 「**議程位階重整**」原 v0.8.0 議程留 v0.9.0 fresh-head 設計）。

### 0.3 與 domain-axiom-slot 的位階分工

| 條款 | 主管面向 | 範圍 |
|---|---|---|
| `domain-axiom-slot.md` | 領域公理槽位本身（位置 / 撰寫紀律 / 違反處置）| **領域公理檔的 mutability frontmatter scaffold**（v0.7.1 加）|
| **本條款** | **mutability 紀律本體**（三層含義 + 3-strike + consolidation + 修訂權限分層）| **跨 condition / template / 領域公理檔通用**（不限於領域公理）|

→ domain-axiom-slot 是「**領域公理特定**」、本條款是「**通用 mutability 紀律**」、後者覆蓋前者所在的 mutability 維度。

### 0.4 與 escalation-protocol 的位階分工

| 條款 | 主管面向 | 觸發機制 |
|---|---|---|
| `escalation-protocol.md` | **失敗事件累積**（單向、有對錯）| 同類失敗 ≥ 2 次 → 強化抽驗、≥ 3 次 → 使用者裁決 |
| **本條款 §2 3-strike** | **條款違反累積觸發刪除評估**（雙向、可能是條款本身有問題）| 同條款違反 ≥ 3 次 → user 評估是否刪除該條款（不是處罰違反者、是評估條款本身）|

→ escalation-protocol 處理「違反者」、本條款 §2 處理「**被違反的條款本身是否仍適合**」。兩軸正交（對齊 charter v0.5.3 失敗 ⊥ 分歧 正交軸精神）。

### 0.5 與 maintainer-discipline 的位階分工

| 條款 | 主管面向 | 動作主體 |
|---|---|---|
| `maintainer-discipline.md` | **framework 維護者**修改 charter 內條款 / spec / template 時的 sync 紀律 | **maintainer**（採用方無關）|
| **本條款 §4** | **AI 修訂權限分層**（採用方專案內 AI / charter maintainer / user 各自能改什麼）| **跨採用方 + maintainer 通用**（位階不特殊）|

→ maintainer-discipline 是「**maintainer 對 charter 自身的紀律**」、本條款是「**任何 AI 對任何 condition 的修訂權限**」。

---

## 1. 條文

charter / 採用方專案內所有 condition / template / 領域公理檔的 frontmatter **必含 `mutability_default` 欄位**，標明三層 mutability 之一（IMMUTABLE-by-AI / APPEND-ONLY / FULL-MUTABLE，依 §1.1 規範）。

各層級對應的修訂權限分層依 §4 規範：

- **AI 不可自升 mutability 層級**（不可從 IMMUTABLE-by-AI 自升 APPEND-ONLY、不可從 APPEND-ONLY 自升 FULL-MUTABLE）— 對齊 `multi-role-tracking §3.4` user explicit 授權精神延伸
- **3-strike 刪除協議**走 user 親決（依 §2）
- **user-initiated consolidation**（多條條款合併）由 user 主動提議、AI 不可代決（依 §3）

違反 → 該修訂視為未授權、抽驗方有權直接退稿（依 `audit-rights.md`）+ 維護者半邊命中 `maintainer-discipline §4` 違反處置。

---

## 1.1 三層 mutability 定義

### 1.1.1 IMMUTABLE-by-AI（AI 不可改、user 親決）

**含義**：AI 在任何情況下都不可改、不可刪、不可加既有規定的修訂；只有 user 親自編輯才能修改。

**典型適用**：
- 領域公理（資金 / 安全 / 合規 — 對齊 `domain-axiom-slot §2.1` 衝突優先序、領域公理優先）
- charter 北極星紀律（v0.7.3 兩無痛定義 + 三服務原則 — 對齊 README §設計哲學）
- 跨 release 結構承諾（如 `versioning-migration §2.3` agent-commons 結構穩定性承諾、v1.0 後永不破壞）

**AI 行為**：
- 只能讀、只能引用、只能對齊
- 若 AI 認為 IMMUTABLE-by-AI 條款有問題 → 走 `role-conflict-resolution §3.3` L2 user 裁決路徑、不可自改

### 1.1.2 APPEND-ONLY（AI 可加新項、不可刪 / 改既有）

**含義**：AI 可加新規定 / 新範例 / 新 sub-section，但不可刪既有規定、不可改既有規定本意。

**典型適用**：
- 既有 21 條 condition（v0.x 階段、結構修正不破壞既有）— 對齊 `versioning-migration §2.3` 結構穩定承諾精神
- 失敗模式 catalog（`failure-modes.md` F-Catalog — 加 F7 / F8 可、改 F1 含義不可）
- 集體記憶層（`failure_mode_log.md` / `institutional-memory/` — 永不刪除、不可改寫，依 `violation-reflection §5`）

**AI 行為**：
- 可加新 entry / 新 sub-section / 新範例
- 不可刪既有段、不可改既有段本意（對齊 `versioning-migration` 「不破壞既有採用方」精神）
- 若 AI 認為 APPEND-ONLY 條款的既有規定有問題 → 走 §2 3-strike 刪除協議路徑

### 1.1.3 FULL-MUTABLE（AI 可改 / 刪 / 加，極少）

**含義**：AI 可在 commit 紀律下自由修改（含刪 / 改 / 加既有規定）。

**典型適用**（極少數場景）：
- `.claude_temp/` 內部追蹤檔（NEXT.md / STATUS.md 部分段落 — maintainer 工作流、非條款本體）
- AI 角色私有區（`agent-commons/roles/<role>/private/` — 依 `multi-role-tracking §3.3` 角色內部 scratch）
- 範例 / placeholder（如 `examples/<project>/mapping.md` 範例段、可隨採用方專案演化）

**AI 行為**：
- 修改前仍須對齊 `evidence-first.md` / `structural-anti-fabrication.md` 等通用紀律
- 不可把任何 condition 本體標為 FULL-MUTABLE（**condition 本體最低層級為 APPEND-ONLY**）

### 1.1.4 三層對照表

| 層級 | AI 加新 | AI 刪 | AI 改 | user 改 | 典型 |
|---|---|---|---|---|---|
| **IMMUTABLE-by-AI** | ❌ | ❌ | ❌ | ✅ | 領域公理 / 北極星 / 結構承諾 |
| **APPEND-ONLY** | ✅ | ❌ | ❌ | ✅ | condition 本體 / F-Catalog / 集體記憶 |
| **FULL-MUTABLE** | ✅ | ✅ | ✅ | ✅ | 內部追蹤 / 角色私有區 / 範例 |

---

## 2. 3-strike 刪除協議

### 2.1 觸發條件

**同條款（含相同 mutability 層級）連續 3 次 audit 命中違反** → user 評估是否刪除 / 修訂 / 降層級。

對齊 `escalation-protocol.md §1` 升級三段式精神，但**性質不同**（依 §0.4 位階分工）：

| 機制 | 性質 |
|---|---|
| escalation-protocol 三段式 | 處理「**違反者**」（單向升級強化抽驗 → 使用者裁決）|
| **本條款 3-strike** | 評估「**被違反的條款本身**」（雙向：條款可能太緊 / 太鬆 / 不適合當前場景）|

### 2.2 3-strike 流程

| Strike | 動作 |
|---|---|
| Strike 1 | 違反者依 `violation-reflection §3` 補交反省 + 雙寫紀律（依 `individual-learning-loop §2`）；條款本身不動 |
| Strike 2 | 違反者升強化抽驗（依 `escalation-protocol §1`）；condition 本身**累積觀察**到 NEXT.md（依 `maintainer-discipline §3.4.3`）|
| **Strike 3** | **觸發 user 評估**：條款是否需修訂 / 降層級 / 刪除？走 `role-conflict-resolution §3.3` L2 user 裁決路徑 |

### 2.3 user 評估的可能結果

| 結果 | 後續動作 |
|---|---|
| **保留現狀**（條款仍合理、違反者持續強化抽驗）| 對齊 escalation-protocol §1 既有路徑、不動條款 |
| **修訂條款**（條款規定不夠清楚 / 邊界 case 未涵蓋）| maintainer 走 `versioning-migration` PATCH / MINOR 升版、補完條款 |
| **降層級**（如 APPEND-ONLY → FULL-MUTABLE 不適用、IMMUTABLE-by-AI → APPEND-ONLY 過嚴）| 對齊 `versioning-migration §2.1` BREAKING 判定條件、需評估升 BREAKING-LITE |
| **刪除條款**（條款已不適合當前 charter 階段）| 對齊 `versioning-migration §2.1` BREAKING（刪 condition = BREAKING）、user 親決升版 |

→ user 評估**不依賴 AI 主動提議**（AI 可在 NEXT.md 累積觀察、但決策權屬 user，對齊 `role-conflict-resolution §5.4` 角色切換決策權屬 user 精神延伸）。

### 2.4 為何 3-strike 而非 2-strike / 5-strike

對齊 `escalation-protocol §1` 既有三段式（≥ 2 次升級、≥ 3 次裁決）的數字選擇精神：

| 候選 | 缺點 |
|---|---|
| 2-strike | 太敏感、條款修訂頻率過高、charter 演化不穩定 |
| 5-strike | 太鬆、條款已實質失效但仍視為「累積中」、user 介入太晚 |
| **3-strike** | 對齊 escalation-protocol 既有節奏、user 介入時點與升級裁決同步 |

---

## 3. user-initiated consolidation（多條條款合併紀律）

### 3.1 概念

當多條 condition 在實際運行時出現**重疊**（同樣的場景兩條條款都規範、容易混淆）→ user 可主動提議 consolidation（合併兩條 / 多條為一條）。

→ 本紀律是「**3-strike 刪除協議**」的對偶 — 前者處理「條款太多 / 太緊」、後者處理「條款太重疊 / 不夠正交」。

### 3.2 user-initiated 紀律（AI 不可代決 consolidation）

| 動作 | 主體 | 紀律 |
|---|---|---|
| 觀察條款重疊 | AI（accumulate 到 NEXT.md）| ✅ 可以累積觀察 |
| 提議 consolidation | **user**（必親自提議）| ❌ AI 不可主動提議 consolidation |
| 設計合併方案 | maintainer / AI（user 授權後）| ✅ 可以協助設計 |
| 簽收合併（升版 BREAKING-LITE）| **user**（必 explicit 授權）| ❌ AI 不可代決 |

→ 對齊 `multi-role-tracking §3.4`「上岸需 user explicit 授權」精神延伸 — 條款合併等同於 charter 演化的關鍵決策點、屬 user 域。

### 3.3 為何 user-initiated（AI 不可主動）

| 替代方案 | 缺點 |
|---|---|
| AI 主動提議 consolidation | 違反 `multi-role-tracking §3.3` 自抽自驗禁令延伸（AI 自評 + 自合 = 自抽自驗）|
| AI 代設計後 user 簽收 | 形式上 user 簽、實質 AI 主導、容易產生 F1 假宣告（user 「以為」自己評估了）|
| **user 主動提議 + AI 協助設計** | charter 演化方向由 user 把關、AI 協助執行、對齊 charter 三層精神（不代寫 / 給結構引導 / 留 AI 主動權）|

### 3.4 consolidation 的執行載體

對齊 `versioning-migration §2.1` BREAKING 判定條件 — condition 合併屬 BREAKING（檔名變動 / 引用範圍變動 / 採用方需 migrate）：

1. user 提議 consolidation（在對話 / GitHub issue / NEXT.md 顯式 framing）
2. maintainer 設計合併方案（依 `maintainer-discipline §3.4.1` 條款層連動 sync 紀律）
3. user explicit 授權合併
4. ship BREAKING / BREAKING-LITE release（依 `versioning-migration §4.1` 框架側責任）
5. 採用方走 migration 流程（依 `versioning-migration §3.1` / §3.4 跨多版本）

---

## 4. AI 修訂權限分層

### 4.1 三層權限對應三層 mutability

| mutability 層 | 採用方專案內 AI | charter maintainer 內 AI | user |
|---|---|---|---|
| **IMMUTABLE-by-AI** | ❌ 不可任何修訂 | ❌ 不可任何修訂 | ✅ 親決（依 §1.1.1）|
| **APPEND-ONLY** | ✅ 可加新項（如新 reflection 個體層 entry）/ ❌ 不可刪改既有 | ✅ 可加新項（如新 sub-section、依 `maintainer-discipline §3.4`）/ ❌ 不可刪改既有（除非走 BREAKING 升版） | ✅ 親決加 / 刪 / 改 |
| **FULL-MUTABLE** | ✅ 可加 / 刪 / 改（含 commit 紀律）| ✅ 可加 / 刪 / 改 | ✅ 親決 |

### 4.2 採用方專案內 AI vs charter maintainer 內 AI

兩者**對採用方專案內檔案的權限分層相同**、但對 charter repo 內檔案：

| 對 charter repo 內檔案 | 採用方專案內 AI | charter maintainer 內 AI |
|---|---|---|
| 修訂 charter 條款 | ❌ 不可（採用方場景不該動 charter）| ✅ 可（依 `maintainer-discipline §3.4`）|
| 提 PR 給 charter | ✅ 可（採用方層發現 charter 問題 → 提 PR、走路徑 B 對齊 `adoption-lifecycle §3.1`）| ✅ 可 |
| 簽收 PR | ❌ 不可 | ✅ 可（依 `maintainer-discipline §4`）|

→ 對齊 `ai-vendor-onboarding §3` 邀請制四步驟精神 — 採用方層 AI 與 charter maintainer 層 AI 動作邊界清晰、不混。

### 4.3 AI 不可自升 mutability 層級

對齊 `multi-role-tracking §3.4.4` init 階段自我激活同樣 = F1 精神延伸：

| 違反場景 | 命中 |
|---|---|
| AI 把 IMMUTABLE-by-AI 條款的 frontmatter 自改為 APPEND-ONLY | 視同 F1（假宣告就位 — 自宣告升維 = 跨越授權邊界）|
| AI 把 APPEND-ONLY 條款的 frontmatter 自改為 FULL-MUTABLE | 同上 |
| AI 自宣告 「我認為這條應該降為 FULL-MUTABLE 你看怎麼樣」 | 屬 §3 user-initiated consolidation 對偶禁令（AI 不可主動提議 mutability 變更）|

### 4.4 違反處置

| 違反 | 處置 |
|---|---|
| AI 自升 mutability 層級 | 視同 F1、抽驗方有權**回退 frontmatter 改回原層級 + 刪除非法升維 commit**（對齊 `init-template §3.3.5` 違反處置精神延伸）|
| AI 主動提議 consolidation（未經 user explicit 授權）| 違反 §3 user-initiated 紀律、抽驗方退稿、要求 AI 補做 violation-reflection（依 `violation-reflection §3`）|
| condition 缺 `mutability_default` frontmatter | `tools/doctor-spec.md` 對應校驗報錯（v0.9.0 PATCH 落地、屬 maintainer-discipline §3.4.1 條款層連動 sync 範圍）|
| 採用方專案內 AI 修訂 charter repo 內檔案 | 違反 §4.2 邊界、抽驗方退稿、要求改走路徑 B 提 PR（依 `adoption-lifecycle §3.1`）|

---

## 5. 與其他 core 條款的關係

| 條款 | 關係 |
|---|---|
| `domain-axiom-slot.md` | §3.3 frontmatter scaffold（v0.7.1 加 `mutability_default`）是本條款的 prior art；本條款 §1 是紀律本體、與 domain-axiom-slot 互補（後者特定領域公理、本條款通用 mutability）|
| `role-conflict-resolution.md` | §3.3 L2 user 裁決路徑是本條款 §2.3 3-strike 第三 strike 觸發路徑；§5.4 角色切換決策權屬 user 對齊本條款 §3.2 user-initiated 精神延伸 |
| `escalation-protocol.md` | §1 升級三段式是本條款 §2.4 3-strike 數字選擇的對齊節奏；兩軸正交（escalation 處理違反者 / 本條款 §2 處理被違反的條款本身）|
| `multi-role-tracking.md` | §3.4「上岸需 user explicit 授權」精神對齊本條款 §3 user-initiated consolidation + §4.3 AI 不可自升 mutability；§3.4.4 init 階段自我激活同樣 = F1 精神延伸到 mutability 自升 |
| `maintainer-discipline.md` | §3.4.1 條款層連動 sync 是本條款 §4.4 違反處置（缺 frontmatter）的執行載體；§4 違反處置（自我抽驗）對齊本條款 §4.4 處置精神 |
| `versioning-migration.md` | §2.1 BREAKING 判定條件對齊本條款 §2.3 user 評估結果（降層級 / 刪除條款 = BREAKING）+ §3.4 consolidation 升版流程 |
| `failure-modes.md` | F1 假宣告就位精神對齊本條款 §4.3 AI 自升 mutability 視同 F1；F5 規則記憶失效對齊本條款 §2 3-strike 觸發條件 |
| `violation-reflection.md` | §5 永不刪除 / 不可改寫精神對齊本條款 §1.1.2 APPEND-ONLY 集體記憶層典型適用 |
| `individual-learning-loop.md` | §2 雙寫紀律是 APPEND-ONLY 層典型動作（個體層 reflection 加新檔、不刪既有）|
| `diagnose-remediate-protocol.md` | §2.1 spec-as-data 四欄結構在 mutability 維度延伸 — 每個 condition / spec 的 mutability 對應不同的「合規規定」欄位嚴格度 |
| `audit-rights.md` | §3 抽驗 SOP 與本條款 §4.4 違反處置配合 — AI 自升 mutability 視同 F1、抽驗方有權直接退稿 |

---

## 6. 對應 dogfood signal

| Signal | 日期 | 事件 | 對應本條款段 |
|---|---|---|---|
| **#11** | 2026-04-28 LIVE | user 公司接入痛點對話直接提議「condition mutability 三層（IMMUTABLE-by-AI / APPEND-ONLY / FULL-MUTABLE）+ 3-strike 刪除」、v0.7.1 ship frontmatter scaffold 預備、紀律本體留 v0.9.0 完整條款化 | §1.1 三層定義 + §2 3-strike 刪除協議 + §0.2 對應 dogfood signal |

未來再撞到同類觀察時：

- 若 doctor 校驗已實作 → 應被自動偵測（mutability 自升 / consolidation AI 主動 / frontmatter 缺欄位）
- 若仍漏 → 加 dogfood signal 累積到 NEXT.md，evaluate 是否升級條款（如 §4 修訂權限分層細化、或 §2 3-strike 改為 2-strike 加嚴）

---

## 7. 變更歷史

### v0.1（自 v0.9.0 引入）

初版。對應 dogfood signal #11（v0.7.1 user 直接提議、v0.7.1 ship frontmatter scaffold、v0.9.0 紀律本體完整條款化）。屬「**紀律本體**」 — 不新加架構級概念、補完 `domain-axiom-slot §3.3` mutability frontmatter scaffold（v0.7.1 加）的紀律內容部分。

**設計學意義**：charter v0.7.1 ship frontmatter scaffold（容器）但紀律本體（內容）留 v0.8.0 / v0.9.0 — 對齊 user「想法碰撞、frontmatter 先 ship、紀律本體留更深迭代」精神。本條款條款化三層 mutability 含義 + 3-strike 刪除協議 + user-initiated consolidation + AI 修訂權限分層、構成 charter 對「條款如何演化」的元紀律。

配合 v0.9.0 同 release 的 ① individual-learning-loop（個體學習迴圈）+ ② diagnose-remediate-protocol（紀律執行循環依賴解）+ ③ adoption-lifecycle（lifecycle 完整化），charter 完成「**紀律完整性 + AI 自我覺察升維**」轉折。
