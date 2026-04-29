# AgentCharter — Adoption Guide

> **受眾**：即將採用 AgentCharter 的團隊（人類 PO + AI 工程師 / PM / 其他角色）
> **AI 優先**：本檔自含足夠 context，AI 讀完即可啟動 self-instantiation 與採用流程
> **版本對齊**：本檔對應 charter `v0.8.0`（依 [versioning-migration.md](./core/versioning-migration.md) §1）
> **本檔不做**：不重複 [core/](./core/) 全文。每段引用具體條款 §段，需要全文時自行 follow。

---

## 0. TL;DR（30 秒）

AgentCharter 是「**多 AI 協作的角色協議框架**」。

把「PM / Engineer / Reviewer」這類職能**從 AI 廠商解綁**：任何 AI（Claude / Gemini / Codex / GPT / 你下個用的 LLM）都能扮演任何角色，協議跨 AI 一致。

**框架本體 = 21 條 core 條款 + 6 份 templates**（其中 1 條 `maintainer-discipline` 是 framework 維護者用，採用方不必啟用）。不需要工具就能採用（手動建目錄 + AI 自律即可）。

**採用識別**：專案根有 `agent-commons/` 目錄 = 用了本框架。

---

## 1. 三條設計公理（+ A4 架構約定）

| 公理 | 含義 |
|---|---|
| **A1. 角色 ⊥ AI** | 「PM」是抽象職能；任何 AI 可扮演；切換扮演者不該改變協議 |
| **A2. AI ⊥ 角色** | 同一 AI 可在不同專案扮演不同角色；身份無黏著 |
| **A3. 專案 ⊥ 框架** | 框架不知道領域差異（金融 / 醫療 / SaaS）；領域風險公理放專案內 |
| **A4. 共同記憶根目錄**（架構級）| 多 AI 共享資產位於**單一根**之下，預設 `agent-commons/`；違反 → 結構違規 |

---

## 2. 5 層守規防線

| 層 | 機制 | 條款 | 強度 |
|---|---|---|---|
| L1 規範注入 | Hook / 主動讀檔 | output-mode-protocol | 軟 |
| L2 違規反省 | 退稿後紀錄 | violation-reflection | 軟 + 集體記憶 |
| L3 結構性反捏造 | 缺 stdout 即退稿 | structural-anti-fabrication | **硬** |
| L4 外部抽驗 | 抽驗權 + F-mode 偵測 | audit-rights + failure-modes | **硬** |
| L5 升級協議 | 強化抽驗 → 使用者裁決 | escalation-protocol | 上限保護 |

**硬層（L3 / L4）不可繞過**；軟層（L1 / L2）依 profile 可配置寬鬆。

---

## 3. 21 條 core 條款（按概念分組）

> **採用方視角**：A 組〜E 組共 20 條對應 `profile.yaml.enabled` 開關（含 2 條架構級前提無開關 + 18 條由 enabled 控制）；F 組 1 條為 **maintainer-only**（採用方無關，三 preset 預設 `false`）。下方分組依此排序。

### A. 角色與職權（4 條）

| 條款 | 一句話 |
|---|---|
| `role-separation.md` | 程式碼權與結案權對稱分離 |
| `audit-rights.md` | 抽驗權不得放棄；結案宣告默認待抽驗 |
| `role-conflict-resolution.md` | 角色決策衝突三級階梯（L0 對話 → L1 條款仲裁 → L2 使用者裁決）|
| `multi-role-tracking.md` | 1 AI 兼 ≥ 2 角色：離岸/上岸宣告 + 身份戳 + 自抽自驗禁令 |

### B. 失敗 / 違規 / 升級（4 條）

| 條款 | 一句話 |
|---|---|
| `failure-modes.md` | F1〜F6（假宣告 / 假 hash / 捏造數據 / 編號偏差 / 規則記憶失效 / **未驗證即宣告就緒**含 surface-level vs structural-level sub-pattern v0.7.0）|
| `structural-anti-fabrication.md` | 缺 stdout 區塊即視同未交付 |
| `violation-reflection.md` | 違規退稿後須補交反省 |
| `escalation-protocol.md` | 連續 ≥2 次升級強化抽驗、≥3 次觸發使用者裁決 |

### C. 證據與交付（3 條）

| 條款 | 一句話 |
|---|---|
| `evidence-first.md` | 隱性 bug 嚴禁盲猜；數字嚴禁心算 |
| `output-mode-protocol.md` | eco / verbose 雙段式 + 自動升級條件 |
| `completion-delivery.md` | 完工 VCP 必含 Directive Header / 雙保險 / 期望錨點 / 失敗解讀表 |

### D. 交接 / 跨 AI（5 條）

| 條款 | 一句話 |
|---|---|
| `handoff-chain.md` | session 末交接鏈必含 7 項（結案級 / 重型）|
| `cross-ai-handoff.md` | 跨 AI 廠商接班：退出方轉移 + 接班方接收 + 強化抽驗不繼承解除權 |
| `working-stack-discipline.md` | DRAFT 暫存堆疊 + save 同步 git commit + session 內物理中斷再續（同身份接班）|
| `init-template.md` | Role Init Mandate：四職責（召喚/校準/簽名/守門）+ 多 AI 自我具象化（v0.5.10：六步驟 → 七步驟，加 step 5 schema 驗證；**v0.7.0**：step 6 簽名 Status 必為 `PROVISIONAL`/`ACTIVE` 二態 + slash command 引用紀律禁絕對路徑）|
| `ai-vendor-onboarding.md` | **新 vendor / 新角色接入「邀請制」四步驟**（v0.6.0）：禁 charter 預先寫死 vendor 層，由真實接觸累積差異 |

### E. 架構 / 配置 / 版本（4 條，含 2 條架構級前提）

| 條款 | 一句話 |
|---|---|
| `common-memory-root.md` | **架構級**：多 AI 共享資產位於單一根（預設 `agent-commons/`）|
| `charter-config.md` | mapping.yaml + profile.yaml schema |
| `domain-axiom-slot.md` | 領域公理槽位：位階（領域 > 核心）+ 撰寫紀律 |
| `versioning-migration.md` | SemVer 對 charter 的具體含義 + 升級流程 |

→ 架構級前提（`common-memory-root` + `charter-config`）採用即啟用，不設開關。其餘 17 條由 `profile.yaml.enabled.<condition>` 控制（v0.6.0 加 `ai-vendor-onboarding` 後）。

### F. Maintainer-only（1 條，採用方無關）

| 條款 | 一句話 |
|---|---|
| `maintainer-discipline.md` | framework 維護者紀律 — spec sync check / DRAFT 紀律也適用維護者；三 preset 預設 `false`（採用方不必啟用）|

→ 採用方修改自己的 charter copy 時不必啟用本條款；其執行載體為 `roles/auditor/_spec.md`（v0.6.0 新增的 maintainer-only 角色概念層）。

---

## 4. agent-commons/ 採用識別目錄結構

```
project-root/
└── agent-commons/                 ← 採用識別
    ├── _config/
    │   ├── profile.yaml           ← 條款啟用 + 參數
    │   └── mapping.yaml           ← 路徑對映 + 領域公理位置
    ├── capsules/                  ← 任務膠囊（PM 主筆）
    ├── handoffs/                  ← HANDOFF_<N>.md 鏈
    ├── protocols/                 ← 領域公理（如 RECON.md / IRON.md）
    ├── institutional-memory/      ← 跨事件知識沉澱
    ├── nextwork.md                ← 任務追蹤主檔
    ├── state/                     ← 工具狀態（output_mode、failure_modes.log）
    └── roles/                     ← 角色私有區
        ├── engineer/{_role.md, sessions/, drafts/, reflections/, private/}
        └── pm/{...}
```

`mapping.yaml.common_memory_root` 可覆寫成自己的目錄名（如沿用既有的 `management/`），但**禁止分散**到多個獨立根。

---

## 5. 三個 preset

| Preset | enabled 條款數 | 適用 |
|---|---|---|
| `minimal.yaml` | 9 / 19 | 探索型 / 單人 + 1 AI / 短期實驗（ai-vendor-onboarding 預設關）|
| `standard.yaml` | 18 / 19（中等參數） | 一般雙 AI 協作 |
| `strict.yaml` | 18 / 19（嚴格上限） | 嚴格合規 / 高風險領域（金融 / 醫療 / 軍工） |

> 註：母數 19 = 21 條 core 條款 - 2 條架構級前提（不設 enabled 開關）。1 條 maintainer-only（`maintainer-discipline`）三 preset 皆預設 `false` — 採用方無關。

詳見 [tools/profiles/](./tools/profiles/)。

---

## 6. 採用流程（T0〜T8）

### T0 採用決策

讀 [README.md](./README.md) → 選 preset → 在 profile.yaml 固定 `charter_version: "0.8.0"`（或當前最新版）。

### T1 接入

依 `tools/init-spec.md` 跑接入流程。AI 自具象化模式（v0.5.9 起 framework 不附實作工具）：

```bash
# 在你專案的 working dir
git clone https://github.com/moerasermax/AgentCharter ~/.agentcharter
```

```
# Prompt 給 AI（Claude / Gemini / Cursor 等）
我採用了 AgentCharter，charter 在 ~/.agentcharter/。

請依 ~/.agentcharter/tools/init-spec.md 跑接入流程：
- preset: standard
- domain-axioms-path: protocols/<YOUR_AXIOM>.md
- domain-axioms-alias: <SHORT_NAME>

完成後請順便具象化為 /charter-init slash command 給未來重用（依
init-template.md §3.3 self-instantiation）。
```

驗證：依 `tools/doctor-spec.md` prompt AI 跑健康檢查。

### T2 AI 自我具象化（**核心，見 §7**）

每個被指派角色的 AI 各自走 init-template §3.3 流程。

### T3 領域公理（v0.7.1 雙路徑）

依 [templates/agent-commons/domain-axioms.md.tpl](./templates/agent-commons/domain-axioms.md.tpl) 寫專案的「血鐵律」。
規範依據：[domain-axiom-slot.md §3](./core/domain-axiom-slot.md)。

**v0.7.1 加：兩條合法路徑（依 [`domain-axiom-slot §3.3`](./core/domain-axiom-slot.md)）**：
- **路徑 A（既有 default）**：user 主筆每條鐵律 → `Status: USER-RATIFIED` + `created_by: user`
- **路徑 B（新加）**：user 邀請 AI 讀既有 codebase 推斷紀律 → 寫 draft（`Status: AI-DRAFTED`）→ user 親自校 → 升 `USER-RATIFIED`。對應 prompt 範本：[`templates/agent-commons/domain-axioms-via-ai-draft-prompt.md.tpl`](./templates/agent-commons/domain-axioms-via-ai-draft-prompt.md.tpl)

**順序紀律（v0.7.2 加）**：T3 必先於 T1 init 完成（init 內 Phase 5b 物理存在校驗會驗 axiom 檔；不在則 fail）。實際採用流程：T0 → T3 → T1 → T2 → T4...

### T4 第一個任務膠囊

PM 寫 capsule（[capsule.md.tpl](./templates/agent-commons/capsule.md.tpl)）→ Engineer **抽驗 capsule** → 接收進入工作。

### T5 完工 VCP + 抽驗

Engineer 提交 VCP（含 stdout 原文，依 structural-anti-fabrication）→ PM 抽驗 → 結案。

### T6〜T8 視觸發場景走

- 違規事件 → violation-reflection.md → 寫 reflection
- 衝突事件 → role-conflict-resolution.md L0/L1/L2 階梯
- 跨 AI 接班 → cross-ai-handoff.md 退出/接收職責
- 多角色短暫 → multi-role-tracking.md 三項防呆
- session 末 → handoff-chain.md 7 項 HANDOFF

---

## 7. AI 自我具象化指引（核心）

> **如果你是即將被指派角色的 AI，本段是你最該看的部分。**

依 [init-template.md §3.3.2](./core/init-template.md) 的 **7 步驟流程**（v0.5.10 從 6 → 7 步、v0.7.0 加 step 6 PROVISIONAL/ACTIVE 紀律）：

```
1. 讀 charter（路徑由使用者提供或環境變數 $CHARTER_DIR）：
   - core/init-template.md（§3.3 自我具象化規範）
   - core/{role-separation,audit-rights,...}.md（依 profile 啟用）
   - roles/<role>/_spec.md（職能定義）
   - roles/<role>/<my-vendor>.md（若存在；無則自評能力）
   - templates/role-init.md.tpl（共通骨架）

2. 讀專案配置：
   - <common-memory-root>/_config/profile.yaml
   - <common-memory-root>/_config/mapping.yaml
   - <common-memory-root>/protocols/<axiom>.md（領域公理）

3. 自我具象化 — 在自己 AI 系統的標準位置生成 init 容器：
   - Claude Code → .claude/commands/<role>-init.md
   - Gemini CLI → .gemini/commands/<role>-init.toml
   - Cursor → .cursor/rules/<role>-init.mdc
   - 其他無 slash 系統 → <common-memory-root>/roles/<role>/init-prompt.md

4. 內容生成原則：
   - 套 templates/role-init.md.tpl 變數
   - 內部執行五步驟（init-template §6）達 §2 等效最終狀態
   - 加入該 AI 廠商特有的工具呼叫

5. 驗證 schema 合規（v0.5.10 加，強制驗證點）：
   - 依 ~/.agentcharter/tools/doctor-spec.md 跑 schema 驗證
   - 必驗：profile.yaml schema / mapping.yaml 必填欄位 / 領域公理檔存在
   - 不通則回到 step 2-3 修補；step 6 簽名禁止（具象化視為失敗）
   - 跳過 step 5 = F6 假宣告（未驗證即宣告就緒）

6. 簽名（v0.7.0 加紀律：限「具象化痕跡」、禁寫「激活痕跡」）：
   - 更新 <common-memory-root>/roles/<role>/_role.md 的「各 AI 具象化位置」表
   - 自己廠商的「是否實裝？」改為 ✅
   - 切換歷史追加「自我具象化完成（doctor schema 通過）」
   - **Status 欄位寫 `PROVISIONAL`**（暫具象化、未經 user explicit 授權激活）
   - **不得寫 Sign-in Log**（Sign-in Log 是激活的紀錄、user explicit 授權後才寫）
   - vendor spec 預設身份（如 `roles/pm/gemini-cli.md`）= 能力預設、不是自動激活授權
   - 對應 `core/multi-role-tracking.md §3.4.4` init 階段自我激活同樣 = F1
   - **slash command 引用紀律**：禁寫死絕對路徑（如 `C:/Users/<name>/.agentcharter/`）；推薦三層優先序：(a) 環境變數 `$AGENTCHARTER_HOME` (b) 相對 user home `~/.agentcharter/...` (c) 採用方專案內相對路徑

7. 回報使用者：
   - 「我已建好 <role>-init，位於 <具象化位置>」
   - 「step 5 doctor schema 驗證已通過（0 errors）」
   - 「Status: PROVISIONAL — 等你下達 `/<role>-init` 命令並 explicit 授權我接該角色後，才會升 ACTIVE 並寫 Sign-in Log」
   - 邀請使用者立刻跑一次驗證
```

**禁令**：要求使用者手動寫該 AI 的 slash command（違反「角色 ⊥ AI」公理 + 「替換性保證」）。

---

## 8. 接入第一週工作清單（人類 PO + AI 共做）

| Day | 動作 | 主筆 |
|---|---|---|
| Day 1 | 讀 README + 本檔 + 20 條 core（採用方視角）；選 preset | PO |
| Day 1 | 手動建 `agent-commons/` 結構；寫 mapping.yaml + profile.yaml | PO |
| Day 1〜2 | 各 AI 跑 self-instantiation（§7）→ 簽名 `_role.md` | 各 AI |
| Day 2〜3 | 寫領域公理 `protocols/<axiom>.md`（依 domain-axiom-slot §3）| PO + AI 共寫 |
| Day 3〜4 | PM 寫第一個任務膠囊 → Engineer 抽驗 → 接收 | PM AI |
| Day 4〜5 | Engineer 落實 → 提 VCP → PM 抽驗 → 結案 | Engineer AI |
| Day 6〜7 | session 末寫 HANDOFF；同步 nextwork.md | 主導角色 AI |

→ 完成後 = 第一個 capsule 跑完整生命週期，框架接入完成。

---

## 9. 場景對照表（觸發點 → 條款 → 動作）

| 場景 | 觸發條款 | 動作摘要 |
|---|---|---|
| AI 提交內容缺 stdout | structural-anti-fabrication | 抽驗方直接退稿，不進入內容審查 |
| 同類偏差累計 ≥ 2 次 | escalation-protocol §1 | 進入強化抽驗模式（所有宣告須附 stdout 原文）|
| 兩角色決策分歧（無人錯）| role-conflict-resolution §3 | 走 L0 對話（≤ 2 回合）→ L1 條款仲裁 → L2 使用者裁決 |
| AI 廠商換手（如 Gemini → Claude）| cross-ai-handoff | 退出方寫能力快照；接班方走 init + 能力差異盤點 |
| 同 AI 兼任 ≥ 2 角色 | multi-role-tracking §3 | 切換必走離岸/上岸宣告 + 身份戳；禁同 session 自抽自驗 |
| **session 內物理中斷再續**（context 重啟 / 額度恢復 / 模型切換）| **working-stack-discipline §5** | **同 AI 同身份；讀最新 HANDOFF + DRAFT_CONTEXT；不寫新身份戳、不追加切換歷史** |
| **DRAFT 累積到一定程度需階段保存** | **working-stack-discipline §3** | **save 觸發：DRAFT → HANDOFF 摘要 + 歸檔 + git commit + 清空 DRAFT（六步不可拆）** |
| 條款升級（charter v0.5.x → v0.6）| versioning-migration §3 | 讀 CHANGELOG → /charter-doctor dry-run → migration → 升 charter_version |
| 領域公理與 core 衝突 | domain-axiom-slot §2.1 | **領域公理優先**（A3 公理具體執行） |

---

## 10. 框架邊界（**不採用什麼**）

避免誤把框架當萬能鎖：

| 不管 | 動機 |
|---|---|
| ❌ 領域風險規則（金額計算 / HIPAA / 認證流程）| 屬領域公理槽位（domain-axiom-slot），框架只提供位階 |
| ❌ 工具自動化（CLI / IDE 整合 / 自動 doctor）| 框架是規範，工具層是 nice-to-have；當前 `tools/{scan,init,doctor}-spec.md` 是 spec only |
| ❌ LICENSE / 多語系 / CI | v1.0 公開化前再決定 |
| ❌ AI 推論能力評估 | 框架不知道某 AI 該不該扮演某角色；由 vendor spec + AI 自評處理 |
| ❌ 程式語言 / 框架選型 / 部署方式 | 與本框架正交 |

---

## 11. 延伸閱讀（路徑表）

| 想知道什麼 | 去哪 |
|---|---|
| **人類採用方的 5 分鐘入門** | **[QUICKSTART.md](./QUICKSTART.md)** |
| **人類採用方的 reference 工具書** | **[TUTORIAL.md](./TUTORIAL.md)** |
| 條款全文 | [core/](./core/)（21 個 .md）|
| 工具（charter-init / charter-doctor）| [tools/](./tools/) |
| 模板（capsule / handoff / IM / nextwork / domain-axioms / _role）| [templates/agent-commons/](./templates/agent-commons/) |
| 角色職能定義 | [roles/<role>/_spec.md](./roles/) |
| AI 廠商實作版（vendor spec）| [roles/<role>/<ai-vendor>.md](./roles/)（當前僅 Claude Engineer 完整）|
| 三個 preset 模板 | [tools/profiles/](./tools/profiles/)（minimal / standard / strict）|
| 工具 spec（未實作）| [tools/{scan,init,doctor}-spec.md](./tools/) |
| 真實採用案例 | [examples/cryptobot/mapping.md](./examples/cryptobot/mapping.md) |
| 版本紀錄 + BREAKING 標籤 | [CHANGELOG.md](./CHANGELOG.md) |
| 治理規則（誰可 merge / 衝突如何處理）| [GOVERNANCE.md](./GOVERNANCE.md) |
| 貢獻流程 | [CONTRIBUTING.md](./CONTRIBUTING.md) |

---

## 12. 採用就緒檢查（self-check）

採用方在 Day 7 結束前應能對所有問題回答 ✅：

- [ ] `agent-commons/` 目錄結構齊全（依 §4）+ **agent-commons/shared/ 不存在**（v0.7.0 doctor §3.7 E602 — namespace ≠ 檔案路徑）
- [ ] `_config/profile.yaml` 含 `charter_version: "0.8.0"`（或當前最新版）+ 選定 preset
- [ ] `_config/profile.yaml` 內 `parameters.failure-modes.enable_modes` **含 F6**（v0.5.10 加 / v0.7.0 強制必啟、doctor §3.7 E605）
- [ ] `_config/mapping.yaml` 含 `common_memory_root` + `domain_axioms.primary` + `working_stack_discipline.shared.draft_context`
- [ ] `_config/mapping.yaml` 內 `layout.<key>` 不含 `shared/` / `roles/` 等 namespace 同名中介層（v0.7.0 doctor §3.7 E601 — namespace ≠ 檔案路徑）
- [ ] `protocols/<axiom>.md` 已寫且符合 [domain-axiom-slot §3.1](./core/domain-axiom-slot.md) 強制要求（每條有後果段、可驗證、有編號）；**Status 為 USER-RATIFIED**（v0.7.1：路徑 A user 主筆 / 路徑 B AI 代產 + user 校升）
- [ ] 每個被指派角色的 AI 已自我具象化（`_role.md` 切換歷史首版到位）；**`_role.md` Status 為 PROVISIONAL/ACTIVE 正確態**（v0.7.0：未經 user explicit 授權前須為 PROVISIONAL、Sign-in Log 為空）
- [ ] **跑過 init Phase 5b 他抽驗**（v0.7.0：fresh-context sub-agent / 邀其他 vendor / user 親跑 PowerShell 三條路徑擇一）— 抽驗集 10 項全綠
- [ ] 至少 1 個 capsule 跑完整生命週期（PM 寫 → Engineer 抽驗 → 接收 → 完工 VCP → PM 抽驗 → 結案）
- [ ] 第一份 HANDOFF 寫成（依 [handoff-chain §2](./core/handoff-chain.md) 7 項齊全）
- [ ] AI 與 PO 都能引用至少 5 條 core 條款 + 1 條領域公理 + 1 個 F-mode（**含 F6**）
- [ ] **`/charter-upgrade-verify` 5 軸全綠**（v0.8.0 加新工具）— 升版 / 接入完成後跑、確認軸 A clone 對齊 / 軸 B schema / 軸 C 結構合規 / 軸 D axiom 紀律（含 frontmatter `status: USER-RATIFIED` 校驗）/ 軸 E stale reference 全綠

→ 全綠 = 採用完成；任一未綠 = 找對應條款回頭補。

---

## 13. 變更歷史

- **v1.8（2026-04-29，charter v0.8.0）** — 升版 + 接入防呆強化（slim 版）連動 sync：line 5 / 149 / 336 charter_version v0.7.5 → v0.8.0 + §12 採用就緒 self-check 加新項「`/charter-upgrade-verify` 5 軸全綠」（v0.8.0 新工具、軸 D 含 axiom frontmatter `status: USER-RATIFIED` 校驗）。**採用方升 v0.8.0 注意事項**：(a) `tools/doctor-spec.md §3.8` vendor schema check 從 spec 層升實作層、E801/W802 強制 — 既有 vendor toml/md 不合規（如 Gemini CLI nested table）會抓新 ERROR、升版前須先跑 doctor 修補；(b) `tools/doctor-spec.md §3.9` 新加 axiom 紀律對齊（E606/E607/W608）— 既有 axiom 若 frontmatter `status: AI-DRAFTED` 會抓 E606、需校 axiom + 升 USER-RATIFIED + 加校正紀錄行；(c) `tools/init-spec.md` Phase 5b CHECK 7 ext — 新接入採用方若 axiom 未升 USER-RATIFIED → init 失敗；(d) 新 spec `tools/post-upgrade-verify-spec.md` 提供 `/charter-upgrade-verify` 工具（user 自具象化為 slash command、跑 5 軸 A/B/C/D/E 校驗）；(e) `QUICKSTART.md` Step 2 ↔ Step 3 swap（axiom 寫在前、init 跑在後）— 對齊 v0.7.0 Phase 5b 物理存在校驗精神、移除 v0.7.2 cross-reference 警告。**升版推薦流程**：1) 跑 /charter-doctor 看不合規項；2) 修補（升 axiom status / 修 vendor schema）；3) profile.yaml `charter_version: "0.8.0"`；4) 自具象化 /charter-upgrade-verify；5) 跑 /charter-upgrade-verify 確認 5 軸全綠。**對應 dogfood-driven hardening 第十一循環** — signal #23 條款化 + #16 升實作層 + #10 升結構修正、三 signal 同 LIVE session 條款化 + SSS S1/S2 首次 capture。詳見 CHANGELOG v0.8.0 段。
- **v1.7（2026-04-28，charter v0.7.5）** — 跨多版本升級指引補完：line 5 / 149 / 336 charter_version v0.7.4 → v0.7.5 + 引用 `core/versioning-migration §3.4`（跨多 MINOR 累積升級流程子段、含「停用一段時間後重新採用」場景具體指引）+ `examples/upgrades/yc-aiagentcrew-v0.5.9-to-v0.7.4.md`（charter 第一個跨版本 walkthrough、回鍋開發者無痛實證）。**採用方升 v0.7.5 注意**：純擴增 / 零動作 migration（只改 profile.yaml charter_version）。對應 v0.7.3 北極星紀律「回鍋開發者無痛」第一個實證 ship。
- **v1.6（2026-04-28，charter v0.7.4）** — vendor 端 slash command schema 規範條款化（dogfood signal #16）：line 5 / 149 / 336 charter_version v0.7.3 → v0.7.4 + §7 self-instantiation 步驟對應提示 vendor schema 規範段（`roles/pm/gemini-cli.md §3.6` toml 扁平結構強制 / `roles/engineer/claude-code.md §4.1` .md 純 markdown 規範）。**採用方升 v0.7.4 注意**：純擴增 / 零動作 migration、doctor 不跑新 check（實作層留 v0.8+ 啟用、已於 v0.8.0 啟用、見 v1.8 entry）。
- **v1.5（2026-04-28，charter v0.7.3）** — 主體內容對齊 v0.7.x 系列（auditor 完整 sweep 抓 10 ERROR + 3 WARN）：§3 B 組 failure-modes F1〜F5 → F1〜F6（含 surface vs structural sub-pattern）+ §3 D 組 init-template 一句話加 v0.7.0 step 6 PROVISIONAL/ACTIVE + slash 引用紀律 + §6 T0 charter_version v0.6.1 → v0.7.3 + §6 T3 加 v0.7.1 雙路徑 + v0.7.2 順序紀律提醒 + §7 self-instantiation 6 → 7 步 + step 6 PROVISIONAL/ACTIVE 紀律 + step 5 doctor 強制驗證點 + §12 採用就緒 self-check 加 5 條 v0.7.x 必查項（含 F6 啟用 / shared/ 不存在 / Phase 5b 他抽驗 / Status PROVISIONAL/ACTIVE）。**重要追溯**：v0.7.0 應分類為 BREAKING-LITE（含兩個既有採用方 migration 點：F6 強制必啟 + mapping 移除 shared/ 中介層）而非 MINOR — 詳見 CHANGELOG v0.7.0 entry。
- **v1.4（2026-04-28，charter v0.7.1 + v0.7.2 補記）** — 補 v0.7.1 / v0.7.2 兩個 release 對應 ADOPTION 變更歷史 entry：v0.7.1 雙路徑（user 主筆 vs AI 代產 + user 校）+ frontmatter scaffold（Status / mutability_default / created_by / created_at）；v0.7.2 流程順序 cross-reference（實際執行 1 → 3 → 2 → 4 → 5）+ structural-anti-fabrication §5 補三行反向引用 + maintainer-discipline §3.4 文檔層 sync checklist。
- **v1.3（2026-04-28，charter v0.7.0）** — 公司專案接入失敗大批次 sync（5 個 dogfood signal 一次條款化）：line 5 charter_version v0.6.1 → v0.7.0 + 連動條款新增段引用（init-spec Phase 5b 採用方半邊「他抽」載體 / multi-role-tracking §3.4.4 init 階段自激活紀律 / init-template §3.3.2 step 6 Status PROVISIONAL/ACTIVE 二態 / failure-modes F6 sub-pattern surface vs structural / doctor-spec §3.7 結構頂層 + namespace 校驗）+ 本變更歷史段。詳見 `.claude_temp/COMPANY-ONBOARDING-FAILURE-AUDIT.md` 完整 audit 紀錄。**採用方升 v0.7.0 注意事項**：(a) profile.yaml `parameters.failure-modes.enable_modes` 須含 F6（v0.5.10 加但 preset 漏改、v0.7.0 強制必啟）；(b) 既有 mapping.yaml 若含 `shared/<X>/` 中介層 → doctor §3.7 報 ERROR、要把目錄內容移到頂層 + 改寫 mapping。
- **v1.2（2026-04-28，charter v0.6.1）** — 文檔層 sync 修補（v0.6.0 release 漏的 ADOPTION 同步點，由 v0.6.1 auditor 第一次實戰抽驗抓到 — dogfood signal #6 候選）：line 5 charter_version 對齊 + §5 preset 表母數 16 → 19 + §6 T0 + §12 採用就緒檢查 charter_version 對齊 + 本變更歷史段。
- **v1.1（2026-04-28，charter v0.6.0）** — 條款數 20 → 21、§3 加 D 組第 5 條 ai-vendor-onboarding + 新增 F 組 maintainer-only 分區、line 286 條款數同步。
- **v1（2026-04-27，charter v0.5.6）** — 初版。為「給接班 AI 快速理解並啟用」而寫，自含 context、引用具體條款 §段、提供採用就緒 self-check。
