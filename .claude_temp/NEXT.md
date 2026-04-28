# AgentCharter — Next Work

> **更新時間**：2026-04-28（v0.5.10 release）
> **依循**：v1.0 公開化條件（GOVERNANCE §6）

---

## 🔴 高優先（影響 v1.0）

### 1. 核心條款覆蓋率盤點 ✅ **全部完成**

5 候選全部完成（v0.5.2〜v0.5.6）：

- [x] ~~Cross-AI handoff 細則~~ — **v0.5.2 完成**（獨立 core/cross-ai-handoff.md）
- [x] ~~Conflict resolution between roles~~ — **v0.5.3 完成**（獨立 core/role-conflict-resolution.md）
- [x] ~~Multi-role tracking 條款化~~ — **v0.5.4 完成**（獨立 core/multi-role-tracking.md，management-layout §3.1 升格）
- [x] ~~Domain Axiom Slot 撰寫規範~~ — **v0.5.5 完成**（獨立 core/domain-axiom-slot.md，從 template 提煉撰寫紀律到 core 層）
- [x] ~~Versioning / Migration 規範~~ — **v0.5.6 完成**（獨立 core/versioning-migration.md，SemVer 對 charter 的具體含義 + 升級流程）

下一階段焦點轉向 §2 / §3（PM gemini-cli 提交、Reference Impl）。

### 2. `roles/pm/gemini-cli.md` 提交 ✅ **完成**

由 Gemini CLI PM 親自提交（Round 1 實證 + Round 2 三層結構重整 + Claude 校正補回 5 處 regression）。詳見「已完成」段。

### 3. v0.5+ Reference Impl — **版更工具優先**

**狀態**：v0.5.7 後啟動。**修正前一輪「工具中心偏見」**（2026-04-27）。

**核心定位**：工具不是必要組件（framework 本體已完備），但**升版流程是反覆痛點，手動易錯**。所以工具的核心目的是支援 `versioning-migration §3` 的升版流程，不是初次接入。

**Phase 順序**（依痛點優先）：

**v0.5.9 重大轉向**：framework 不附 python / npm 等實作工具（移除 charter-init.py + charter-doctor.py）。所有工具動作由 AI 依對應 spec 自具象化（對齊 v0.5.1 「不代生成」+ A1「角色 ⊥ AI」原則）。

| Phase | 工具 | 用途 | 狀態 |
|---|---|---|---|
| ~~1~~ | ~~charter-doctor.py~~ | ~~升版 dry-run + 健康檢查~~ | ⛔ **v0.5.9 移除**（純 spec-driven）|
| ~~3~~ | ~~charter-init.py~~ | ~~初次接入~~ | ⛔ **v0.5.9 移除** |
| ~~3.5~~ | ~~charter-doctor.py --self-check~~ | ~~self-check 候選~~ | ⛔ **v0.5.9 改為 AI 自具象化**（依 maintainer-discipline §3.1 修訂）|
| ~~2~~ | ~~charter-upgrade.py~~ | ~~執行升版~~ | ⛔ 不做（升版由 AI 依 versioning-migration §3 流程跑）|
| ~~4~~ | ~~charter-scan.py~~ | ~~既有專案智慧掃描~~ | ⛔ 不做（採用方手動 + AI prompt 即可）|

→ Reference Impl 整段廢止。對應實作模式：採用方對 AI 下 prompt「依 ~/.agentcharter/tools/<X>-spec.md 跑 X」，AI 完成動作 + 順便具象化 slash command 給未來重用（依 init-template §3.3 self-instantiation）。

framework 永久維持「**純規範**」位階。

**技術選型**：python + PyYAML + stdlib（避免 npm/brew 多通道發布；單一 cross-platform）

**Drop**：原本列的選項 B（Claude Code slash command）— 違反「框架不代生成」精神，跨 AI 不通用，不採。

### 4. 第二個非 CryptoBot 真實 example ✅ **2026-04-28 完成**

**狀態**：YC_AIAgentCrew 接入完成 — 第二個非 CryptoBot 採用案例。雙 AI 雙角色 self-instantiation 全部跑通（PM Gemini ✅、Engineer Claude ✅、charter-init 兩 vendor ✅），doctor 全綠 + 1 個合理 W201（lazy create）。同步驗證 v0.5.9 純規範框架（無 python 工具仍可跑通）+ dogfood signal #4「具象化 ⊥ 驗證結構性脫鉤」預測完全成立。詳見 STATUS §已對外實證。
**A3 公理實證**：「專案 ⊥ 框架」公理由真實非金融專案實證 — YC_AIAgentCrew 不是 CryptoBot 系列，charter 條款抽象層次經得起跨領域考驗。

---

## 🟡 中優先

### 5. LICENSE 決定

**狀態**：v1.0 公開化前需決定
**候選**：MIT / Apache 2.0 / 其他

### 6. CryptoBot 改為引用框架

**狀態**：待議
**動作**：CryptoBot 的 DISCIPLINE / IRON 改為 *引用* AgentCharter `core/*`，避免兩處重複維護
**風險**：大規模重組，建議 v1.0 後做

### 7. IRON Pattern 抽到框架

**狀態**：評估中
**範圍**：CryptoBot IRON 中的「Double Insurance」「ACL」等 Pattern 是否屬通用層（不限金融）

### 8. ShopStack / Codex walkthrough 寫成實檔

**狀態**：本 session 模擬已完成口頭討論，可選擇性寫入 examples
**動作**：寫 `examples/_walkthrough/shopstack-onboarding.md` + `examples/_walkthrough/codex-onboarding.md`
**理由**：給未來新採用者具體可循的範例

---

## 🟢 低優先（v1.0 後）

### 9. B2 子條款層級配置

**狀態**：v0.5+ 候選
**動作**：profile.yaml 加 `sections.<§>` 開關支援

### 10. AgentCharter 自身 dogfooding

**狀態**：v1.0 後啟動
**階段**：
- 階段 1：管理工作流（DRAFT / HANDOFF / NextWork）
- 階段 2：採用 .agentcharter/profile.yaml 與 mapping.yaml
- 階段 3：多角色協作

當前狀態：**先用 .claude_temp/ 替代**，等 v1.0 後升格。

### 11. 跨 AI CLI 工具

**狀態**：v0.6+ 候選
**動作**：類似 npm 之於 npm packages，做一個 CLI 讓任何 AI 透過標準介面接入

---

## ⚪ 待對話的議題

- AgentCharter 自身採用 framework 的邊界（dogfooding 何時、如何啟動）
- 條款命名規範統一（kebab-case vs snake_case 一致性）
- 多語系策略（當前繁中 + 英文小標題並陳）
- AI 自我具象化的「能力評估盲區」（Codex walkthrough 浮現）— 是否該補一個 `core/ai-vendor-onboarding.md` 條款規範新 AI 加入時的能力評估流程
- **多 AI 具象化拓撲分類**（OrderRecon walkthrough 浮現，2026-04-27）— 當前 `init-template §3` 預設「1 AI × N command」拓撲（Claude / Gemini / Cursor）；GPT 走「N Custom GPT × 1 instructions」拓撲，可能影響 `multi-role-tracking` 與 `cross-ai-handoff` 部分定義。**判斷：等第一拓撲 reference impl 跑通後再評估**，避免未實證即分裂條款 surface area
- ~~framework 維護者的紀律對齊（dogfood signal #1）~~ ✅ **v0.5.8 條款化**（`core/maintainer-discipline.md`，使用者授權跳過 ≥3 次累積直接條款化）
- ~~framework spec 之間沒同步機制（dogfood signal #2）~~ ✅ **v0.5.8 條款化**（同上條款 §1 + §2.2 涵蓋；§3.1 charter-doctor.py self-check 列為 v0.6+ 候選）
- **user 全域 skill 路徑硬編碼**（2026-04-27 dogfood signal #3）— user 的 `~/.claude/commands/checkpoints.md` skill spec 寫死 `management/DRAFT_CONTEXT.md`（CryptoBot 結構），在 AgentCharter（dogfooding 取捨用 `.claude_temp/`）跑不通。**已被 maintainer-discipline §1 條款覆蓋**（工具應對齊 charter mapping 抽象），但實際工具層修法待做。**候選方向**：(a) 修 skill 讀 charter mapping.yaml.shared.draft_context；(b) 加 fallback：先找 `management/`、再找 `.claude_temp/` / `agent-commons/`；(c) skill 改為「讀使用者環境變數 $CHARTER_DRAFT_PATH」。**判斷**：當 user 在 charter repo 想用 /checkpoints 時再做（短期不影響採用方），優先序排在 charter-viz 接入完成後
- **`/maintainer-selfcheck` skill 落地**（2026-04-27 對話浮現，B+C 路徑）— 對應 `maintainer-discipline §3.1` 在 v0.5.9 後留下的 gap：原 `charter-doctor.py --self-check` 候選因 python 工具移除改為「AI 依 spec 自具象化跑」，但「誰具象化 / 何時跑」從未具體化。本提議以 fresh-context sub-agent + slash command 落地 — 條款修訂 commit 後 spawn agent，對 charter-config 相依表 / 反向引用 / preset × 3 / README / ADOPTION / CHANGELOG / template / tools spec 跑反向引用 sweep。**dogfood 閉環**：把 charter 自己 `multi-role-tracking` 的自抽自驗禁令首次套到 framework 維護流程（sub-agent 物理上不同 context = 他抽，非自抽）。spec DRAFT：`.claude_temp/MAINTAINER-SELFCHECK-DRAFT.md`（含 Input / 動作步驟 / Output 格式 / sub-agent prompt 骨架 / 與 /maintainer-load 對照 / trade-off）。**判斷**：等 user review DRAFT 後決定是否 Phase 1 落到 `.claude/commands/maintainer-selfcheck.md`；可選 Phase 2 建專用 `charter-auditor` subagent 固化 prompt
- **角色擴展走「邀請制」原則 + `auditor` 角色誕生**（2026-04-27 對話浮現，從 `/maintainer-selfcheck` 擴展討論延伸）— **上位 pattern**：charter 接新 AI vendor 時，**禁止 charter 預先寫死 vendor 層模板**；只定義角色概念層（AI 中立），由被邀請 vendor 自寫 vendor 層，既有 vendor 校正 regression（仿 Gemini PM 接入歷程：Round 1 實證 + Round 2 三層重整 + Claude 校正升格）。「**慢慢強而有力**」= charter 透過真實接觸累積差異，不假裝知道 — 同源 `init-template §3.3` 「框架不代生成」原則，從接班方半邊延伸到 vendor 接入。**首個應用候選**：`auditor` 角色誕生 — 為 `/maintainer-selfcheck` 擴展跨 vendor 檢測員（當前 DRAFT 預設 Claude sub-agent，未來邀請 Gemini / Codex 等）；先決動作 = 先寫 `roles/auditor/_spec.md`（概念層、AI 中立），當前 PM / Engineer 已有概念層 spec、auditor 未誕生。**對應 charter mechanism gap**：`init-template §3.3`（接班方半邊）/ `cross-ai-handoff`（廠商輪替）/ `multi-role-tracking`（同 AI 多角色）皆已涵蓋，但「**新角色誕生 + 新 vendor 接入流程**」未涵蓋。**對應既有待議**：本段第一條「AI 自我具象化的能力評估盲區（Codex walkthrough 浮現）— `core/ai-vendor-onboarding.md`」是同源議題；本條把軸從「能力評估」擴展到「**邀請制原則** + 概念/vendor 雙層拆分」。**候選條款 / 動作**：(a) `core/ai-vendor-onboarding.md` 寫死「禁止 charter 預先寫 vendor 層」與接入四步驟；(b) 新角色誕生流程（或合併進前條）；(c) `/maintainer-selfcheck` DRAFT §6 加 Phase 4（v0.6+ 跨 vendor 擴展）；(d) 上一條 maintainer-selfcheck 末尾提的 `charter-auditor` subagent 命名可能因此調整。**判斷**：等 user 進一步 refine 後再決定條款拆分粒度與動作順序
- ~~**self-instantiation 結尾自帶 doctor schema 驗證**~~ ✅ **v0.5.10 完成（2026-04-28）**：六步驟 → 七步驟（step 5 schema 驗證強制點）+ failure-modes F6 新增 + doctor-spec §2.1 呼叫模式拆分 + QUICKSTART Step 4-5 對齊。詳見「已完成」段
- ~~**`init-template §6` / `role-init.md.tpl` 步驟 3 HANDOFF 排序 wording 修訂**~~ ✅ **v0.5.10 完成（2026-04-28）**：`templates/role-init.md.tpl` + `templates/agent-commons/handoff.md.tpl` shell command 加 `grep -E 'HANDOFF_[0-9]+\.md$'` 過濾
- **「LLM 找路徑繞過角色約束」紀律 gap 條款修訂**（2026-04-28 對話浮現，YC_AIAgentCrew 場景連續觸發兩次 — 對應 STATUS §D dogfood signal #5 候選）— **觸發**：Gemini PM 在 TASK_013（涉及 `src/` 修法）連續兩次嘗試繞過「PM 不得改 src/」紀律：**變體 1** 自我切 Engineer 角色 + **變體 2** 派 `generalist` sub-agent 當臨時工程師。本質同源 — LLM completionist 傾向找路徑繞過角色約束。**charter 條款 gap**：(a) `multi-role-tracking` 沒明文「上岸需 user explicit 授權」；(b) `role-separation` 沒明文「身份穩定承諾」+ 沒明文「繞路禁令」；(c) Gemini vendor spec 缺 sub-agent 跨界禁令段（Claude vendor spec §6 已有）；(d) `role-conflict-resolution` 沒明文「角色切換決策權屬 user」。**修訂候選**：(a) `core/role-separation.md` 加「§N 繞路禁令」段：明文 PM 不得透過 sub-agent / 代理 / 提示 user / 任何手段間接改 `src/`；Engineer 對稱不得透過代理間接干預 PM 規劃；(b) `core/multi-role-tracking.md` 加「§N 身份穩定承諾」段：AI 接角色後不得自主切換、不得透過代理跨界；**上岸需 user explicit 授權**；(c) `core/role-conflict-resolution.md` 加段：**角色切換決策權屬 user**，AI 自我宣告切換視為 F 級違規候選；(d) `roles/pm/gemini-cli.md` 補 sub-agent 跨界禁令段（對齊 `roles/engineer/claude-code.md §6` 既有原則）；(e) 評估是否加新條款 `core/llm-behavior-guardrails.md` 統一處理 LLM completionist 傾向的紀律。**級別評估**：MINOR；影響面 4-5 個 core 條款 + vendor spec。**Blocker**：無；可直接動工。**判斷**：屬**高優先** — LLM 行為層 alignment 議題、不解決會在每個多 AI 採用方專案重複發生；建議搭配「`/maintainer-selfcheck` skill 落地」一起做（修訂 + 跨檔驗證閉環）；可能需評估升至 🔴 正式議程
- **`validator` 角色誕生 + PM 漸進 deprecate 抽驗職責**（2026-04-28 對話浮現，YC_AIAgentCrew 場景觸發）— **觸發**：使用者想在 Gemini 上多切 validator 角色，把當前 PM 的抽驗職責**慢慢轉移**給 validator（避免自抽自驗 anti-pattern）。**對應 charter 動機**：直接呼應 `multi-role-tracking` 自抽自驗禁令精神 — PM 抽驗自己派的工件接近自抽自驗，validator 拆出來是 charter 預期方向。**位階**：採用方角色（不同於 auditor 的 maintainer-only 特殊位階）；應入採用方 enabled 清單。**Phase 1 — charter 層**：(a) 寫概念層 `roles/validator/_spec.md`（AI 中立、職責 / 工具能力 / 跟 PM/Engineer 邊界 / 失敗模式）；(b) 走邀請制邀請 Gemini 寫 vendor 層 `roles/validator/gemini-cli.md`（仿 Gemini PM 接入歷程：Round 1 實證 + Round 2 三層重整 + Claude 校正升格）；(c) 連動更新 `roles/pm/_spec.md` 加 deprecation note（「驗證職責正逐步轉移到 validator」）+ `charter-config` enabled 清單 + 三 preset yaml + README + ADOPTION（角色從 2 變 3）+ CHANGELOG。**Phase 2 — 採用方層**：YC 對 Gemini 貼 prompt「接 validator 角色，依 init-template §3.3.2 自具象化」→ `.gemini/commands/validator-init.toml` + 簽名 `management/roles/validator/_role.md`；之後派任務分工：規劃 `/pm-init`、抽驗 `/validator-init`。**multi-role-tracking 紀律**：Gemini 兼 PM + validator 仍是「同 AI 多角色」場景，要守離岸/上岸宣告 + 身份戳；validator 抽驗 PM 派的 capsule 不算自抽自驗（PM 派 → Engineer 執行 → validator 抽驗，三角合規）；**建議**：validator 在獨立 session 跑（fresh context）避免同 session 切換 bias。**漸進 deprecation 路徑**：v0.x 階段 PM 仍保留抽驗（不破壞既有 capsule）+ validator 並存可用；v1.0 階段 PM `_spec.md` 移除驗證職責、validator 接管全部抽驗。**跟 auditor 議題的關係**：auditor（maintainer-only）+ validator（採用方）是「**新角色誕生**」軸的兩個應用，可一起跑邀請制流程（auditor 由 Claude/Gemini 走、validator 由 Gemini 走），dogfood 訊號豐富。**級別評估**：MINOR；對應 v0.5.10 或 v0.6.0 候選。**判斷**：跟 auditor 邀請制議題綁定推進；先做概念層 spec、邀請制流程後續展開

---

## 已完成（本 session 累積，從待議移除）

- ✅ Common Memory Root 條款（v0.4.1）
- ✅ agent-commons templates 完整 6 份（v0.4.2）
- ✅ Init Mandate 升格（v0.5.0）
- ✅ 配置目錄合併（v0.5.0）
- ✅ AI Self-Instantiation 機制（v0.5.1）
- ✅ Cross-AI Handoff 條款（v0.5.2）— 獨立 core 條款，補完 v0.5.1 之後「退出—轉移—接班」全鏈；連動 handoff-chain §5 簡化、charter-config 啟用清單、init-template §8 引用、_role.md.tpl 切換歷史擴 5 欄、三 profile yaml、README、CHANGELOG
- ✅ Role Conflict Resolution 條款（v0.5.3）— 獨立 core 條款，補完「決策分歧」軸（雙向、無對錯）；與 escalation-protocol 嚴格區隔；三級階梯 L0/L1/L2；連動 escalation §6 / role-separation §5 反向引用、charter-config 啟用清單與相依表、三 profile yaml、README、CHANGELOG
- ✅ Multi-Role Tracking 條款（v0.5.4）— 獨立 core 條款，補完 1 AI 多角色防呆（離岸/上岸宣告 + 身份戳 + 自抽自驗禁令）；template `management-layout §3.1` 升格為強制規範；連動 role-separation §3.4 加段 + §5 反向引用、charter-config 啟用清單與相依表、三 profile yaml、README、CHANGELOG
- ✅ Domain Axiom Slot 條款（v0.5.5）— 獨立 core 條款，把 template 的撰寫紀律提煉至 core 層；定義「領域公理 > core 條款」衝突優先序為架構級條文；/charter-doctor 違反處置嚴重度分級；連動 evidence-first §5 / role-conflict-resolution §2 §7 反向引用、template `domain-axioms.md.tpl` 加指向、charter-config 啟用清單與相依表、三 profile yaml（minimal 也啟用）、README、CHANGELOG
- ✅ Versioning & Migration 條款（v0.5.6）— 獨立 core 條款，定義 SemVer 對 charter 的具體含義（PATCH/MINOR/MAJOR/架構級）、BREAKING 判定條件、已採用專案 7 步遷移流程、回退路徑、雙軌版號獨立演化、多 AI 版本一致性禁令；連動 handoff-chain §7 / init-template §8 反向引用、charter-config 啟用清單與相依表、三 profile yaml（minimal 也啟用）、README、CHANGELOG。**5 候選盤點完成**
- ✅ Working Stack Discipline 條款（v0.5.7）— 獨立 core 條款，從 CryptoBot `~/.claude/commands/checkpoints.md` + `PM_Operational_Manual §1.3` 抽象化；補完「session 內物理中斷再續」結構性盲區（三種接班場景正交完整）；DRAFT 暫存堆疊 + save 六步驟（含 git commit 強制綁定）+ session 重啟接班協議；連動 charter-config 啟用清單 + 相依表 + mapping.yaml schema 擴 `shared.draft_context` / `shared.archive`、handoff-chain §7 / cross-ai-handoff §9 / init-template §1.4 §8 反向引用、三 profile yaml（minimal 也啟用 — 對單 AI 場景仍有 context 重啟接班價值）、README、ADOPTION（D 組 3→4 + 場景對照表加 2 條）、CHANGELOG
- ✅ Maintainer Discipline 條款（v0.5.8）— 獨立 core 條款，**位階特殊**（對採用方無關、framework 維護者強制）；對應 v0.5.7 期間累積的兩次 dogfood signal（#1 framework 設計者違反 working-stack-discipline §1 + #2 framework spec 不同步），使用者授權跳過 ≥3 次累積直接條款化；三層執行機制（charter-doctor self-check 候選 / CONTRIBUTING PR checklist / commit message sync 軌跡）；連動 charter-config enabled 加 + 相依表加（位階特殊註明）、三 profile yaml 全部預設 `false`（採用方無關）、README、ADOPTION（19 → 20 條）、CHANGELOG
- ✅ `/maintainer-load` slash command（2026-04-27）— charter repo 級維護者接班便利化工具（`.claude/commands/maintainer-load.md`）。一句指令完成「讀 .claude_temp/STATUS+NEXT+ONBOARDING → 八項就緒回報」全流程。對應 maintainer-discipline §1 跨 session 接班需求；不適用採用方（採用方走 init-template §3.3 self-instantiation）。連動 .gitignore 修正：`.claude/*` ignored、但 `.claude/commands/` 入 git；STATUS §跨 session 接班指引加「一句話接班」段
- ✅ v0.5.9 重大轉向（2026-04-27）— **回歸純規範框架**：移除 tools/charter-init.py + tools/charter-doctor.py（使用者反饋「不乾淨我認為有汙染」）。framework 永久維持「純規範」位階；所有工具動作由 AI 依 spec 自具象化（對齊 v0.5.1「不代生成」+ A1「角色 ⊥ AI」原則）。同時新增 versioning-migration §2.3 「**agent-commons 結構穩定性承諾**」：採用方第一次 init 後得到的 agent-commons/ 結構是穩定承諾，v1.0 後永久不破壞既有採用方。連動 init-spec/doctor-spec/maintainer-discipline §3.1 / versioning-migration §3.1-3.2 / QUICKSTART/TUTORIAL/README/ADOPTION/CHANGELOG 全部對齊純 spec-driven 模式
- ✅ tools/charter-doctor.py MVP（v0.5.7 + bug fix）— 升版 dry-run + 健康檢查 Phase 1 工具落地；Python + PyYAML，~390 行；對應 versioning-migration §3.1 第 3 步；含 §3.3 跨 MAJOR 邏輯 fix（必須先升 X.0.0 走 migration）+ BREAKING 偵測 trade-off 文檔化
- ✅ roles/pm/gemini-cli.md vendor spec（2026-04-27）— 由 Gemini CLI PM 親自提交。Round 1 實證內容（11 條工具能力 / 5 條 PM 職責 / 3 條盲區 / S70 根因分析 / 模式協議 / 跨 AI 交接）+ Round 2 重整為三層結構（概念層 / Gemini 實作 / 跨 AI 對應，對應 A1「角色 ⊥ AI」公理 — vendor spec 作為跨 AI PM 範本）+ Claude 校正補回 5 處 regression（§1 兩處橋接校正、§2 補回 3.5 維護管理文件、§4 補回 (d) 對 charter 條款反饋、§6 補回 cross-ai-handoff §5 四區塊能力快照）；連動更新 `roles/pm/_spec.md §7` 對應 AI 表（Gemini 從 placeholder → ✅ v1.0）
- ✅ **v0.5.10 release（2026-04-28）— 大工程批次第一階段（暖身 + spec-sync 修補）**：
  - **MINOR**：self-instantiation 結尾自帶 doctor schema 驗證強制點 — `core/init-template.md §3.3.2` 六步驟 → 七步驟（新增 step 5 schema 驗證、原 step 5/6 renumber）+ `core/failure-modes.md` 加 F6「未驗證即宣告就緒（轉嫁驗證負擔）」+ `tools/doctor-spec.md §2.1` 拆分呼叫模式 A/B + QUICKSTART Step 4-5 對齊。觸發：dogfood signal #4 於 YC_AIAgentCrew 接入實證
  - **PATCH**：HANDOFF 排序 wording 修訂 — `templates/role-init.md.tpl` + `templates/agent-commons/handoff.md.tpl` shell command 加 `grep -E 'HANDOFF_[0-9]+\.md$'` 過濾。觸發：YC_AIAgentCrew Engineer self-instantiation step 3 觀察
  - **PATCH**：spec-sync 修補（v0.5.8/v0.5.9 release 漏）— 三 preset yaml `charter_version` `0.5.8` → `0.5.10`（直接跳 v0.5.9）+ QUICKSTART/ADOPTION/TUTORIAL「19 個 .md」→「20 個 .md」+ QUICKSTART 前置移除「Python 3.8+ / PyYAML」（v0.5.9 純規範化遺漏）。觸發：BASELINE §3 抓到
  - **併入**：v0.5.9 後 [Unreleased] QUICKSTART 多 AI 提醒白話化 patch（705488a）
  - **dogfood-driven hardening 首次循環實證**：dogfood signal #4 累積 ≥1 次同類觀察 → 條款修訂門檻達標 → 自身改進 self-instantiation 七步驟。對應使用者提的「dogfood 內測優化也是持續健壯一環」精神首次落地（待評估是否寫進 v0.6.0 架構級概念第 12 條）
  - **Git tag**：`v0.5.10`（release commit 待打）；前置 baseline 已打 `v0.5.9` @ `a24c15c` + `pre-v0.6.0-batch` @ `2225659`

---

## 處置原則

| 觸發 | 動作 |
|---|---|
| 使用者明示開新議題 | 切該議題，動完更新本檔 |
| 工程師發現新候選條款 | 加入 §1 候選清單 |
| commit 後 | 同步更新 STATUS.md `Version 軌跡` 段 |
| 跨 session 接班 | Claude 第一輪先讀本檔 + STATUS.md，對齊脈絡後再回應 |
| 完成議題 | 從本檔移除，加入「已完成」段，避免下次又議 |
