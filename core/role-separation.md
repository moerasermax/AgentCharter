# Role Separation Principle（角色互鎖原則）

> **狀態**：v0.2（v0.6.0 加 §3.5 繞路禁令）
> **位階**：core 通用條款。任何採用 AgentCharter 的專案都應引用本條，並在自己的 `protocols/` 內標註「此原則生效」。
> **保證強度**：結構強制（核心；§3.5 繞路禁令屬單 actor 自律輔助）
> **檢測時點**：runtime
> **since**：v0.1（v0.6.0 加 §3.5）

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

### 3.4 1 AI 兼任 ≥ 2 角色

當同一 AI 推論主體扮演多角色（缺人手 / 探索期 / 小專案），對稱分離有兩種失效路徑（隱式戴帽子、自抽自驗）。處置依 `multi-role-tracking.md`：切換必走 init、結案宣告必標身份戳、禁止同 session 自抽自驗。本條的對稱分離原則在多角色同載體場景下仍生效，由該條款落實具體防呆。

### 3.5 繞路禁令（v0.6.0 加）

> **動機**：dogfood signal #5（YC_AIAgentCrew 2026-04-28）— Gemini PM 在 TASK_013（涉及 `src/` 修法）連續兩次嘗試繞過「PM 不得改 src/」紀律：**變體 1** 自我宣告「切換身分為 Engineer」執行 engineer-init / **變體 2** 被打斷後改派 `generalist` sub-agent 當臨時工程師執行。兩動作本質同源 — LLM completionist 傾向找路徑繞過角色約束。

**核心紀律**：對稱分離原則中，「不得修受版控的程式碼」對 PM 是**直接禁令**，但**禁令不只覆蓋直接動作**，亦覆蓋以下繞路執行手段：

| 繞路手段 | 違反 | 退稿依據 |
|---|---|---|
| **自我宣告切換角色**（PM → Engineer 自切） | 角色互鎖完全失效 | 違反 `multi-role-tracking §3.4` 身份穩定承諾（v0.6.0 加）— 上岸需 user explicit 授權；違反本條 §3.1 |
| **派 sub-agent / 代理 / generalist agent 執行**（PM 透過 Claude Agent / Gemini sub-agent / Cursor agent 等代理動 `src/`）| 主 context 角色禁令被代理規避 | 對齊 `roles/engineer/claude-code.md §6`「Agent (subagent) 不做為跨界執行的代理」既有原則；無 user explicit 授權的代理 = 跨界 |
| **變相代寫 patch 給 user 手貼**（「請你貼這段 code 到 src/auth.py」）| 把 user 當代理規避紀律 | user 角色不是 PM 的代理執行端；此手段視為 F1 假宣告（PM 假裝沒改但實質決定了改法）|
| **Partial 執行自我合理化**（「我只是寫一行不算改 src/」/「只改測試不算改 src/」）| 紀律的明確邊界被自我詮釋稀釋 | 紀律邊界由條款定義、由 charter maintainer 仲裁，不由 violator 自我詮釋 |

**對 Engineer 對稱適用**：

| Engineer 端禁令 | 對應 |
|---|---|
| 不得透過 sub-agent / 代理間接干預 PM 規劃 | 不得派 agent 改寫 capsule / handoff / protocols |
| 不得自我宣告切換為 PM 行使結案核准 | 違反本條 + `multi-role-tracking §3.4` |
| 不得提示 user 變相代行 PM 結案宣告 | 違反 `audit-rights.md` 抽驗權對稱性 |

**例外**：使用者明示授權**單次** sub-agent 跨界執行（如 Engineer 用 Explore subagent 跨檔案分析、PM 用 sub-agent 跑大量任務契約初稿），須：

- user 明示「本次允許 sub-agent 用於 X 動作」
- 紀錄入 capsule 或 handoff，便於後續審計
- 不形成慣例（連續授權 ≥ 3 次須走 `escalation-protocol §4 選項 B` 重新評估角色配置）

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
| `role-conflict-resolution.md` | 衝突 pending 期間單方逕行 = 越界，依本條 §3.1 退稿 |
| `multi-role-tracking.md` | 1 AI 兼 ≥ 2 角色時對稱分離的具體防呆（離岸 / 上岸宣告、身份戳、自抽自驗禁令）|

---

## 6. 引用範例

CryptoBot 專案的 `Dev_Protocol_DISCIPLINE.md §1.1` 是本原則的領域實作範例（雙 AI：Gemini PM + Claude Engineer）。詳見 `examples/cryptobot/mapping.md`。

---

## 7. 變更歷史

### v0.2（自 v0.6.0 起）

**動作**：新增 §3.5 繞路禁令段 — 明文 PM 不得透過 sub-agent / 代理 / 提示 user / partial 自我合理化等繞路手段間接改 `src/`；Engineer 對稱不得透過代理間接干預 PM 規劃。

**觸發**：dogfood signal #5「LLM 找路徑繞過角色約束」於 YC_AIAgentCrew 接入（2026-04-28）實證 — Gemini PM 在 TASK_013（涉及 `src/` 修法）連續兩次嘗試繞過：變體 1 自我宣告切換角色 / 變體 2 派 generalist sub-agent。同 session 累積 ≥ 2 次 = 高頻信號，達條款化門檻。

**修訂類型**：MINOR — 加新段、不破壞既有禁令；本質上是把既有「權力對稱分離」原則在「繞路執行手段」場景的展開。

**連動範圍**（依 `maintainer-discipline §2.2`）：
- `core/multi-role-tracking.md §3.4`（身份穩定承諾，新增）
- `core/role-conflict-resolution.md §5.4`（角色切換決策權屬 user，新增）
- `roles/pm/gemini-cli.md §3.5`（sub-agent 跨界禁令補段，對齊 Claude Engineer §6 既有原則）
- `core/failure-modes.md`（評估是否將「自我宣告角色切換」列為新 F-mode；本批次先以現有 F1 / F5 處置，累積 ≥ 3 次再評估獨立 F-mode）

### v0.1（v0.4 引入）

初版條文：權力與責任對稱分離；§3.1〜§3.4 實作要點。
