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

| Phase | 工具 | 用途 | 狀態 |
|---|---|---|---|
| 1 | `charter-doctor.py` | 升版 dry-run + 健康檢查 | ✅ MVP 完成（commit `4e4725a` + bug fix `422f559`）|
| 2 | `charter-upgrade.py` | 執行升版（自動 schema 擴充 + BREAKING 確認）| ⏳ 等 v0.6+ 第一次 BREAKING 升級時實證 |
| 3 | `charter-init.py` | 初次接入（建 agent-commons + 套 preset + 寫 yaml）| ✅ MVP 完成（2026-04-27，第二專案採用驅動）|
| 4 | `charter-scan.py` | 既有專案智慧掃描（需 LLM judgment）| ⏳ 留 v1.0 |

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
- **framework 維護者的紀律對齊**（2026-04-27 dogfood signal #1）— framework 條款規範採用方，但對「framework 設計者 / 維護者」沒有強制力。實證：Claude 在第二採用案例討論時違反 `working-stack-discipline §1`（DRAFT 對話累積而非檔案外部化），使用者提醒才補做紀錄。**判斷：暫不條款化**，累積 ≥ 3 次同類觀察後再評估（避免 v0.x 階段 surface area 擴張）。**候選方向**：(a) 新 `core/maintainer-discipline.md` 條款；(b) 擴充 `working-stack-discipline §X` 涵蓋維護者場景；(c) 維持非條款化，靠 git commit/PR 自我審視 + 使用者抽驗機制；詳見 `.claude_temp/STATUS.md §D` 與 `.claude_temp/CHARTER-VIZ-ONBOARDING.md`

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
