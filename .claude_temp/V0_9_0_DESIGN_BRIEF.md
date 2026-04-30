# v0.9.0 Design Brief — multi-agent 並行 ship 對齊文件

> **建立**：2026-04-30 LIVE（post-v0.8.2 ship 同 day）
> **位階**：給 3 個 sub-agent（A condition 概念層 / B 實作層 / C 採用方層）共讀的對齊文件、確保 fresh-head 設計時 vision 一致、降低跨 agent 整合衝突
> **主 release**：v0.9.0 MINOR — **紀律完整性 + AI 自我覺察升維**
> **生命週期**：3 agent ship 完、maintainer 綜合後、本檔重點併進 CHANGELOG v0.9.0 段 + 歸檔

---

## §1 v0.9.0 主軸（為何這個 release 重要）

charter v0.7.x 累積「**紀律密度導向**」（21 條 condition + 12 個架構級概念）；v0.8.x 加「**設計層升維**」（spec-as-data + 雙軸矩陣）；v0.9.0 是**紀律完整性 + AI 自我覺察升維**的關鍵轉折：

| v0.x 階段 | charter 主軸 |
|---|---|
| v0.5-v0.7 | 條款體系建構（21 條 + 12 個架構級概念）|
| v0.8.x | 設計層升維（spec-as-data + 雙軸矩陣）|
| **v0.9.0**（本 release）| **紀律完整性 + AI 自我覺察升維**（個體學習迴圈 + 引導式紀律 + lifecycle 完整化 + mutability 紀律本體 + essential preset）|

**核心收斂**：v0.9.0 ship 完才真正完成 v0.7.3 北極星「不讓 user 記」對採用方 + AI 雙邊閉環 — charter 紀律完整性的最後一塊拼圖。

---

## §2 對齊紀律（all 3 agent 設計時必對照）

### 2.1 v0.7.3 北極星完整閉環

| 北極星紀律 | 對採用方角度（既有 ✅）| 對 AI 角度（v0.9.0 補完）|
|---|---|---|
| 不讓 user 記 | walkthrough + verify 工具 + spec-as-data | **個體學習迴圈**（① individual-learning-loop）|
| 回鍋無痛 | 跨多版本升版 walkthrough + 跨版本到最新 | **AI 跨 session 學習迴圈**（① 同上）|
| 解決重複溝通 | charter 引導採用方 | **個體 / 集體記憶雙寫紀律**（① 同上）|
| 培養魚塭 | 跨 vendor 純規範 framework | 不變（vendor-agnostic 維持）|

### 2.2 multi-perspective 第十四循環四方金礦落地

| 金礦 | v0.9.0 落地對應 |
|---|---|
| 結構師：雙軸正交矩陣 | ① individual-learning-loop = 「結構強制 × pre-init」格 / ② diagnose-remediate-protocol = 「結構強制 × runtime」格 |
| 理念守護者：「LLM 不可矯正」方向性誤讀指認 | ① 對齊「設計成集體記憶才重要」+「**但個體記憶仍要寫 + 強制讀**」 |
| 工程師：採用方層 vs 維護者層分離 | ③ adoption-lifecycle / uninstall 屬採用方層、② commit hook 候選屬 vendor 層 |
| 採用方：essential preset 真槓桿 | ⑤ essential preset 直接落地 |

### 2.3 dogfood signal 對應 v0.9.0 議程

| signal | 條款化對應 |
|---|---|
| #11 condition mutability 三層分類 | → ④ condition-mutability |
| #26 init token cost / ROI | → ⑤ essential preset |
| #27 spec-driven 循環依賴 reality check | → ② diagnose-remediate-protocol |
| #28 progressive adoption | → ⑤ essential preset |
| #30 LLM 砍 fork 內容 | → ② 候選加固 OR doctor §3.10 W902 順手 |
| #31 simulated slash command | → ② 真實 stdout 證據加固 |
| #32 LLM 不查 templates | → ① init-template §3.3.2 step 0 強制 read templates |
| #33 failure-mode 自報失效 | → ② commit hook 走 vendor 邀請制加固 |
| #34 個體學習迴圈紀律缺失（**user 明示「框架必備」**） | → ① individual-learning-loop（**v0.9.0 議程第一順位**） |

---

## §3 設計紀律（all 3 agent 必守）

| 紀律 | 對應 |
|---|---|
| **嚴守向下兼容**（v0.x 階段、可接受 BREAKING-LITE）| 21 條既有 condition 不增不減本體（除非新加 sub-section）|
| **純擴增 spec + 結構強制升維** | 不破壞既有；新加紀律走「結構強制」（不再加新「單 actor 自律」紀律）|
| **v0.7.4 雙軌節奏** | v0.9.0 = MINOR（大方向新加條款）— 4 條新 condition + 1 範本 + 1 preset + 1 spec 新檔 |
| **純規範 framework**（v0.5.9 決策）| **不附 binary**；commit hook 候選走 vendor 邀請制（vendor.md 各自實作、charter 概念層只寫紀律）|
| **跨 vendor 中性** | 不寫死 Claude Code / Gemini CLI 任一 vendor；vendor 層擴展走 ai-vendor-onboarding §3 邀請制 |
| **對齊 charter 既有條款 frontmatter pattern**（v0.8.2 加雙軸 blockquote 段）| 4 條新 condition 開頭必含「保證強度 / 檢測時點 / since」三行 |

---

## §4 4 條新 condition 設計大綱（給 Agent A）

對每條 condition、Agent A 必含：
- frontmatter（依既有 21 條 condition pattern：狀態 / 位階 / 依存 / 雙軸 blockquote 三行）
- §0/§1「條文」或「概念定位」
- 中間若干 §「內容紀律」
- §「與其他條款的關係」（最後段、互引完整性必對齊）

### ① core/individual-learning-loop.md（**最深、最關鍵、user 明示框架必備、v0.9.0 議程第一順位**）

**核心問題**：

charter 既有設計把 `core/violation-reflection §2`「LLM 不可矯正、價值在集體記憶」實作為**集體記憶層**（`state/failure_mode_log.md` + `institutional-memory/`）— 但**個體記憶層 + 學習迴圈紀律缺失**：
- `templates/agent-commons/reflection.md.tpl` 不存在
- `core/init-template §3.3.2` 七步驟沒「step 0 讀過去違反紀錄」
- 寫入紀律沒明示「個人 vs 集體雙寫」
- 跨 session 學習迴圈完全沒條款

**第 4 軸結構性盲區**：charter v0.5.7 working-stack-discipline 補完接班場景三軸（handoff-chain / cross-ai-handoff / working-stack-discipline）— **個體 AI 跨任務 / 跨 session 學習迴圈**是第 4 軸、漏。

**對應 dogfood signal**：#34（user 2026-04-30 LIVE 公司專案接入抓到、user 明示「框架必備」、不走累積門檻直接條款化、同 v0.5.8 / v0.7.1 / v0.7.4 user 直接條款化 pattern）。

**設計方向**：

1. **寫入紀律**：命中 F-mode 後、補 violation-reflection **雙寫**：
   - 集體層 `state/failure_mode_log.md`（既有）
   - **個體層 `roles/<role>/reflections/<YYYY-MM-DD>_<f-mode>_<short>.md`**（新加）
   - 雙寫紀律強制（不可只寫集體 / 不可只寫個體）

2. **讀取紀律**：擴 `core/init-template §3.3.2` 七步驟 → **八步驟**：
   - 加 **step 0「讀過去違反紀錄」** — 每次 self-instantiation 必先 read 自己 reflections/ + failure_mode_log + IM
   - 跨 session 接班 AI 同樣強制（依 cross-ai-handoff）

3. **跨 session 學習迴圈**：
   - 每次接班讀過去 reflections
   - 每次任務開始前 review 過去違反
   - 違規不再復發紀律

**架構級概念位階**：第 13 個（接班場景四軸補完、第 4 軸）

**必含 sub-section**：
- §0/§1 概念位階（為何引入、第 4 軸位階）
- §2 寫紀律（雙寫個體 + 集體）
- §3 讀紀律（init step 0 強制讀）
- §4 跨 session 學習迴圈（接班 AI 紀律繼承）
- §5 與其他條款的關係（必引：violation-reflection / failure-modes / handoff-chain / cross-ai-handoff / init-template / multi-role-tracking）
- §6 校驗（doctor §3.11 對齊：reflections/ 累積 + 雙寫對應）

### ② core/diagnose-remediate-protocol.md（SSS S3 架構級條款化、v0.8.x 漸進落地的終局）

**核心問題**：

charter spec-driven 紀律執行**循環依賴 LLM 自律**（multi-perspective 結構師金礦指認、user LIVE 公司專案實證）：
- doctor / init / verify 全是 AI 自跑
- AI 自由解讀 ERROR code → 可 simulated 修補（signal #31）
- AI 不查 templates → 自編格式（signal #32）
- AI 不主動補交 violation-reflection（signal #33）

charter v0.8.1 ship spec-as-data 起手實證（doctor §3.7-§3.9 四欄擴展）— v0.9.0 條款化此精神、升維到完整實作。

**對應 dogfood signal**：#27（spec-driven 循環依賴 reality check）+ #33 + #31 + #32 + #30。

**設計方向**：

1. **spec-as-data 結構**（charter 對 spec 的設計紀律）：
   - 每個 error code / 校驗項加四欄結構：合規規定（charter ground truth、寫死）/ 修補方向 + 約束（必動 / 不可動 / 不可代決 / 推薦路徑）/ 反例段（charter 已駁回的 anti-pattern + 對應正解）/ 真實 stdout 證據要求（每 PASS 必附 binary stdout、不能純文字）
   - 現實落地：v0.8.1 doctor §3.7-§3.9 已起手、v0.9.0 propagate 全 spec
   - 現實落地：post-upgrade-verify-spec / init-spec 全 propagate

2. **commit hook 走 vendor 邀請制**（signal #33 加固、結構強制升維）：
   - charter 概念層：寫紀律「commit 時若 AI 標 F-mode 命中、failure_mode_log 必有對應 entry 否則退稿」
   - vendor 層：claude-code.md / gemini-cli.md / cursor.md 各自實作 commit hook
   - 對齊 ai-vendor-onboarding §3 邀請制（charter 不寫死 vendor）

3. **真實 stdout 證據要求**（signal #31 加固）：
   - verify report 每 ID PASS 必附該 ID 對應的 binary stdout
   - 純文字 PASS 視同 violation-reflection §1 假宣告
   - 對齊 structural-anti-fabrication 既有精神、延伸到 verify 工具層

**架構級概念位階**：對齊 v0.8.1 SSS S3 起手實證、v0.9.0 架構級條款化（不新加架構級概念、屬「設計層引導式紀律」）

**必含 sub-section**：
- §0/§1 概念位階（spec-driven vs LLM 自律循環依賴解）
- §2 spec-as-data 結構（四欄 + 真實 stdout 證據）
- §3 弱保證項清單派生（從雙軸標籤派生、可手寫 OR 由 lint binary 派生）
- §4 vendor 邀請制 commit hook 加固
- §5 與其他條款的關係（必引：violation-reflection / failure-modes / structural-anti-fabrication / ai-vendor-onboarding / 整套 tools/*-spec.md）

### ③ core/adoption-lifecycle.md（含 SSS S2 設計素材、5 階段 lifecycle）

**核心問題**：

charter 升版場景 5 個 walkthrough 收齊（QUICKSTART 全新 + yc-v0.5.9-to-v0.7.4 跨多 MINOR + v0.7.5-to-v0.8.0 含 BREAKING-LITE + v0.8.0-to-v0.8.1 純擴增 + 新校驗 + v0.8.1-to-v0.8.2 純文檔擴增）— 但**棄用 / 重新採用場景無條款**、且 vendor 升級 path 三路徑無條款化。

**對應**：SSS S2 設計素材已備（user LIVE 提案 2026-04-29、含 /charter-uninstall 流程 + vendor 升級 path 三路徑 A/B/C + 互學深化）。

**設計方向**：

1. **5 階段 adoption lifecycle**：
   - 全新接入（既有：QUICKSTART）
   - 升版（既有：4 個升版 walkthrough）
   - **棄用**（新加：/charter-uninstall 工具設計、含「保留最後的溫柔」精神 — 棄用是有尊嚴的離別不是 lock-in）
   - **重新採用**（新加：停用一段時間後重採用、含 archive 報告恢復路徑）
   - **vendor 升級 path 三路徑**（A 維持現狀 / B 開 issue 給 charter / C AI 自驅修復對齊新 vendor schema、SSS S1 子集）

2. **對應 ⑥ tools/uninstall-spec.md**（Agent B 寫 spec、本條款引用）

3. **對齊既有 walkthrough**：5 個既有 walkthrough 屬 lifecycle 階段「升版」+「全新接入」、本條款 link 過去

**架構級概念位階**：lifecycle 完整化（不新加架構級概念、屬「升版場景補完」+「棄用 / 重新採用條款化」）

**必含 sub-section**：
- §0/§1 概念位階（5 階段定義）
- §2 各階段紀律
- §3 vendor 升級 path 三路徑（含對齊 SSS S1 user 授權閘）
- §4 與既有 walkthrough 對齊（5 個既有 → lifecycle 階段映射）
- §5 與其他條款的關係（必引：versioning-migration / ai-vendor-onboarding / handoff-chain / cross-ai-handoff）
- §6 對應 /charter-uninstall 工具引用

### ④ core/condition-mutability.md（signal #11、紀律本體）

**核心問題**：

charter v0.7.1 frontmatter scaffold（mutability_default）已 ship — 但**紀律本體未條款化**：
- 三層 mutability（IMMUTABLE-by-AI / APPEND-ONLY / FULL-MUTABLE）含義
- 3-strike 刪除協議（哪些條件下可刪某條 condition）
- user-initiated consolidation（多條條款合併紀律）
- AI 對 condition 的修訂權限分層

**對應 dogfood signal**：#11（v0.7.1 user 直接提議、v0.9.0 紀律本體）。

**設計方向**：

1. **3 層 mutability 定義**：
   - IMMUTABLE-by-AI：AI 不可改、user 親決
   - APPEND-ONLY：AI 可加新項、不可刪 / 改既有
   - FULL-MUTABLE：AI 可改 / 刪 / 加（極少）

2. **3-strike 刪除協議**：
   - 連續 3 次 audit 命中該條款違反 → user 評估是否刪除
   - 對齊 escalation-protocol 升級三段式

3. **user-initiated consolidation**：
   - 多條條款重疊 → user 主動提議合併
   - AI 不可代決 consolidation

4. **AI 修訂權限分層**：
   - 對齊三層 mutability、AI 在不同層有不同修訂權

**架構級概念位階**：對齊 domain-axiom-slot 的 mutability 紀律本體（v0.7.1 frontmatter scaffold 條款化）

**必含 sub-section**：
- §0/§1 三層 mutability 定義
- §2 3-strike 刪除協議
- §3 user-initiated consolidation
- §4 AI 修訂權限分層
- §5 與其他條款的關係（必引：domain-axiom-slot / role-conflict-resolution / escalation-protocol / multi-role-tracking）

---

## §5 實作層設計（給 Agent B）

### 5.1 templates/agent-commons/reflection.md.tpl（新檔、對應 ① individual-learning-loop）

對齊既有 6 份 templates pattern（capsule / handoff / institutional-memory-entry / nextwork / domain-axioms / _role）：

```markdown
# 違規反省：<TASK_ID> / <F-MODE>_<SHORT_DESC>

> **建立日期**：<YYYY-MM-DD>
> **角色**：<role>（<vendor>）
> **位階**：個體層學習迴圈 entry（依 individual-learning-loop §2 雙寫紀律）
> **依據**：<觸發來源 — F-mode 命中 / audit 退稿 / user 抓到>

---

frontmatter（YAML）：
---
date: <YYYY-MM-DD>
role: <role>
vendor: <vendor>
status: 強化抽驗 / user 裁決待議 / 結案
violations: <F-mode 編號逐個列>
---

## 1. 命中模式（按 charter F-mode 分類）
[逐個列 F-mode 命中事件、含 evidence + 對應條款引用]

## 2. 學習要點（next-time 紀律）
[每條鐵律、未來如何避免、引用 charter 條款]

## 3. 對應條款引用
[完整列引用 core/*.md / tools/*-spec.md / templates/*]

---

## 模板使用指南

實例化此模板時替換以下變數：
| 變數 | 範例 |
|---|---|
| `<TASK_ID>` | TASK_S70 / TICKET_123 / INC-2026-001 |
| `<F-MODE>` | F1 / F3 / F6 / role-separation §3.5 等 |
| `<SHORT_DESC>` | 短描述 |
| `<role>` | engineer / pm / reviewer 等 |
| `<vendor>` | claude-code / gemini-cli / cursor 等 |
```

### 5.2 core/init-template.md §3.3.2 七步驟 → 八步驟

加 **step 0「讀過去違反紀錄」** 在現有 step 1 之前：

```
step 0：讀過去違反紀錄（v0.9.0 加、對齊 individual-learning-loop §3 讀紀律）
- ReadFile agent-commons/roles/<role>/reflections/*.md（個體層、最近 5 個）
- ReadFile agent-commons/state/failure_mode_log.md（集體層）
- ReadFile agent-commons/institutional-memory/*.md（IM 層、相關事件）
- 不通則 self-instantiation 視為失敗、step 0 必過才能進 step 1

[既有 step 1-7]
```

### 5.3 tools/doctor-spec.md §3.11 個體學習迴圈合規（新段、對應 ①）

對齊既有 §3.7-§3.9 四欄 spec-as-data 結構：

```
### 3.11 個體學習迴圈合規（v0.9.0 加；individual-learning-loop §6 對齊）

校驗集（v0.9.0 必跑）：

1. 對 roles/<role>/_role.md 內 status 為 ACTIVE 的角色：
   reflections/ 目錄存在 + 至少一個 reflection 檔（accumulating audit trail）
   缺 → W1101

2. failure_mode_log 內 F-mode 命中 entry 是否有對應 reflection 個體層 entry（雙寫對應）：
   逐 F-mode entry 比對 reflections/<date>_<f-mode>_*.md 存在
   不對應 → W1102

3. reflection 檔 frontmatter 完整（date / role / vendor / status / violations）
   缺欄位 → E1103

| 失敗 | 狀態碼 | 處置 |
|---|---|---|
| reflections/ 目錄缺 | W1101 | 警告：補建 + 寫第一個 reflection |
| F-mode 命中無對應 reflection | W1102 | 警告：補寫 reflection 個體層 entry |
| reflection frontmatter 不完整 | E1103 | 致命：補完 frontmatter 必填欄位 |

[每個 W/E 加四欄詳盡引導：合規規定 / 修補方向 + 約束 / 反例]
```

### 5.4 tools/post-upgrade-verify-spec.md 模式 B/C 補完（v0.9.0 ship）

模式 A 既有 v0.8.0 ship。v0.9.0 補：

- **模式 B（升版 diff）**：跟 ~/.agentcharter 比 charter_version 對應 git log 跨 commit 變動、列出新加 condition / 新範本 / 新 spec
- **模式 C（pre-commit sync）**：commit message 標 charter_version 變動時、自動跑 verify

### 5.5 tools/profiles/essential.yaml（新檔、3-5 條 core、對應 ⑤）

對齊既有 minimal/standard/strict pattern：

```yaml
# AgentCharter Profile Preset — essential
#
# 適用：探索期專案 / 單人 / 快迭代 / 想要 AI 別瞎掰但不想要全套儀式成本
# 設計：只啟用最硬層 3-5 條核心防線、配置最寬鬆、token 成本 < 5k init
# 對應 dogfood signal #28 progressive adoption / #26 init token cost

charter_version: "0.9.0"
preset: essential

enabled:
  structural-anti-fabrication: true     # L3 硬層（必）
  audit-rights: true                    # L4 硬層（必）
  evidence-first: true                  # 隱性 bug 嚴禁盲猜
  failure-modes: true                   # F1-F6 偵測
  role-separation: true                 # 角色互鎖
  # 其他全停
  violation-reflection: false
  escalation-protocol: false
  output-mode-protocol: false
  completion-delivery: false
  handoff-chain: false
  cross-ai-handoff: false
  role-conflict-resolution: false
  multi-role-tracking: false
  domain-axiom-slot: false              # essential 不要求領域公理
  versioning-migration: false
  working-stack-discipline: false
  init-template: false
  ai-vendor-onboarding: false
  individual-learning-loop: false       # essential 不要求個體學習迴圈
  diagnose-remediate-protocol: false
  adoption-lifecycle: false
  condition-mutability: false
  maintainer-discipline: false

parameters:
  failure-modes:
    enable_modes: [F1, F2, F3, F6]      # 寬鬆
```

### 5.6 tools/profiles/{minimal,standard,strict}.yaml 升 v0.9.0 + enabled

- charter_version "0.8.2" → "0.9.0"
- standard/strict enabled 加：individual-learning-loop / diagnose-remediate-protocol / adoption-lifecycle / condition-mutability（4 條全 true）
- minimal 加：individual-learning-loop = true（對應 user 明示框架必備）/ 其他 3 條 false
- 條款計數標頭升 21 → 25

### 5.7 tools/uninstall-spec.md（新檔、/charter-uninstall、對應 ③）

對齊 SSS S2.1 設計素材：

```
# /charter-uninstall — 採用方棄用工具設計

> **狀態**：v0.9.0
> **位階**：tools / 設計文檔。對應 core/adoption-lifecycle.md「棄用」階段執行載體。
> **核心精神**：「保留最後的溫柔」— 對齊「培養魚塭、不討魚」、棄用是有尊嚴的離別不是 lock-in

---

## 1. Phase 1：三次確認
- Q1: 確定要棄用 charter？
- Q2: 已備份 agent-commons/ 重要資產？
- Q3: 確認執行不可逆操作？

## 2. Phase 2：保留最後的溫柔 — export adoption archive
寫入 <project>/charter-archive/CHARTER_ADOPTION_REPORT_<date>.md：
- 接入摘要 / capsules 統計 / HANDOFF 鏈時間線 / IM entries / protocols snapshot
- failure_mode_log 統計（F1-F6 各觸發次數）
- dogfood signal 觸發紀錄
- 結語「感謝採用 AgentCharter v<X>、你的紀律遺產保留於本檔」

## 3. Phase 3：level 選擇（預設 Soft）
- Soft：移除 vendor slash command + agent-commons/_role.md 加 status: ARCHIVED
- Full：Soft + 砍 _config（保留 protocols/）+ 1 次確認
- Nuclear：Full + 砍整個 agent-commons/（archive 先寫完）+ 2 次確認

## 4. Phase 4：charter clone 處理
檢查 ~/.agentcharter 有無其他 active 專案在用、詢問 user 是否刪

## 5. Phase 5：結束 + 輸出 archive 報告位置
```

---

## §6 採用方層設計（給 Agent C）

### 6.1 examples/upgrades/v0.8.2-to-v0.9.0.md walkthrough（第 6 升版場景）

對齊既有 5 個 walkthrough pattern（v0.7.5-to-v0.8.0 / yc-v0.5.9-to-v0.7.4 / v0.8.0-to-v0.8.1 / v0.8.1-to-v0.8.2）：

```
# 升版實證 walkthrough：v0.8.2 → v0.9.0

§0 為什麼這個 walkthrough 重要
   - charter walkthrough 系列第 6 個場景：MINOR 含新加 condition + new template + 新 preset
   - 對齊 v0.7.4 雙軌節奏「大方向新加條款用 MINOR」精神、v0.9.0 大 release

§1 升版前 baseline（v0.8.2）
   - profile.yaml charter_version: "0.8.2"
   - 21 條 condition / 12 個架構級概念

§2 演化軸（v0.9.0 改變）
   - 4 條新 condition（individual-learning-loop / diagnose-remediate-protocol / adoption-lifecycle / condition-mutability）
   - 1 新範本（reflection.md.tpl）
   - 1 新 preset（essential.yaml）
   - 1 新 spec（uninstall-spec.md）
   - init-template 七步驟 → 八步驟（加 step 0）
   - doctor §3.11 個體學習迴圈合規（W1101/W1102/E1103）
   - post-upgrade-verify 模式 B/C ship
   - 22 條條款啟用（standard/strict）+ 21 條 maintainer-only / 架構級前提排除

§3 升版步驟（每步給 AI 的 prompt）
   Step 1：拉 charter 最新版（git pull）
   Step 2：跑 doctor pre-check（看 v0.9.0 新校驗 W1101/W1102 是否觸發）
   Step 3：補建 reflections/ 目錄 + 第一個 reflection（如有 W1101 / W1102）
   Step 4：升 charter_version → "0.9.0"
   Step 5：自具象化 + 跑 /charter-upgrade-verify 5 軸全綠

§4 升版後 self-check
§5 跨版本場景（v0.8.0 / v0.7.5 / 更舊版本直跳 v0.9.0）
§6 設計學意義（北極星 + 四方金礦 + dogfood-driven hardening 第十七循環）
§7 變更歷史
```

### 6.2 採用方文檔升版

| 檔案 | 修訂 |
|---|---|
| `ADOPTION.md` | line 5 / 149 / 336 升 v0.9.0 + §3 條款表 21 → 25 條（加 D 組 cross-ai 加 individual-learning-loop / E 組 architecture 加 adoption-lifecycle / condition-mutability + diagnose-remediate-protocol 新組或 SSS S3 組）+ §13 加 v1.11 entry |
| `TUTORIAL.md` | line 6 升 v0.9.0 + 變更歷史加 v1.11 entry |
| `QUICKSTART.md` | 升 v0.9.0 + 變更歷史對齊 + Step X 加 essential preset 介紹 |
| `README.md` | §「核心通用條款」段加 4 條新 condition + §設計哲學第 6 條候選（個體學習迴圈精神顯化 — 對齊 user「不讓 AI 自己也記不住自己的錯」精神） |
| `.claude/commands/maintainer-load.md` | 升 v0.9.0 + 加 v0.9.0 release entry 子段（含 4 條新 condition + 第 13 個架構級概念 + dogfood signal 第十七循環收編） |

---

## §7 跨 agent 對齊 lockdown（最關鍵、整合衝突避免）

### 7.1 數量對齊

| 項 | v0.8.2（before）| v0.9.0（after）|
|---|---|---|
| **core/*.md condition 總數** | 21 | **25** |
| **maintainer-only** | 1（maintainer-discipline）| 1 |
| **架構級前提**（不設 enabled）| 2（common-memory-root / charter-config）| 2 |
| **採用方相關 max enabled**（standard/strict）| 18 | **22** |
| **架構級概念** | 12 | **13**（individual-learning-loop 為第 13 個）|
| **charter_version** | 0.8.2 | **0.9.0** |
| **架構級新加 condition** | — | individual-learning-loop（第 13 個）|

### 7.2 命名規範一致

- 全部小寫 + dash：`individual-learning-loop` / `diagnose-remediate-protocol` / `adoption-lifecycle` / `condition-mutability`
- frontmatter 格式（依 v0.8.2 加雙軸 blockquote）：

```markdown
> **狀態**：v0.1（自 v0.9.0 引入）
> **位階**：core 通用條款。
> **依存**：<必引條款>
> **保證強度**：<X>
> **檢測時點**：<Y>
> **since**：v0.9.0
```

### 7.3 互引格式統一

- `core/<name>.md §X` 格式
- 雙向引用對齊：每條新 condition 引到的既有條款、既有條款 §「與其他條款的關係」段也要對應補回引用（v0.8.x PATCH 順手 OR maintainer 整合修）

### 7.4 dogfood-driven hardening 第十七循環（slim v0.9.0 設計層轉折）

| v0.x 階段 | 主軸 |
|---|---|
| 第 1-10 循環（v0.5-v0.7）| 條款體系建構 |
| 第 11-13 循環（v0.8.0-v0.8.2）| 設計層升維（spec-as-data + 雙軸矩陣）|
| 第 14 循環（multi-perspective）| sub-agent 反向校準（new dogfood 類型）|
| 第 15-16 循環（v0.8.1-v0.8.2）| 雙軌節奏連續 ship |
| **第 17 循環（v0.9.0）**| **紀律完整性 + AI 自我覺察升維**（charter 完成 v0.7.3 北極星閉環）|

---

## §8 整合 checkpoint（maintainer 介入點）

各 agent 完成後、user 把 3 個 agent 的產出貼回給 maintainer（或 maintainer 直接 ReadFile）。maintainer：

1. **review 3 個 agent 產出**（一致性 / 互引完整性 / 條款數對齊 §7）
2. **修整合衝突**（如條款編號 / 互引 / preset enabled 對齊）
3. **ship release-level 文件**：
   - `CHANGELOG.md v0.9.0` 段（最大段、~150 行）
   - `.claude_temp/STATUS.md` Version 軌跡 + frontmatter + 架構級概念 12 → 13 + Git tags
   - `.claude_temp/NEXT.md` 已完成 v0.9.0 段 + 待議移除 mark ✅（#11/#26/#27/#28/#30/#31/#32/#33/#34）
4. **commit + push v0.9.0**
5. **歸檔本 brief**（重點併進 CHANGELOG v0.9.0 段）

---

## §9 紀律提示（all 3 agent 必守）

1. **fresh-head 設計**：你 context 是 clean、可以深思設計品質、不要趕；但同時也要在 ~3-4 hr 內完成 deliverable
2. **嚴守 §7 lockdown**：條款數 / 架構級概念 / charter_version / 命名 / 互引格式 — 任何不對齊整合時都會出衝突
3. **不要 freelance 編造 charter 沒有的條款**（對應 `core/structural-anti-fabrication.md`）
4. **遇到 v0.x 既有條款互引時、必 ReadFile 既有條款本體確認**（不可 guess、對應 dogfood signal #32 教訓「LLM 不查 charter 既有資源」）
5. **遇到設計選擇有歧義時、優先對齊 charter 既有 pattern**（看 21 條既有 condition 怎麼寫、跟著做）
6. **deliverable 完成後、列「對齊 §7 lockdown 自檢清單」**：
   - 我寫的 condition 數 + 既有條款數 = 25 ✅
   - 命名 dash-case ✅
   - 互引格式統一 ✅
   - 雙軸 blockquote 三行 ✅
   - 對齊 v0.8.2 既有 21 條 condition 風格 ✅
