# AgentCharter — Adoption Guide

> **受眾**：即將採用 AgentCharter 的團隊（人類 PO + AI 工程師 / PM / 其他角色）
> **AI 優先**：本檔自含足夠 context，AI 讀完即可啟動 self-instantiation 與採用流程
> **版本對齊**：本檔對應 charter `v0.10.3`（依 [versioning-migration.md](./core/versioning-migration.md) §1）
> **本檔不做**：不重複 [core/](./core/) 全文。每段引用具體條款 §段，需要全文時自行 follow。

---

## 0. TL;DR（30 秒）

AgentCharter 是「**多 AI 協作的角色協議框架**」。

把「PM / Engineer / Reviewer」這類職能**從 AI 廠商解綁**：任何 AI（Claude / Gemini / Codex / GPT / 你下個用的 LLM）都能扮演任何角色，協議跨 AI 一致。

**框架本體 = 25 條 core 條款 + 7 份 templates**（其中 1 條 `maintainer-discipline` 是 framework 維護者用，採用方不必啟用）。不需要工具就能採用（手動建目錄 + AI 自律即可）。

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

## 3. 25 條 core 條款（按概念分組）

> **採用方視角**：A 組〜E 組共 24 條對應 `profile.yaml.enabled` 開關（含 2 條架構級前提無開關 + 22 條由 enabled 控制）；F 組 1 條為 **maintainer-only**（採用方無關，三 preset 預設 `false`）。下方分組依此排序。

### A. 角色與職權（4 條）

| 條款 | 一句話 |
|---|---|
| `role-separation.md` | 程式碼權與結案權對稱分離 |
| `audit-rights.md` | 抽驗權不得放棄；結案宣告默認待抽驗 |
| `role-conflict-resolution.md` | 角色決策衝突三級階梯（L0 對話 → L1 條款仲裁 → L2 使用者裁決）|
| `multi-role-tracking.md` | 1 AI 兼 ≥ 2 角色：離岸/上岸宣告 + 身份戳 + 自抽自驗禁令 |

### B. 失敗 / 違規 / 升級（5 條）

| 條款 | 一句話 |
|---|---|
| `failure-modes.md` | F1〜F6（假宣告 / 假 hash / 捏造數據 / 編號偏差 / 規則記憶失效 / **未驗證即宣告就緒**含 surface-level vs structural-level sub-pattern v0.7.0）|
| `structural-anti-fabrication.md` | 缺 stdout 區塊即視同未交付 |
| `violation-reflection.md` | 違規退稿後須補交反省 |
| `escalation-protocol.md` | 連續 ≥2 次升級強化抽驗、≥3 次觸發使用者裁決 |
| `diagnose-remediate-protocol.md` | **（v0.9.0 加）**SSS S3 架構級條款化 — spec-as-data 結構（合規規定 / 修補方向 + 約束 / 反例 / 真實 stdout 證據）+ commit hook vendor 邀請制加固 + 真實 stdout 證據要求 |

### C. 證據與交付（3 條）

| 條款 | 一句話 |
|---|---|
| `evidence-first.md` | 隱性 bug 嚴禁盲猜；數字嚴禁心算 |
| `output-mode-protocol.md` | eco / verbose 雙段式 + 自動升級條件 |
| `completion-delivery.md` | 完工 VCP 必含 Directive Header / 雙保險 / 期望錨點 / 失敗解讀表 |

### D. 交接 / 跨 AI（6 條）

| 條款 | 一句話 |
|---|---|
| `handoff-chain.md` | session 末交接鏈必含 7 項（結案級 / 重型）|
| `cross-ai-handoff.md` | 跨 AI 廠商接班：退出方轉移 + 接班方接收 + 強化抽驗不繼承解除權 |
| `working-stack-discipline.md` | DRAFT 暫存堆疊 + save 同步 git commit + session 內物理中斷再續（同身份接班）|
| `init-template.md` | Role Init Mandate：四職責（召喚/校準/簽名/守門）+ 多 AI 自我具象化（v0.5.10：六步驟 → 七步驟，加 step 5 schema 驗證；**v0.7.0**：step 6 簽名 Status 必為 `PROVISIONAL`/`ACTIVE` 二態 + slash command 引用紀律禁絕對路徑；**v0.9.0**：七步驟 → 八步驟、加 step 0「讀過去違反紀錄」對應個體學習迴圈）|
| `ai-vendor-onboarding.md` | **新 vendor / 新角色接入「邀請制」四步驟**（v0.6.0）：禁 charter 預先寫死 vendor 層，由真實接觸累積差異 |
| `individual-learning-loop.md` | **（v0.9.0 加、第 13 個架構級概念、補完接班場景四軸的第 4 軸）**個體 AI 跨任務 / 跨 session 學習迴圈：寫紀律（雙寫個體 `roles/<role>/reflections/` + 集體 `state/failure_mode_log.md`）+ 讀紀律（init step 0 強制讀）+ 跨 session 學習迴圈（接班 AI 紀律繼承）|

### E. 架構 / 配置 / 版本（6 條，含 2 條架構級前提）

| 條款 | 一句話 |
|---|---|
| `common-memory-root.md` | **架構級**：多 AI 共享資產位於單一根（預設 `agent-commons/`）|
| `charter-config.md` | mapping.yaml + profile.yaml schema |
| `domain-axiom-slot.md` | 領域公理槽位：位階（領域 > 核心）+ 撰寫紀律 |
| `versioning-migration.md` | SemVer 對 charter 的具體含義 + 升級流程 |
| `adoption-lifecycle.md` | **（v0.9.0 加）**5 階段 lifecycle 完整化：全新接入 / 升版 / 棄用（含「保留最後的溫柔」精神）/ 重新採用 / vendor 升級 path 三路徑（A 維持現狀 / B 開 issue / C AI 自驅修復對齊 SSS S1 子集）|
| `condition-mutability.md` | **（v0.9.0 加）**condition mutability 紀律本體：三層 mutability（IMMUTABLE-by-AI / APPEND-ONLY / FULL-MUTABLE）+ 3-strike 刪除協議 + user-initiated consolidation + AI 修訂權限分層 |

→ 架構級前提（`common-memory-root` + `charter-config`）採用即啟用，不設開關。其餘 23 條由 `profile.yaml.enabled.<condition>` 控制（v0.6.0 加 `ai-vendor-onboarding` 後 19 → 21 / v0.9.0 加 4 條後 21 → 23、含 1 條 maintainer-only 預設 false 共 22 條採用方有效）。

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

## 5. 四個 preset

| Preset | enabled 條款數 | 適用 |
|---|---|---|
| `essential.yaml`（v0.9.0 加）| 3-5 / 23 | 探索期 / 單人 / 快迭代 / 想要 AI 別瞎掰但不想要全套儀式成本（< 5k init token）|
| `minimal.yaml` | 10 / 23 | 探索型 / 單人 + 1 AI / 短期實驗（含 individual-learning-loop = true）|
| `standard.yaml` | 22 / 23（中等參數） | 一般雙 AI 協作（v0.9.0 後含 4 條新加 condition）|
| `strict.yaml` | 22 / 23（嚴格上限） | 嚴格合規 / 高風險領域（金融 / 醫療 / 軍工） |

> 註：母數 23 = 25 條 core 條款 - 2 條架構級前提（不設 enabled 開關）。1 條 maintainer-only（`maintainer-discipline`）四 preset 皆預設 `false` — 採用方無關。
>
> v0.9.0 加 essential preset 對應 dogfood signal #28 progressive adoption + #26 init token cost / ROI 真槓桿；minimal 加 individual-learning-loop = true 對應 user 明示「框架必備」（signal #34）。

詳見 [tools/profiles/](./tools/profiles/)。

---

## 6. 採用流程（T0〜T8）

### T0 採用決策

讀 [README.md](./README.md) → 選 preset → 在 profile.yaml 固定 `charter_version: "0.10.0"`（或當前最新版）。

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

**v0.10.0+ 推薦**：init 完成後跑 `bash ~/.agentcharter/tools/vendor/commons/install-git-hooks.sh` 安裝 commit hook（vendor 中立 binary 攔截、6 條同源 signal #33/#35/#42-#45 結構強制）。詳見 [`tools/commit-hook-spec.md`](./tools/commit-hook-spec.md)。

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
- [ ] `_config/profile.yaml` 含 `charter_version: "0.9.0"`（或當前最新版）+ 選定 preset
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
- [ ] **個體學習迴圈合規**（v0.9.0 加、`core/individual-learning-loop §6` 對齊、doctor §3.11 校驗）— 每個 ACTIVE 角色 `agent-commons/roles/<role>/reflections/` 目錄存在 + 至少一個 reflection 檔（W1101）+ failure_mode_log F-mode 命中 entry 都有對應個體層 reflection 雙寫對應（W1102）+ reflection 檔 frontmatter 完整 5 欄（E1103）
- [ ] **AI self-instantiation 八步驟對齊**（v0.9.0 加、`core/init-template §3.3.2` 七步驟 → 八步驟）— 每個 ACTIVE 角色 slash command 含 step 0「讀過去違反紀錄」（individual-learning-loop §3 讀紀律）

→ 全綠 = 採用完成；任一未綠 = 找對應條款回頭補。

---

## 13. 變更歷史

- **v1.18（2026-05-06，charter v0.10.3）** — 純 spec sweep + maintainer-only lint binary PATCH 連動 sync。**零採用方動作要求** — 升版只改 `agent-commons/_config/profile.yaml` `charter_version: "0.10.2"` → `"0.10.3"`、無其他動作（向下兼容、純文檔 / spec / maintainer 工具層擴增）。**升版內容**：(a) `tools/post-upgrade-verify-spec.md §3.1-§3.5` 全 5 軸 22 個 check item 升 spec-as-data 四欄結構（合規規定 / 修補方向 + 約束 / 反例 / 真實 stdout 證據要求、SSS S3 propagate 終局議程落地、~660 行 spec-as-data 四欄結構加固）；(b) `tools/doctor-spec.md §3` 段首加全局「真實 stdout 證據要求」紀律段（覆蓋 §3.1-§3.12 所有 W/E codes）；(c) `README.md §設計哲學`第 5 條雙軸座標加「升維軌跡 — 結構強制升維紀錄」段（雙軸 framing 第三段、列出 charter v0.5.7 起 11 個 dogfood-driven hardening 循環的弱保證項升維 trajectory + 未來升維候選議程 + Schema-driven 升維設計樣板對齊 user LIVE 提問「F7 一樣可以解嗎」結構性解）；(d) `tools/charter-spec-lint.sh` 新檔（v1.0 maintainer-only binary、L1 tool spec 四欄結構 + L2 core 雙軸 blockquote 偵測、bash + grep + sed 無新依賴、跑全 charter 0 errors / 0 warnings）；(e) `core/maintainer-discipline.md §3.1.1` 加 lint binary 紀律段。**設計動機**：對應 user 2026-05-06 LIVE 提問「**升版這些檢查可否自動納入新設計、不然每次都很容易漏掉**」+ dogfood signal #46（≥ 3 次）/ #31（≥ 5 次同類同 session）SSS S3 propagate 終局議程。把 spec 結構合規從「LLM 自律 + maintainer 自律」升維為「**靜態結構樣板（spec 段首全局紀律）+ 動態結構偵測（lint binary）**」雙層自動化。**對應 v0.7.3 北極星「不讓 user 記」延伸到「不讓 maintainer 記」**（規範自動化的元層落地）。**詳細 step-by-step 升版流程見 [`examples/upgrades/v0.10.2-to-v0.10.3.md`](./examples/upgrades/v0.10.2-to-v0.10.3.md)**（純 spec sweep walkthrough、採用方 1 步流程）。詳見 CHANGELOG v0.10.3 段。
- **v1.17（2026-05-06，charter v0.10.2）** — commit hook H7 schema-driven 強制必啟集合 **BREAKING-LITE PATCH** 連動 sync（含 v0.10.1 step 0.5 charter version 主動通知 sync 補齊）。**採用方升 v0.10.2 注意事項**：⚠️ **BREAKING-LITE** — 採用方升完若 profile.yaml 漏強制必啟欄位（當前 ship **REQ-001-F6** = `enable_modes` 必含 F6、v0.7.0+ standard/strict 強制必啟）下次 commit 被 H7 binary 攔截、不可繞（除非走 `--no-verify`）。對齊 user 紀律「**有衝突就代表沒有向下兼容**」（v0.7.0 mislabel 教訓）。**升版 5 步流程**：(a) `git pull ~/.agentcharter` 拿新 `tools/profiles/_required.yaml`（schema source of truth）+ `charter-commit-checks.sh v1.1`（含 H7）；(b) 跑 `bash ~/.agentcharter/tools/vendor/commons/install-git-hooks.sh --update` 同步 deploy script；(c) **檢查 profile.yaml 對齊 `_required.yaml`**：當前 ship REQ-001-F6 → `parameters.failure-modes.enable_modes` 必含 `F6`（如 dbSDK case 漏 F6 → 補 F6）；(d) `agent-commons/_config/profile.yaml` `charter_version: "0.10.1"` → `"0.10.2"`；(e) commit 測試 H7 攔截（合規→ PASS、漏項 → reject + 修法路徑）。**設計動機**：dogfood signal #46（≥ 3 次同類）+ #31（≥ 5 次同類同 session）+ #52 候選（user 直接條款化、不走累積門檻）— 2026-05-06 公司專案 dbSDK LIVE：Engineer Claude verify + Gemini PM doctor 同 session 連續 simulated PASS、profile.yaml 漏 F6 都沒抓、user 親手抓 + 詰問「我們的 doctor 會驗證出來嗎」「以後 F7 一樣可以解嗎」。三層雙重防禦（init/doctor/verify spec）對 F6 強制必啟整體 LIVE 失效 → H7 schema-driven binary 兜底。**未來擴展紀律**：charter 加新強制必啟欄位（如未來 F7）→ 改 `_required.yaml` 加 entry + 補對應 hook inline check（5-10 行 bash）→ 採用方 git pull 即傳播、**不需再加 H8/H9 binary**（schema-driven 單一擴展點、避免 hook 數爆炸）。**對應 v0.8.2 §設計哲學第 5 條「弱保證項升結構強制」最赤裸 LIVE 實證** + **dogfood signal #27「spec-driven 與 LLM 自律 循環依賴」結構性解** + **v0.7.3 北極星「不讓 user 記」延伸到「強制必啟集合不讓 user 記憶哪幾條必啟」**。**v0.10.1 step 0.5 配套**（之前 v0.10.1 ship 採用方文檔層漏 sync、本 entry 一併補完）：`core/init-template §3.3.2` 加 step 0.5（charter version 比對 + 主動通知）— AI 在 step 0 後讀 framework 當前版本（讀 CHANGELOG）vs profile.yaml charter_version，三分支處理（equal 跳過 / framework > project INFO / framework < project ERROR）；對齊 v0.7.3 北極星「不讓 user 想到去比對版本」。**詳細 step-by-step 升版流程見 [`examples/upgrades/v0.10.1-to-v0.10.2.md`](./examples/upgrades/v0.10.1-to-v0.10.2.md)**（首個 BREAKING-LITE PATCH walkthrough）。詳見 CHANGELOG v0.10.2 + v0.10.1 段。
- **v1.16（2026-05-05，charter v0.10.0）** — commit hook vendor 中立架構 ship MINOR 連動 sync：T1 接入流程加「v0.10.0+ 推薦：跑 install-git-hooks.sh」+ T0 charter_version 範例值升 v0.10.0。**採用方升 v0.10.0 注意事項**：(a) 升版主要動作改 `charter_version: "0.9.x"` → `"0.10.0"`；(b) commit hook 是 opt-in（`bash ~/.agentcharter/tools/vendor/commons/install-git-hooks.sh`）— 推薦裝、6 條同源 dogfood signal（#33 不自報 / #35 自激活累積 2 次 / #42 雙寫漏 / #43 檔名漂浮 / #44 sprint 混 reflection / #45 致 XXX 缺）binary 攔截升維；(c) 架構是 git 原生 hook + agent-commons 共用 script（vendor 中立 — Claude/Gemini/Kiro/Cursor/人類 commit 全攔）；(d) 不寫進 vendor 私有目錄、對齊「ai-vendor-onboarding §1 邀請制原則 + framework 不代寫 vendor 層」精神；(e) 新加 `core/cross-ai-handoff §3.3` directive header「致 XXX」標準格式（signal #45 條款化、commit-hook H6 校驗載體）。**詳細 step-by-step 升版流程見 [`examples/upgrades/v0.9.x-to-v0.10.0.md`](./examples/upgrades/v0.9.x-to-v0.10.0.md)**。詳見 CHANGELOG v0.10.0 段。
- **v1.15（2026-05-01，charter v0.9.6）** — checkpoints save 後交班詢問 + `deactivate_all_active` PATCH 連動 sync：`tools/vendor/commons/checkpoints_handler.sh`（v2.1 → v2.2）+ `roles/pm/gemini-cli.md §3.7`（v1.4 → v1.5）TOML save 流程加 step 7 交班詢問。**採用方升 v0.9.6 注意事項**：(a) 升版只改 `charter_version: "0.9.5"` → `"0.9.6"`；(b) 需重新跑 PM init `§3.7` 更新 `.gemini/commands/checkpoints.toml`（save flow 新增 step 7）；(c) 部署新版 `checkpoints_handler.sh v2.2`（從 `tools/vendor/commons/` 複製至 `~/.gemini/`）以啟用 `deactivate_all_active` action。詳見 CHANGELOG v0.9.6 段。
- **v1.14（2026-05-01，charter v0.9.3）** — checkpoints_handler.sh 自動版本偵測 + 升版引導 PATCH 連動 sync：`roles/pm/gemini-cli.md §3.7 Step 1`（v1.3 → v1.4）三分支版本偵測（MISSING 自動安裝 / STALE 詢問升版 / CURRENT 繼續）+ `tools/vendor/commons/checkpoints_handler.sh` canonical 新檔。**採用方升 v0.9.3 注意事項**：純擴增 vendor spec 層 + 新增 canonical 工具、既有採用方升版只改 profile.yaml `charter_version: "0.9.2"` → `"0.9.3"`；**Gemini PM 採用方重新跑 PM init 時將自動偵測並引導升版舊版 handler**（框架自動引導、無需 maintainer 手動說明）。詳見 CHANGELOG v0.9.3 段。
- **v1.13（2026-05-01，charter v0.9.2）** — PM init `/checkpoints` 後置介紹 PATCH 連動 sync：`roles/pm/gemini-cli.md §3.7`（v1.3 新增）PM self-instantiation step 8 後置主動介紹存檔機制 + `.gemini/commands/checkpoints.toml` 標準範本。**採用方升 v0.9.2 注意事項**：純擴增 vendor spec 層、既有採用方升版只改 profile.yaml `charter_version: "0.9.1"` → `"0.9.2"`；Gemini PM 採用方下次 PM init 時將自動介紹 `/checkpoints` 機制。詳見 CHANGELOG v0.9.2 段。
- **v1.12（2026-05-01，charter v0.9.1）** — doctor Gap 偵測 + Doctor 角色概念層 PATCH 連動 sync：`tools/doctor-spec.md §2.1 模式 C`（互動式 Gap 遷移）+ `§3.12`（W1201-W1205）+ `tools/init-spec.md Phase 3.5`（scaffold 預建）+ `roles/doctor/_spec.md`（新角色概念層）+ `UPGRADE.md`（升版入口文件）。**採用方升 v0.9.1 注意事項**：純擴增 tools/spec/roles 層、零 migration；跑 doctor 後若看到 W1201-W1205 為新增 Warning 碼（平行獨語 / 目錄空）；`UPGRADE.md` 為新增採用方升版入口（30 秒決策走哪條路）。詳見 CHANGELOG v0.9.1 段。
- **v1.11（2026-04-30，charter v0.9.0）** — 紀律完整性 + AI 自我覺察升維 MINOR 連動 sync（dogfood signal #34 LIVE 條款化、user 明示「個體學習迴圈框架必備」、第十七循環 dogfood-driven hardening）：line 5 / 149 / 337 charter_version v0.8.2 → v0.9.0 + §3 條款表 21 → 25 條（新加 4 條：B 組 +1 `diagnose-remediate-protocol` SSS S3 架構級條款化 / D 組 +1 `individual-learning-loop` 第 13 個架構級概念 + 補完接班場景四軸的第 4 軸 / E 組 +2 `adoption-lifecycle` lifecycle 5 階段完整化 + `condition-mutability` 紀律本體）+ §5 preset 表 母數 19 → 23 + 新加 essential preset（3-5 / 23、< 5k init token、signal #28 progressive adoption + signal #26 ROI 真槓桿）+ §12 self-check 加 v0.9.0 兩項（個體學習迴圈合規 W1101/W1102/E1103 + AI self-instantiation 八步驟對齊）。**採用方升 v0.9.0 注意事項**：(a) 既有採用方升版主要動作就是改 profile.yaml `charter_version: "0.8.2"` → `"0.9.0"`、然後跑 doctor 看 §3.11 個體學習迴圈合規 W1101（reflections/ 缺）/ W1102（雙寫漏對應）/ E1103（frontmatter 不全）；(b) AI self-instantiation 從七步驟升八步驟（加 step 0「讀過去違反紀錄」）— 既有 slash command 雖仍可用、但 step 0 漏跑 = 命中 F6 surface-level、強烈建議重新具象化；(c) 新範本 `templates/agent-commons/reflection.md.tpl` 為個體層反省範本（雙寫紀律執行載體）；(d) 新加 essential preset（3-5 條 core / < 5k init token）— 探索期專案首選、可從 essential 起手後漸進升 minimal/standard/strict；(e) 新加棄用工具 `tools/uninstall-spec.md`「保留最後的溫柔」精神 — 棄用是有尊嚴的離別不是 lock-in、含 archive 報告 + 三 level（Soft/Full/Nuclear）。**對應 dogfood-driven hardening 第十七循環**（紀律完整性 + AI 自我覺察升維、charter 完成 v0.7.3 北極星閉環 — 對採用方 + AI 雙邊「不讓 user 記」）。**詳細 step-by-step 升版流程（含每步給 AI 的 prompt 範本）見 [`examples/upgrades/v0.8.2-to-v0.9.0.md`](./examples/upgrades/v0.8.2-to-v0.9.0.md)** — charter 升版系列第 6 個 walkthrough（單 MINOR 升版、紀律完整性 + AI 自我覺察升維）+ §5 跨版本場景指引（v0.8.0 / v0.7.5 / 更舊版本直跳 v0.9.0 合併路徑）。詳見 CHANGELOG v0.9.0 段。
- **v1.10（2026-04-30，charter v0.8.2）** — 雙軸矩陣 framing 第一段連動 sync（multi-perspective 第十四循環結構師金礦落地）：line 5 / 149 / 336 charter_version v0.8.1 → v0.8.2 + §12 採用就緒 self-check charter_version 範例值升。**採用方升 v0.8.2 注意事項**：(a) 純擴增 README + 21 條條款開頭 blockquote、既有採用方升版只改 profile.yaml `charter_version: "0.8.1"` → `"0.8.2"`；(b) `README.md §設計哲學` 新加第 5 條「雙軸座標 — 哪些紀律靠誰守」（物理依據軸 + 檢測時點軸 + 依賴 LLM 紀律的條款清單）— 採用方應讀此段、了解每條 charter 條款的保證強度（為主動加固弱保證項作準備）；(c) 21 條 `core/*.md` 開頭加 blockquote 三新行（保證強度 / 檢測時點 / since）— 對採用方執行邏輯零影響、純文檔層擴增。**對應 dogfood-driven hardening 第十六循環**（multi-perspective 評估結構師金礦落地、第二日連續 ship 對齊雙軌節奏）。**詳細 step-by-step 升版流程（含每步給 AI 的 prompt 範本）見 [`examples/upgrades/v0.8.1-to-v0.8.2.md`](./examples/upgrades/v0.8.1-to-v0.8.2.md)** — charter 升版系列最簡 walkthrough（2 步流程）+ §5 跨版本場景（v0.7.5 / v0.8.0 直跳 v0.8.2、dogfood signal #29 LIVE 實證 capture）。詳見 CHANGELOG v0.8.2 段。
- **v1.9（2026-04-30，charter v0.8.1）** — SSS S3 起手實證 + dogfood signal #24 升工具層 + #19 順手修連動 sync：line 5 / 149 / 336 charter_version v0.8.0 → v0.8.1 + §12 採用就緒 self-check charter_version 範例值升。**採用方升 v0.8.1 注意事項**：(a) 純擴增 spec 層 + 文檔層、既有採用方升版只改 profile.yaml `charter_version: "0.8.0"` → `"0.8.1"`；(b) `tools/doctor-spec.md §3.10` 新加採用方文檔變更歷史 sync 校驗（W901）— 採用方文檔變更歷史漏 entry 會抓 WARN、需補變更歷史 entry（依 maintainer-discipline §3.4.2 紀律）；(c) `tools/doctor-spec.md §3.7-§3.9` 全加四欄 spec-as-data 結構（合規規定 / 修補方向 + 約束 / 反例）— 對採用方執行邏輯零影響、純文檔層擴增；(d) §3.7 校驗集第 2 條雙重否定措辭修（dogfood signal #19、解決 Gemini 把合規「shared/ 不存在」誤標 WARN 風險）。**對應 dogfood-driven hardening 第十四循環**（multi-perspective sub-agent 反向校準）+ **第十五循環**（signal #24 升工具層、第二日連續 ship 對齊雙軌節奏）。**詳細 step-by-step 升版流程（含每步給 AI 的 prompt 範本）見 [`examples/upgrades/v0.8.0-to-v0.8.1.md`](./examples/upgrades/v0.8.0-to-v0.8.1.md)**。詳見 CHANGELOG v0.8.1 段 + `examples/external-evaluations/clispike-multi-perspective-eval-2026-04-30.md`。
- **v1.8（2026-04-29，charter v0.8.0）** — 升版 + 接入防呆強化（slim 版）連動 sync：line 5 / 149 / 336 charter_version v0.7.5 → v0.8.0 + §12 採用就緒 self-check 加新項「`/charter-upgrade-verify` 5 軸全綠」（v0.8.0 新工具、軸 D 含 axiom frontmatter `status: USER-RATIFIED` 校驗）。**採用方升 v0.8.0 注意事項**：(a) `tools/doctor-spec.md §3.8` vendor schema check 從 spec 層升實作層、E801/W802 強制 — 既有 vendor toml/md 不合規（如 Gemini CLI nested table）會抓新 ERROR、升版前須先跑 doctor 修補；(b) `tools/doctor-spec.md §3.9` 新加 axiom 紀律對齊（E606/E607/W608）— 既有 axiom 若 frontmatter `status: AI-DRAFTED` 會抓 E606、需校 axiom + 升 USER-RATIFIED + 加校正紀錄行；(c) `tools/init-spec.md` Phase 5b CHECK 7 ext — 新接入採用方若 axiom 未升 USER-RATIFIED → init 失敗；(d) 新 spec `tools/post-upgrade-verify-spec.md` 提供 `/charter-upgrade-verify` 工具（user 自具象化為 slash command、跑 5 軸 A/B/C/D/E 校驗）；(e) `QUICKSTART.md` Step 2 ↔ Step 3 swap（axiom 寫在前、init 跑在後）— 對齊 v0.7.0 Phase 5b 物理存在校驗精神、移除 v0.7.2 cross-reference 警告。**升版推薦流程**（5 步抽象、**詳細 step-by-step 流程含每步 AI prompt 範本見 [`examples/upgrades/v0.7.5-to-v0.8.0.md`](./examples/upgrades/v0.7.5-to-v0.8.0.md)** — 對應 dogfood signal #21 紀律修正：每步給 AI 的 prompt、不要求 user 自己編輯）：1) 跑 /charter-doctor 看不合規項；2) 修補（B 類修 vendor schema / C 類升 axiom status）；3) profile.yaml `charter_version: "0.8.0"`；4) 自具象化 /charter-upgrade-verify；5) 跑 /charter-upgrade-verify 確認 5 軸全綠。**對應 dogfood-driven hardening 第十一循環** — signal #23 條款化 + #16 升實作層 + #10 升結構修正、三 signal 同 LIVE session 條款化 + SSS S1/S2 首次 capture。詳見 CHANGELOG v0.8.0 段。
- **v1.7（2026-04-28，charter v0.7.5）** — 跨多版本升級指引補完：line 5 / 149 / 336 charter_version v0.7.4 → v0.7.5 + 引用 `core/versioning-migration §3.4`（跨多 MINOR 累積升級流程子段、含「停用一段時間後重新採用」場景具體指引）+ `examples/upgrades/yc-aiagentcrew-v0.5.9-to-v0.7.4.md`（charter 第一個跨版本 walkthrough、回鍋開發者無痛實證）。**採用方升 v0.7.5 注意**：純擴增 / 零動作 migration（只改 profile.yaml charter_version）。對應 v0.7.3 北極星紀律「回鍋開發者無痛」第一個實證 ship。
- **v1.6（2026-04-28，charter v0.7.4）** — vendor 端 slash command schema 規範條款化（dogfood signal #16）：line 5 / 149 / 336 charter_version v0.7.3 → v0.7.4 + §7 self-instantiation 步驟對應提示 vendor schema 規範段（`roles/pm/gemini-cli.md §3.6` toml 扁平結構強制 / `roles/engineer/claude-code.md §4.1` .md 純 markdown 規範）。**採用方升 v0.7.4 注意**：純擴增 / 零動作 migration、doctor 不跑新 check（實作層留 v0.8+ 啟用、已於 v0.8.0 啟用、見 v1.8 entry）。
- **v1.5（2026-04-28，charter v0.7.3）** — 主體內容對齊 v0.7.x 系列（auditor 完整 sweep 抓 10 ERROR + 3 WARN）：§3 B 組 failure-modes F1〜F5 → F1〜F6（含 surface vs structural sub-pattern）+ §3 D 組 init-template 一句話加 v0.7.0 step 6 PROVISIONAL/ACTIVE + slash 引用紀律 + §6 T0 charter_version v0.6.1 → v0.7.3 + §6 T3 加 v0.7.1 雙路徑 + v0.7.2 順序紀律提醒 + §7 self-instantiation 6 → 7 步 + step 6 PROVISIONAL/ACTIVE 紀律 + step 5 doctor 強制驗證點 + §12 採用就緒 self-check 加 5 條 v0.7.x 必查項（含 F6 啟用 / shared/ 不存在 / Phase 5b 他抽驗 / Status PROVISIONAL/ACTIVE）。**重要追溯**：v0.7.0 應分類為 BREAKING-LITE（含兩個既有採用方 migration 點：F6 強制必啟 + mapping 移除 shared/ 中介層）而非 MINOR — 詳見 CHANGELOG v0.7.0 entry。
- **v1.4（2026-04-28，charter v0.7.1 + v0.7.2 補記）** — 補 v0.7.1 / v0.7.2 兩個 release 對應 ADOPTION 變更歷史 entry：v0.7.1 雙路徑（user 主筆 vs AI 代產 + user 校）+ frontmatter scaffold（Status / mutability_default / created_by / created_at）；v0.7.2 流程順序 cross-reference（實際執行 1 → 3 → 2 → 4 → 5）+ structural-anti-fabrication §5 補三行反向引用 + maintainer-discipline §3.4 文檔層 sync checklist。
- **v1.3（2026-04-28，charter v0.7.0）** — 公司專案接入失敗大批次 sync（5 個 dogfood signal 一次條款化）：line 5 charter_version v0.6.1 → v0.7.0 + 連動條款新增段引用（init-spec Phase 5b 採用方半邊「他抽」載體 / multi-role-tracking §3.4.4 init 階段自激活紀律 / init-template §3.3.2 step 6 Status PROVISIONAL/ACTIVE 二態 / failure-modes F6 sub-pattern surface vs structural / doctor-spec §3.7 結構頂層 + namespace 校驗）+ 本變更歷史段。詳見 `.claude_temp/COMPANY-ONBOARDING-FAILURE-AUDIT.md` 完整 audit 紀錄。**採用方升 v0.7.0 注意事項**：(a) profile.yaml `parameters.failure-modes.enable_modes` 須含 F6（v0.5.10 加但 preset 漏改、v0.7.0 強制必啟）；(b) 既有 mapping.yaml 若含 `shared/<X>/` 中介層 → doctor §3.7 報 ERROR、要把目錄內容移到頂層 + 改寫 mapping。
- **v1.2（2026-04-28，charter v0.6.1）** — 文檔層 sync 修補（v0.6.0 release 漏的 ADOPTION 同步點，由 v0.6.1 auditor 第一次實戰抽驗抓到 — dogfood signal #6 候選）：line 5 charter_version 對齊 + §5 preset 表母數 16 → 19 + §6 T0 + §12 採用就緒檢查 charter_version 對齊 + 本變更歷史段。
- **v1.1（2026-04-28，charter v0.6.0）** — 條款數 20 → 21、§3 加 D 組第 5 條 ai-vendor-onboarding + 新增 F 組 maintainer-only 分區、line 286 條款數同步。
- **v1（2026-04-27，charter v0.5.6）** — 初版。為「給接班 AI 快速理解並啟用」而寫，自含 context、引用具體條款 §段、提供採用就緒 self-check。
