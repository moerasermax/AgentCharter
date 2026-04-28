# Company Project Onboarding — DRAFT（待 user 回 5 問題）

> **建立**：2026-04-28（session 結尾儲存供下次接班）
> **觸發**：使用者準備接入公司 production 專案、要求「最穩定」
> **位階**：暫時追蹤檔（依 working-stack-discipline §1 DRAFT 須是檔案）
> **生命週期**：user 回答 5 個問題後 → 升級為接入計畫 → 接入完成後可選歸檔為 `examples/<company-name>/onboarding.md`

---

## 當前 charter 狀態（給接班 AI 對齊）

| 項目 | 狀態 |
|---|---|
| 版本 | **v0.6.1**（auditor 第一次實戰後的 stable for production tag）|
| Git tags | `v0.5.9` / `pre-v0.6.0-batch` / `v0.5.10` / `v0.6.0` / `v0.6.1` 全部本地 + remote 同步 |
| GitHub remote | `https://github.com/moerasermax/AgentCharter`（private）已 push 到 v0.6.1 |
| Auditor 健全度驗證 | ✅ 通過（5 綠燈、3 ERROR + 2 WARN 已修進 v0.6.1）|
| 公司接入推薦版本 | `git checkout v0.6.1` |

---

## 等待 user 回答的 5 個問題

1. **領域**：什麼產品 / 服務？（金融 / 醫療 / SaaS / 內部工具 / 其他）
2. **領域風險**：寫錯什麼會「不只是 bug、是事故」？（資金 / PII / 合規 / 線上服務 SLA / 其他）— 決定領域公理寫什麼 + alias 命名
3. **AI 配置**：打算用幾個 AI、各扮什麼角色？（典型：Claude × Engineer + Gemini × PM + 可選 Gemini × Validator）
4. **既有結構**：repo 已有哪些目錄結構？（純 src/ / 已有 docs/ / 已有 management/ 等）— 決定要不要走 charter-scan
5. **保守度**：preset 偏好 standard / strict？（公司專案 default 建議 strict，但 strict 1/2 第一次違規即升級可能太嚴）

---

## user 回答後該產出的接入計畫（5 段）

| # | 段 | 內容 |
|---|---|---|
| 1 | decision matrix | preset 選 / 領域公理 alias / AI 角色配置 |
| 2 | vendor self-instantiation prompts | 給 user 貼給 Claude / Gemini 的接入 prompt（含 v0.5.10 step 5 schema 驗證指示）|
| 3 | 第一個任務 prompt 範本 | 給 user 對 PM 的指令（「請依 charter v0.6.1 寫 capsule CAP-001：\<task\>」）— **不是 capsule 本身**，capsule 由 PM 照 `templates/agent-commons/capsule.md.tpl` 寫 |
| 4 | 接入完成 self-check checklist | 對齊 ADOPTION §12 採用就緒檢查 |
| 5 | v0.6.1 stable tag 確認 + 升版注意 | charter v0.7+ 升版時公司專案怎麼跟進（依 versioning-migration §3）|

---

## 接入後該帶到公司專案的 charter 流程（CryptoBot 模式）

採用 charter v0.6.1 後公司專案會走的流程（依 `templates/agent-commons/` 6 份 1:1 萃取自 CryptoBot 的範本）：

| CryptoBot 模式 | charter 對應檔 |
|---|---|
| 任務膠囊 | `capsule.md.tpl` — PM 寫 → Engineer 抽驗 → 接收 → 完工 VCP → PM/Validator 抽驗 → 結案 |
| DRAFT 暫存 | mapping.yaml.shared.draft_context 指向（v0.5.7 working-stack-discipline）|
| HANDOFF 鏈 | `handoff.md.tpl` — session 末交接、跨 AI 接班 |
| Institutional Memory | `institutional-memory-entry.md.tpl` — 五段格式（症狀→根因→診斷→修法→預防）|
| nextwork | `nextwork.md.tpl` — 任務追蹤主檔 |
| 領域公理 | `domain-axioms.md.tpl` — 鐵律撰寫範本 |
| _role 簽名 | `_role.md.tpl` — 角色簽到 + 切換歷史 |

**v0.6.1 比 CryptoBot 多的三層紀律**（公司專案會自動繼承）：

- v0.5.10：self-instantiation 七步驟（step 5 強制跑 doctor schema 驗證）
- v0.6.0：繞路禁令 + 身份穩定承諾（PM 不得自切 Engineer / 不得 sub-agent 改 src/）
- v0.6.0：邀請制原則（未來接第三 AI 須走四步驟）

---

## 未解 thread（待下次 session 跟進）

- 使用者提到「另一個專案接入很棒!!!」但沒展開 — 不確定是 charter-viz 還是新採用案例。下次可詢問哪個面向跑得棒、有沒有新 dogfood signal 觀察、是否要記入 `examples/<project>/onboarding.md`
- WARN-3（CHANGELOG / ADOPTION 「採用方視角」語意游移）+ WARN-4（audit-rights 沒引用 validator deprecation）— 留 v0.7+ 處理
- dogfood signal #6 候選「條款層 sync 與文檔層 sync 不對等」— 累積觀察、待 ≥ 3 次同類後評估條款化

---

## 下次接班指引

接班 AI 跑 `/maintainer-load` 自動讀 STATUS + NEXT + 本檔，輸出八項就緒回報。

當前 session 結尾狀態：
- charter v0.6.1 已 release + push
- 公司專案接入計畫尚未產出（等 5 個問題回答）
- 不主動推進 — 等使用者下達

**下次 session user 開口時，預期 user 會回 5 個問題的答案** → 接班 AI 應依答案直接產出接入計畫 5 段。
