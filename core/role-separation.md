# Role Separation Principle（角色互鎖原則）

> **狀態**：v0.1
> **位階**：core 通用條款。任何採用 AgentCharter 的專案都應引用本條，並在自己的 `protocols/` 內標註「此原則生效」。

---

## 1. 條文

在多角色協作中（典型雙 AI：PM + Engineer），**權力與責任必須對稱分離**：

| 權力 | 唯一持有者 | 對稱責任 |
|---|---|---|
| 程式碼寫入權（`src/`、`tests/`、可執行設定）| **Engineer** | 不得宣告完工 / 結案 |
| 任務契約撰寫權（task capsule、需求文件、結案宣告）| **PM** | 不得修改受版控的程式碼 |
| Shell 命令執行權（git、build、test、外部 API）| **Engineer** | 須對 PM 提供可重現指令 |
| 抽驗權（audit）| **Engineer**（對 PM 結案宣告）| **PM**（對 Engineer 完工驗收）| 雙向抽驗，互不獨佔閉環 |

兩者**不應有「免互鎖」捷徑**。任一方獨佔閉環即視為違反本原則。

---

## 2. 設計動機

不對稱的後果：

- **PM 兼有寫程式碼權** → 結案宣告無 Engineer 抽驗 → 假宣告無代價 → 系統真相被污染
- **Engineer 兼有結案權** → 沒有外部驗收 → 個人偏見變專案標準 → 集體決策退化
- **任一方獨佔抽驗權** → 另一方淪為執行端 → 協作降級為單向命令

對稱分離強制兩端必須交付可驗證產物，互為彼此的事實檢核器。

---

## 3. 實作要點

### 3.1 權力越界即時退稿

| 越界場景 | 應對 |
|---|---|
| PM 嘗試 commit 程式碼 / 提交程式碼差異 | Engineer 立即退稿，要求 PM 改寫成「程式碼指令」交回 Engineer 執行 |
| Engineer 自行宣告「膠囊已結案」 | PM 拒絕關膠囊，要求 Engineer 改為「核准結案請求」由 PM 結案 |
| 任一方拒絕對方的抽驗 | 觸發 `escalation-protocol.md` 升級 |

### 3.2 例外授權必須單次明示

當不得不打破互鎖（如 PM 端工具失靈、Engineer 端時間窗口受限），須**使用者明示授權**且**不形成慣例**。授權範圍須寫進對應 capsule 或 handoff，便於後續審計。

### 3.3 多於兩個角色時的延伸

新增角色（Reviewer、QA、SRE）時，每個新角色須明示：
- 該角色的「權力槽位」是什麼
- 與既有角色的職責邊界（無重疊、無斷層）
- 抽驗關係（誰抽驗誰）

---

## 4. 對應的失敗模式

當本原則被違反，常見後果（與 `failure-modes.md` 互引）：

| 違反方式 | 失敗模式 |
|---|---|
| PM 假宣告完工繞過 Engineer 抽驗 | F1（假宣告檔案 / 段落已寫入）|
| Engineer 自行結案不報 PM | （角色越界，未列入 F-table，視為紀律事件）|
| 任一方放棄抽驗權「相信對方」| 規則記憶失效（F5）— 抽驗權不得放棄是硬規則 |

---

## 5. 與其他 core 條款的關係

| 條款 | 關係 |
|---|---|
| `audit-rights.md` | 本原則的「抽驗」槽位由 audit-rights 詳述 |
| `escalation-protocol.md` | 互鎖被違反時的升級路徑 |
| `evidence-first.md` | 抽驗時的證據要求 |

---

## 6. 引用範例

CryptoBot 專案的 `Dev_Protocol_DISCIPLINE.md §1.1` 是本原則的領域實作範例（雙 AI：Gemini PM + Claude Engineer）。詳見 `examples/cryptobot/mapping.md`。
