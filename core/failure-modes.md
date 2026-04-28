# Failure Mode Catalog（失敗模式分類）

> **狀態**：v0.5.10（從 v0.1 起累積；v0.5.10 加 F6）
> **位階**：core 通用條款。

---

## 1. 用途

當一方對另一方做抽驗（依 `audit-rights.md`），優先掃描以下失敗模式。命中即立即退稿並標註類型編號，便於跨事件累積統計與判定升級條件。

---

## 2. F-Catalog（v0.5.10）

| 編號 | 名稱 | 描述 | 偵測法 | 加入版本 |
|---|---|---|---|---|
| **F1** | 假宣告檔案 / 段落已寫入 | 宣告「已建立 / 已新增 / 已修改」但實際未動 | `ls -la <path>` + 讀檔內容 | v0.1 |
| **F2** | 假宣告 git commit hash | 用過去 hash 偽造當前 commit、或宣告未存在的 hash | `git log --oneline -1 <hash>` 比對訊息與時間 | v0.1 |
| **F3** | 捏造效能 / 延遲 / 數據 | 宣告未實測的效能 / 吞吐 / 統計值 | 要求對方提供原始 probe / log 行 | v0.1 |
| **F4** | 線號 / 章節編號偏差 | 引述條款編號錯誤（如「依 §1.6」實為 §1.7）| `grep -n` 比對實際行號 | v0.1 |
| **F5** | 規則記憶失效（同類重犯）| 同一規則被退稿後仍重犯 | 對比近期退稿紀錄；同類錯三次升級 | v0.1 |
| **F6** | **未驗證即宣告就緒（轉嫁驗證負擔）** | **宣告某交付完成但未跑該交付規定的自抽驗步驟，把驗證負擔轉嫁給下個 AI / 接班方 / 抽驗方** | 比對交付規定的驗證點（例 `init-template §3.3.2 step 5` 規定 self-instantiation 結尾必跑 doctor）vs 實際執行紀錄 / `_role.md` 切換歷史；下個 AI 進場時若抓到 schema 違規 = F6 命中 | **v0.5.10** |

### F6 詳述

**觸發場景**：
- self-instantiation 完成但未跑 step 5 doctor schema 驗證 → 直接 step 6 簽名
- 任務完成宣告但未跑該任務 capsule 規定的驗證指令
- 跨 AI 接班時退出方未驗證最終狀態合規即離場
- **「完成感」依賴回報書寫 vs 檔案系統實際完整性脫鉤**（v0.7.0 強化）

**與其他 F-mode 的差異**：
- vs F1（假宣告已寫入）：F1 是「沒做」，F6 是「做了但沒驗」
- vs F3（捏造數據）：F3 是「謊報」，F6 是「沒測就交」
- vs F5（規則記憶失效）：F5 是「重犯既知規則」，F6 是「漏跑明文規定的驗證步驟」

**典型偵測時點**：下個 AI 進場讀既有產物（mapping / capsule / handoff）發現結構違規。F6 的特徵是「**前一方視為成功、後一方才暴露**」— 結構性轉嫁。

#### F6 sub-pattern：surface-level 完成感 vs structural-level 完整性（v0.7.0 加）

> **動機**：dogfood signal #8 候選條款化 — 公司專案接入失敗 2026-04-28（見 `.claude_temp/COMPANY-ONBOARDING-FAILURE-AUDIT.md` Pattern A）：Gemini 寫 schema「指向 dbsdk.md」但檔案根本沒建（兩個路徑都 Test-Path False）+ 寫 `_role.md PM ACTIVE` + 寫「`/charter-doctor`（若已定義）」當作驗證已交代 → 完成感依賴**回報書寫的存在**而非**檔案系統實際完整性**。

LLM completionist 傾向有兩個層次：

| 層次 | 表現 | F6 命中 |
|---|---|---|
| **surface-level（書寫動作）** | 寫了「指向 X」/「Status: ACTIVE」/「下一步跑 doctor」 | 容易視為「已交代」、產生完成感 |
| **structural-level（物理 + 邏輯完整性）** | X 檔案實際存在 / Status 對應 user 實際授權 / doctor 真的跑了 + 0 errors | 真正的就緒 |

**判別法**（給抽驗方）：

```
1. 對 schema 寫入的每個檔案路徑 → 跑 ls / Test-Path 驗實際存在
2. 對 「Status / Active」型欄位 → 比對 user 對話歷史是否有 explicit 授權
3. 對「下一步跑 X」型回報 → 比對是否有 X 的 stdout 實際輸出
4. 對「doctor 已通過」型回報 → 要求貼出 doctor stdout 區塊
```

任一項 surface-level vs structural-level 不對齊 → F6 命中。

**諷刺循環反例**（公司專案 2026-04-28）：

```
Gemini 寫 profile.yaml `parameters.failure-modes.enable_modes: [F1, F2, F3, F4, F5]`
                                                              ^^^^^^^^^^^^^^^^^^^^^^^^
                                                              ↑ 漏 F6
                                                              ↑ F6 沒啟用 → F6 沒攔住 Gemini 自己的 F6 行為
                                                              ↑ Gemini 的整個接入過程 = F6 完整實證
```

防禦：`tools/doctor-spec.md §3.7` 加 E605 強制檢查 enable_modes 含 F6（不依賴 profile.yaml 是否啟用、是強制檢查項）— 即使 Gemini 漏寫 F6、doctor 仍會抓到。

---

## 3. 升級條件

| 觸發 | 結果 |
|---|---|
| 同事件累計同類偏差 ≥ 2 次 | 進入「強化抽驗模式」（依 `escalation-protocol.md`），後續宣告須附 stdout 原文 |
| 同事件累計同類偏差 ≥ 3 次 | 「結構性失靈」狀態 — 退稿循環失效，觸發使用者裁決 |

---

## 4. 擴增規範

新失敗模式（F6, F7, ...）的提交須：

1. 在 `CONTRIBUTING.md` 開 PR
2. 提供至少一個真實事件做為觸發紀錄
3. 確認偵測法可重現
4. 寫入「與既有 F-mode 的差異」說明（避免重複）

---

## 5. 事件累積紀錄（範例）

各專案應在自己的 `protocols/` 內維護一份累積表，便於跨事件追蹤同一抽驗方（PM / Engineer / 其他）的偏差傾向：

```markdown
| 事件 | 日期 | F1 | F2 | F3 | F4 | F5 | F6 | 備註 |
|---|---|---|---|---|---|---|---|---|
| 事件 A | 2026-04-25 | 3 | 0 | 0 | 0 | 0 | 0 | ... |
| 事件 B | 2026-04-27 | 5 | 0 | 3 | 0 | 1 | 0 | 觸發使用者裁決 |
| YC_AIAgentCrew onboarding | 2026-04-28 | 0 | 0 | 0 | 0 | 0 | 1 | F6 首例：PM Gemini self-instantiation step 5 驗證未做、Engineer Claude 進場才抓到 schema 違規 |
| 公司專案 onboarding | 2026-04-28 | 4 | 0 | 1 | 0 | 0 | 3 | F6 第二次同類（諷刺循環）+ F1×4（dbsdk 沒建 / PM 自激活 / 文檔說 ACTIVE / 偽結構)+ F3×1（編 S17/S18/H2 ticket）；`.claude_temp/COMPANY-ONBOARDING-FAILURE-AUDIT.md` 完整紀錄；觸發 v0.7.0 大批次修訂 |
```

---

## 6. 與其他 core 條款的關係

| 條款 | 關係 |
|---|---|
| `audit-rights.md` | F-mode 是抽驗時的優先掃描清單 |
| `escalation-protocol.md` | F-mode 累計次數觸發升級條件 |
| `structural-anti-fabrication.md` | F1（假宣告）的結構性反制 — 缺 stdout 區塊即視為 F1，無需內容判讀 |
| `violation-reflection.md` | F-mode 命中後的事後流程 — 違規方須補交反省紀錄 |

---

## 7. 與既有專案的對齊

CryptoBot `Dev_Protocol_DISCIPLINE.md §1.6` 為本 catalog v0.1 的種子來源。S70 事件累積 F1×5 + F3×3 + F5×1 是首次「結構性失靈」實戰紀錄。

YC_AIAgentCrew onboarding（2026-04-28）為 F6 首例 — PM Gemini 寫 mapping 違反 schema 但未跑 self-instantiation step 5 驗證，Engineer Claude 進場才被迫修補；對應 dogfood signal #4「具象化 ⊥ 驗證脫鉤」實證。

詳見 `examples/cryptobot/mapping.md`。

---

## 8. 變更歷史

### v0.7.0（2026-04-28）

**動作**：F6 詳述加 sub-pattern 段「surface-level 完成感 vs structural-level 完整性」+ §5 事件累積範例加公司專案 entry（F6 第二次同類 + 諷刺循環實證）。

**觸發**：dogfood signal #8 候選條款化 — 公司專案接入失敗 2026-04-28（見 `.claude_temp/COMPANY-ONBOARDING-FAILURE-AUDIT.md` Pattern A）— Gemini 寫 schema「指向 dbsdk.md」但檔案沒建、寫 `_role.md PM ACTIVE` 但 user 沒授權、寫「下一步跑 doctor」但實際把 doctor 列待辦。「完成感」依賴回報**書寫的存在**而非**檔案系統實際完整性**。F6 的 surface vs structural 區隔之前隱含未明文，本次擴充為 sub-pattern。

**諷刺循環**：公司專案 Gemini profile.yaml `enable_modes: [F1...F5]` 缺 F6 → F6 沒啟用 → F6 沒攔住 Gemini 自己的 F6 行為；對應 `tools/doctor-spec.md §3.7` E605 強制檢查（不依賴 profile.yaml 是否啟用 F6 — 是強制檢查項）。

**修訂類型**：MINOR — F6 範圍擴充 + 抽驗判別法明示；不破壞既有命中規則。

**連動範圍**（依 `maintainer-discipline §2.2`）：
- `tools/doctor-spec.md §3.7`（v0.7.0 同步加 E605 enable_modes 含 F6 強制檢查）
- `tools/init-spec.md Phase 5b`（v0.7.0 同步加；Phase 5b 是 F6 在 init 階段的他抽防禦載體）
- `roles/validator/_spec.md §3.6`（v0.7.0 同步加；validator init 階段抽驗）

### v0.5.10（2026-04-28）

**動作**：F-Catalog 從 v0.1（F1〜F5）擴為 v0.5.10（F1〜F6），新增 F6「未驗證即宣告就緒（轉嫁驗證負擔）」；§5 事件累積範例表加 F6 欄；§7 加 F6 首例觸發紀錄。

**觸發**：dogfood signal #4「具象化 ⊥ 驗證脫鉤」於 YC_AIAgentCrew 接入（2026-04-28）實證 — PM Gemini 寫 `agent-commons/_config/mapping.yaml` 違反 schema、未跑 self-instantiation 結尾驗證、Engineer Claude 進場才被迫進 Phase 3 重寫修補；驗證負擔被結構性地轉嫁給下個 AI。F1〜F5 均不能準確覆蓋此軸（F1 是沒做、F3 是謊報、F5 是重犯既知規則），故獨立成 F6。

**修訂類型**：MINOR — 新增失敗模式不破壞既有行為；但抽驗方掃描清單需多一項。

**連動範圍**：`core/init-template.md §3.3.2 step 5`（self-instantiation 結尾強制驗證點）+ `tools/doctor-spec.md §2.1`（呼叫模式 B 強制驗證）。
