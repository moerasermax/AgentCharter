# Governance

> **狀態**：v0.1
> **位階**：本框架治理規則。

---

## 1. 版本權威

| 元件 | 主筆 / 維護者 |
|---|---|
| `core/*` 通用條款 | 框架創始者（目前：使用者）+ 至少一個角色實作 AI 共同核可 |
| `roles/<role>/_spec.md` | 該角色「金本位」維護者（典型由創始者指定）|
| `roles/<role>/<ai-vendor>.md` | 該 AI 廠商代表 / 該 AI 自身 |
| `examples/<project>/` | 該專案維護者 |
| `templates/*` | 框架創始者 |

---

## 2. 變更流程

### 2.1 新增條款（增量項）

| 類型 | 流程 |
|---|---|
| `core/*` 新條款 | PR + 至少一個真實事件背書 + ≥2 名角色實作核可（不同 AI 視角的 reviewer）|
| 新失敗模式 F<n> | PR + 至少一個真實事件觸發紀錄 + 確認偵測法可重現 + 與既有 F-mode 的差異說明 |
| 新角色（如 reviewer / qa）| PR + 角色 spec + 至少一個 AI 實作版 |
| 新 AI 實作版（如 cursor.md）| PR + 工具能力清單 + 每項職責執行細節 + 已知盲區 |

### 2.2 修訂條款

- 「澄清 / 補強」性修訂：可直接 PR + 1 名 reviewer
- 「行為改變」性修訂：須 ≥2 名角色實作 reviewer + 影響專案的維護者知會

### 2.3 刪除條款

**最嚴格**：

- 必須有「為何刪除」的具體理由
- 必須證明無人在用（grep 過所有 examples 與已知 dependents）
- 須 ≥2 名角色實作 reviewer 同意
- 若有專案在引用，須通知該專案維護者並等待回覆

「無作用條款」概念上等同 IRON 修訂限制 — 默認傾向**保留 + 標 deprecated**，而非真實刪除。

---

## 3. 衝突處理

### 3.1 同條款不同 AI 實作版本衝突

例：`roles/engineer/claude-code.md` 與 `roles/engineer/cursor.md` 對「抽驗手段」描述不同。

處理：

1. 先查 `roles/engineer/_spec.md` 是否有明確規定 — 有則對齊 spec
2. 若 spec 沉默 → 各 AI 在自己檔案內描述自己的差異即可，不視為衝突
3. 若 spec 與 AI 實作差異本身衝突 → 升級至「治理層裁決」（§4）

### 3.2 同條款被多專案引用且需求衝突

- 抽出可變參數（如「測試覆蓋率基線」），用 placeholder 讓各專案自填
- 不抽變的核心邏輯 → 強制統一，專案不可在自己的 mapping 內偷偷改

---

## 4. 治理層裁決

當 §3.1 / §3.2 處理不下時：

1. PR 標 `governance-escalation`
2. 召集所有 active 角色實作維護者（至少 2 人）
3. 投票或共識決
4. 結果寫入 `CHANGELOG.md` 並標 `[GOVERNANCE]`

「使用者裁決」適用於框架未啟動 governance 機制前的 v0.x 階段；v1.0 後應由社群 governance 取代。

---

## 5. 與 `escalation-protocol.md` 的差異

| 文件 | 範圍 |
|---|---|
| `core/escalation-protocol.md` | **執行期**多 AI 協作中的失敗升級（含使用者裁決例外）|
| `GOVERNANCE.md`（本檔）| **編輯期**框架本身的治理（誰可改框架條款）|

兩者不可混用。

---

## 6. 私有 vs 公開

當前狀態：**私有**（v0.x）。

公開化決定須滿足：

- v1.0 stable
- 至少 2 個 active 角色實作 AI（避免單 AI lock-in）
- 至少 1 個非 CryptoBot 的真實 example
- LICENSE 決定（建議 MIT 或 Apache 2.0）
