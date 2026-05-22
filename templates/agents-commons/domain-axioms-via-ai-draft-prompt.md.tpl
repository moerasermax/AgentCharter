# 領域公理「路徑 B」觸發 prompt 範本

> **位階**：採用方接入流程模板 — 路徑 B（AI 讀 codebase 代產領域公理草稿 + user 校）
> **依據**：`core/domain-axiom-slot.md §3.3`（v0.7.1 加 — 雙路徑明文）
> **對應載體**：`templates/agent-commons/domain-axioms.md.tpl`（草稿輸出位置）
> **適用情境**：採用方接入時 user 想低門檻起手 / 既有 codebase 已有隱含紀律可被 AI 推斷

---

## 使用方式

1. user 替換下方 prompt 的 `<placeholder>`（如有 — 通常無）
2. 貼給你選定的 AI（Claude / Gemini / Cursor / 任何能讀 codebase 的 AI）
3. AI 跑完 → 產出 `agent-commons/protocols/<axiom>.md` 草稿（Status: AI-DRAFTED）
4. user **親自校正**（不能讓 AI 升 Status）：
   - 看每條 AI 推斷的鐵律 + 推斷依據
   - 改 / 刪 / 新增條款（保留 codebase 真實紀律、刪 AI 推錯的）
   - 確認 frontmatter `Status` 從 `AI-DRAFTED` 改為 `USER-RATIFIED`
   - 確認 `created_by` 改為 `user-ratified-from-ai-draft`（保留審計痕跡）
5. user 校完才跑 charter init Phase 1-5b（依 QUICKSTART.md Step 3）

---

## Prompt 範本

```
我採用了 AgentCharter，charter 在 ~/.agentcharter/。

接入前，請先**讀我公司專案 codebase**（特別注意以下訊號源）：
- 既有 schema migration 紀律 / DB 操作 pattern
- 既有 PR / code review 慣例
- 任何 README / CONTRIBUTING.md / docs/ 內已寫過的工程紀律
- src/ 內反覆出現的「不要 X、必須 Y」comment / docstring
- test/ 內的 invariant assertion / property-based test
- CI / pre-commit hook 規則
- 過去的 commit message / issue / PR description（如可訪問）

依 ~/.agentcharter/core/domain-axiom-slot.md §3.1 撰寫紀律
（每條鐵律含後果段 + 可驗 + 編號）+ ~/.agentcharter/templates/agent-commons/domain-axioms.md.tpl
模板格式，**幫我起草** agent-commons/protocols/<axiom>.md 第一版（3-5 條鐵律）。

**紀律（必守）**：
1. 草稿頂寫 frontmatter：
   - status: AI-DRAFTED
   - mutability_default: APPEND-ONLY
   - created_by: ai-drafted
   - created_at: <今天日期>
2. **Status 升 USER-RATIFIED 由 user 親自改、AI 不可代**（對應 multi-role-tracking §3.4.4
   user explicit 授權精神）
3. **不要編造**、只把「你從 codebase 讀到的真實紀律」顯化（找不到就少寫幾條、不要湊數）
4. 每條鐵律附「**推斷依據**」段（檔案路徑 + 行號 / 或 grep 結果 / 或 commit hash）— 給我
   校正時知道你怎麼推的
5. 完成後**先別**跑 charter init / 先別動 agent-commons/_config — 等我校過 axiom 檔才繼續

**輸出格式範例**：

​```markdown
---
status: AI-DRAFTED
mutability_default: APPEND-ONLY
created_by: ai-drafted
created_at: 2026-04-28
---

# <project> 開發鐵律 (Domain Axioms)

> 版本：v0.1 · AI-DRAFTED · 待 user 校正
> 位階：本文件為本專案最高且唯一不可妥協之領域底線。

## ① <鐵律名>

<條款內容>

> **後果**：<違反的具體損害>

> **驗證**：<grep / runtime probe 描述>

> **推斷依據**（v0.7.1 路徑 B 紀律）：
> - 來源檔：`src/<path>:line`
> - grep 結果：`<command + output>`
> - 累積觀察：在 codebase X 處反覆出現此 pattern

## ② ...
​```

完成後請回報「✅ AI-DRAFTED 草稿完成，N 條鐵律 + 推斷依據；待 user 校正並升 Status」。
```

---

## user 校正 checklist

校正草稿時請逐條確認：

- [ ] **真實性**：AI 寫的鐵律真的來自 codebase 而非編造？看「推斷依據」段比對
- [ ] **適用性**：這條鐵律對未來 6 個月仍然適用？還是是過時 pattern？
- [ ] **可驗證性**：「驗證」段給的方法你能跑通嗎？跑不通 = 該條無法當紀律
- [ ] **後果段**：是否「具體損害」（資金 / 安全 / 合規 / 服務中斷）？「會出錯」「不太好」這類不算
- [ ] **編號**：①②③ 連續 + 不重複
- [ ] **缺漏**：你心裡有的「不只是 bug、是事故」場景，AI 是否漏抓？親自補

校完後：
- frontmatter `status: AI-DRAFTED` → `USER-RATIFIED`
- frontmatter `created_by: ai-drafted` → `user-ratified-from-ai-draft`
- 加一行「校正紀錄：<YYYY-MM-DD> user 校正完成、N 條保留 / M 條改寫 / K 條刪除 / L 條新增」

---

## 與既有條款的關係

| 條款 | 關係 |
|---|---|
| `core/domain-axiom-slot.md §3.3`（v0.7.1 加）| 雙路徑明文；本範本是路徑 B 的觸發載體 |
| `core/multi-role-tracking.md §3.4.4`（v0.7.0）| AI-DRAFTED → USER-RATIFIED 升級需 user explicit 授權；同源 PROVISIONAL/ACTIVE 二態精神 |
| `tools/scan-spec.md`（v0.4 起）| 「AI 讀 codebase 推斷」設計精神；本範本是其延伸到領域公理層 |
| `core/ai-vendor-onboarding.md`（v0.6.0）| 「framework 不代寫 vendor 層」紀律 — 本範本不違反（**user 在自己專案內邀請 AI 寫 draft 是 user 對 AI 的協作關係、不是 framework 對 vendor 的代寫**）|

---

## 變更歷史

- **v0.1（自 v0.7.1 引入）** — 初版，對應 user 提議「初次領域公理可選 user 主筆 vs AI 代產雙路徑」（dogfood signal #12 候選 user 直接條款化）。雙路徑 + AI-DRAFTED frontmatter scaffold；condition mutability 紀律本體留 v0.8.0。
