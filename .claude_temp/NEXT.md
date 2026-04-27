# AgentCharter — Next Work

> **更新時間**：2026-04-27
> **依循**：v1.0 公開化條件（GOVERNANCE §6）

---

## 🔴 高優先（影響 v1.0）

### 1. 核心條款覆蓋率盤點（剩餘候選）

**狀態**：部分已做（common-memory-root、charter-config 已加），剩 5 候選未決議。

**候選清單**：

- [ ] **Domain Axiom Slot 撰寫規範** — 雖已有 `templates/agent-commons/domain-axioms.md.tpl`，但缺 core 條款規範「該寫多嚴格、該分幾梯」
- [ ] **Versioning / Migration 規範** — 條款升級時已採用專案怎麼遷？（init-spec.md `--update` 提到但簡略）
- [ ] **Cross-AI handoff 細則** — 跨 AI 接班規範（handoff-chain.md §5 提到但簡略；v0.5.1 self-instantiation 補了部分）
- [ ] **Conflict resolution between roles** — 兩角色決策衝突的裁決路徑（escalation-protocol 只處理失敗事件，不處理意見不合）
- [ ] **Multi-role tracking 條款化** — 1 AI 多角色的審計規範（templates/management-layout.md 提到但未條款化）

### 2. `roles/pm/gemini-cli.md` 提交

**狀態**：placeholder 等待 Gemini 端產出（v0.5.1 後改由 Gemini 自我具象化時產出 vendor spec）
**Blocker**：需 Gemini 端代理人或 Gemini CLI 自己參與
**內容**：依 `roles/pm/_spec.md` + Gemini 工具能力 + S70 事件根因分析

### 3. v0.5+ Reference Impl

**狀態**：等核心條款穩定後啟動
**動作**：把 `tools/{scan,init,doctor}-spec.md` 變成可跑的工具
**選項**：
- A. bash + python 原型
- B. 直接寫成 Claude Code slash command（但會違反「框架不代生成」原則 — 需設計成「指引 AI 自我具象化」）
- C. 跨 AI CLI（最大）

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

---

## 已完成（本 session 累積，從待議移除）

- ✅ Common Memory Root 條款（v0.4.1）
- ✅ agent-commons templates 完整 6 份（v0.4.2）
- ✅ Init Mandate 升格（v0.5.0）
- ✅ 配置目錄合併（v0.5.0）
- ✅ AI Self-Instantiation 機制（v0.5.1）

---

## 處置原則

| 觸發 | 動作 |
|---|---|
| 使用者明示開新議題 | 切該議題，動完更新本檔 |
| 工程師發現新候選條款 | 加入 §1 候選清單 |
| commit 後 | 同步更新 STATUS.md `Version 軌跡` 段 |
| 跨 session 接班 | Claude 第一輪先讀本檔 + STATUS.md，對齊脈絡後再回應 |
| 完成議題 | 從本檔移除，加入「已完成」段，避免下次又議 |
