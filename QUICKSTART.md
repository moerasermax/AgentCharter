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

### Step 2：寫領域公理（10 分鐘 — 兩條路徑擇一）

> ⚠️ **v0.7.1 加雙路徑**：依 [`core/domain-axiom-slot §3.3`](./core/domain-axiom-slot.md)，user 初次寫領域公理可選兩條合法路徑。
> 本 Step 必須先於 Step 3 完成 — Step 3 init 跑時會驗 axiom 檔物理存在（Phase 5b 第 7 項）。

#### 路徑 A：user 主筆（既有 default）

user 親自寫每條鐵律。最低要求：

- 每條鐵律必含「**後果**」段（具體損害，禁模糊「可能會出錯」）
- 條款內容**可被驗證**（grep / runtime probe；「應該寫得好」不可驗）
- 有獨立**編號**（便於跨檔引用）

frontmatter（依 [`templates/agent-commons/domain-axioms.md.tpl`](./templates/agent-commons/domain-axioms.md.tpl)）：

```yaml
---
status: USER-RATIFIED
mutability_default: APPEND-ONLY
created_by: user
created_at: 2026-04-28
---
```

**範例**（金融專案的金額處理鐵律）：

```markdown
### ① 金額一律 Decimal（精度級）

禁用 float / double 處理金額；資料庫 schema NUMERIC(18,4)。

> **後果**：浮點累積誤差 → 對帳出現 ¢ 級漂移 → 合規 fine
```

#### 路徑 B：AI 讀 codebase 代產草稿 + user 校（v0.7.1 加）

適用：user 想低門檻起手 / 既有 codebase 已有隱含工程紀律。

1. 用 [`templates/agent-commons/domain-axioms-via-ai-draft-prompt.md.tpl`](./templates/agent-commons/domain-axioms-via-ai-draft-prompt.md.tpl) 內的 prompt 範本貼給你的 AI（Claude / Gemini / Cursor）
2. AI 讀 codebase 推斷紀律 → 寫 `agent-commons/protocols/<axiom>.md` 草稿
   - frontmatter 預設 `status: AI-DRAFTED` + `created_by: ai-drafted`
   - 每條鐵律附「推斷依據」段（檔案路徑 + grep 結果）
3. **user 親自校正**（不能讓 AI 升 Status — 對應 `multi-role-tracking §3.4.4`）：
   - 看 AI 推斷 vs 實際 codebase
   - 改 / 刪 / 新增條款
   - frontmatter `status: AI-DRAFTED` → `USER-RATIFIED`
   - frontmatter `created_by: ai-drafted` → `user-ratified-from-ai-draft`（保留審計痕跡）
4. **user 校完（升 USER-RATIFIED）才能跑 Step 3（charter init Phase 1-5b）— 不可在 AI-DRAFTED 狀態啟動 init**（對應 v0.7.0 Phase 5b 物理存在校驗 + multi-role-tracking §3.4.4 user explicit 授權精神）

#### 哪條路徑選？

| 你的情境 | 推薦路徑 |
|---|---|
| 你對領域底線有明確心智模型 | A |
| 你說「邊做邊補、不確定有什麼鐵律」 | B（AI 讀 codebase 起手）|
| 既有 codebase 大、有 README / docs / 大量 invariant | B（AI 能挖出 user 沒意識到的紀律）|
| 早期 startup / 探索期專案 | B 起手（→ 演化）+ META 鐵律（依 `core/domain-axiom-slot §3.1` 撰寫紀律最低要求只需 1 條 + 後果 + 可驗 + 編號）|

### Step 3：在你專案跑 init（1 分鐘）

> ⚠️ **placeholder 提醒**：本 step prompt 是 charter 範本，請**先把 `<YOUR_AXIOM>` / `<SHORT_NAME>` 兩個 placeholder 替換為你 Step 2 寫好的具體檔名與短名**再貼給 AI。對應 dogfood signal #5 第二次完整實證 — 公司專案接入失敗 2026-04-28（見 `.claude_temp/COMPANY-ONBOARDING-FAILURE-AUDIT.md`）：placeholder 沒填、AI 自己編了一個（命中 `failure-modes F3` 捏造數據 / completionist 繞過 user）。

**第一次接入**（**先確認 Step 2 axiom 已 USER-RATIFIED**）：複製貼給你的 AI：

```
我採用了 AgentCharter，charter 在 ~/.agentcharter/。

請依 ~/.agentcharter/tools/init-spec.md 跑接入流程 phase 1-5b：
- preset: standard
- domain-axioms-path: protocols/<你已替換的具體檔名>.md
- domain-axioms-alias: <你已替換的具體 alias>

完成後請順便把這個流程具象化為 /charter-init slash command 到你
廠商的標準位置（依 init-template.md §3.3 self-instantiation），
未來我打 /charter-init <args> 直接重用。

紀律提示：
- (v0.8.0) 跑 init 前自驗 axiom frontmatter `status` 是否 USER-RATIFIED；
  若為 AI-DRAFTED → 終止退稿、回報 user 校 axiom 後重新觸發
  （依 core/domain-axiom-slot §3.3 路徑 B 紀律 + Phase 5b CHECK 7 ext）
- (v0.7.0) self-instantiation step 6 簽名 _role.md Status 必為 PROVISIONAL（未經我 explicit 授權）
- (v0.7.0) step 6 不得寫 Sign-in Log（等我 explicit 授權某 AI 接該角色才寫）
- (v0.7.0) charter-init slash command 內引用 framework 路徑禁寫死 user home 絕對路徑
  （推薦 $AGENTCHARTER_HOME / ~/.agentcharter / agent-commons/ 三層）
- (v0.7.0) Phase 5b 觸發 fresh-context sub-agent（路徑 A）對 init 結果跑他抽驗
  （依 tools/init-spec.md Phase 5b + roles/validator/_spec.md §3.6）
- (v0.7.0) 結尾貼出 doctor stdout + Phase 5b 抽驗結果（不要只回報「成功」摘要）
```

AI 跑完 → 產出 `agent-commons/` 結構 + `.claude/commands/charter-init.md` 或 `.gemini/commands/charter-init.toml`（依 AI 廠商）+ Phase 5b 他抽驗報告。

**之後重用**：直接打 `/charter-init standard`（前提：已具象化過）。

> charter v0.5.9 後 framework 不附 python / npm 等實作工具 — 純規範框架，所有工具動作由 AI 自具象化（對齊「角色 ⊥ AI」+「framework 不代生成」原則）。
>
> v0.7.0 加 Phase 5b（採用方接入流程「他抽」屬性）對應 dogfood signal #7 候選條款化 — 封閉採用方接入流程「自抽自驗」結構性盲區，對稱於 v0.6.0 加 auditor 角色封閉 maintainer 半邊。

**參數速查**：

| 參數 | 選項 / 範例 | 說明 |
|---|---|---|
| `--preset` | `essential` / `minimal` / `standard` / `strict` | 紀律嚴格度（不確定選 `standard`、想極簡起手選 `essential`）|
| `--domain-axioms-path` | `protocols/RECON.md` | 你的領域公理檔位置 |
| `--domain-axioms-alias` | `RECON` / `IRON` / `HIPAA` | 短名稱（< 10 字元）|

**preset 選哪個？**

| Preset | 條款啟用 | 適用 | init token |
|---|---|---|---|
| **`essential`**（v0.9.0 加） | 3-5 / 23 | 探索期 / 單人 / 快迭代 / 想要 AI 別瞎掰但不想要全套儀式成本 | **< 5k** |
| `minimal` | 10 / 23 | 探索型 / 單人 + 1 AI / 短期實驗（含 individual-learning-loop = true）| ~ 12k |
| **`standard`** | **22 / 23** | **一般雙 AI 協作** | ~ 30k |
| `strict` | 22 / 23 | 嚴格合規 / 高風險（金融 / 醫療 / 軍工） | ~ 35k |

> 💡 **v0.9.0 加 essential preset**（dogfood signal #28 progressive adoption + signal #26 init token cost / ROI 真槓桿）— 只啟用最硬層 3-5 條核心防線（structural-anti-fabrication / audit-rights / evidence-first / failure-modes / role-separation）+ 配置最寬鬆。**漸進升維路徑**：essential（探索期）→ minimal（雙 AI 但短期）→ standard（一般協作）→ strict（嚴格合規）。任何時候都可改 `profile.yaml.preset` 升級、不需重建 agent-commons/。

不確定 → `standard`。詳見 [TUTORIAL §3.3](./TUTORIAL.md#33-preset-選哪個)。

### Step 4：通知 AI 自我具象化（5 分鐘）

依 [init-template §3.3](./core/init-template.md)，**框架不代生成 slash command**，由 AI 自己依 charter 規範具象化。

> 🔁 **每個 AI 各自貼一次**：如果本專案有多 AI 並存（如 Claude × Engineer + Gemini × PM），下方 prompt 是並列示範，**不是「選一個貼」**。每個 AI 接的角色都要有自己的 vendor-specific init slash command（Claude 用 `.claude/commands/`、Gemini 用 `.gemini/commands/`，不通用）。第三個 AI 加入時照樣再貼一次對應 prompt。

#### 4.1 通用骨架（非典型組合自填）

派任 prompt 通用骨架在 [`templates/role-invocation-prompt.md.tpl`](./templates/role-invocation-prompt.md.tpl) — 6 個 placeholder 替換完即可貼給任何 AI 接任何角色（含未來新增 vendor / 角色）。

依 [v0.6.0 邀請制](./core/ai-vendor-onboarding.md) + A3「專案 ⊥ 框架」公理，**charter 不主動蒐集每個組合的具體 prompt** — 由採用方依骨架自填。下方 §4.2 兩段是典型雙 AI 配置的已實證填充對照。

#### 4.2 已實證填充範例（典型雙 AI 配置）

**對 Claude Code（Engineer）**：
```
我採用了 AgentCharter，charter 在 ~/.agentcharter/。
請接 Engineer 角色，依 ~/.agentcharter/core/init-template.md §3.3.2
7 步驟自我具象化到 .claude/commands/engineer-init.md。
特別注意：
- step 5（v0.5.10 加）— 簽名前必跑 doctor schema 驗證；
  不通請告訴我（不要強行簽名 _role.md）。
- step 6（v0.7.0 加）— 簽名 _role.md Status 必為 PROVISIONAL，
  不得寫 Sign-in Log（等我 explicit 授權後我會說「請以 Engineer 身份接此專案」
  你才升 ACTIVE 並寫 Sign-in Log）。
- slash command 引用 framework 路徑禁寫死 user home 絕對路徑。
通過後簽名 agent-commons/roles/engineer/_role.md，
回報「step 5 doctor schema 通過 0 errors」+ 「step 6 _role.md PROVISIONAL 簽名完成」。
```

**對 Gemini CLI（PM）**：
```
我採用了 AgentCharter，charter 在 ~/.agentcharter/。
請接 PM 角色，依 ~/.agentcharter/roles/pm/gemini-cli.md（Gemini 的
vendor spec）+ core/init-template.md §3.3.2 自我具象化到
.gemini/commands/pm-init.toml。
特別注意：
- step 5（v0.5.10 加）— 簽名前必跑 doctor schema 驗證；
  不通請告訴我（不要強行簽名 _role.md）。
- step 6（v0.7.0 加）— 簽名 _role.md Status 必為 PROVISIONAL，
  不得寫 Sign-in Log（等我 explicit 授權後我會說「請以 PM 身份接此專案」
  你才升 ACTIVE 並寫 Sign-in Log）。
- slash command 引用 framework 路徑禁寫死 user home 絕對路徑。
通過後簽名 agent-commons/roles/pm/_role.md，
回報「step 5 doctor schema 通過 0 errors」+ 「step 6 _role.md PROVISIONAL 簽名完成」。
```

其他組合（PM × Claude / Validator × Gemini / Cursor × Engineer / auditor × 任一 vendor 等）依 §4.1 骨架自填。

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

### Step 6（v0.10.0+ 推薦）：安裝 commit hook（30 秒）

> v0.10.0 起 charter 提供 vendor 中立的 commit hook（git 原生 + agent-commons 共用 script）— 攔截 6 條紀律違反（_role.md 自激活 / F-mode 雙寫漏 / reflection 檔名 / 雙寫對應 / sprint 編號 warn / handoff directive header warn）。**opt-in、不裝就退化到 advisory 模式**。

在採用方專案根目錄跑：

```bash
bash ~/.agentcharter/tools/vendor/commons/install-git-hooks.sh
```

預期：

```
✅ deployed: agent-commons/_config/hooks/charter-commit-checks.sh
✅ shim installed at .git/hooks/pre-commit
🎉 charter commit hook 安裝完成
```

之後每次 `git commit` 自動跑 H1-H6 校驗。詳見 [`tools/commit-hook-spec.md`](./tools/commit-hook-spec.md)。

---

## 完成 ✅

你現在有：

- ✅ `agent-commons/` 結構齊全（capsules / handoffs / protocols / institutional-memory / state / roles/{engineer,pm}/）
- ✅ 領域公理 doctor 通過
- ✅ 雙 AI 各自有 init slash command 可呼叫
- ✅ commit hook binary 攔截就緒（若跑 Step 6）
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

---

## 變更歷史

- **v1.4（2026-05-06，charter v0.10.3）** — 純 spec sweep + maintainer-only lint binary PATCH 連動 sync。**零採用方動作要求** — 升版只改 profile.yaml `charter_version: "0.10.2"` → `"0.10.3"`、無其他動作。**核心改動**：(a) verify-spec §3.1-§3.5 全 5 軸 22 個 check item 升 spec-as-data 四欄結構（SSS S3 propagate 終局）；(b) 新加 `tools/charter-spec-lint.sh`（maintainer-only、零採用方影響）；(c) README §設計哲學第 5 條加雙軸「升維軌跡」段。**詳細 step-by-step 升版流程見 [`examples/upgrades/v0.10.2-to-v0.10.3.md`](./examples/upgrades/v0.10.2-to-v0.10.3.md)**（採用方 1 步流程）。詳見 CHANGELOG v0.10.3 段。
- **v1.3（2026-05-06，charter v0.10.2）** — commit hook H7 schema-driven 強制必啟集合 **BREAKING-LITE PATCH** 連動 sync（含 v0.10.1 step 0.5 charter version 主動通知配套）。**升 v0.10.2 注意**：⚠️ **BREAKING-LITE** — 升完若 profile.yaml 漏強制必啟欄位（當前 ship REQ-001-F6 = `enable_modes` 必含 F6）下次 commit 被 H7 binary 攔截。**升版 5 步**：(a) `git pull ~/.agentcharter`；(b) `install-git-hooks.sh --update`；(c) 檢查 profile.yaml 對齊 `tools/profiles/_required.yaml`；(d) profile.yaml `charter_version: "0.10.1"` → `"0.10.2"`；(e) commit 測試 H7。**新加檔案**：(1) `tools/profiles/_required.yaml`（H7 schema source of truth、強制必啟集合定義、未來 F7/F8 改本檔即可）；(2) `examples/upgrades/v0.10.1-to-v0.10.2.md`（首個 BREAKING-LITE PATCH walkthrough）。**設計動機**：dogfood signal #46 + #31 + #52 候選累積（公司專案 dbSDK LIVE 三層雙重防禦對 F6 整體失效）。**詳細 step-by-step 升版流程見 [`examples/upgrades/v0.10.1-to-v0.10.2.md`](./examples/upgrades/v0.10.1-to-v0.10.2.md)**。詳見 CHANGELOG v0.10.2 + v0.10.1 段。
- **v1.2（2026-05-05，charter v0.10.0）** — commit hook vendor 中立架構 ship MINOR 連動 sync：5 步流程加 Step 6（v0.10.0+ 推薦）安裝 commit hook（`bash ~/.agentcharter/tools/vendor/commons/install-git-hooks.sh`）。**升 v0.10.0 注意**：(a) 既有採用方升版主要動作就是改 profile.yaml `charter_version` → `"0.10.0"`；(b) commit hook 是 opt-in（不裝就退化 advisory）— 推薦裝、6 條同源 dogfood signal（#33/#35/#42-#45）binary 攔截升維；(c) 架構是 git 原生 hook + agent-commons 共用 script（vendor 中立 — Claude/Gemini/Kiro/Cursor/人類 commit 全攔）。**詳細 step-by-step 升版流程見 [`examples/upgrades/v0.9.x-to-v0.10.0.md`](./examples/upgrades/v0.9.x-to-v0.10.0.md)**。詳見 CHANGELOG v0.10.0 段。
- **v1.1（2026-04-30，charter v0.9.0）** — 紀律完整性 + AI 自我覺察升維 MINOR 連動 sync（dogfood signal #34 LIVE 條款化）：Step 3 preset 表加 essential 一列（v0.9.0 新加、3-5 條 core / < 5k init token、signal #28 progressive adoption + signal #26 ROI 真槓桿）+ 漸進升維路徑說明（essential → minimal → standard → strict）。**升 v0.9.0 注意**：(a) 既有採用方升版主要動作就是改 profile.yaml `charter_version` → `"0.9.0"`；(b) AI self-instantiation 從七步驟升八步驟（加 step 0「讀過去違反紀錄」對應個體學習迴圈 `core/individual-learning-loop §3` 讀紀律）— 既有 slash command 雖仍可用、但 step 0 漏跑 = 命中 F6 surface-level、強烈建議重新具象化；(c) 新範本 `templates/agent-commons/reflection.md.tpl` 為個體層反省範本（雙寫紀律執行載體）；(d) 新 spec `tools/uninstall-spec.md` `/charter-uninstall` 棄用工具設計。**詳細 step-by-step 升版流程（含每步給 AI 的 prompt 範本）見 [`examples/upgrades/v0.8.2-to-v0.9.0.md`](./examples/upgrades/v0.8.2-to-v0.9.0.md)**。詳見 CHANGELOG v0.9.0 段。
- **v1.0（2026-04-27〜2026-04-30，charter v0.5.7 → v0.8.2）** — 初版 5 步流程（前置 / Clone / 寫領域公理 / 跑 init / AI 自我具象化 / 人工二次確認）+ v0.7.x 累積增補（雙路徑領域公理 / Phase 5b 他抽驗 / step 6 PROVISIONAL/ACTIVE 二態 / vendor schema 規範）+ v0.8.x 累積增補（axiom status fail-fast / Step 2 ↔ Step 3 swap / 雙軸矩陣 framing）。
