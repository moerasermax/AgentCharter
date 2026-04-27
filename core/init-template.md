# Role Init Mandate（角色初始化職責規範）

> **狀態**：v0.5.0 — 升格為職責規範（v0.4 僅為「五步驟骨架」）
> **位階**：core 通用條款。**抽象規範 + 具象化指引**雙層。

---

## 0. 概念位階 — Init 是什麼

Role Init 是接班 AI 進入角色身份的**召喚與校準機制**，相當於：

| 比喻 | 含義 |
|---|---|
| **使用者分身** | 接班 AI 透過 init 對齊使用者意圖；無 init = 無分身 |
| **造物主** | init 「召喚」AI 進入角色，並「校準」其認知 |
| **守門人** | init 拒絕未對齊的 AI 進入工作（缺協議、缺路徑、缺權限）|

**核心地位**：Init 是多 AI 協作的**入口契約**。任何角色被任何 AI 扮演，都必須通過此契約。

→ 因此 Init 不是「Claude Code 的方便指令」，而是**框架級職責規範** — Claude / Gemini / Cursor / 任何 AI 都須各自具象化這個職責。

---

## 1. Init 的核心職責（抽象，所有 AI 都要做）

任何 AI 扮演任何角色時，init 必須完成以下 **四大職責**：

### 1.1 召喚（Summon）

讓接班 AI 進入正確角色身份。動作：

- 讀 `<charter>/roles/<role>/_spec.md`（職能定義）
- 讀 `<charter>/roles/<role>/<ai-vendor>.md`（該 AI 的執行細節）
- 讀 `<common-memory-root>/roles/<role>/_role.md`（該專案的角色身份檔）
- 確認 AI 廠商與 `_role.md` 紀錄一致（不一致即視為跨 AI 接班場景）

### 1.2 校準（Calibrate）

讓接班 AI 對齊當前專案狀態。動作：

- 讀領域公理（`<common-memory-root>/protocols/<axiom>.md`）
- 讀啟用的所有 `core/*` 條款（依 `profile.yaml`）
- 讀最近 HANDOFF（`<common-memory-root>/handoffs/HANDOFF_<latest>.md`）
- 讀 NextWork（`<common-memory-root>/nextwork.md`）
- 讀失敗模式累積紀錄（`<common-memory-root>/state/failure_modes.log`）
- 套用當前模式（eco / verbose，依 `<common-memory-root>/state/output_mode`）

### 1.3 簽名（Sign-in）

留下「我是誰、何時到的」的審計痕跡。動作：

- 更新 `_role.md` 切換歷史表（加一行：日期 / AI 廠商 / 觸發原因）
- 在歷史紀錄留下審計 trail，便於後續跨 session 追蹤

### 1.4 守門（Gatekeep）

確認就緒狀態，否則拒絕推進。動作：

- 確認協議檔案存在（依 `evidence-first.md`，用工具證實）
- 確認共同記憶根目錄與必含子槽位齊全
- 確認對方角色是否在強化抽驗模式（若是，本 session 對其結案宣告強制要求附 stdout 原文）
- 全綠 → 進入待命狀態，等待使用者派任務
- 任一項紅 → 中斷 init，回報缺失項，**禁止進入工作**

---

## 2. 必達的最終狀態（Completion State）

跑完 init 後，接班 AI 必須處於以下狀態（任何 AI 一致）：

| 狀態項 | 內容 |
|---|---|
| 領域公理 | 已載入心智模型，可引用條款編號 |
| 角色 spec | 已讀，知道職責邊界與不職責 |
| 共同記憶根目錄 | 已定位，後續所有讀寫以此為基準 |
| 抽驗權狀態 | 釐清對方是否在強化抽驗模式 |
| 最近 HANDOFF | 已讀，對齊上次 session 的脈絡 |
| 模式 | 已套用對應規範（eco / verbose）|
| 自我簽到 | `_role.md` 切換歷史已更新 |
| 待辦 | 從 NextWork 抽出 1〜2 條最高優先 |

→ 缺任一項 = 未對齊 = 不可進入工作。

---

## 3. 各 AI 具象化規範

框架定義抽象職責（§1〜§2），各 AI 實作具象 slash command。**抽象規範一致，具象實作可替換**。

### 3.1 主流 AI 對應位置

| AI | 具象化位置 | 實作格式 |
|---|---|---|
| **Claude Code** | `.claude/commands/<role>-init.md` | Slash command（純 markdown）|
| **Gemini CLI** | `.gemini/commands/<role>-init.toml`（依 Gemini 慣例）| 依 Gemini 規格 |
| **Cursor** | `.cursor/rules/<role>-init.mdc` | Rules system |
| **無 slash command 系統** | 通用 prompt 文件 + 對話開頭手動貼入 | 純 prompt |

→ 任一 AI 的 init slash command 實作**必須產出 §2 等效最終狀態**。

### 3.2 實作模板

依 `templates/role-init.md.tpl` 為共通骨架，各 AI 廠商套用替換變數後實例化到自己的 slash command 系統。

新 AI 加入時須：
1. 提交 `roles/<role>/<ai-vendor>.md`，含工具能力清單與職責執行細節
2. 在 `_role.md.tpl` 加入該 AI 的具象化位置欄位
3. 提供至少一個範例 init slash command 實例

---

## 4. 跨 AI 兼容性要求

當 session 在不同 AI 間接班（Claude → Gemini → Cursor → ...）時：

| 要求 | 細節 |
|---|---|
| 等效最終狀態 | 不論誰跑 init，§2 八項狀態必須齊備 |
| 共讀同一份檔案 | `_role.md`、mapping.yaml、protocols、HANDOFF — 各 AI 讀同一份，無私有副本 |
| 統一就緒回報格式 | 跨 AI 對話時可一眼看出對方是否對齊 |

### 統一就緒回報格式

```
✅ <role>-init 完成
- 領域公理：<axiom> v<X>
- 通用條款：AgentCharter v<X> 已載入（依 profile）
- 模式：<eco|verbose>
- 最近 HANDOFF：HANDOFF_<N>.md
- 抽驗模式：<正常 | 強化中（理由：...）>
- 我是：<AI 廠商> 扮演 <role>
- git 狀態：<簡列>
- 待辦：<NextWork 抽 1-2 條>

<role> 值機完成，待派任務。
```

---

## 5. 替換性保證（Substitutability）

| 保證 | 機制 |
|---|---|
| 任何 AI 可被替換 | 退出後新 AI 跑自己的 init → 達等效狀態 |
| 替換無資產損失 | 共同記憶根目錄是物理 anchor，跨 AI 共讀 |
| 替換留審計 trail | `_role.md` 切換歷史 + HANDOFF 鏈跨 AI 接班紀錄 |
| 無隱性綁定 | 「只有 X AI 能扮演此角色」**禁止**；發現即視為違反本條款 |

---

## 6. 五步驟骨架（保留 v0.4 原內容，作為 §3.2 模板執行步驟）

任何 AI 的 init slash command 內部執行流程：

### 步驟 1 — 載入完整協議文件（必讀，禁略）

讀領域公理 + AgentCharter `core/*` + 角色 spec。

### 步驟 2 — 列出核心心智守則（10 條左右）

針對該角色會被踩到的紅線，每條一句話 + 條款引述。詳見 `roles/<role>/_spec.md §5`。

### 步驟 3 — 當前環境快照

讀 `_role.md`、git 狀態、最近 HANDOFF、最新任務膠囊。

### 步驟 4 — 抽驗權狀態檢查

讀失敗模式累積紀錄，判斷對方是否在強化抽驗模式。

### 步驟 5 — 就緒回報（依 §4 統一格式）

完成步驟 1〜4 後輸出極簡就緒回報，回報後**不主動推進任務**，等使用者下達具體指令。

---

## 7. 違反處置

| 違反 | 處置 |
|---|---|
| 跳過 init 即進入工作 | 視同 F1（假宣告就位）；抽驗方有權立即退稿並要求重來 |
| Init 實作未達 §2 等效狀態 | 該 AI 廠商實作不合規，須補強對應 `<ai-vendor>.md` |
| 跨 AI 接班未跑新 AI 的 init | 視為協議違反；新 AI 必須跑自己廠商的 init，不可繼承前任狀態 |
| `_role.md` 未更新切換歷史 | 違反 §1.3 簽名職責；audit trail 缺失 |

---

## 8. 與其他 core 條款的關係

| 條款 | 關係 |
|---|---|
| `role-separation.md` | init 確認角色身份才進入工作，避免越界 |
| `audit-rights.md` | init 守門職責是抽驗權的入口確認 |
| `common-memory-root.md` | init 第一動作為定位本根目錄 |
| `evidence-first.md` | init 守門必用工具證實協議 / 路徑存在 |
| `output-mode-protocol.md` | init 套用模式為其執行入口 |
| `failure-modes.md` | 跳過 init 即視為 F1 |

---

## 9. 變更歷史

- **v0.5.0（2026-04-27）** — 升格為「職責規範」，加 §1 抽象職責、§2 必達狀態、§3 多 AI 具象化、§4 兼容性、§5 替換性保證。原五步驟骨架保留為 §6。
- v0.4（v0.1）— 初版，僅含五步驟骨架。
