# Working Stack Discipline（暫存堆疊紀律 / DRAFT-HANDOFF 兩級存檔）

> **狀態**：v0.1（自 v0.5.7 引入）
> **位階**：core 通用條款。**處理 session 內中途累積與物理中斷再續**，是 v0.5.x 之前 charter 結構性盲區的補完。
> **依存**：`handoff-chain.md`（結案級存檔）、`cross-ai-handoff.md`（換 AI 載體）、`failure-modes.md`、`evidence-first.md`、`common-memory-root.md`、`charter-config.md`
> **保證強度**：結構強制（DRAFT 須是檔案、不為對話累積）
> **檢測時點**：runtime + handoff
> **since**：v0.5.7

---

## 0. 概念位階 — 三種接班場景的正交補完

charter 在 v0.5.6 之前覆蓋兩種接班場景：

| 場景 | 條款 | 觸發 |
|---|---|---|
| **session 末交接** | `handoff-chain.md`（結案級 / 重型）| 一個工作段結束、寫完整 HANDOFF |
| **AI 廠商換手** | `cross-ai-handoff.md`（換載體）| 不同 AI 接同一角色（如 Claude → Gemini）|

但**第三種場景**長期空白：

| 場景 | 條款 | 觸發 |
|---|---|---|
| **session 內物理中斷再續** | **本條款**（暫存級 / 輕型）| 同 AI 同身份，但物理 context 重啟（額度滿 / context window 清空 / 模型切換省 token / 使用者中斷後續開）|

→ 三條款**互斥且互補**：
- handoff-chain 處理**邏輯結案**（工作段完成）
- cross-ai-handoff 處理**載體換手**（AI 廠商不同）
- **本條款處理物理中斷**（同身份的非結案性續接）

---

## 1. 條文

任何持續超過單次推論週期的工作，**應在 `DRAFT_CONTEXT.md` 累積關鍵證據**；觸發 save 時 DRAFT 摘要為 HANDOFF 並**同步 git commit**；同身份 session 重啟時必讀最新 DRAFT 接續。

---

## 2. DRAFT_CONTEXT 必含 / 不含

`DRAFT_CONTEXT.md` 位於 `mapping.yaml.shared.draft_context` 指向位置（典型：`<common-memory-root>/DRAFT_CONTEXT.md`）。

### 2.1 必含

| 內容類別 | 範例 |
|---|---|
| 關鍵 stdout 原文 | 跑過的 test / build / probe 結果（依 `evidence-first.md`）|
| 決策軌跡 | 「採 A 不採 B，因 X 條款 §Y」這類判斷 |
| 未結案 capsule 的中間狀態 | capsule ID + 當前進度 + 待解問題 |
| 修改檔案清單 | git status 摘要 / 重要 diff 段 |
| 違規 / 衝突事件 | 觸發了哪條 F-mode 或 role-conflict-resolution 的事件 |

### 2.2 不含

| 內容類別 | 動機 |
|---|---|
| ❌ 完整對話 log | 太大；DRAFT 是摘要不是 transcript |
| ❌ 純探索性思路（無實作）| 思路在腦中；DRAFT 是工作素材 |
| ❌ 第三方系統的全 raw payload | 取關鍵欄位即可，全 payload 放 capsule annotation |
| ❌ 已寫進 capsule / handoff 的內容 | 避免重複；DRAFT 是「尚未轉正」的層 |

### 2.3 DRAFT 與其他存檔的位階

```
即時對話        ←→ session 揮發（不入 git）
↓ 累積關鍵
DRAFT_CONTEXT   ←→ session 內持久（入 git，輕量）
↓ save 觸發
HANDOFF_<N>     ←→ session 末永久（入 git，重型）
↓ 沉澱
Institutional Memory ←→ 跨事件知識（入 git，集體記憶）
```

---

## 3. save 觸發條件

### 3.1 手動觸發

使用者明示 save（如 `/checkpoints save`）。

### 3.2 自動觸發候選（v0.6+ 工具層落實）

非強制，由採用方依需求啟用：

| 條件 | 動機 |
|---|---|
| Context window 接近上限（如 85%）| 避免重啟前丟失累積 |
| DRAFT_CONTEXT 大小超過閾值（如 5KB）| 避免單一 DRAFT 過大 |
| 時間閾值（如距上次 save ≥ 4 小時）| 避免長 session 累積過久 |
| 事件閾值（如 N 個 capsule 結案）| 對齊工作節點 |

→ 自動觸發是**建議**而非條款強制。手動觸發是基礎。

### 3.3 save 動作的最低標準

| 步驟 | 細節 |
|---|---|
| 1. DRAFT → HANDOFF 摘要 | 不可 copy-paste 原文；須**重整為交接級摘要**（依 `handoff-chain.md §2` 七項必含） |
| 2. 寫入 HANDOFF_<N+1>.md | N 自動遞增（若工具支援）或手動指定下一序號 |
| 3. 歸檔完工膠囊（若有）| 完工 capsule 移至 `mapping.yaml.shared.archive` 指向位置 |
| 4. 更新 NextWork | 完工項從 Active 移至 Completed，新增 Up Next |
| 5. **git commit**（強制，依 §4）| save 與 commit 不可分離 |
| 6. 清空 DRAFT_CONTEXT | 上述全部成功後才清空 |

任一步驟失敗 → 整個 save 動作回滾，DRAFT 不清空。

---

## 4. 與 git commit 的綁定（核心紀律）

### 4.1 條文

**save 必須同步 git commit**。DRAFT/HANDOFF 與 git history 不可偏離。

### 4.2 動機

| 違反場景 | 後果 |
|---|---|
| save 寫 HANDOFF 但忘 commit | 下次 git log 看不到該 HANDOFF；session 重啟若有人 git pull 即丟失 |
| commit 但 DRAFT 沒清 | 同份內容存兩處（DRAFT 重複了 HANDOFF），下次 save 會雙重摘要 |
| save 寫 HANDOFF 但 git tree 不乾淨（有未 commit 的工作）| HANDOFF 描述的狀態 ≠ git 狀態，違反 evidence-first |

→ save = HANDOFF 寫入 + commit + DRAFT 清空，**三件不可拆**。

### 4.3 無 git 環境的 fallback

採用方無 git（探索期 / 短期實驗）：

- save 仍可執行，但 §4.1 git commit 步驟跳過
- HANDOFF 結尾須加註：「⚠️ 偵測非 git repo，未執行 commit」
- /charter-doctor 警示：「建議 `git init` 後手動補回」
- 視為 minimal preset 場景（charter-config.md profile.yaml 可標明）

---

## 5. session 重啟接班（核心）

### 5.1 觸發

「session 重啟」 = 同 AI / 同身份 / 同專案，但**物理 context 重啟**：

| 觸發類型 | 範例 |
|---|---|
| context 額度恢復 | API 限流解除後續開 |
| context window 清空 | 對話過長被 reset / 主動 /clear |
| 模型版本切換（同廠商）| Opus → Sonnet 省 token、Haiku 跑批量 |
| 使用者中斷後續開 | 開會 / 下班 / 第二天回來 |

**不**包含：
- 不同 AI 廠商接班（→ `cross-ai-handoff.md`）
- 不同身份接班（同 AI 但角色變了，→ `multi-role-tracking.md`）
- 邏輯結案後新工作段（→ `handoff-chain.md`）

### 5.2 接班動作

```
1. 讀最新 HANDOFF_<N>.md（依 handoff-chain.md §2，跨 session 接班共用）
2. 讀 DRAFT_CONTEXT.md
   - 若 size = 0 → session 內無中斷累積，正常接班
   - 若 size > 0 → 有未 save 的累積，本 session 從中斷點續接
3. 對齊狀態：
   - 領域公理 / charter / 角色 spec 仍生效（同身份不需重讀，但建議掃過）
   - 強化抽驗模式狀態繼承（無中斷則狀態不變）
   - 未結案 capsule 從 DRAFT 拉出當前進度
4. 不寫新身份戳（依 multi-role-tracking §3.2 — 身份未變）
5. 不追加 _role.md 切換歷史（依 cross-ai-handoff §6 — 載體未變）
6. 繼續未完工作
```

### 5.3 與其他接班場景的辨識表

| 接班場景 | AI 廠商 | 身份 / 角色 | 物理 context | 條款入口 |
|---|---|---|---|---|
| session 末完整交接 | 不限 | 不限 | 結案 + 新 session | `handoff-chain.md` |
| 跨 AI 廠商接班 | **變** | 不變 | 切換 | `cross-ai-handoff.md` |
| 同 AI 多角色切換 | 不變 | **變** | 不變 | `multi-role-tracking.md` |
| **session 內物理中斷再續** | 不變 | 不變 | **變** | **本條款** |

辨識權：接班 AI 第一輪自我判定；爭議時由使用者裁決。

### 5.4 物理中斷未 save 的處置

最壞情境：物理中斷發生在 save 之前（DRAFT 累積但沒 save 就斷線）：

| 損失程度 | 因應 |
|---|---|
| DRAFT_CONTEXT 已入 git | 0 損失（git pull 即可重現）|
| DRAFT 未 commit 但本機檔案在 | 重啟後讀本機 DRAFT 即可續 |
| DRAFT 連本機檔案都沒（純對話累積）| **損失**；接班 AI 須回頭從上一份 HANDOFF + git log 重建脈絡 |

→ 紀律：**DRAFT 須是檔案而非對話累積**。本條款 §1 「應在 `DRAFT_CONTEXT.md` 累積」是強制要求。

---

## 6. 與其他 core 條款的關係

| 條款 | 關係 |
|---|---|
| `handoff-chain.md` | save 觸發時 DRAFT → HANDOFF，依其 §2 必含 7 項；本條款規範「該怎麼產生」，handoff-chain 規範「該長什麼」 |
| `cross-ai-handoff.md` | 跨 AI 接班時，退出方應先觸發 save（DRAFT → HANDOFF）再交接；接班方依其 §4 接收，本條款場景不重複 |
| `multi-role-tracking.md` | 身份切換時不適用本條款 §5（屬該條款管轄）；DRAFT 仍可累積（記不同身份段） |
| `init-template.md §1.4` | 守門步驟須讀最新 DRAFT（若有），對齊 session 內中斷累積 |
| `evidence-first.md` | DRAFT 必含內容（§2.1）即 evidence-first 的「關鍵 stdout / 證據」沉澱 |
| `failure-modes.md` | 違反觸發 F1 / F4 / F5（依 §7） |
| `common-memory-root.md` | DRAFT_CONTEXT.md 位置在 mapping.yaml.shared.draft_context；archive 位置在 shared.archive |
| `charter-config.md` | mapping.yaml schema 須擴 `shared.draft_context` + `shared.archive` 兩欄 |

---

## 7. 違反處置

當本條款被違反，依 `failure-modes.md` 對應如下（不另立新 F-mode）：

| 違反方式 | 失敗模式 |
|---|---|
| save 寫 HANDOFF 但未 git commit | F4（編號 / 紀錄偏差）|
| DRAFT 累積但純存對話 / 無檔案 | F4 + 結構性不交付（依 `structural-anti-fabrication.md`） |
| save 後 DRAFT 未清空 | F5（規則記憶失效），下次 save 會雙重摘要 |
| session 重啟跳過讀 DRAFT 即進入工作 | F1（假宣告就位）|
| HANDOFF 寫入但 git tree 有未 commit 工作 | F4（紀錄偏差）+ 違反 evidence-first |
| 跨 AI 接班時退出方未先 save 即離開 | F4 + 違反 cross-ai-handoff §3.1 |

---

## 8. 與 CryptoBot 既有實作的對應（reference impl）

CryptoBot 專案的 `~/.claude/commands/checkpoints.md` slash command 是本條款的實證 reference impl：

| CryptoBot 概念 | 本條款對應 | 抽象化方向 |
|---|---|---|
| `management/DRAFT_CONTEXT.md` | `<common-memory-root>/DRAFT_CONTEXT.md` | 路徑由 mapping.yaml 指定 |
| `management/history/HANDOFF_N.md` | `<common-memory-root>/handoffs/HANDOFF_<N>.md` | 同 handoff-chain §6 |
| `management/history/archive/` | `<common-memory-root>/<archive 槽位>` | mapping.yaml.shared.archive |
| `Dev_Protocol_DISCIPLINE §6.5` | `core/handoff-chain.md` | charter 對應條款 |
| `PM_Operational_Manual §1.3`（暫存堆疊紀律 / save 同步 git commit）| **本條款 §4** | 抽象化至 framework 層 |
| Smart Name Mapping（自動遞增）| `handoff-chain §6`（命名規則）+ 工具層自動化候選 | 工具實作議題 |

→ CryptoBot 的 checkpoints.md 預期在 v1.0 後改為**反向引用本條款**（dogfood signal）。當前階段（v0.x）兩處平行維護，本條款先建立 framework 級規範。

---

## 9. 變更歷史

- **v0.1（自 v0.5.7 引入）** — 初版。補完 charter v0.5.6 之前的「session 內物理中斷再續」結構性盲區。從 CryptoBot `~/.claude/commands/checkpoints.md` + `PM_Operational_Manual §1.3` 抽象化而來。三種接班場景（結案 / 換 AI / 物理中斷）至此正交完整。
