# AgentCharter

> **多 AI 協作的角色協議框架** — 把「PM」「Engineer」「Reviewer」這些職能抽象出來，讓任何 AI（Claude / Gemini / Cursor / 你下個用的 LLM）都可以在任意專案上各司其職並互相抽驗。

---

## 設計哲學（北極星）

> **框架的價值來自於服務、不是規範本身。**

charter 的存在感應該被淡化、採用方應該感受到「**事情變順了**」而非「我又要記住一條紀律」。

### 兩種「無痛」

| 無痛類型 | 含義 |
|---|---|
| **回鍋開發者無痛**（lifecycle）| 不管採用方遇到什麼狀態 — 全新接入 / 升版 / 棄用 / 停用一段時間後重新採用 — charter 都隨時支援、無摩擦銜接 |
| **小白無痛**（onboarding）| 由淺入深、越用越愛；最基本的紀律 charter 守住、但**啟用方式要極度簡易**；採用方**不該記 prompt** — charter 主動引導、user 最少做 1 個動作 |

### 三條服務原則

1. **解決重複溝通**：跨 AI 接班 / 跨 session 重啟 / 跨角色交付 / 採用方對 AI 反覆糾正 — 這些重複溝通的成本，charter 透過條款 + 模板 + 紀律統一處理
2. **由 charter 引導採用方**：不是 user 找 prompt 模板貼給 AI、而是 user 把入口檔給 AI、AI 主動引導 user
3. **培養魚塭、不討魚**：拒絕為了眼前舒服（quick fix）犧牲未來舒適（系統性無痛）；每個 release 都對齊「**是不是讓未來採用方更舒適**」而非「**現在這個採用方夠用就好**」

### 對未來修訂的紀律

每次條款 / spec / templates 修訂時，maintainer 必對照三題：

- 這個修訂讓**回鍋開發者**體驗加分還是減分？
- 這個修訂讓**小白接入**門檻降低還是升高？
- 這個修訂解決**新的重複溝通**、還是新增了採用方要記的東西？

任一答「減分 / 升高 / 新增負擔」 → 修訂須降級 / 改寫 / 重新設計。

---

## 為什麼存在

當你的工作流不只一個 AI（例如 Gemini 當 PM、Claude 當 Engineer），你會撞到三個問題：

1. **角色綁死特定 AI**：「我們的 PM 規則」其實只有 Gemini 跑得對
2. **協議綁死特定專案**：搬到新專案要重新發明所有紀律
3. **AI 能力差異無顯式描述**：Claude 有 hook、Gemini 沒 hook，協議在後者上會失效

AgentCharter 把這三軸正交化：

```
Charter (this repo)         ← 跨 AI、跨專案、跨角色的最大公約數
   │
   ├── core/                ← 通用條款（職責、抽驗、失敗模式、交付契約…）
   ├── roles/<role>/        ← 各角色職能定義 + 各 AI 的實作版
   ├── examples/<project>/  ← 真實專案的對照表（IRON ↔ Charter）
   └── templates/           ← 生成 /<role>-init 等的模板
```

---

## 三條設計公理

| 公理 | 含義 |
|---|---|
| **A1. 角色 ⊥ AI** | 「PM」是抽象職能，可由任何 AI 扮演；切換扮演者不該改變協議 |
| **A2. AI ⊥ 角色** | 同一個 AI 可在不同專案扮演不同角色；身份無黏著 |
| **A3. 專案 ⊥ 框架** | 框架不知道「金融 / 醫療 / SaaS」差異；領域特定條款（如 IRON 風控）放專案內，框架只提供「**領域安全公理槽位**」（Domain Safety Axiom Slots）|

### A4 架構級約定（v0.4.1 加入）

| 約定 | 含義 |
|---|---|
| **共同記憶根目錄** | 多 AI 共享資產必須位於**單一根**之下，預設叫 `agent-commons/`。看到此目錄 ＝ 此專案採用 AgentCharter。詳見 `core/common-memory-root.md` |

---

## 核心通用條款（`core/`）

| 檔案 | 一句話描述 |
|---|---|
| `role-separation.md` | 角色互鎖原則 — 寫程式碼權與結案宣告權對稱分離 |
| `audit-rights.md` | 抽驗權 — 結案宣告默認待抽驗，工程師抽驗權不得放棄 |
| `failure-modes.md` | F1〜F6 失敗模式分類（假宣告 / 假 hash / 捏造數據 / 編號偏差 / 規則記憶失效 / **F6 未驗證即宣告就緒**含 surface-level vs structural-level sub-pattern v0.7.0）|
| `escalation-protocol.md` | 連續失敗 → 強化抽驗 → 結構性失靈 → 使用者裁決 |
| `role-conflict-resolution.md` | 角色決策分歧裁決協議（區隔 escalation：分歧無對錯，雙向 L0/L1/L2 階梯）|
| `multi-role-tracking.md` | 1 AI 兼 ≥ 2 角色的審計規範（離岸/上岸宣告、身份戳、自抽自驗禁令）|
| `domain-axiom-slot.md` | 領域公理槽位的位階 / 撰寫紀律 / 違反處置（與 core 衝突時領域公理優先）|
| `versioning-migration.md` | SemVer 對 charter 的具體含義 + 升級遷移流程 + 多 AI 版本一致性 |
| `evidence-first.md` | 隱性 Bug 嚴禁盲猜；參數嚴禁假設值 |
| `structural-anti-fabrication.md` | 事實宣告必含 stdout 區塊；不靠 AI 自我誠實，靠文檔結構強制 |
| `violation-reflection.md` | 違規退稿後須補交反省；反省價值在「未來 AI / 集體記憶」而非矯正當前 AI |
| `charter-config.md` | mapping.yaml + profile.yaml schema；可插拔啟用條款，不需重組目錄 |
| `common-memory-root.md` | **架構級約定** — 多 AI 共享資產必須位於單一根（預設 `agent-commons/`）；採用識別 |
| `output-mode-protocol.md` | eco / verbose 雙段式輸出 + 自動升級條件 |
| `completion-delivery.md` | 工程師完工須附「PM 驗收測試計畫」（Directive Header / 雙保險 / 危險度標籤 / 期望錨點 / 失敗解讀表）|
| `handoff-chain.md` | Session 交接鏈與必含項目 |
| `cross-ai-handoff.md` | 跨 AI 廠商接班：退出方轉移職責 + 接班方接收職責 + 強化抽驗狀態傳遞 |
| `working-stack-discipline.md` | DRAFT 暫存堆疊 + save 同步 git commit + session 內物理中斷再續（同身份接班）|
| `maintainer-discipline.md` | **framework 維護者紀律**（位階特殊：對採用方無關，三 preset 預設關）— spec sync check + DRAFT 紀律對 maintainer 也適用 |
| `init-template.md` | Role Init Mandate — 四大職責 + 多 AI 具象化 + AI 自我具象化機制（v0.5.10：七步驟含 step 5 schema 驗證強制點 / **v0.7.0：step 6 簽名 Status 必為 PROVISIONAL/ACTIVE 二態 + slash command 引用紀律禁絕對路徑**）|
| `ai-vendor-onboarding.md` | **新 vendor / 新角色接入「邀請制」四步驟**（v0.6.0）— 禁 charter 預先寫死 vendor 層；charter 寫概念層 → 邀請 vendor 寫 vendor 層 → 既有 vendor 校正 regression → maintainer 簽收 |

---

## 角色目錄（`roles/`）

每個角色含：
- `_spec.md` — 該角色「做什麼 / 不做什麼 / 與其他角色的邊界」
- `<ai-vendor>.md` — 該 AI 在扮演此角色時的執行細節（如 Claude 用 hook，Gemini 用主動讀檔）

當前提供：

**採用方角色**（採用方視具體場景啟用）：

- `roles/engineer/_spec.md` + `roles/engineer/claude-code.md` — Engineer 概念層 + Claude Code 工程師實作（v0.1 reference impl）
- `roles/pm/_spec.md` + `roles/pm/gemini-cli.md` — PM 概念層（v0.6.0 加 §3.3/§3.4 漸進 deprecate 抽驗）+ Gemini CLI PM 實作（v1.1，含 §3.5 sub-agent 跨界禁令）
- `roles/validator/_spec.md` — 抽驗權專職載體；漸進接管 PM 抽驗職責（v0.6.0 概念層 / **v0.7.0 §3.6 擴 init 階段抽驗 — 採用方半邊 Phase 5b 載體**）；vendor 層待邀請制流程

**Maintainer-only 角色**（採用方無關，charter repo 自身維護用）：

- `roles/auditor/_spec.md` — charter repo 自身一致性抽驗；對應 `maintainer-discipline §3.1` 執行載體（v0.6.0 概念層 / **v0.7.0 §8 加與 validator 對稱性反向引用**）；vendor 層待邀請制流程

---

## 對任意專案的接入流程

5 步流程：

```bash
# Step 1: clone charter
git clone https://github.com/moerasermax/AgentCharter ~/.agentcharter
cd ~/projects/<your-project>
```

```
# Step 2: 編 agent-commons/protocols/<YOUR_AXIOM>.md（先寫好鐵律；
#         init Phase 5b 會驗 axiom 物理存在）

# Step 3: prompt AI 跑接入（AI 完成 + 自具象化 /charter-init）
我採用了 AgentCharter，charter 在 ~/.agentcharter/。
請依 ~/.agentcharter/tools/init-spec.md 跑接入流程：
- preset: standard
- domain-axioms-path: protocols/<YOUR_AXIOM>.md
- domain-axioms-alias: <SHORT_NAME>
完成後請順便具象化為 /charter-init slash command（依 init-template §3.3）。

# Step 4: prompt 雙 AI 自我具象化角色 init（依 init-template §3.3）

# Step 5: prompt AI 跑 doctor 驗證
請依 ~/.agentcharter/tools/doctor-spec.md 跑健康檢查。
```

> v0.5.9 起 framework **不附 python / npm 等實作工具**（純規範框架）。所有工具動作由 AI 依對應 spec 自具象化（對齊 A1「角色 ⊥ AI」+「framework 不代生成」原則）。

詳細指引見 [QUICKSTART.md](./QUICKSTART.md)（5 分鐘小白入門）+ [TUTORIAL.md](./TUTORIAL.md)（reference 工具書）。

---

## 起源（v0.1）

本框架由 **CryptoBot 專案**的 S70 Dashboard PnL 誤判事件後沉澱啟動 — 該事件中 PM 連續 ≥7 次假宣告觸發強化抽驗 → 結構性失靈 → 使用者裁決。事件結束後，使用者要求把工程師（Claude）的協作守則抽象成跨 AI 框架。

詳見 `examples/cryptobot/mapping.md`。

---

## 治理 / 貢獻 / 變更

- `GOVERNANCE.md` — 誰可 merge、衝突如何處理、版本權威
- `CONTRIBUTING.md` — 如何提交新角色 / 新失敗模式 / 新 AI 實作版
- `CHANGELOG.md` — 版本紀錄

---

## License

私有專案；公開化決定保留至 v1.0。

---

## 採用文件（依受眾分）

| 檔案 | 受眾 | 用途 | 何時讀 |
|---|---|---|---|
| **本檔（`README.md`）** | 任何人 | 介紹 charter 是什麼 + 三公理 + 條款列表 | 第一次接觸 |
| **[`QUICKSTART.md`](./QUICKSTART.md)** | 人類採用方（**小白**） | 5 分鐘讀完，30 分鐘跑通第一個任務 | **接入時** |
| **[`TUTORIAL.md`](./TUTORIAL.md)** | 人類採用方（深入） | reference 工具書（章節獨立，可跳讀；含 troubleshooting） | 卡關 / 想深入 |
| [`ADOPTION.md`](./ADOPTION.md) | 該團隊的 AI | AI 自含 context 採用指南（密集格式） | AI 接班時 |
