# Session Handoff Chain（交接鏈）

> **狀態**：v0.1
> **位階**：core 通用條款。
> **保證強度**：結構強制（核心 7 項齊全；接班方七步驟自驅屬單 actor 自律輔助）
> **檢測時點**：handoff
> **since**：v0.1

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

當下個 session 由不同 AI 接手（如 Claude → Cursor），除本檔 §2 標準必含項目外，**HANDOFF 須額外完成 `cross-ai-handoff.md` 規定的轉移職責**：

- 退出方：能力快照、強化抽驗狀態、私有筆記轉移宣告、隱性決策清單、未結案膠囊清單（依 cross-ai-handoff.md §3 / §5）
- 接班方：跑自己廠商的 init（含必要時 self-instantiation）、能力差異盤點、狀態繼承、簽名（依 cross-ai-handoff.md §4 / §6）

→ 詳細格式與失敗模式對應見 `cross-ai-handoff.md`。本檔僅保留指向，避免雙處維護。

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
| `versioning-migration.md` | 升級事件須寫進 §2 第 3 項「協議版本迭代軌跡」；BREAKING 升級必含 |
| `working-stack-discipline.md` | save 觸發時 DRAFT 摘要為 HANDOFF（依其 §3.3）；本條款規範 HANDOFF 必含項，前者規範產生流程 |
