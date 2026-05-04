# Commit Hook Vendor 邀請制 — 設計提綱

> **位階**：v0.9.x ship 前的設計草稿（NOT yet condition / NOT yet shipped）
> **動機**：6 條同源 signal 累積 — #33 / #35 / #42-#45 全部「**單 actor 自律弱保證項**」家族，需升結構強制
> **依據**：v0.8.2 §設計哲學第 5 條雙軸（物理依據：強制 > 互檢 > 自律 / 檢測時點：init > runtime > post-upgrade > handoff）+ v0.9.0 `core/diagnose-remediate-protocol §commit hook vendor 邀請制加固`（已寫精神、未實作）
> **作者**：Claude（charter maintainer）+ user（讓步討論中）
> **狀態**：DRAFT — 等 user review 設計方向後決定是否進 v0.9.x ship

---

## 1. 北極星

把以下 6 條既有 LIVE 違反從「LLM 讀規範自律」升級到「commit 時 binary 攔截」：

| Signal | 違反內容 | 累積次數 |
|---|---|---|
| **#35** | `_role.md` PROVISIONAL→ACTIVE 自激活、Sign-in Log 自寫、PROVISIONAL 擅自產膠囊 | 2 次（dbSDK + CryptoBot S71）|
| **#33** | 命中 F-mode 不主動補 `failure_mode_log.md` entry + reflection | 1 次（dbSDK 多次同 session）|
| **#42** | 任務完成後不寫個體 reflection（individual-learning-loop §2 雙寫缺漏）| 1 次（CryptoBot Kiro LIVE 待回應觀察） |
| **#43** | reflection 檔名非 `YYYY-MM-DD_topic.md` 格式 | 1 次（dbSDK Gemini PROTOCOLS.md → 改名） |
| **#44** | reflection 內容夾雜 project state（應屬 capsule）| 1 次（dbSDK Gemini S36 決策誤入） |
| **#45** | cross-AI handoff 段不含「致 XXX」directive header | 多次（user 每次需手把手教）|

---

## 2. 架構：vendor 邀請制 ≠ framework 代寫

對齊 `core/ai-vendor-onboarding.md`（v0.6.0）「框架不代寫 vendor 層」紀律：

```
charter 層（規範）                vendor 層（實作）
─────────────────                ────────────────────
tools/commit-hook-spec.md        .claude/hooks/pre-commit.sh         ← Claude Code
   定義什麼必檢、何時檢          .gemini/hooks/pre-commit.toml       ← Gemini CLI
   提供 reference 範例           .cursor/hooks/pre-commit.mdc        ← Cursor
   不代寫各 vendor 實作          .kiro/hooks/<vendor 自訂>           ← Kiro
                                 etc.（其他 vendor 邀請制接入）
```

charter 提供 **spec + 一個 reference 實作**（建議 claude-code 起手、因 maintainer 主場）；其他 vendor「**邀請制**」自實作，charter 不代寫。

---

## 3. 必檢項（commit 時 binary 攔截）

### 檢項 H1：`_role.md` Status 變更紀律（signal #35）

**觸發**：commit diff 包含 `roles/<role>/_role.md` 中 `Status: PROVISIONAL` → `Status: ACTIVE` 變更。

**校驗**：
- 該 commit 的 `_role.md` 內容須含字樣 `Status: ACTIVE — 由 user 於 <date> explicit 授權` 或 Sign-in Log 新增 entry 的「觸發原因」欄含「user explicit 授權」字串
- **缺**：reject commit、提示「自激活違反 multi-role-tracking §3.4.4 = F1」

**反例**：
- ❌ AI 自己改 `Status: PROVISIONAL` → `Status: ACTIVE` 但 commit message 只寫「init 完成、role 就緒」
- ✅ Sign-in Log entry 含「觸發原因：user explicit 授權『你可以登入了』」

---

### 檢項 H2：F-mode 自報紀律（signal #33）

**觸發**：commit message 或 diff 內含 F-mode ID 引用（如 `F1`/`F3`/「假宣告」/「捏造」等）。

**校驗**：
- 該 commit 須同時包含 `state/failure_mode_log.md` 新 entry + 對應 `roles/<role>/reflections/<YYYY-MM-DD>_<f-mode>_<short>.md`（雙寫紀律）
- **缺**：reject commit、提示「failure-mode 自報紀律違反、雙寫缺漏」

---

### 檢項 H3：Reflection 檔名格式（signal #43）

**觸發**：commit diff 在 `roles/<role>/reflections/` 路徑下新增 `.md` 檔。

**校驗**：
- 檔名 regex：`^\d{4}-\d{2}-\d{2}_[a-z0-9_-]+\.md$`
- **不匹配**：reject commit、提示「reflection 檔名須 `YYYY-MM-DD_topic.md` 格式（individual-learning-loop §2.3）」

---

### 檢項 H4：Reflection vs Project State 邊界（signal #44）

**觸發**：H3 通過後額外校驗。

**校驗**：
- reflection 內容掃 sprint 編號（regex `S\d+\b`）/ task ID / capsule 引用
- **若有命中**：WARN（不 reject，但提示「reflection 應為 meta-knowledge、project state 應在 capsules/nextwork」）
- 紀律提醒，不阻擋（避免誤殺正當引用如「S70 違反史複習」）

---

### 檢項 H5：個體學習迴圈雙寫（signal #42）

**觸發**：commit diff 包含 `state/failure_mode_log.md` 新 entry。

**校驗**：
- 同一 commit 須含對應 `roles/<role>/reflections/<YYYY-MM-DD>_<f-mode>_<short>.md`
- **缺**：reject commit、提示「individual-learning-loop §2.3 雙寫紀律違反」

---

### 檢項 H6：cross-AI handoff Directive Header（signal #45）

**觸發**：commit diff 包含 `handoffs/HANDOFF_<N>.md` 新檔 或 含「轉交」/「移交」/「致 」字樣。

**校驗**：
- handoff 文件須含 `^---\n致 [^\n]+\n` 起始 directive header（regex）
- **缺**：WARN（reflection-discipline 引導性、不 reject 第一版）

---

## 4. 演化階段（漸進加固）

| Phase | 範圍 | 嚴格度 |
|---|---|---|
| **Phase 1（v0.9.x）** | charter spec + claude-code reference impl | H1/H2/H3 reject / H4/H6 warn |
| **Phase 2（v0.9.x+1）** | gemini-cli + cursor + kiro 邀請制接入 | 同 Phase 1 範圍 |
| **Phase 3（v1.0）** | H4/H5/H6 從 warn 升 reject | 全 binary 攔截 |

理由：H1/H2/H3 是清楚 binary（status 字樣 / regex），誤殺率低；H4/H6 涉及語意判斷，先 warn 累積樣本再升 reject。

---

## 5. 與既有條款的關係

| 條款 | 關係 |
|---|---|
| `core/diagnose-remediate-protocol §commit hook vendor 邀請制加固`（v0.9.0）| 本提綱是該條款的實作層 ship；spec 已寫、現在落地 |
| `core/ai-vendor-onboarding.md`（v0.6.0）| 邀請制紀律對齊；charter 不代寫各 vendor hook |
| `core/multi-role-tracking §3.4.4`（v0.7.0）| H1 是該條款的結構強制執行載體 |
| `core/individual-learning-loop §2.3`（v0.9.0）| H2/H3/H5 是該條款的雙寫紀律執行載體 |
| `core/cross-ai-handoff §6`（v0.5.0）| H6 是該條款的 directive header 紀律執行載體（待 §6 補明文） |
| `tools/doctor-spec.md`（v0.9.1）| commit hook 是 doctor 之外的第二層攔截；doctor = 任意時點驗證、hook = commit 時攔截 |

---

## 6. 不在範圍

明確排除（避免 scope creep）：

- ❌ 不寫 push hook（commit 是夠細的攔截點、push 已晚）
- ❌ 不檢查程式碼內容（commit hook 只攔 charter 結構違反、不替代 lint / formatter）
- ❌ 不要求每個專案都裝 hook（vendor 邀請制 = opt-in、user 可選擇）
- ❌ Phase 1 不做 H4/H5/H6 binary reject（先 warn 累積樣本）

---

## 7. 預期效果（量化目標）

對齊 v0.9.0 LIVE ROI 量測方式（v0.7.5→v0.8.1 紀律違反 ≥10 次、v0.9.0 後 2 次、改善 80%）：

- Phase 1 ship 後：H1/H2/H3 違反次數 → 0（binary 攔截）
- Phase 2 ship 後：跨 vendor 一致行為（不再有 vendor-specific 違反 pattern）
- 累積 6 個月後：v0.7.3 北極星「不讓 user 記」LIVE 對齊度量

---

## 8. 待 user 決定

1. ✅ / ❌ 設計方向 OK？
2. Phase 1 範圍（H1/H2/H3 reject、H4/H6 warn）合理嗎？
3. claude-code reference impl 要走 hook 還是 doctor extend？（兩個都可以、傾向 hook 因為 doctor 是 advisory 不 reject commit）
4. 要不要先寫 `tools/commit-hook-spec.md` 純 spec 版（不附 reference impl）讓你 review？

---

## 變更歷史

- **v0.1（2026-05-04）** — 初版設計提綱：6 條 signal 同源整合（#33/#35/#42-#45）→ 「弱保證項升結構強制」一次條款化候選；對應 v0.9.0 已寫精神 + v0.9.x 實作層 ship。
