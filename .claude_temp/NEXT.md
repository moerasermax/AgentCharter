# AgentCharter — Next Work

> **更新時間**：2026-04-27
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

### 4. 第二個非 CryptoBot 真實 example

**狀態**：等使用者新專案出現
**Blocker**：需有實際採用 framework 的非金融專案

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

---

## 處置原則

| 觸發 | 動作 |
|---|---|
| 使用者明示開新議題 | 切該議題，動完更新本檔 |
| 工程師發現新候選條款 | 加入 §1 候選清單 |
| commit 後 | 同步更新 STATUS.md `Version 軌跡` 段 |
| 跨 session 接班 | Claude 第一輪先讀本檔 + STATUS.md，對齊脈絡後再回應 |
| 完成議題 | 從本檔移除，加入「已完成」段，避免下次又議 |
