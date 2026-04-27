# Structural Anti-Fabrication（結構性反捏造）

> **狀態**：v0.1（與 v0.1 骨架同期，列入 0.1.x 補強）
> **位階**：core 通用條款。

---

## 1. 條文

任何**事實型宣告**（claim of fact）的成立**不依賴宣告方的誠實**，而依賴**文檔結構的強制證據欄位**。

具體要求：宣告方撰寫的 capsule / handoff / 結案訊息 / 完工交付，**結構模板必須預埋**對應證據區塊；該區塊缺失或內容為純文字描述（非可重現指令的 stdout / 檔案 listing / git log）即視為**該宣告未交付**，抽驗方有權**直接退稿且不進入抽驗**。

---

## 2. 設計動機

`audit-rights.md` 已規定「相信對方說的不是合法抽驗」，但仍依賴抽驗方在事後比對。實戰中發現兩個漏洞：

| 漏洞 | 表現 |
|---|---|
| **遞迴信任陷阱** | AI 自我審查 = 同權重審同盲點；F1 假宣告型錯誤的根源是「以為自己做了」，self-check 也會「以為已 self-checked」 |
| **形式主義** | 自我 checklist 通過率變指標 → AI 學會「過 checklist」而非「真的對」（Goodhart's Law）|

本條把驗證從「AI 行為」搬到「文檔結構」：模板上**沒有 stdout 區塊就連送都送不出**。AI 想假宣告**無處可放**。

---

## 3. 強制證據欄位（依宣告類型）

| 宣告類型 | 必含證據區塊 |
|---|---|
| 「已建立 / 已重命名 / 已刪除 X 檔案」 | ` ```bash + ls -la <path> ``` ` 完整 stdout |
| 「已寫入 X 段落到 Y 檔」 | ` ```bash + grep -c "<關鍵字>" <file> ``` ` + 預期值 |
| 「git commit 已落地，hash = X」 | ` ```bash + git log --oneline -1 <hash> ``` ` 原文 |
| 「測試 N 個全綠」 | test runner 末段 stdout（含「Passed: N / Failed: 0」字樣）|
| 「資料庫查詢結果 = X」 | ` ```sql ``` ` query + ` ```text ``` ` raw output |
| 「外部 API 回傳 = Y」 | curl / probe 完整 request + response payload |
| 「環境狀態 = Z」 | 對應狀態指令的 stdout（whoami / pwd / env | grep ...） |

純文字描述（如「我已撤回兩份膠囊並加註記」）**不被接受**為證據。

---

## 4. 模板範例

### 4.1 結案宣告模板（capsule 結尾用）

```markdown
## 結案宣告（依 structural-anti-fabrication）

> 以下每一項宣告均**附 stdout 區塊**；空區塊或純文字描述視為未交付。

### 宣告 1：<具體行為描述>

**指令**：

​```bash
<可重現指令>
​```

**stdout**：

​```text
<指令的真實 stdout，貼原文，不裁剪不改寫>
​```

**期望錨點**：<關鍵字串 / 數字 / 狀態碼>

### 宣告 2：...
```

### 4.2 抽驗判讀規則

抽驗方收到結案宣告後**先檢查結構**：

1. 是否每個宣告都有對應 stdout 區塊？→ 否：直接退稿，標 F1，不進入內容判讀
2. stdout 區塊是否為真實工具輸出（非偽造文字）？→ 用獨立指令重跑驗證
3. stdout 是否含期望錨點？→ 否：退稿並指出差距
4. 三項全綠 → 進入正式 audit-rights §3 抽驗 SOP

---

## 5. 與既有條款的關係

| 條款 | 關係 |
|---|---|
| `audit-rights.md` | 本條是 audit-rights 的**結構強化層**：把「事後抽驗」前移到「結構檢查」 |
| `failure-modes.md` F1 | 結構違規即視為 F1，不需展開檢查就可退稿 |
| `escalation-protocol.md` | 進入「強化抽驗模式」後，本條從「建議」升級為「強制」 |
| `evidence-first.md` | 本條是 evidence-first 的執行載體 — 證據必須在文檔結構內顯式 |
| `completion-delivery.md` | 完工交付的 VCP 期望錨點與本條結構模板共用同一精神 |

---

## 6. 實作建議（自動化）

各專案可寫簡易 lint script 自動偵測：

```bash
# 偽碼：偵測 capsule 內「已...」「完成」「建立」字樣是否伴隨 stdout 區塊
grep -E "已(建立|落實|完成|更新|校準)" capsules/*.md | \
  while IFS=: read f line content; do
    after=$(awk -v ln=$line 'NR>=ln && NR<=ln+30' "$f")
    echo "$after" | grep -q '```' || echo "[F1 候選] $f:$line — $content"
  done
```

未來若有 CI / pre-commit hook，可在 PR 階段直接攔截違規結案宣告。

---

## 7. v0.x 階段適用範圍

當前 v0.1 階段，本條為**強烈建議 → 強化抽驗模式必強制**：

| 階段 | 強度 |
|---|---|
| 正常模式 | 強烈建議；違反不自動退稿，但抽驗方可主動引用本條退稿 |
| 強化抽驗模式（依 escalation-protocol §2）| **強制**；違反即自動退稿，無例外 |
| 結構性失靈狀態 | 已升級至使用者裁決階段，本條無豁免 |

v0.2 可考慮進一步把本條升為「全模式預設強制」。
