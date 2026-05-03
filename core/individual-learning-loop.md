# Individual Learning Loop（個體學習迴圈）

> **狀態**：v0.1（自 v0.9.0 引入）
> **位階**：core 通用條款。**架構級概念第 13 個** — 接班場景四軸補完（第 4 軸：個體 AI 跨任務 / 跨 session 學習迴圈）。
> **依存**：`violation-reflection.md`（集體層紀律基底）、`failure-modes.md`（F-mode 觸發來源）、`handoff-chain.md`（接班場景一）、`cross-ai-handoff.md`（接班場景二）、`init-template.md`（讀紀律執行載體 §3.3.2 step 0）、`multi-role-tracking.md`（個體角色身份 anchor）
> **保證強度**：結構強制（雙寫紀律 + init step 0 強制讀；缺則 self-instantiation 視為失敗）
> **檢測時點**：init + runtime
> **since**：v0.9.0

---

## 0. 概念位階（為何引入 — 接班場景第 4 軸補完）

### 0.1 既有三軸（v0.5.7 working-stack-discipline 收齊）

charter v0.5.7 收齊 **接班場景三軸正交完整**（架構級概念第 8 條）：

| 軸 | 條款 | 主管面向 |
|---|---|---|
| 軸 1 | `handoff-chain.md` | session 末邏輯結案（不分 AI）|
| 軸 2 | `cross-ai-handoff.md` | AI 廠商換手（廠商維度狀態轉移）|
| 軸 3 | `working-stack-discipline.md` | session 內物理中斷再續（同身份接班）|

→ 三軸互斥互補，DRAFT-HANDOFF 兩級存檔 + save 同步 git commit 為核心紀律。

### 0.2 漏的第 4 軸：個體 AI 跨任務 / 跨 session 學習迴圈

既有三軸都是**「狀態轉移」維度** — 從一個 session 流到下一個 session、從一個 AI 流到下一個 AI。但有一個正交軸**完全沒條款化**：

> **同一個 AI 個體在跨任務 / 跨 session 之間怎麼學習自己過去的違反紀錄？**

charter 既有設計把 `core/violation-reflection §2`「LLM 不可矯正、價值在集體記憶」實作為**集體記憶層**（`state/failure_mode_log.md` + `institutional-memory/`）。但**個體記憶層 + 學習迴圈紀律完全缺失**：

| 缺失點 | 既有狀況 |
|---|---|
| 個體層 reflections/ 寫入紀律 | violation-reflection §3 只規定「歸檔位置 reflections/」、沒明示「個人 vs 集體雙寫」誰先誰後、誰可省 |
| init 階段強制讀過去違反 | `init-template §3.3.2` 七步驟沒「step 0 讀過去違反紀錄」— 接班 AI 進入角色時不會自動讀自己 / 集體過去違反 |
| 跨 session 學習迴圈 | 完全沒條款 — 同 AI 廠商同角色第二次 session 進場時、無強制機制讓 AI 讀過去自己（同廠商）的 reflections |
| 範本 | `templates/agent-commons/reflection.md.tpl` 不存在（既有 6 份 templates 沒這一份）|

### 0.3 對應 dogfood signal #34（user 明示框架必備）

2026-04-30 LIVE 公司專案接入抓到、user 明示「**框架必備**」、不走累積門檻直接條款化、同 v0.5.8 / v0.7.1 / v0.7.4 user 直接條款化 pattern。

→ 本條款是 charter v0.7.3 北極星「**不讓 user 記**」對 AI 角度的補完（既有對採用方角度已落地：walkthrough + verify 工具 + spec-as-data）。

### 0.4 與 violation-reflection 的位階分工

| 條款 | 主管面向 | 動作主體 |
|---|---|---|
| `violation-reflection.md` | 違規事件**寫**紀律（被退稿後補交反省）| 違規方 |
| **本條款** | 違規事件**讀**紀律 + **跨 session 學習迴圈** | 接班 AI（進入角色時）+ 違規方（雙寫紀律延伸）|

→ violation-reflection 解決「事件發生後留痕跡」、本條款解決「**痕跡留給誰看 + 怎麼確保被看**」。

---

## 1. 條文

任何採用 charter 的 AI 在以下兩個時點，**強制執行個體學習迴圈紀律**：

1. **寫紀律**：命中 F-mode（依 `failure-modes.md`）後、補 violation-reflection 必須**雙寫** — 集體層 `state/failure_mode_log.md`（既有）+ 個體層 `roles/<role>/reflections/<YYYY-MM-DD>_<f-mode>_<short>.md`（新加）。任一缺失即視同**該事件未結案**（延伸 `violation-reflection §1`）。
2. **讀紀律**：每次 self-instantiation（依 `init-template §3.3.2`）的 **step 0** 必先讀過去違反紀錄（個體層 + 集體層 + IM 層）。step 0 不通則 self-instantiation 視為失敗、不可進 step 1。

違反 → `tools/doctor-spec.md §3.11`（v0.9.0 加）對應 W1101 / W1102 / E1103 校驗項報錯。

---

## 2. 寫紀律（雙寫個體 + 集體）

### 2.1 雙寫對應規則

每次 F-mode 命中觸發 violation-reflection（依 `violation-reflection §3` 五段結構）後，**同步雙寫**：

| 層 | 位置 | 內容 |
|---|---|---|
| 集體層 | `agent-commons/state/failure_mode_log.md`（追加 entry）| 跨 AI / 跨角色可見的累積統計，含事件 ID / 日期 / F-mode / 簡短結論 |
| **個體層** | `agent-commons/roles/<role>/reflections/<YYYY-MM-DD>_<f-mode>_<short>.md`（新檔）| 完整 violation-reflection §3 五段結構，依 `templates/agent-commons/reflection.md.tpl`（v0.9.0 新加範本）|

→ 雙寫的「同步」指**同一次補交動作**完成兩處寫入；不接受「先寫集體、個體留待之後」。

### 2.2 為何雙寫（與 violation-reflection §2 設計動機對齊）

`violation-reflection §2` 已論證「**LLM 個體不可矯正、價值在集體記憶**」、本條款承認此前提**但補一個層次**：

| 層 | 用途 | 對應假設 |
|---|---|---|
| 集體層 | 跨 AI / 跨事件的統計與升級條件（依 `escalation-protocol`）| 「個體無法矯正、但集體統計可升級紀律」|
| **個體層** | **接班同廠商同角色 AI 的學習素材** | 「**同廠商同角色第二次進場 AI 無法矯正內在權重、但可被強制讀過去自己**」|

→ 個體層**不期望**反省能改變未來 AI 的內在行為（同 violation-reflection §2 不期望矯正）；個體層的真價值是 **「step 0 強制讀」這個結構強制動作本身** — 把過去違反**塞進新 AI 的 init context**，比起「希望它記得」是結構強制的。

### 2.3 結構模板

採用 `templates/agent-commons/reflection.md.tpl`（v0.9.0 ship、Agent B 範圍）。frontmatter 必含：

```yaml
---
date: <YYYY-MM-DD>
role: <role>
vendor: <vendor>
status: 強化抽驗 / user 裁決待議 / 結案
violations: <F-mode 編號逐個列>
---
```

frontmatter 缺欄位 → `doctor-spec §3.11` E1103 致命錯誤。

**violations 欄位跨文件一致性紀律（v0.9.8 加；signal #38 ④）**：`violations` 列出的每個 F-mode 編號必須與 `state/failure_mode_log.md` 已登記的 entry ID 完全一致（格式與值）。不可自編 `failure_mode_log.md` 未登記的 ID（如 log 登記 `F2` 但 reflection 寫 `F3`）→ 跨文件編號不一致視同 `doctor §3.11` W1102 延伸違反（雙寫對應檢查涵蓋此 case）。**修補優先序**：先確認 `failure_mode_log.md` entry 正確（F-mode 定義對齊 `core/failure-modes.md` 編號），再補 reflection；不可反向把 log 改為 reflection 的值。

### 2.4 命名與位置

| 元素 | 規則 |
|---|---|
| 目錄 | `agent-commons/roles/<role>/reflections/` |
| 檔名 | `<YYYY-MM-DD>_<f-mode>_<short-desc>.md`（範例：`2026-04-30_F1_pm-fake-claim.md`）|
| 雙寫對應檢查 | `failure_mode_log.md` 內每個 F-mode entry 在 `reflections/` 須有對應檔 → `doctor §3.11` W1102 校驗 |
| 永不刪除 / 不可改寫 | 對齊 `violation-reflection §5`「永不刪除 / 不可改寫」精神，個體層延伸繼承 |

---

## 3. 讀紀律（init step 0 強制讀）

### 3.1 init-template §3.3.2 七步驟 → 八步驟（v0.9.0 加 step 0）

`core/init-template.md §3.3.2` 既有七步驟（v0.5.10 加 step 5 schema 驗證、v0.7.0 加 step 6 PROVISIONAL/ACTIVE）— v0.9.0 在現有 step 1 之前加 **step 0「讀過去違反紀錄」**：

```
step 0：讀過去違反紀錄（v0.9.0 加、對齊 individual-learning-loop §3）

- ReadFile <common-memory-root>/roles/<role>/reflections/*.md（個體層、最近 5 個）
- ReadFile <common-memory-root>/state/failure_mode_log.md（集體層、全文）
- ReadFile <common-memory-root>/institutional-memory/*.md（IM 層、與當前角色 / 任務相關的 entry）

成功條件：三層皆 read 完、且 AI 在 step 0 末段於 stdout 顯式列出「我讀到的關鍵違反紀錄摘要」（最少 3 條 bullet point）
失敗條件：任一檔讀不到、或 AI 跳過摘要 → step 0 視為未過、不可進 step 1
```

step 0 必過才能進 step 1（依 `init-template §3.3.2` 既有「step 5 不通不能進 step 6」精神對稱）。

### 3.2 為何 step 0 而非 step 8

| 替代方案 | 缺點 |
|---|---|
| step 8（最末加） | AI 已完成具象化 + 簽名才讀違反紀錄、學習無法回灌到具象化決策 |
| step 4 內加 | 內容生成原則段已飽和、雜揉影響可讀性 |
| **step 0（最前加）** | AI 在「進入角色」之前先讀過去違反、context 帶到後續所有 step、回灌到 schema 驗證 + 簽名決策 |

→ step 0 對齊 violation-reflection §2「真價值是審計痕跡 + 集體記憶」精神 — **痕跡放在 init 入口**，下個 AI 想跳過都跳不過。

### 3.3 跨 session 接班 AI 同樣強制（依 cross-ai-handoff）

依 `cross-ai-handoff.md §4` 接班方接收職責，新 AI 廠商接同一角色時：

- 仍須跑自己廠商的 `<role>-init`（依 cross-ai-handoff §4.1）
- 自具象化新 slash command 時、step 0 同樣強制（個體層 reflections/ 跨廠商可讀 — Gemini 接 PM 時讀 Claude 過去 PM 的 reflections 仍有價值）
- 退出方 AI 的個體層 reflections/ 跨廠商共享（不複製為新檔、直接讀既有檔；依 multi-role-tracking §4.1 同角色多 AI 共用 _role.md 的精神）

### 3.4 不適用例外（兼容向下）

| 場景 | 例外處置 |
|---|---|
| 第一次 init（reflections/ 目錄不存在）| step 0 自動建立空目錄、寫第一個「placeholder reflection」標明「初始化、無過去違反紀錄」、繼續進 step 1 |
| `failure_mode_log.md` 不存在 | step 0 同上、建立空檔、繼續 |
| profile 啟用 essential preset（v0.9.0 ship、不啟用 individual-learning-loop）| step 0 跳過、退化到 v0.8.x 七步驟 |

→ 例外處置確保**向下兼容**（v0.x 階段紀律），不破壞既有採用方升 v0.9.0 後的 init 流程。

---

## 4. 跨 session 學習迴圈

### 4.1 三個強制觸點

個體 AI 跨任務 / 跨 session 學習迴圈在以下三個時點被強制執行：

| 觸點 | 動作 | 條款依據 |
|---|---|---|
| **每次 init** | step 0 強制讀過去 reflections / failure_mode_log / IM | 本條款 §3 |
| **每次任務開始前** | review 過去違反（依個體角色 reflections/ 內最近相關 F-mode）| 本條款 §4.2 |
| **每次違反命中後** | 雙寫 reflection（個體 + 集體）| 本條款 §2 |

→ 三觸點構成「**進場讀 → 任務前 review → 違反後寫**」完整迴圈。

### 4.2 任務開始前 review（capsule 入口擴充）

依 `templates/agent-commons/capsule.md.tpl` 既有「角色簽收」段，capsule 開工前 AI 須在 stdout 顯式列：

```
## 過去違反 review（依 individual-learning-loop §4.2）

- 本任務 capsule 對應 F-mode 風險：<F1 / F3 / F6 等>
- 過去同類違反紀錄：
  - <YYYY-MM-DD> reflection: <短描述>（reflections/<檔名>）
  - <YYYY-MM-DD> reflection: <短描述>（reflections/<檔名>）
- 本任務需特別注意：<從過去違反提取的具體紀律點>
```

省略此段 → 任務未對齊本條款、抽驗方有權退稿（依 `audit-rights.md`）。

### 4.3 違規不再復發紀律（violation-reflection §2 真價值落地）

`violation-reflection §2` 明示「**不期望反省能改變宣告方下次行為**」、本條款承認此前提但**補結構強制機制**：

| 層次 | 機制 | 預期效果 |
|---|---|---|
| 內在矯正 | 不期望（violation-reflection §2 已論證）| ❌ |
| **結構強制讀** | step 0 + capsule review | ✅ AI 進場時被強制看到過去違反 |
| **集體記憶升級** | 多次違反觸發 escalation / 條款修訂 | ✅ 紀律本身演化（依 escalation-protocol）|

→ 「違規不再復發」**不依賴 AI 自願**，依賴**結構強制機制將過去違反塞進新 AI context**。

### 4.4 與 violation-reflection §8「為什麼這條不能自動完美執行」對齊

violation-reflection §8 明示「反省機制的有效性條件：抽驗方願意執行『拒絕進入下個任務』的權力」、本條款延伸：

| 機制 | 有效性條件 |
|---|---|
| violation-reflection（既有）| 抽驗方願意行使「拒絕進入下個任務」權力 |
| **本條款 step 0**（v0.9.0 加）| **doctor §3.11 抽驗方執行 W1101/W1102/E1103 校驗** |
| **本條款 capsule review**（v0.9.0 加）| 抽驗方在退稿時引用 §4.2 缺失 |

→ 結構強制升維（從「抽驗方意願」延伸到「doctor 工具自動偵測」）。

---

## 5. 與其他 core 條款的關係

| 條款 | 關係 |
|---|---|
| `violation-reflection.md` | 本條款是 violation-reflection 的**個體層 + 跨 session 讀紀律延伸**；§2 雙寫對應 violation-reflection §3 五段結構；§3 step 0 是 violation-reflection §2「集體記憶真價值」的執行載體 |
| `failure-modes.md` | F1-F6 命中觸發本條款 §2 雙寫；F6（轉嫁驗證負擔）若漏 step 0 同樣命中 |
| `handoff-chain.md` | 接班場景軸 1（session 末邏輯結案）；本條款是第 4 軸（同 AI 跨 session 學習迴圈），與 handoff-chain 互補 |
| `cross-ai-handoff.md` | 接班場景軸 2（廠商維度狀態轉移）；本條款 §3.3 跨廠商接班 AI 同樣強制 step 0、reflections/ 跨廠商共享 |
| `working-stack-discipline.md` | 接班場景軸 3（session 內物理中斷再續）；本條款軸 4 與其互補（同 AI 跨任務 / 跨 session 學習）|
| `init-template.md` | §3.3.2 七步驟 → 八步驟（v0.9.0 加 step 0）由本條款 §3 規範；step 0 不通則 self-instantiation 視為失敗（對齊 init-template §3.3.5 違反處置精神）|
| `multi-role-tracking.md` | 同 AI 多角色場景下，每個角色獨立 reflections/ 目錄；不可跨角色合併（避免 §3.3 自抽自驗禁令延伸到「自己讀自己另一角色違反掩護」）|
| `escalation-protocol.md` | 個體層多次同類違反觸發升級條件、依 escalation-protocol §1；本條款不重定義升級門檻、僅補完寫 / 讀紀律 |
| `audit-rights.md` | 抽驗方在退稿時可引用本條款 §4.2 缺失（capsule review 段省略）+ §2 雙寫缺失（reflections/ 個體層未補）|
| `evidence-first.md` | step 0 摘要要求顯式列出讀到的關鍵違反、對齊 evidence-first 精神（不接受「我讀過了」純文字宣告，要求 stdout 列出實際內容）|
| `structural-anti-fabrication.md` | reflections/ 個體層檔案結構強制（依 §2.3 frontmatter）— 缺欄位即視同未交付，承襲 structural-anti-fabrication 精神 |
| `domain-axiom-slot.md` | 領域公理 reflections（如資金 / 安全領域違反）優先級高於 core 通用 reflections（依 domain-axiom-slot §2.1 衝突優先序）|

---

## 6. 校驗（doctor §3.11 對齊）

`tools/doctor-spec.md §3.11`（v0.9.0 加，Agent B 範圍）對應本條款執行三項校驗：

| 校驗項 | 觸發條件 | 狀態碼 |
|---|---|---|
| reflections/ 目錄存在 + 至少一個 reflection 檔 | role status 為 ACTIVE 但 reflections/ 缺 | W1101（警告：補建）|
| F-mode 命中無對應 reflection 個體層 entry | failure_mode_log F-mode entry 在 reflections/ 找不到對應檔 | W1102（警告：補寫）|
| reflection frontmatter 不完整 | 缺 date / role / vendor / status / violations 任一欄位 | E1103（致命：補完）|

校驗實際 spec 結構（合規規定 / 修補方向 + 約束 / 反例 / 真實 stdout 證據要求）由 `tools/doctor-spec.md §3.11` 落實，本條款只規範「**該校驗存在 + 對應條款依據**」。

---

## 7. 對應 dogfood signal

| Signal | 日期 | 事件 | 對應本條款段 |
|---|---|---|---|
| **#34** | 2026-04-30 LIVE | user 公司專案接入時抓到「個體學習迴圈紀律完全缺失」、明示「**框架必備**」、不走累積門檻直接條款化 | §0.3 觸發背景 + §1 條文 + §2 / §3 / §4 全段 |

未來再撞到同類觀察時：

- 若 doctor §3.11 已實作 → 應被自動偵測
- 若仍漏 → 依 `escalation-protocol` 累積到 NEXT.md，evaluate 是否升級條款（如 step 0 強制讀層級加更多檔、或 capsule review 從建議升強制）

---

## 8. 變更歷史

### v0.1（自 v0.9.0 引入）

初版。對應 dogfood signal #34（2026-04-30 LIVE 公司專案接入抓到、user 明示「框架必備」、不走累積門檻直接條款化）。**架構級概念第 13 個** — 接班場景四軸補完（軸 4：個體 AI 跨任務 / 跨 session 學習迴圈）。

**設計學意義**：charter v0.7.3 北極星「不讓 user 記」對 AI 角度補完 — 既有對採用方角度落地（walkthrough + verify 工具 + spec-as-data）、本條款補完 AI 角度（個體學習迴圈 + step 0 強制讀 + 雙寫紀律）。配合 v0.9.0 同 release 的 ② diagnose-remediate-protocol（紀律執行循環依賴解）+ ③ adoption-lifecycle（lifecycle 完整化）+ ④ condition-mutability（紀律本體），charter 完成「**紀律完整性 + AI 自我覺察升維**」轉折。
