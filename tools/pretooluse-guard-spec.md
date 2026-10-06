# PreToolUse Guard Spec（工具呼叫前的機械護欄）

> **狀態**：v0.1
> **位階**：tools / 規格與選擇性範例；需採用方明確部署。
> **保證強度**：部分結構強制（正則黑名單、不是安全邊界）；未涵蓋行為仍為單 actor 自律
> **檢測時點**：runtime（PreToolUse）
> **since**：v0.14.0

---

## 1. 職責與分層

guard 只讀當次工具名與參數，做可機械判斷的攔截；不呼叫模型、不重試工具，不落地記錄 prompt、原始輸出、金鑰或秘密。允許時保持靜默，不把每次通過加入模型上下文。

與 [commit-hook](./commit-hook-spec.md) 的 H1-H8 檢查層分開：PreToolUse 在工具執行前攔已列操作形式，commit-hook 在提交時驗角色、reflection、handoff 與 profile 等工件。H1-H7 見既有規格；H8 以採用方實際部署與版本為準，不宣稱本規格新增或驗證了 H8。兩層互補，工具放行不證明提交合規，提交合規不證明所有工具操作安全。

## 2. 攔截類別與設定

| 類別 | 範例行為與覆蓋 |
|---|---|
| 子代理 | 設定列出的子代理工具名，未有有效人工授權視窗即 deny；不計並行數或遞迴深度。 |
| 破壞性命令 | 已列 Git 重設／清除／強制推送、遞迴或強制刪除、磁碟操作等正則命中。 |
| 受保護全域配置 | 已列 shell 寫入、複製／移動形式；整檔 Write 工具命中已列配置路徑時 deny，局部 Edit 行為維持原範例。 |
| 秘密檔 | 已列 shell 寫入／移動／刪除形式與 Write／Edit／MultiEdit／apply_patch 的秘密路徑樣式。 |
| 重入 | 授權設定中的重入變數已啟用時 deny。 |

[範例腳本](../examples/governance-profile/global_guard.example.ps1) 用 `-ConfigPath` 讀 [JSON 設定](../examples/governance-profile/guard-config.example.json)：受保護相對路徑、秘密檔樣式、授權／重入變數名稱、時效上限分鐘數與子代理工具名。路徑片段仍是正則比對，沒有檔案身分、正規化或 ACL 保證。設定檔讀取錯誤須以非零退出回報；採用方仍須驗證 host 如何處理 hook 錯誤。

未涵蓋的安裝、權限、網路、部署、開 Port 與範圍擴張依 [human-gates](../core/human-gates.md) 自律與人工核准，不宣稱範例全涵蓋。

## 3. 授權與輸出契約

人工核准須來自 AI 無法自行設定的控制面；由人控制 CLI 啟動環境的時效型變數只是一種參考載體。期限是未來 ISO-8601 時間且不超過設定上限；過期、缺值、解析失敗均不視為有效授權。高風險視窗只控制範例的黑名單放行，不能代替精確動作的人工核准。

deny 在 stdout 輸出 JSON，退出碼為 0（代表 hook 正常產出判定，**不是工具獲准**）：

```json
{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"命中已列規則；需要人工核准。"}}
```

理由只含規則與核准要求，不回顯原始命令、prompt 或秘密。允許呼叫不輸出內容；host 必須實際支援並遵從此 JSON 契約。

### 驗證紀律

**合規規定**：部署者在隔離環境送入允許與拒絕事件，確認 hook 判定及 host 是否阻止原工具執行；不只驗退出碼。

**修補方向**：核對設定路徑、事件欄位與 host 契約；範例外的加固另立工作包，不在參數化時順手改語意。

**反例**：❌ 看到 exit 0 即認為 deny 無效，或只有 deny JSON 卻宣稱 host 已攔截。

**真實 stdout 證據要求**：保留不含秘密的 deny JSON、退出碼與隔離測試觀察；純文字 PASS 不足以證明部署完成。

## 4. 已知限制

本範例保留來源的正則黑名單邏輯，以下為類別層級限制，未於本版修補：

- **fail-open**：工具事件 JSON 輸入解析失敗會靜默放行，不是 fail-closed。
- **資料剝除**：heredoc 餵非 shell 直譯器（例如 python／node）時，內文會被剝除、不檢查，可能把實際程式碼誤當資料；here-string 也受文字啟發式限制。
- **訊息替換**：commit `-m` 等訊息內容被替換，可能漏掉其中的命令替換；這不是完整 shell 語法分析。
- **寫檔形式不完整**：`[IO.File]::WriteAllText`、`sed -i`、`python -c` 等寫檔途徑未被完整涵蓋；別名、組合或其他工具也可能不命中。
- **控制面未受保護**：guard 自身、其 JSON 設定與專案層設定未受此範例保護；可改控制面者可能改變放行政策。
- **環境變數繼承**：既有父 CLI 不受 shell 子行程回寫，不代表新開子 CLI 不會繼承 AI 設定的變數；不可把環境變數當作不可偽造的人工核准。
- **事件與工具差異**：僅匹配已列工具名／參數形式，未知工具或 host 不遵從 deny 契約不在保證內；並行數、遞迴、任務範圍與全部人工閘門仍靠自律或其他控制。

因此保證只限「實際送入此 hook、符合已列比對形式且 host 遵從判定」的呼叫，不作端到端安全宣告。

## 5. 不記錄與審計留痕

guard 本身不落地記錄。deny 訊息出現在 host 的對話紀錄，採用方依 [audit-rights](../core/audit-rights.md) 抽驗，再依 [violation-reflection](../core/violation-reflection.md) 保存自己的反省；反省只記規則、原因與修正，不複製秘密或原始 prompt。不記錄不豁免抽驗或反省義務；host 未保存對話時須明示留痕缺口，不能宣稱 guard 有完整審計 log。
