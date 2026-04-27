# Session Handoff Chain（交接鏈）

> **狀態**：v0.1
> **位階**：core 通用條款。

---

## 1. 條文

每個 Session 結束時必須新增一份 `HANDOFF_<N>.md`，下個 Session 從上一份讀起。**HANDOFF 鏈是工作交接的真理**。

---

## 2. 必含項目（缺一不可）

| 項目 | 說明 |
|---|---|
| 1. 里程碑摘要 | 本 session 達成的高層目標（一段話）|
| 2. 完整任務清單 | 列出**所有**完成的任務 / 膠囊 / hotfix 檔名；**禁止**為敘事流暢吞 hotfix 進主任務 |
| 3. 協議版本迭代軌跡 | 本 session 修改過的協議文件（IRON / DISCIPLINE / 其他）的版號變化 + 涵蓋條款 |
| 4. 知識庫新增段落引述 | 本 session 寫入 `Institutional_Memory` 等知識文件的新章節須在 HANDOFF 摘要層級被點名 |
| 5. 技術指標 | 測試通過率、build 警告數、覆蓋的 VCP 數 |
| 6. 下一階段預告 | 明確的 NextWork 項目，與本 session 殘留待辦 |
| 7. 待 commit 清單 | 列出本 session 觸發的所有檔案異動，並建議 commit 訊息 |

---

## 3. 禁止項目

| 禁令 | 動機 |
|---|---|
| ❌ 未經實證的描述性括號（如「(已校準)」「(已測試)」「(已部署)」）| 無證據即標明為待驗，避免假宣告污染下個 session 認知 |
| ❌ 把 hotfix 軌跡吞進主任務描述 | 每個 hotfix 都代表一段「真實技術債發現 → 修復」軌跡，必須能從 HANDOFF 看到這條軌跡 |
| ❌ 省略協議版本迭代 | 下個 session 接班時必須能看到「協作協議升級」這條軸 |

---

## 4. 抽驗權

抽驗方（典型：撰寫 HANDOFF 的非主筆）收到完成的 HANDOFF 後**必須**抽驗一次內容真實性（與實際檔案、git log、testcase 數量比對），不符合即回頭要求補強。

抽驗依據對應的失敗模式分類（`failure-modes.md` F1〜F5）執行。

---

## 5. 跨 AI 交接的特別規範

當下個 session 由不同 AI 接手（如 Claude → Cursor），HANDOFF 須額外含：

- 本 session 用過的工具能力（hook、shell、特定 MCP server）
- 接班 AI 若無對應能力的 fallback 路徑
- 任何不可重現的 stateful 副作用（如本機暫存檔、特定 process 保留）

---

## 6. 命名與位置建議

| 元素 | 建議 |
|---|---|
| 檔名 | `HANDOFF_<遞增編號>.md`（避免日期，因為跨日 session 不只一個）|
| 目錄 | `<project>/management/history/` 或 `<project>/handoffs/` |
| 歸檔 | 完成後不刪除，永久保留作為審計 trail |

---

## 7. 與其他 core 條款的關係

| 條款 | 關係 |
|---|---|
| `audit-rights.md` | HANDOFF 是跨 session 結案宣告，必抽驗 |
| `completion-delivery.md` | 個別任務的 VCP 結果應在 HANDOFF 引述 |
| `failure-modes.md` | 本 session 累積的失敗模式紀錄應寫入 |
