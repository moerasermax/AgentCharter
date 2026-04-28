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

**與其他 F-mode 的差異**：
- vs F1（假宣告已寫入）：F1 是「沒做」，F6 是「做了但沒驗」
- vs F3（捏造數據）：F3 是「謊報」，F6 是「沒測就交」
- vs F5（規則記憶失效）：F5 是「重犯既知規則」，F6 是「漏跑明文規定的驗證步驟」

**典型偵測時點**：下個 AI 進場讀既有產物（mapping / capsule / handoff）發現結構違規。F6 的特徵是「**前一方視為成功、後一方才暴露**」— 結構性轉嫁。

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

### v0.5.10（2026-04-28）

**動作**：F-Catalog 從 v0.1（F1〜F5）擴為 v0.5.10（F1〜F6），新增 F6「未驗證即宣告就緒（轉嫁驗證負擔）」；§5 事件累積範例表加 F6 欄；§7 加 F6 首例觸發紀錄。

**觸發**：dogfood signal #4「具象化 ⊥ 驗證脫鉤」於 YC_AIAgentCrew 接入（2026-04-28）實證 — PM Gemini 寫 `agent-commons/_config/mapping.yaml` 違反 schema、未跑 self-instantiation 結尾驗證、Engineer Claude 進場才被迫進 Phase 3 重寫修補；驗證負擔被結構性地轉嫁給下個 AI。F1〜F5 均不能準確覆蓋此軸（F1 是沒做、F3 是謊報、F5 是重犯既知規則），故獨立成 F6。

**修訂類型**：MINOR — 新增失敗模式不破壞既有行為；但抽驗方掃描清單需多一項。

**連動範圍**：`core/init-template.md §3.3.2 step 5`（self-instantiation 結尾強制驗證點）+ `tools/doctor-spec.md §2.1`（呼叫模式 B 強制驗證）。
