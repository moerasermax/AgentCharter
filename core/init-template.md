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

### 3.3 AI 自我具象化（Self-Instantiation）— **首選機制**

> **核心原則**：框架**不代替任何 AI 生成 slash command**。AI 是自我建造的造物。

當任何 AI 第一次被指派扮演某角色時（無對應 slash command），該 AI 必須執行**自我具象化流程**：

#### 3.3.1 觸發條件

- 使用者向 AI 表達「你來當 \<role\>」
- AI 讀 `<common-memory-root>/roles/<role>/_role.md` 發現自己廠商的 slash command 位置標為 ❌（未實裝）
- 任何時候 AI 偵測到自己的具象化檔案不存在

#### 3.3.2 自我具象化步驟

```
1. 讀 AgentCharter charter（位置由使用者提供或環境變數 $CHARTER_DIR）：
   - core/init-template.md（本檔，職責規範）
   - core/role-separation.md / audit-rights.md / ...（依 profile 啟用）
   - roles/<role>/_spec.md（職能定義）
   - roles/<role>/<my-vendor>.md（若存在；該 AI 廠商的執行細節）
   - templates/role-init.md.tpl（通用骨架）

2. 讀專案配置：
   - <common-memory-root>/_config/profile.yaml（哪些條款啟用、參數）
   - <common-memory-root>/_config/mapping.yaml（路徑對映）
   - <common-memory-root>/protocols/<axiom>.md（領域公理）

3. 自我具象化 — 在自己 AI 系統的標準位置生成 slash command 檔案：
   - Claude Code → .claude/commands/<role>-init.md
   - Gemini CLI → .gemini/commands/<role>-init.toml（或對應 Gemini 慣例）
   - Cursor → .cursor/rules/<role>-init.mdc
   - 無 slash 系統 → <common-memory-root>/roles/<role>/init-prompt.md（純 prompt 給使用者手動貼）

4. 內容生成原則：
   - 套用 templates/role-init.md.tpl 變數
   - 內部執行五步驟（依 §6）必達 §2 等效最終狀態
   - 加入該 AI 廠商特有的工具呼叫（如 Claude 用 Read/Bash、Gemini 用對應 API）
   - 套用 <my-vendor>.md 的執行細節（若有）

5. 簽名：
   - 更新 <common-memory-root>/roles/<role>/_role.md 的「各 AI 具象化位置」表
   - 將自己廠商的「是否實裝？」改為 ✅
   - 在切換歷史追加一行：「<日期> / <我> / 自我具象化完成」

6. 回報使用者：
   - 「我已建好我的 <role>-init slash command，位於 <具象化位置>」
   - 「你下次打 /<role>-init 即可使用」
   - 邀請使用者立刻跑一次驗證
```

#### 3.3.3 為何這樣設計

| 替代方案 | 缺點 |
|---|---|
| 框架代生成（init-spec Phase 4 自動產 .claude/commands/）| 框架越界決定其他 AI 的 slash 機制；不同 AI 系統差異無法兼顧 |
| 使用者手動寫 | 高接入摩擦；複雜度推給使用者 |
| **AI 自我具象化（本機制）** | 框架只定義職責，AI 自選最熟悉自己系統的實作；對齊「角色 ⊥ AI」公理 |

#### 3.3.4 跨 AI 接班的 self-instantiation 鏈

當不同 AI 接班同一角色時，每個 AI 各自做一次 self-instantiation：

```
T1: Gemini 接 PM → 自我具象化 → .gemini/commands/pm-init.toml ✅
T2: Claude 接 PM（Gemini 額度用完）→ self-instantiation → .claude/commands/pm-init.md ✅
    （兩個 slash command 並存，未來任何 AI 重新接手皆有對應）
T3: 第一個 AI 回鍋 → 直接跑既有 slash command（無需重新具象化）
```

`_role.md` 的「各 AI 具象化位置」表是這個鏈的**集體記憶 anchor**。

#### 3.3.5 違反處置

| 違反 | 處置 |
|---|---|
| AI 拒絕自我具象化（要求使用者手動寫）| 違反「替換性保證」+ 「角色 ⊥ AI」公理；該 AI 廠商實作不合規 |
| 自我具象化完成但未更新 `_role.md` | 違反 §1.3 Sign-in 職責；audit trail 缺失 |
| 自我具象化的 slash command 缺步驟（不滿足 §2 八項狀態）| 該實作為次品，下次 init 時須重新具象化 |

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
