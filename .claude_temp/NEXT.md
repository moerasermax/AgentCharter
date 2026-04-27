# AgentCharter — Next Work

> **更新時間**：2026-04-27
> **依循**：v1.0 公開化條件（GOVERNANCE §6）

---

## 🔴 高優先（影響 v1.0）

### 1. 核心條款覆蓋率盤點

**狀態**：待開始
**動作**：列出可能遺漏的條款候選（4〜5 個），逐一決議是否補入 core/。

**候選清單**：

- [ ] **Domain Axiom Slot 撰寫規範** — 各專案怎麼寫 domain-axioms.md？（目前只說「填這槽位」沒指南）
- [ ] **Versioning / Migration 規範** — 條款升級時已採用專案怎麼遷？（init-spec.md `--update` 提到但簡略）
- [ ] **Cross-AI handoff 細則** — 跨 AI 接班規範（handoff-chain.md §5 提到但簡略）
- [ ] **Conflict resolution between roles** — 兩角色決策衝突的裁決路徑（escalation-protocol 只處理失敗事件）
- [ ] **Multi-role tracking 條款化** — 1 AI 多角色的審計規範（templates/management-layout.md 提到但未條款化）

### 2. `roles/pm/gemini-cli.md` 提交

**狀態**：placeholder 等待 Gemini 端產出
**Blocker**：需 Gemini 端代理人或 Gemini CLI 自己參與
**內容**：依 spec §3 七項，特別是 S70 事件根因分析與防範改善

### 3. v0.5 Reference Impl

**狀態**：等核心條款穩定後啟動
**動作**：把 `tools/{scan,init,doctor}-spec.md` 變成可跑的工具
**選項**：
- A. bash + python 原型
- B. 直接寫成 Claude Code slash command
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

---

## 🟢 低優先（v1.0 後）

### 8. B2 子條款層級配置

**狀態**：v0.5+ 候選
**動作**：profile.yaml 加 `sections.<§>` 開關支援

### 9. AgentCharter 自身 dogfooding

**狀態**：v1.0 後啟動
**階段**：
- 階段 1：管理工作流（DRAFT / HANDOFF / NextWork）
- 階段 2：採用 .agentcharter/profile.yaml 與 mapping.yaml
- 階段 3：多角色協作

當前狀態：**先用 .claude_temp/ 替代**，等 v1.0 後升格。

### 10. 跨 AI CLI 工具

**狀態**：v0.6+ 候選
**動作**：類似 npm 之於 npm packages，做一個 CLI 讓任何 AI 透過標準介面接入

---

## ⚪ 待對話的議題

- AgentCharter 自身採用 framework 的邊界（dogfooding 何時、如何啟動）
- 條款命名規範統一（kebab-case vs snake_case 一致性）
- 多語系策略（當前繁中 + 英文小標題並陳）

---

## 處置原則

| 觸發 | 動作 |
|---|---|
| 使用者明示開新議題 | 切該議題，動完更新本檔 |
| 工程師發現新候選條款 | 加入 §1 候選清單 |
| commit 後 | 同步更新 STATUS.md `Version 軌跡` 段 |
| 跨 session 接班 | Claude 第一輪先讀本檔 + STATUS.md，對齊脈絡後再回應 |
