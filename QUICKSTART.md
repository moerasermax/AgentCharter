# AgentCharter — 5 分鐘快速開始

> **給誰**：採用 AgentCharter 框架的團隊（人類 + 雙 AI 協作）
> **目標**：5 分鐘讀完，30 分鐘跑通第一個任務
> **看不懂某步驟？** → 跳到 [TUTORIAL.md](./TUTORIAL.md) 對應章節
> **完全不知道這在做什麼？** → 先讀 [README.md](./README.md)

---

## 前置（5 分鐘確認）

你需要：

- [ ] git（任何版本）
- [ ] 至少一個 AI 工具（Claude Code / Gemini CLI / Cursor）
- [ ] 你的專案 git working dir

> charter v0.5.9 後是純規範框架 — 不需 Python / npm / 任何 runtime。所有工具動作由 AI 依 spec 自具象化執行。

---

## 5 步流程

### Step 1：Clone charter（30 秒）

```bash
git clone https://github.com/moerasermax/AgentCharter ~/.agentcharter
```

charter 是規範集，clone 到本機任一位置即可（不需 npm install）。

### Step 2：在你專案跑 init（1 分鐘）

**第一次接入**：複製貼給你的 AI（Claude / Gemini / Cursor 等）：

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

AI 跑完 → 產出 `agent-commons/` 結構 + `.claude/commands/charter-init.md` 或 `.gemini/commands/charter-init.toml`（依 AI 廠商）。

**之後重用**：直接打 `/charter-init standard`（前提：已具象化過）。

> charter v0.5.9 後 framework 不附 python / npm 等實作工具 — 純規範框架，所有工具動作由 AI 自具象化（對齊「角色 ⊥ AI」+「framework 不代生成」原則）。

**參數速查**：

| 參數 | 選項 / 範例 | 說明 |
|---|---|---|
| `--preset` | `minimal` / `standard` / `strict` | 紀律嚴格度（不確定選 `standard`）|
| `--domain-axioms-path` | `protocols/RECON.md` | 你的領域公理檔位置 |
| `--domain-axioms-alias` | `RECON` / `IRON` / `HIPAA` | 短名稱（< 10 字元）|

**preset 選哪個？** 不確定 → `standard`。詳見 [TUTORIAL §3.3](./TUTORIAL.md#33-preset-選哪個)。

### Step 3：寫領域公理（10 分鐘）

編輯 `agent-commons/protocols/<YOUR_AXIOM>.md`（init 已複製模板）。

**最低要求**（依 [domain-axiom-slot §3.1](./core/domain-axiom-slot.md)）：

- 每條鐵律必含「**後果**」段（具體損害，禁模糊「可能會出錯」）
- 條款內容**可被驗證**（grep / runtime probe；「應該寫得好」不可驗）
- 有獨立**編號**（便於跨檔引用）

**範例**（金融專案的金額處理鐵律）：

```markdown
### ① 金額一律 Decimal（精度級）

禁用 float / double 處理金額；資料庫 schema NUMERIC(18,4)。

> **後果**：浮點累積誤差 → 對帳出現 ¢ 級漂移 → 合規 fine
```

### Step 4：通知 AI 自我具象化（5 分鐘）

依 [init-template §3.3](./core/init-template.md)，**框架不代生成 slash command**，由 AI 自己依 charter 規範具象化。

> 🔁 **每個 AI 各自貼一次**：如果本專案有多 AI 並存（如 Claude × Engineer + Gemini × PM），下方 prompt 是並列示範，**不是「選一個貼」**。每個 AI 接的角色都要有自己的 vendor-specific init slash command（Claude 用 `.claude/commands/`、Gemini 用 `.gemini/commands/`，不通用）。第三個 AI 加入時照樣再貼一次對應 prompt。

複製對應 prompt 給每個你採用的 AI：

**對 Claude Code**：
```
我採用了 AgentCharter，charter 在 ~/.agentcharter/。
請接 Engineer 角色，依 ~/.agentcharter/core/init-template.md §3.3.2
7 步驟自我具象化到 .claude/commands/engineer-init.md。
特別注意 step 5（v0.5.10 加）— 簽名前必跑 doctor schema 驗證；
不通請告訴我（不要強行簽名 _role.md）。
通過後簽名 agent-commons/roles/engineer/_role.md，
回報「step 5 doctor schema 通過 0 errors」+ 「step 6 _role.md 簽名完成」。
```

**對 Gemini CLI**：
```
我採用了 AgentCharter，charter 在 ~/.agentcharter/。
請接 PM 角色，依 ~/.agentcharter/roles/pm/gemini-cli.md（Gemini 的
vendor spec）+ core/init-template.md §3.3.2 自我具象化到
.gemini/commands/pm-init.toml。
特別注意 step 5（v0.5.10 加）— 簽名前必跑 doctor schema 驗證；
不通請告訴我（不要強行簽名 _role.md）。
通過後簽名 agent-commons/roles/pm/_role.md，
回報「step 5 doctor schema 通過 0 errors」+ 「step 6 _role.md 簽名完成」。
```

驗證：打 `/engineer-init` 或 `/pm-init`，AI 應輸出統一就緒回報格式（依 init-template §4）。

> v0.5.10 加 step 5 schema 驗證強制點 — 動機：避免具象化階段未抓到的 schema 違規（如 mapping.yaml 缺 `common_memory_root` 必填）轉嫁給下個 AI 修補。對應 `failure-modes.md F6`。

### Step 5：人工二次確認 + 具象化 `/charter-doctor`（1 分鐘）

> v0.5.10 起，Step 4 self-instantiation 結尾**已自動跑過 doctor schema 驗證**（強制點，依 `init-template §3.3.2 step 5`）。本步驟為人工二次確認 + 把 doctor 具象化為日後重用的 slash command。

複製貼給你想要有 `/charter-doctor` 的 AI（多 AI 並存時通常給 PM 或 Engineer 其中一位即可）：

```
請依 ~/.agentcharter/tools/doctor-spec.md §2.1 模式 A（人工健康檢查）
對本專案的 agent-commons/ 跑一次完整檢查，並順便具象化為 /charter-doctor
slash command 給未來重用。
```

**期望**：`📊 Summary: 0 errors / 0 warnings / 0 infos`

> **若 Step 5 卻有 errors**：表示 Step 4 中某個 AI 跳過了 self-instantiation step 5 強制驗證點 = 命中 `failure-modes F6`（未驗證即宣告就緒）。請要求該 AI 重做 self-instantiation。

之後重用打 `/charter-doctor`。詳見 [TUTORIAL §11](./TUTORIAL.md#11-troubleshooting)。

---

## 完成 ✅

你現在有：

- ✅ `agent-commons/` 結構齊全（capsules / handoffs / protocols / institutional-memory / state / roles/{engineer,pm}/）
- ✅ 領域公理 doctor 通過
- ✅ 雙 AI 各自有 init slash command 可呼叫
- ✅ 第一個任務可以開始派發

---

## 下一步：派發第一個任務

PM 對 AI 下指令：

```
/pm-init
（PM 就緒回報後）
請寫 capsule CAP-001：<你的第一個任務需求>
```

完整任務生命週期（PM 寫 → Engineer 抽驗 → 接收 → 完工 VCP → PM 抽驗 → 結案）→ [TUTORIAL §6](./TUTORIAL.md#6-派發第一個任務)

---

## 卡住了？查表

| 狀況 | 看哪 |
|---|---|
| 想理解每步**為什麼**這樣做 | [TUTORIAL.md](./TUTORIAL.md) |
| doctor 報錯不知道意思 | [TUTORIAL §11 troubleshooting](./TUTORIAL.md#11-troubleshooting) |
| AI 不會自我具象化 | [TUTORIAL §5 AI onboarding](./TUTORIAL.md#5-ai-自我具象化) |
| 想查某條款全文 | [core/](./core/) 21 個 .md |
| 想看真實採用案例 | [examples/cryptobot/mapping.md](./examples/cryptobot/mapping.md) |
| AI 自己讀的版本 | [ADOPTION.md](./ADOPTION.md)（給 AI 看，密集格式） |
| 概念總覽 | [README.md](./README.md) |

---

## 文件位階速查

| 檔案 | 受眾 | 用途 | 何時讀 |
|---|---|---|---|
| `README.md` | 任何人 | 介紹 charter 是什麼 | 第一次接觸 |
| **`QUICKSTART.md`** | **人類採用方** | **5 分鐘跑起來** | **接入時** |
| `TUTORIAL.md` | 人類採用方（深入）| 工具書 / reference | 卡關 / 想深入 |
| `ADOPTION.md` | 該團隊的 AI | AI 自含 context 採用指南 | AI 接班時 |
