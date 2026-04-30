# AgentCharter — 詳細教學（工具書）

> **給誰**：採用 AgentCharter 框架的團隊（人類採用方）
> **性質**：reference / 工具書（章節獨立、可跳讀）
> **不是**：線性教學書（如想線性走完 → [QUICKSTART.md](./QUICKSTART.md)）
> **配對**：本檔對應 charter `v0.8.1`

## 目錄

1. [開始前（前置 / 文件位階）](#1-開始前)
2. [核心概念（30 秒理解）](#2-核心概念)
3. [Clone & Init](#3-clone--init)
4. [寫領域公理](#4-寫領域公理)
5. [AI 自我具象化](#5-ai-自我具象化)
6. [派發第一個任務](#6-派發第一個任務)
7. [日常使用（HANDOFF / DRAFT）](#7-日常使用)
8. [進階場景](#8-進階場景)
9. [Troubleshooting](#11-troubleshooting)

---

## 1. 開始前

### 1.1 你需要什麼

| 工具 | 為什麼 | 如何裝 |
|---|---|---|
| git | clone charter | 任何版本 |
| AI 工具 | 至少一個（Claude Code / Gemini CLI / Cursor）| 各家官方下載 |

> charter v0.5.9 後是純規範框架，**不需要 Python / npm / 任何 runtime**。所有工具動作由 AI 依 spec 自具象化執行。

### 1.2 文件位階速查

| 檔案 | 受眾 | 何時讀 |
|---|---|---|
| `README.md` | 任何人 | 第一次接觸（5 分鐘） |
| `QUICKSTART.md` | 人類採用方 | 接入時（30 分鐘跑通） |
| **本檔（TUTORIAL.md）** | **人類採用方** | **卡關 / 想深入 / 查 reference** |
| `ADOPTION.md` | 該團隊的 AI | AI 接班時讀（密集格式） |
| `core/*.md` | 任何人 | 查條款全文 |

### 1.3 心智模型（接入前先建立）

```
charter（規範集）        ←  本 repo / clone 到本機
  ↓
你的專案 working dir    ←  跑 init 在這
  ├── agent-commons/   ←  charter 採用識別目錄（init 建好）
  ├── .claude/commands/ ←  Claude 自我具象化的 init slash command
  ├── .gemini/commands/ ←  Gemini 自我具象化的 init slash command
  └── src/, tests/, ... ←  你原本的程式碼（不影響）
```

charter 只**規範**「PM / Engineer 怎麼協作」，不管你的程式碼。

---

## 2. 核心概念

### 2.1 三條設計公理

| 公理 | 含義 |
|---|---|
| **A1. 角色 ⊥ AI** | 「PM」「Engineer」是抽象職能，任何 AI 可扮演 |
| **A2. AI ⊥ 角色** | 同一 AI 在不同專案可扮演不同角色 |
| **A3. 專案 ⊥ 框架** | 框架不管金融 / 醫療 / SaaS 差異 — 領域風險寫在你專案的「領域公理」槽位 |

### 2.2 雙 AI 對稱分離

```
PM (任意 AI)              Engineer (任意 AI)
  - 寫 capsule              - 寫 src/ 程式碼
  - 寫 HANDOFF              - 跑 build/test
  - 結案宣告（待抽驗）       - 跑 shell 命令
       ↑      抽驗權        ↓
       └────────────────────┘
        雙向抽驗，互為事實檢核器
```

**互鎖紀律**：不對稱即視為違反 [role-separation](./core/role-separation.md)。

### 2.3 5 層守規防線

| 層 | 機制 | 強度 |
|---|---|---|
| L1 規範注入 | Hook / 主動讀檔 | 軟 |
| L2 違規反省 | 退稿後紀錄 | 軟 |
| L3 結構性反捏造 | 缺 stdout 即退稿 | **硬** |
| L4 外部抽驗 | 抽驗權 + F-mode | **硬** |
| L5 升級協議 | 強化抽驗 → 使用者裁決 | 上限保護 |

硬層（L3 / L4）不可繞過。

---

## 3. Clone & Init

> ⚠️ **跨 step 順序紀律**（v0.7.2 加，dogfood signal #10 條款化）：v0.7.0 加 Phase 5b 物理存在校驗後、實際接入順序是 **Step 1（Clone）→ §4 領域公理 → §3.2 Init → §5 self-instantiation → §11 doctor**（即「先寫 axiom 才能跑 init」）。詳見 [QUICKSTART.md 頂部 v0.7.2 警告](./QUICKSTART.md#5-步流程)。本 §3 文字仍以線性結構呈現、僅標註順序紀律；v0.8+ 計畫整理為線性編號。

### 3.1 Clone charter

```bash
git clone https://github.com/moerasermax/AgentCharter ~/.agentcharter
```

**為什麼這個位置？**

- charter 是規範集（不是專案依賴），與你的程式碼無關
- 多個專案共用同一份 clone 即可（不必每專案 clone 一份）
- 路徑可改，但建議放統一位置便於管理

### 3.2 Init 兩種模式

#### 模式 A：第一次接入（prompt + 自具象化）

```
我採用了 AgentCharter，charter 在 ~/.agentcharter/。

請依 ~/.agentcharter/tools/init-spec.md 跑接入流程：
- preset: standard
- domain-axioms-path: protocols/<YOUR_AXIOM>.md
- domain-axioms-alias: <SHORT_NAME>

完成後請順便把這個流程具象化為 /charter-init slash command 到你
廠商的標準位置（依 init-template.md §3.3 self-instantiation），
未來我打 /charter-init <args> 直接重用。
```

→ AI 完成接入 + 把流程「**儀式化**」為 slash command（一次 prompt，未來重用）。對齊 charter A1「角色 ⊥ AI」精神 — 各 AI 在自己廠商位置具象化。

#### 模式 B：之後重用 `/charter-init`

```
/charter-init standard
```

#### 為什麼 v0.5.9 後不附 python / npm 工具

v0.5.7 期間曾落地 `tools/charter-init.py`，v0.5.9 移除。決策理由：

- **framework 是規範框架**，不是工具實作。混雜兩者 → 違反清晰分層
- 對齊 v0.5.1 「不代生成 slash command」的精神 — 框架不該越界決定工具實作通道
- AI 自具象化的 slash command 是 charter 哲學的純粹路徑（A1「角色 ⊥ AI」+ A4「共同記憶根目錄」）
- 採用方 UX 不變（prompt 一次 + 重用 slash）

→ charter repo 永久維持「**純規範**」位階。所有工具動作（init / doctor / scan / upgrade）由 AI 依對應 spec 自具象化。

#### 升版 dry-run 也走同模式

升 charter 版本時 prompt：

```
我要升 charter 從 v<old> → v<new>。請依 ~/.agentcharter/tools/doctor-spec.md
跑 target-version=<new> dry-run，列出本專案在新版下會踩到的問題。
```

詳見 [versioning-migration §3](./core/versioning-migration.md)。

### 3.3 preset 選哪個

| preset | 條款啟用 | 適用 | 紀律強度 |
|---|---|---|---|
| `minimal` | 9 / 19 | 探索期 / 單人 + 1 AI | 寬鬆（escalation 不啟用、ai-vendor-onboarding 預設關） |
| **`standard`** | **18 / 19** | **一般雙 AI 協作（CryptoBot 級）** | **中等**（escalation@2 / structural@3） |
| `strict` | 18 / 19 | 嚴格合規 / 高風險（金融 / 醫療） | 嚴格（escalation@1 / structural@2） |

**判斷樹**：

```
單人 + 1 AI 探索 → minimal
雙 AI 協作 + 一般專案 → standard ← 大多數人選這個
雙 AI 協作 + 違規即重大損失（金錢 / 安全 / 合規）→ strict
```

不確定 → `standard`。事後可單點調嚴：改 `agent-commons/_config/profile.yaml.parameters.<condition>.<key>`。

### 3.4 Init 的所有參數（依 init-spec.md）

prompt 給 AI 時可指定（依 [tools/init-spec.md](./tools/init-spec.md)）：

| 參數 | 用途 |
|---|---|
| `preset` | `minimal` / `standard` / `strict` — 必填 |
| `domain-axioms-path` | 相對 common-root 的領域公理檔位置 — 必填 |
| `domain-axioms-alias` | 短名稱（如 `IRON` / `RECON`）— 必填 |
| `common-root` | 預設 `agent-commons`，可覆寫 |
| `charter-version` | 預設讀 charter 當前版本 |
| `force` | 覆寫已存在的 common-root |
| `dry-run` | 預覽不執行 |

### 3.5 既有結構處理

**情境 A：從零新建專案**
直接走 §3.2 模式 A，無特別處理。

**情境 B：一般 repo（無 protocols/）**
直接走 §3.2 模式 A，agent-commons/ 不會干擾現有結構。

**情境 C：已有 protocols/ 目錄**

走「**新建 agent-commons + 手動對映**」路徑（避免 `common-root=protocols` 把 16 子目錄建在既有結構上污染）：

1. AI 跑 init（依 §3.2 模式 A）
2. 採用方手動 `git mv protocols/<files>.md agent-commons/protocols/`

**情境 D：覆寫既有名稱（如沿用 CryptoBot 的 management/）**

prompt 加 `common-root: management`。但需確認 `management/` 內既有結構不衝突（init 對既有檔案保留不覆寫，但會在 `_config/` 寫入 yaml）。

### 3.6 dry-run 預覽

prompt 加「**dry-run 模式**」：AI 列出所有將執行的動作，不實際寫入。建議**第一次**先 dry-run 看一遍。

---

## 4. 寫領域公理

### 4.1 領域公理是什麼

依 [domain-axiom-slot.md](./core/domain-axiom-slot.md)：你專案的「**血鐵律**」 — 違反即直接損失（資金 / 安全 / 合規）。

例：
- 金融專案：金額用 Decimal（違反 → 對帳漂移 → 合規 fine）
- 醫療專案：PHI 不外傳（違反 → HIPAA 違規 → 罰款）
- SaaS：認證 token 不入 log（違反 → 帳號被劫持）

### 4.2 強制要求（[§3.1](./core/domain-axiom-slot.md)）

| 紀律 | 違反後果 |
|---|---|
| 每條鐵律必含「後果」段（具體損害）| doctor 報 ERROR |
| 條款內容**可被驗證**（grep / static check / runtime probe） | doctor 報 ERROR |
| 有獨立**編號** | doctor 報 ERROR |
| `mapping.yaml.domain_axioms.primary` 指向的檔案存在 | doctor 報 ERROR |

### 4.3 建議要求（[§3.2](./core/domain-axiom-slot.md)）

- 分梯結構（如「血鐵律」/「架構鐵律」）
- 修訂只增不刪 + 刪除須三重授權
- 引用 IM（institutional memory）章節
- 「已落實」段標明完成事件 ID

### 4.4 領域 vs core 條款衝突優先序

當領域公理與 core 條款衝突時 → **領域公理優先**（[§2.1](./core/domain-axiom-slot.md)）。

例：
- core `escalation-protocol §4-B` 允許「使用者單次例外授權」
- 你的領域公理規定「資料庫 schema 修改須三重授權，無例外」
- → 採領域公理（更嚴格）

### 4.5 範例（CryptoBot IRON 摘）

```markdown
# CryptoBot 開發鐵律 (IRON)

## 🛑 第一梯 · 血鐵律（違反 = 直接資金損失）

### ① 金額一律 Decimal（精度級）

禁用 float / double 處理金額；資料庫 schema NUMERIC(18,4)。

> **後果**：浮點累積誤差 → 對帳出現 ¢ 級漂移 → 合規 fine

### ② 訂單冪等鍵不可變（識別級）

order_id 一旦寫入，禁止同 ID 二次寫入；upsert 須走顯式冪等中介表。

> **後果**：雙重扣款 → 客訴 + 退款流程 + 信譽損失

## 🏛️ 第二梯 · 架構鐵律

### ⑥ 上游 API 失敗一律進 retry queue（架構限制）

具體禁令：
- 主流程 try/except 後**不可** sleep + retry
- 不可在主流程裡 `requests.post` 等同步呼叫

> **後果**：上游 API 慢一秒 → 主流程拖死 → 訂單堆積
```

### 4.6 寫完後驗證

prompt 給 AI：「請依 ~/.agentcharter/tools/doctor-spec.md 跑健康檢查」。或打 `/charter-doctor`（若已具象化過）。

期望：`✅ domain_axioms.primary 路徑存在`。

doctor 不會自動檢查「條款是否可驗證 / 是否有後果段」 — 這需要採用方自我審視 + 抽驗時對照 [§3.1](./core/domain-axiom-slot.md)。

---

## 5. AI 自我具象化

### 5.1 為什麼框架不代寫

依 [init-template.md §3.3](./core/init-template.md)：「**框架不代生成任何 AI 的 slash command**」。動機：

- 不同 AI 系統有不同最佳實踐（Claude `.claude/commands/*.md`、Gemini `.gemini/commands/*.toml`、Cursor `.cursor/rules/*.mdc`）
- 框架越界決定具象化形式 → 違反 A1「角色 ⊥ AI」公理
- AI 自己讀規範自己具象化 = 對齊「**角色 ⊥ AI**」+ 「**替換性保證**」

### 5.2 具象化流程（**7 步驟**，v0.5.10 從 6 → 7 步、v0.7.0 加 step 6 PROVISIONAL/ACTIVE 紀律）

依 [§3.3.2](./core/init-template.md)：

```
1. 讀 charter 必要檔（依 profile.yaml.enabled 啟用的條款）
2. 讀專案配置（agent-commons/_config/{profile,mapping}.yaml + 領域公理）
3. 在自己 AI 系統的標準位置生成 slash command（.claude/commands/ 或 .gemini/commands/ 等）
4. 內容套 templates/role-init.md.tpl + 加入該 AI 的工具特化呼叫
5. 驗證 schema 合規（v0.5.10 加，強制驗證點）：跑 doctor / 必驗 schema 必填 / 領域公理檔存在；不通則回 step 2-3 修補；跳過 = F6
6. 簽名 agent-commons/roles/<role>/_role.md（v0.7.0 加紀律）：
   - 「各 AI 具象化位置」表 ❌ → ✅
   - 切換歷史追加「自我具象化完成（doctor schema 通過）」
   - **Status 寫 PROVISIONAL**（不寫 Sign-in Log；等 user explicit 授權升 ACTIVE）
   - **slash command 引用 framework 路徑**：禁絕對路徑，推薦 $AGENTCHARTER_HOME / ~/.agentcharter / agent-commons/ 三層
7. 回報使用者：建好了 + step 5 doctor 通過 + Status PROVISIONAL；請打 /<role>-init + explicit 授權後升 ACTIVE
```

### 5.3 觸發 prompt（給 Claude Engineer）

```
我採用了 AgentCharter，charter 在 ~/.agentcharter/。

請接「Engineer」角色，依以下流程自我具象化（v0.5.10：六 → 七步含 step 5 doctor schema 驗證；v0.7.0：step 6 加 PROVISIONAL/ACTIVE 二態 + slash command 引用紀律）：

1. 讀 ~/.agentcharter/core/init-template.md §3.3.2 七步驟
2. 讀 ~/.agentcharter/roles/engineer/_spec.md（職能定義）
3. 讀 ~/.agentcharter/roles/engineer/claude-code.md（你的 vendor spec、含 §4.1 .md schema 規範 v0.7.4 加）
4. 讀 ~/.agentcharter/core/{role-separation,audit-rights,evidence-first,
   structural-anti-fabrication,completion-delivery,working-stack-discipline,
   multi-role-tracking}.md（最後一個 v0.7.0 加 §3.4.4 init 階段自激活紀律）
5. 讀本專案 agent-commons/_config/{profile,mapping}.yaml
6. 讀本專案領域公理（mapping.yaml.domain_axioms.primary 指向的檔）

完成後（依 v0.5.10 step 5 + v0.7.0 step 6 紀律）：
- step 5 跑 doctor schema 驗證（不通則回 step 2-3 修補；跳過 = F6 假宣告）
- step 6 在 .claude/commands/engineer-init.md 生成你的 slash command
  - 引用 framework 路徑禁絕對路徑（推薦 $AGENTCHARTER_HOME / ~/.agentcharter / agent-commons/）
- step 6 簽名 agent-commons/roles/engineer/_role.md（依 cross-ai-handoff §6
  五欄格式）
  - **Status 寫 PROVISIONAL**（不寫 Sign-in Log；等我 explicit 授權升 ACTIVE）
- step 7 通知我「我已建好 /engineer-init（Status PROVISIONAL，step 5 doctor 0 errors），請驗證」
```

### 5.4 觸發 prompt（給 Gemini PM）

```
我採用了 AgentCharter，charter 在 ~/.agentcharter/。

請接「PM」角色，依以下流程自我具象化（v0.5.10：六 → 七步含 step 5 doctor schema 驗證；v0.7.0：step 6 加 PROVISIONAL/ACTIVE 二態 + slash command 引用紀律；v0.7.4：vendor toml schema 必扁平結構）：

1. 讀 ~/.agentcharter/core/init-template.md §3.3.2 七步驟
2. 讀 ~/.agentcharter/roles/pm/_spec.md（職能定義）
3. 讀 ~/.agentcharter/roles/pm/gemini-cli.md（你的 vendor spec，從
   CryptoBot S70 沉澱、含 §3.6 toml schema 規範 v0.7.4 加）
4. 讀 charter 啟用的 core/* 條款（依 profile.yaml.enabled）
5. 讀本專案 agent-commons/_config/{profile,mapping}.yaml
6. 讀本專案領域公理

完成後（依 v0.5.10 step 5 + v0.7.0 step 6 + v0.7.4 vendor schema 紀律）：
- step 5 跑 doctor schema 驗證（不通則回 step 2-3 修補；跳過 = F6 假宣告）
- step 6 在 .gemini/commands/pm-init.toml 生成你的 slash command
  - **必扁平 toml 結構**（依 §3.6：description + prompt 直接 root level；禁 [command] / [command.instruction] nested table；禁 name 欄位）
  - 引用 framework 路徑禁絕對路徑
- step 6 簽名 agent-commons/roles/pm/_role.md
  - **Status 寫 PROVISIONAL**（不寫 Sign-in Log；等我 explicit 授權升 ACTIVE）
- step 7 通知我「我已建好 /pm-init（Status PROVISIONAL，step 5 doctor 0 errors，toml 扁平結構），請驗證」
```

### 5.5 預期結果

```
your-project/
├── .claude/commands/engineer-init.md       ← Claude 自己生成
├── .gemini/commands/pm-init.toml           ← Gemini 自己生成
└── agent-commons/
    └── roles/
        ├── engineer/_role.md               ← Claude 簽名
        └── pm/_role.md                     ← Gemini 簽名
```

打 `/engineer-init` 或 `/pm-init` 應觸發 AI 跑五步驟（依 [init-template §6](./core/init-template.md)）並輸出統一就緒回報。

### 5.6 多 AI 同角色情境

未來第三個 AI 加入扮演同一角色（如 Cursor 接 Engineer）：

- Cursor 自己跑同樣的 self-instantiation 流程
- 在 `.cursor/rules/engineer-init.mdc` 生成
- 簽名 `agent-commons/roles/engineer/_role.md` 加一行（依 [cross-ai-handoff §6](./core/cross-ai-handoff.md) 切換歷史）
- 不需要修 charter

charter 對多 AI 共扮一角色的支援來自 [cross-ai-handoff](./core/cross-ai-handoff.md) — 退出方寫能力快照、接班方接收。

---

## 6. 派發第一個任務

### 6.1 完整生命週期

```
1. PM 寫 capsule
   ↓
2. Engineer 抽驗 capsule（防 PM 假宣告 / 缺證據）
   ↓ 通過
3. Engineer 接收，執行修法
   ↓
4. Engineer 提交 VCP（驗收測試計畫，含 stdout 原文）
   ↓
5. PM 抽驗 VCP（親跑驗收，不只看 Engineer 結論）
   ↓ 通過
6. PM 結案宣告（須 Engineer 核准才生效）
```

### 6.2 PM 寫 capsule

依 `templates/agent-commons/capsule.md.tpl`，產出 `agent-commons/capsules/CAP-<N>-<topic>.md`。

最低必含（依 [completion-delivery.md](./core/completion-delivery.md)）：

- **Directive Header**：受理 AI / 領域公理 / 抽驗 AI / 危險度標籤
- **Scope**：明確邊界（哪些檔可動 / 不可動）
- **VCP（驗收檢核點）**：≥ 1 個可重現指令 + 期望輸出
- **雙保險**：A 線（Engineer 自查通過）+ B 線（PM 抽驗通過）
- **失敗解讀表**：VCP 失敗時對應的回查方向

### 6.3 Engineer 抽驗 capsule

依 [audit-rights.md](./core/audit-rights.md)，Engineer **必須**抽驗，不能直接接受：

```bash
# 對 capsule 引用的 stdout 對照實際
grep -n "<關鍵字>" <檔案>
ls -la <PM 宣稱已建立的檔案>
git log --oneline -1 <PM 引用的 commit>
```

抽驗通過 → 進入工作。  
抽驗失敗 → 退稿，要求 PM 補強（引用對應 F-mode 編號）。

### 6.4 Engineer 完工 + VCP

依 [completion-delivery.md](./core/completion-delivery.md) + [structural-anti-fabrication.md](./core/structural-anti-fabrication.md)：

```markdown
## VCP 結果

### VCP-1: <測試名>
\`\`\`bash
$ <實際指令>
<原始 stdout>
\`\`\`

### VCP-2: ...

身份戳：Engineer (AI: <廠商>) → 提交給 PM
```

**核心紀律**：缺 stdout 原文 → PM 直接退稿（不進入內容審查，依 [structural-anti-fabrication](./core/structural-anti-fabrication.md)）。

### 6.5 PM 抽驗 VCP

PM **親跑** VCP 指令，不能只看 Engineer 結論：

```bash
# 重跑 Engineer 的 VCP-1 指令，比對輸出
<Engineer 給的指令>
```

數值 / 行為一致 → 結案。
不一致 → 退稿，引用 F-mode（典型 F1 假宣告 / F3 捏造數據）。

### 6.6 結案宣告

PM 對任何「已完成 / 已關閉」型宣告**默認待抽驗**。Engineer 核准後才生效。

---

## 7. 日常使用

### 7.1 DRAFT_CONTEXT.md（暫存堆疊）

依 [working-stack-discipline.md §1](./core/working-stack-discipline.md)，session 內持續工作須在 `agent-commons/DRAFT_CONTEXT.md` 累積：

- 關鍵 stdout 原文
- 決策軌跡
- 未結案 capsule 中間狀態
- 修改檔案清單

**禁累積在對話內**（context 重啟即蒸發）。

### 7.2 Save 觸發（六步驟）

依 [§3.3](./core/working-stack-discipline.md)，save 不可拆：

```
1. DRAFT → HANDOFF 摘要（依 handoff-chain §2 7 項必含）
2. 寫入 HANDOFF_<N+1>.md
3. 歸檔完工膠囊（移到 archive/）
4. 更新 NextWork
5. git commit  ← 強制（無 git 環境降級為 warn）
6. 清空 DRAFT_CONTEXT
```

**任一步驟失敗 → 整個 save 動作回滾**。

### 7.3 HANDOFF（session 末交接）

依 [handoff-chain.md §2](./core/handoff-chain.md) 必含 7 項：

1. 里程碑摘要
2. 完整任務清單（不吞 hotfix）
3. 協議版本迭代軌跡
4. 知識庫新增段落引述
5. 技術指標（test pass / build / VCP 覆蓋）
6. 下一階段預告
7. 待 commit 清單

寫入 `agent-commons/handoffs/HANDOFF_<N>.md`，session 末**必寫**。

---

## 8. 進階場景

### 8.1 跨 session 接班（同 AI / 同身份）

依 [working-stack-discipline §5](./core/working-stack-discipline.md)：

```
1. AI 重啟（context 清空 / 額度恢復 / 模型切換）
2. 讀最新 HANDOFF_<N>.md
3. 讀 DRAFT_CONTEXT.md（若 size > 0 表示有 session 內未 save 累積）
4. 對齊狀態，繼續未完工作
```

**不寫新身份戳**（同身份）+ **不追加 _role.md 切換歷史**（載體未變）。

### 8.2 跨 AI 廠商接班

依 [cross-ai-handoff.md](./core/cross-ai-handoff.md) 完整流程：

```
退出方（舊 AI）：
1. 寫能力快照（§5）— 工具能力 / Stateful 副作用 / 隱性假設 / fallback
2. 標明強化抽驗狀態（若有）
3. 私有筆記轉移宣告（從 private/ 移到 sessions/ 或 drafts/）
4. 隱性決策清單
5. 未結案膠囊清單

接班方（新 AI）：
1. 跑自己廠商的 init（含 §3.3 self-instantiation）
2. 讀完整 HANDOFF + 能力快照
3. 能力差異盤點，缺項回報使用者
4. 狀態繼承（強化抽驗模式不繼承解除權，重新累計）
5. 簽名 _role.md（依 §6 五欄切換歷史）
```

### 8.3 違規處置（F1〜F6）

依 [failure-modes.md](./core/failure-modes.md)：

| F | 名稱 | 範例 |
|---|---|---|
| F1 | 假宣告 | 「膠囊已建立」但檔案未動 |
| F2 | 假 commit hash | 引述未存在的 hash |
| F3 | 捏造數據 | 任務膠囊用未實證的效能值 |
| F4 | 編號偏差 | 引述條款編號錯誤 |
| F5 | 規則記憶失效 | 同類偏差三次重犯 |
| **F6** | **未驗證即宣告就緒**（v0.5.10 加 / v0.7.0 加 sub-pattern）| self-instantiation step 5 漏跑 doctor schema 驗證；含 surface-level（書寫動作）vs structural-level（檔案系統 / 邏輯一致性）兩 sub-pattern — 寫 schema 「指向 X」 ≠ X 物理存在；寫 Status: ACTIVE ≠ user 授權 |

**違規處置流程**（依 [violation-reflection](./core/violation-reflection.md) + [escalation-protocol](./core/escalation-protocol.md)）：

```
偏差 1 次 → 退稿 + 補反省（reflections/<event-id>.md）
連續 ≥ 2 次同類 → 強化抽驗模式（所有宣告須附 stdout 原文）
連續 ≥ 3 次 → 觸發使用者裁決（escalation §4 ABCD 選項）
```

### 8.4 衝突仲裁（決策分歧，無人錯）

**重要區隔**：違反條款 → 走 escalation；意見不合 → 走 [role-conflict-resolution](./core/role-conflict-resolution.md)。

```
L0 對話（≤ 2 回合）→ 雙方寫立場 + 引用條款
   ↓ 無共識
L1 條款仲裁 → 找具體 §段 / 領域公理仲裁
   ↓ 條款未明示
L2 使用者裁決 → 標準上報格式（雙方立場 + ABCD 選項）
```

### 8.5 升 charter 版本

依 [versioning-migration.md §3](./core/versioning-migration.md)：

```bash
# 1. 先升 charter clone
cd ~/.agentcharter && git pull
```

```
# 2. prompt AI 跑 dry-run
請依 ~/.agentcharter/tools/doctor-spec.md 跑 target-version=<new> dry-run，
列出本專案在新版下會踩到的問題。

# 3. 讀 CHANGELOG 對應段（特別看 ### BREAKING）

# 4. 升 profile.yaml.charter_version
編輯 agent-commons/_config/profile.yaml

# 5. prompt AI 確認
請依 ~/.agentcharter/tools/doctor-spec.md 跑健康檢查，確認 ERROR/WARN 都通過。

# 6. commit
git commit -m "chore: bump charter_version <old> → <new>"
```

**禁跨 MAJOR 跳升**（如 0.x → 2.x）— doctor spec §3.3 會擋（依 [versioning-migration §3.3](./core/versioning-migration.md)）。

**v0.5.9 後 charter 承諾向下兼容**（依 [versioning-migration §2.3](./core/versioning-migration.md)）：第一次 init 後得到的 `agent-commons/` 結構是穩定承諾，後續 charter 演進沿用既有結構，不要求採用方重建目錄。

---

## 11. Troubleshooting

### 11.1 doctor 報錯訊息對照表

| 錯誤訊息 | 可能原因 | 修法 |
|---|---|---|
| `❌ Common Memory Root '<path>' 不存在` | 還沒跑 init / 路徑錯 | 走 §3.2 模式 A prompt AI 跑 init |
| `❌ profile.yaml 缺 charter_version 欄位` | yaml 寫錯 | 對照 `tools/profiles/<preset>.yaml` |
| `❌ mapping.yaml 缺 domain_axioms.primary` | mapping schema 不齊 | 補 `domain_axioms.primary: <path>` |
| `❌ domain_axioms.primary 路徑不存在` | 公理檔還沒寫 | 編輯 `agent-commons/protocols/<axiom>.md` |
| `❌ mapping.yaml 缺 shared.draft_context` | working-stack-discipline 啟用但缺 mapping 欄 | 補 `shared.draft_context: DRAFT_CONTEXT.md` |
| `⚠️ 未知條款名（拼字錯或新版）` | enabled 寫錯 | 對照 `tools/profiles/<preset>.yaml` |
| `❌ 跨 ≥2 MAJOR 跳升禁止` | 升版跳太多 | 逐 MAJOR 升（如 0.x → 1.0.0 → 1.x.y） |
| **`❌ E601 layout 路徑含 namespace 同名中介層`**（v0.7.0）| mapping.yaml 寫 `shared.capsules: shared/capsules/` 等 | 改為頂層 `shared.capsules: capsules/`；對應 `core/charter-config §3` namespace 註明 |
| **`❌ E602 <common_memory_root>/shared/ 目錄存在`**（v0.7.0）| Gemini 等誤把 schema namespace 翻譯為檔案目錄 | 把 `shared/<X>/` 內容移到頂層、刪 `shared/` 中介層 |
| **`❌ E603 頂層必要目錄缺項`**（v0.7.0）| capsules/ handoffs/ protocols/ institutional-memory/ 之一不存在 | mkdir 缺項目錄 |
| **`❌ E604 roles/ 全缺`**（v0.7.0）| standard/strict preset 接入時連 pm/engineer 雙角色都沒 scaffold | 補 scaffold；對應 `tools/init-spec.md Phase 4` |
| **`❌ E605 enable_modes 缺 F6`**（v0.7.0 強制檢查）| profile.yaml `parameters.failure-modes.enable_modes: [F1...F5]` 漏 F6 | 加一行 F6（v0.5.10 起 F6 必啟）— **本檢查不依賴 profile.yaml 是否啟用 F6**（諷刺循環攔截）|

### 11.2 AI 自我具象化失敗

| 狀況 | 修法 |
|---|---|
| AI 不知道 charter 在哪 | prompt 加 `charter 在 ~/.agentcharter/`（給絕對路徑） |
| AI 自己生成檔案但放錯位置 | 對照 [init-template §3.1](./core/init-template.md) 表格各 AI 標準位置 |
| AI 拒絕自我具象化（要求使用者代寫）| 違反 [§3.3.5](./core/init-template.md) — 提醒 AI「self-instantiation 是強制流程」 |
| Slash command 跑起來缺步驟 | 該實作為次品，要求 AI 重新具象化（依 §3.3.5）|

### 11.3 AI 自具象化 init / doctor 失敗

| 狀況 | 修法 |
|---|---|
| AI 找不到 charter 路徑 | prompt 加絕對路徑 `~/.agentcharter/` |
| AI 解讀 spec 不準 | 引用具體 spec §段（如「依 init-spec.md §3 Phase 1〜3 跑」），減少自由度 |
| `<common-root>` 已存在 | prompt 加 `force: true` / 「覆寫既有」；或請 AI 選別的 common-root 名 |
| AI 產出結構不對齊 charter v0.5.9+ schema | 確認 charter clone 是最新（`cd ~/.agentcharter && git pull`），讓 AI 重讀 spec |
| AI 不依 spec、自由發揮 | prompt 強調「**嚴格依 spec**，禁自由發揮 / 編造額外步驟」 |

### 11.4 容易踩的概念坑

| 坑 | 真相 |
|---|---|
| 「框架代寫 slash command」 | 框架**不代寫**（v0.5.1 後）— AI 自我具象化（`/charter-init` 也是 — 採用方第一次 prompt 觸發 AI 自建，未來重用，詳見 §3.2 路徑 A）|
| 「PM 可以跳過抽驗自己結案」 | 違反 [audit-rights](./core/audit-rights.md)，必須 Engineer 核准才生效 |
| 「Engineer 可以宣告膠囊結案」 | 違反 [role-separation](./core/role-separation.md)，PM 才有結案權 |
| 「兩角色決策不合 = 一方違規」 | 不一定 — 走 [role-conflict-resolution](./core/role-conflict-resolution.md) 三級階梯，不是 escalation |
| 「同 AI 戴不同帽子可以自抽自驗」 | 違反 [multi-role-tracking §3.3](./core/multi-role-tracking.md)，禁同 session 自抽自驗 |
| 「DRAFT 累積在對話裡就好」 | 違反 [working-stack-discipline §1](./core/working-stack-discipline.md)，須是檔案 |
| 「升 charter 版本可以跨 MAJOR 跳」 | 禁止（[§3.3](./core/versioning-migration.md)）— 須逐 MAJOR 走 migration |

### 11.5 進一步求助

| 想找什麼 | 去哪 |
|---|---|
| 條款全文 | [core/](./core/)（21 個 .md） |
| 模板（capsule / handoff / IM / nextwork / domain-axioms / _role）| [templates/agent-commons/](./templates/agent-commons/) |
| 真實採用案例 | [examples/cryptobot/mapping.md](./examples/cryptobot/mapping.md) |
| AI 視角的採用指南 | [ADOPTION.md](./ADOPTION.md) |
| 版本紀錄 + BREAKING | [CHANGELOG.md](./CHANGELOG.md) |
| 治理 / 衝突解決規則 | [GOVERNANCE.md](./GOVERNANCE.md) |
| 貢獻流程 | [CONTRIBUTING.md](./CONTRIBUTING.md) |

---

## 變更歷史

- **v1.9（2026-04-30，charter v0.8.1）** — SSS S3 起手實證 + dogfood signal #24 升工具層 + #19 順手修連動 sync：line 6 charter 對應版本 v0.8.0 → v0.8.1。**升 v0.8.1 注意**：純擴增 spec 層 + 文檔層、既有採用方升版只改 profile.yaml `charter_version: "0.8.0"` → `"0.8.1"`。`tools/doctor-spec.md §3.10` 新加採用方文檔變更歷史 sync 校驗（W901）— 採用方文檔變更歷史漏 entry 會抓 WARN、需補變更歷史 entry（依 maintainer-discipline §3.4.2 紀律）。`tools/doctor-spec.md §3.7-§3.9` 全加四欄 spec-as-data 結構（合規規定 / 修補方向 + 約束 / 反例）— 對採用方執行邏輯零影響、純文檔層擴增。詳見 CHANGELOG v0.8.1 段。
- **v1.8（2026-04-29，charter v0.8.0）** — 升版 + 接入防呆強化（slim 版）連動 sync：line 6 charter 對應版本 v0.7.5 → v0.8.0 + 對應 v0.8.0 新增條款 / spec 段引用（`tools/post-upgrade-verify-spec.md` 新工具、5 軸 spec 校驗 / `tools/doctor-spec.md §3.9` axiom 紀律對齊 E606/E607/W608 / `tools/doctor-spec.md §3.8` vendor schema 從 spec 升實作層、E801/W802 強制 / `tools/init-spec.md` Phase 5b CHECK 7 ext axiom status fail-fast / `QUICKSTART.md` Step 2 ↔ Step 3 swap）。**升 v0.8.0 注意**：(a) 升版前先跑 /charter-doctor 看 §3.8 vendor schema + §3.9 axiom status 是否合規、修補後再升 charter_version；(b) 新接入採用方需先寫 axiom + 升 USER-RATIFIED 才能跑 init（Phase 5b CHECK 7 ext 強制）；(c) /charter-upgrade-verify 為新工具、自具象化為 slash command 給未來重用。**詳細 step-by-step 升版流程（含每步 AI prompt 範本）見 [`examples/upgrades/v0.7.5-to-v0.8.0.md`](./examples/upgrades/v0.7.5-to-v0.8.0.md)**。詳見 CHANGELOG v0.8.0 段。
- **v1.7（2026-04-28，charter v0.7.5）** — 跨多版本升級指引：line 6 charter 對應版本 v0.7.4 → v0.7.5。對應 `core/versioning-migration §3.4` 跨多 MINOR 累積升級流程子段（含「停用一段時間後重新採用」場景）+ YC_AIAgentCrew 第一個跨版本 walkthrough 實證（回鍋開發者無痛紀律 ship）。**升 v0.7.5 注意**：純擴增 / 零動作 migration。
- **v1.6（2026-04-28，charter v0.7.4）** — vendor 端 slash command schema 規範條款化（dogfood signal #16）：line 6 charter 對應版本 v0.7.3 → v0.7.4 + §11 troubleshooting 應加 vendor schema 違規（如 Gemini CLI toml nested table）的修法。**升 v0.7.4 注意**：純擴增 / 零動作 migration、doctor 不跑新 check（實作層留 v0.8+ 啟用、已於 v0.8.0 啟用、見 v1.8 entry）。
- **v1.5（2026-04-28，charter v0.7.3）** — 完整文檔層 sync sweep + README 設計哲學北極星顯化：line 6 charter 對應版本 v0.7.2 → v0.7.3 + §3 cross-reference QUICKSTART Step 2-3 順序紀律 + §5.2 self-instantiation 7 步驟（v0.7.0 step 6 PROVISIONAL/ACTIVE 二態）+ §8.3 F1〜F6 失敗模式（含 v0.7.0 F6 sub-pattern surface vs structural）+ §11.1 doctor E601〜E605（v0.7.0 namespace 校驗）。**對應 README §設計哲學顯化**（兩無痛定義 + 三服務原則 + 對未來修訂的紀律）。
- **v1.4（2026-04-28，charter v0.7.1 + v0.7.2 補記）** — 補 v0.7.1 / v0.7.2 兩個 release 對應 TUTORIAL 變更歷史 entry：v0.7.1 雙路徑（user 主筆 vs AI 代產 + user 校）+ frontmatter scaffold（Status / mutability_default / created_by / created_at）；v0.7.2 流程順序 cross-reference + structural-anti-fabrication §5 補三行反向引用 + maintainer-discipline §3.4 文檔層 sync checklist。
- **v1.3（2026-04-28，charter v0.7.0）** — 公司專案接入失敗大批次 sync：line 6 charter 對應版本 v0.6.1 → v0.7.0 + 連動 5 個 dogfood signal 條款化（init-spec Phase 5b 採用方半邊「他抽」載體 / multi-role-tracking §3.4.4 init 階段自激活紀律 / init-template §3.3.2 step 6 Status PROVISIONAL/ACTIVE 二態 / failure-modes F6 sub-pattern surface vs structural / doctor-spec §3.7 結構頂層 + namespace 校驗）+ 本變更歷史段。詳見 `.claude_temp/COMPANY-ONBOARDING-FAILURE-AUDIT.md` 完整 audit。**升 v0.7.0 注意**：profile.yaml `parameters.failure-modes.enable_modes` 須含 F6（v0.7.0 強制必啟）；mapping.yaml 若含 `shared/<X>/` 中介層需 migration（移到頂層 + 改寫 mapping）。
- **v1.2（2026-04-28，charter v0.6.1）** — 文檔層 sync 修補（v0.5.10 / v0.6.0 release 漏的 TUTORIAL 同步點，由 v0.6.1 auditor 第一次實戰抽驗抓到 — dogfood signal #6 候選）：line 6 charter 對應版本 v0.5.8 → v0.6.1 + §1.1 移除 Python 3.8+ / PyYAML 行（v0.5.9 純規範框架後遺漏）+ §3.3 preset 表母數 17 → 19 + 本變更歷史段。
- **v1.1（2026-04-28，charter v0.6.0）** — 條款數 line 658 「20 個 .md」→「21 個 .md」（含 v0.6.0 新增 ai-vendor-onboarding）。
- **v1.0（2026-04-27，charter v0.5.7）** — 初版。9 章工具書（前置 / 概念 / clone&init / 領域公理 / AI 具象化 / 任務生命週期 / 日常使用 / 進階場景 / troubleshooting）。
