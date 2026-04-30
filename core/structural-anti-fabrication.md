# Structural Anti-Fabrication（結構性反捏造）

> **狀態**：v0.3（自 v0.7.2 加 §5 三行反向引用；v0.2 為全模式預設強制；初版 v0.1）
> **位階**：core 通用條款。
> **保證強度**：結構強制（缺 stdout 區塊即視同未交付、退稿留審計痕跡）
> **檢測時點**：runtime + handoff
> **since**：v0.1.1（v0.2 起全模式預設強制）

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
| **`failure-modes.md` F6 sub-pattern「surface-level vs structural-level」（v0.7.2 加）** | **理論同源**：F6（v0.7.0 加）= 「未驗證即宣告就緒」是 F1 的「**做了沒驗**」變體；本條對 F1 的硬反制（「缺 stdout 區塊即視同未交付」）邏輯延伸到 F6 的「**surface 書寫 vs structural 完整性**」軸。判別法相同：依據結構性物理證據判定、不依宣告方誠實 |
| `escalation-protocol.md` | 進入「強化抽驗模式」後，本條從「建議」升級為「強制」 |
| `evidence-first.md` | 本條是 evidence-first 的執行載體 — 證據必須在文檔結構內顯式 |
| `completion-delivery.md` | 完工交付的 VCP 期望錨點與本條結構模板共用同一精神 |
| **`tools/init-spec.md` Phase 5b 物理存在校驗（v0.7.2 加）** | **執行層延伸**：Phase 5b 抽驗集第 7 項「domain_axioms.primary 指向的檔案實際存在（不只 schema 寫了路徑）」 = 本條「stdout 區塊 vs 純文字描述」精神在 init 階段的執行載體。schema 寫路徑 ≈ 純文字宣告 / 檔案物理存在 ≈ stdout 區塊。雙重防禦：本條規範文檔結構、Phase 5b 規範 init 結果 |
| **`core/domain-axiom-slot.md §3.3` 路徑 B「每條附推斷依據」紀律（v0.7.2 加）** | **領域公理層延伸**：路徑 B（AI 讀 codebase 代產草稿）規定每條鐵律附「我從哪推斷的」（檔案路徑 / grep 結果 / commit hash）= 本條「強制證據欄位」精神在 axiom draft 場景的應用。AI 寫的鐵律若缺推斷依據 → 視同 F1（structural-anti-fabrication 結構性反制） |

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

## 7. 強度（v0.2 起）

**全模式預設強制**：

| 階段 | 強度 | 違反處置 |
|---|---|---|
| 正常模式 | **強制** | 結構違規（缺 stdout 區塊或為純文字描述）即視同未交付，抽驗方可直接退稿，不進入內容判讀 |
| 強化抽驗模式 | **強制 + 自動退稿** | 違反由抽驗方**自動**退稿，無人工介入 |
| 結構性失靈狀態 | **強制** | 已升級至使用者裁決階段，本條無豁免 |

### 7.1 Token 影響說明

升為全模式強制後 token 變化：

| 環節 | 影響 |
|---|---|
| 結案宣告（撰寫方）| +50〜200 tokens / 宣告（含 stdout 區塊）|
| 抽驗回應（檢查方）| -30〜100 tokens / 次（結構缺失直接退稿，省去內容判讀）|
| F1 退稿循環 | -2K〜10K tokens / 事件（假宣告被結構攔下，不發生連環退稿）|

→ 短期略增（正常 session 約 +1〜3%），長期顯著減少（避免假宣告事件爆炸性消耗）。

### 7.2 與其他條款的相容

- 與 `output-mode-protocol.md` eco 模式相容：stdout 屬「事實型內容」，不在 eco 可砍項
- 與 `audit-rights.md` 互補：本條前置防線（結構檢查），audit-rights 為後續抽驗 SOP

---

## 8. 變更歷史

### v0.3（自 v0.7.2 起，patch only）

**動作**：§5 「與既有條款的關係」表加三行反向引用：(1) `failure-modes.md F6` sub-pattern（理論同源 — 結構性反制邏輯延伸到 surface vs structural 軸）/ (2) `tools/init-spec.md Phase 5b` 物理存在校驗（執行層延伸 — schema 寫路徑 ≈ 純文字宣告 / 檔案物理存在 ≈ stdout 區塊）/ (3) `core/domain-axiom-slot.md §3.3` 路徑 B「每條附推斷依據」紀律（領域公理層延伸 — AI 寫鐵律若缺推斷依據 = F1 結構性反制）。

**觸發**：dogfood signal #6 第三次同類觀察（2026-04-28，user 在 v0.7.1 release 後連續兩次 IDE 開 `core/structural-anti-fabrication.md` 即抓到 — v0.7.0 + v0.7.1 多次加段都跟本條同源、但都漏 §5 反向引用）。**user 親自行使「他抽」屬性**抓到 maintainer + auditor 都漏的 spec drift — 對應 v0.7.0 加 Phase 5b 採用方半邊「他抽」屬性的現場實證。

**修訂類型**：PATCH — 純引用同步、不動本條職能。

### v0.2（自 0.2.0 起為全模式預設強制）

升為全模式預設強制；§7 加強度說明 + §7.1 token 影響。

### v0.1

初版。「結構性反捏造」基本概念 + §3 強制證據欄位 + §4 模板範例。
