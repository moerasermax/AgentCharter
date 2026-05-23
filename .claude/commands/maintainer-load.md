---
description: AgentCharter 維護者接班 — 讀 .claude_temp/ 對齊當前脈絡，等待下達議題
argument-hint: "(無參數)"
---

# /maintainer-load

接班 AgentCharter charter 維護工作。本指令是 `core/maintainer-discipline.md` 的便利化工具（對應 §3 三層機制 + 跨 session 接班需求）。

## 不是給採用方用的

- 採用方的「角色 init」走 `core/init-template.md §3.3` self-instantiation（在 `.claude/commands/<role>-init.md`）
- 本指令僅給 **charter repo 維護者** 用，目的是快速對齊 `.claude_temp/` 累積的脈絡

## 執行流程

### Step 1：讀 charter 當前狀態（依序，不要批次）

依以下順序讀檔（每檔讀完不主動評論，只累積脈絡）：

1. `Read .claude_temp/STATUS.md` — 當前版本 / 條款清單 / 設計決策 / 接班指引
2. `Read .claude_temp/NEXT.md` — 待議事項 / 已完成清單 / dogfood signals
3. 若 `.claude_temp/` 內含 `*ONBOARDING.md`：用 Glob 找出並逐個 Read（進行中採用案例追蹤）

### Step 2：簡短就緒回報

讀完後輸出**就緒回報**（不主動推進，等使用者下達議題）。格式：

```
✅ /maintainer-load 完成

- charter 當前版本：v<X>（最近 commit `<hash>`）
- 條款數：<N> 條（其中 <M> 條 maintainer-only）
- 三 preset 啟用：minimal <a>/<總> · standard <b>/<總> · strict <c>/<總>
- 八個架構級概念已釐清（最近一個：<v0.5.X 的概念>）
- dogfood signal 累積：#1〜#<N>（最近一條：<簡述>）
- 待議事項（高優先 抽 1-2 條）：
  • <條目 1>
  • <條目 2>
- 採用案例追蹤（若有）：
  • <案例名稱>：<進度>

charter maintainer 接班完成，待下達議題。
```

### Step 3：禁主動推進

讀完只輸出就緒回報。**不**主動：
- 建議「我發現你應該做 X」
- 跑 `git status` / `git log`（除非使用者問）
- 讀 `core/*` 條款全文（太大；要時再讀）
- 讀 `templates/` / `examples/` / `tools/` 全文
- 任何 side effect（pull / push / commit / mkdir）

## 與 /checkpoints 的對照

| 動作 | /checkpoints（user 全域）| /maintainer-load（charter repo）|
|---|---|---|
| 對應專案 | CryptoBot 等用 `management/` 結構 | charter repo 自身（dogfooding 取捨用 `.claude_temp/`）|
| 讀什麼 | 最新 HANDOFF_<N>.md | STATUS.md + NEXT.md + ONBOARDING.md |
| 輸出 | 摘述為四點 | 八項就緒回報 |
| 副作用 | save 會寫 HANDOFF + git commit | **無 side effect**（純讀取）|

## 與 maintainer-discipline §3 的關係

`maintainer-discipline.md §3` 規定三層執行機制（工具層 / 流程層 / commit 層）。本指令是「**接班便利化**」的延伸 — 不在 §3 列出的三層內，而是對應 §1 條文「DRAFT 須是檔案」紀律的反向（**接班讀檔**對應**累積寫檔**）。

當前狀態（v0.13.0）：
- 寫檔：自然執行（每次重要工作更新 `.claude_temp/` + commit）
- 讀檔：本指令落實
- 抽驗執行載體：`roles/auditor/_spec.md`（v0.6.0 概念層誕生）— 跑 spec sync check 走 fresh-context sub-agent 達成「他抽」屬性
- 採用方半邊對稱（v0.7.0 加）：`tools/init-spec.md Phase 5b` + `roles/validator/_spec.md §3.6`（採用方接入流程 init 結果抽驗）
- 領域公理雙路徑（v0.7.1 加）：`core/domain-axiom-slot §3.3` + `templates/agent-commons/domain-axioms-via-ai-draft-prompt.md.tpl`（路徑 B AI 代產草稿）
- 文檔層 sync checklist（v0.7.2 加，dogfood signal #6 三次同類條款化）：`core/maintainer-discipline §3.4`
- **設計哲學（北極星）顯化**（v0.7.3 加）：README 加「設計哲學」段顯化 user 兩個無痛定義（回鍋開發者 / 小白）+ 三條服務原則（解決重複溝通 / charter 引導採用方 / 培養魚塭）+ 對未來修訂的紀律。所有未來修訂須對照「**讓未來採用方更舒適 vs 現在這個夠用**」三題對齊
- **vendor 端 slash command schema 規範**（v0.7.4 加 spec 層 → v0.8.0 實作層啟用、dogfood signal #16 條款化）：`roles/pm/gemini-cli.md §3.6`（toml 扁平結構強制）+ `roles/engineer/claude-code.md §4.1`（.md 純 markdown 規範）+ `tools/doctor-spec.md §3.8`（vendor schema check 啟用 E801/W802）
- **跨多版本升版指引 + 回鍋開發者無痛實證**（v0.7.5 加）：`core/versioning-migration §3.4`（跨多 MINOR 累積升級流程）+ `examples/upgrades/yc-aiagentcrew-v0.5.9-to-v0.7.4.md`（第一個跨版本 walkthrough）
- **v0.8.0「升版 + 接入防呆強化」slim release**（2026-04-29 ship）：
  1. `tools/post-upgrade-verify-spec.md` 新檔（5 軸 spec：A clone / B schema / C structure / D axiom / E stale ref；user LIVE 提議 `/charter-upgrade-verify` slash command）
  2. `tools/doctor-spec.md §3.9` axiom 紀律對齊（E606/E607/W608 — dogfood signal #23 條款化、跨 init/doctor/post-upgrade-verify 三層雙重防禦）
  3. `tools/doctor-spec.md §3.8` vendor schema 從 spec 層升實作層（v0.7.4 累積 → v0.8.0 啟用）
  4. `tools/init-spec.md Phase 5b CHECK 7 ext` axiom frontmatter status 校驗（init 端 fail-fast 載體）
  5. QUICKSTART Step 2 ↔ Step 3 swap（v0.7.6 prep 併入；signal #10 從 cross-reference 升結構修正、signal #22 候選紀錄）
  6. SSS 級議程紀錄：S1 AI 自治協作 + user 授權閘 / S2 v0.8.0/v0.9.0 lifecycle 設計素材（含 `/charter-uninstall` 流程 + vendor 升級 path 三路徑 + 互學深化）
- **v0.8.1「SSS S3 起手實證 + dogfood signal #24 升工具層 + #19 順手修」PATCH release**（2026-04-30 ship）：
  1. `tools/doctor-spec.md §3.7-§3.9` 既有 error codes 全加四欄 spec-as-data 結構（合規規定 / 修補方向 + 約束 / 反例）— SSS S3「引導式紀律」起手實證、共 10 個 H4 子段（E601-E605 + E801/W802 + E606/E607/W608）
  2. `tools/doctor-spec.md §3.10` 新加採用方文檔變更歷史 sync 校驗（W901）— dogfood signal #24 升工具層條款化、`core/maintainer-discipline §3.4` 演化路徑「升級到工具層自動偵測」終局實作
  3. `tools/doctor-spec.md §3.7` 校驗集第 2 條雙重否定措辭修（signal #19 YC v0.8.0 升版 LIVE 實證 Gemini 誤標 WARN）
  4. **dogfood-driven hardening 第十四循環**：multi-perspective sub-agent 反向校準（雙軸矩陣金礦 + 4 個 maintainer 校準點）— `examples/external-evaluations/clispike-multi-perspective-eval-2026-04-30.md`、commit `afcd330`
  5. **第十五循環**：signal #24 + #19 + SSS S3 起手 三 signal 同 LIVE session 條款化、第二日連續 ship 對齊雙軌節奏「頻繁小擴增 PATCH」精神
- **v0.8.2「雙軸矩陣 framing 第一段」PATCH release**（2026-04-30 ship、multi-perspective 第十四循環結構師金礦落地）：
  1. `README.md §設計哲學` 新加第 5 條「雙軸座標 — 哪些紀律靠誰守」 — 物理依據軸（強制 / 多 actor 互檢 / 單 actor 自律）+ 檢測時點軸（init / runtime / post-upgrade / handoff）+ 依賴 LLM 紀律的條款清單（弱保證項公開）+ 對齊「對未來修訂的紀律」三題新增雙軸對齊軸
  2. 21 條 `core/*.md` 開頭加 blockquote 三新行（保證強度 / 檢測時點 / since）— 採用方執行邏輯零影響、純文檔層擴增
  3. **dogfood-driven hardening 第十六循環**：multi-perspective 第十四循環結構師金礦落地、第二日連續 ship 對齊 v0.7.4 雙軌節奏「頻繁小擴增 PATCH」精神
  4. 對齊 `core/violation-reflection §2`「LLM 個體不重要、集體記憶才重要」設計方向
- **v0.9.0「紀律完整性 + AI 自我覺察升維」MINOR release**（2026-04-30 ship、第十七循環 dogfood-driven hardening、charter 完成 v0.7.3 北極星閉環）：
  1. **4 條新加 condition**（21 → 25 條 condition、12 → 13 個架構級概念）：
     - `core/individual-learning-loop.md`（**第 13 個架構級概念**、補完接班場景四軸的第 4 軸：個體 AI 跨任務 / 跨 session 學習迴圈）— 寫紀律（雙寫個體 `roles/<role>/reflections/` + 集體 `state/failure_mode_log.md`）+ 讀紀律（init step 0 強制讀）+ 跨 session 學習迴圈（接班 AI 紀律繼承）
     - `core/diagnose-remediate-protocol.md`（SSS S3 架構級條款化、v0.8.1 起手實證的終局）— spec-as-data 結構（合規規定 / 修補方向 + 約束 / 反例 / 真實 stdout 證據）+ 弱保證項清單派生 + commit hook vendor 邀請制加固 + 真實 stdout 證據要求
     - `core/adoption-lifecycle.md`（5 階段 lifecycle 完整化 + SSS S2 設計素材落地）— 全新 / 升版 / 棄用（含「保留最後的溫柔」精神）/ 重新採用 / vendor 升級 path 三路徑（A/B/C、SSS S1 子集）
     - `core/condition-mutability.md`（紀律本體、v0.7.1 frontmatter scaffold 條款化）— 三層 mutability + 3-strike 刪除協議 + user-initiated consolidation + AI 修訂權限分層
  2. **新範本 `templates/agent-commons/reflection.md.tpl`**（個體層反省範本、雙寫紀律執行載體）
  3. **新 preset `tools/profiles/essential.yaml`**（3-5 條 core / < 5k init token、signal #28 progressive adoption + signal #26 ROI 真槓桿）— 探索期專案首選、漸進升維路徑：essential → minimal → standard → strict
  4. **新 spec `tools/uninstall-spec.md`**（`/charter-uninstall` 棄用工具設計）— 五 phase（三次確認 / archive 報告 / level 選擇 Soft|Full|Nuclear / charter clone 處理 / 結束報告）+「保留最後的溫柔」精神（棄用是有尊嚴的離別不是 lock-in）
  5. **`core/init-template.md §3.3.2` 七步驟 → 八步驟**（加 step 0「讀過去違反紀錄」對應個體學習迴圈 §3 讀紀律）— signal #32 條款化（LLM 不查 templates）+ signal #34 紀律本體（個體學習迴圈）
  6. **`tools/doctor-spec.md §3.11` 個體學習迴圈合規**（W1101 reflections/ 缺 / W1102 雙寫漏對應 / E1103 frontmatter 不全、四欄 spec-as-data 結構對齊 §3.7-§3.10）
  7. **`tools/post-upgrade-verify-spec.md` 模式 B/C ship**（模式 B 升版 diff 自動列新 condition / 範本 / spec；模式 C pre-commit sync 自動跑 verify、v0.8.0 模式 A 既有 → v0.9.0 補完）
  8. **dogfood signal 第十七循環收編**：#11 mutability 三層分類 → ④ / #26 init token cost ROI → ⑤ / #27 spec-driven 循環依賴 reality check → ② / #28 progressive adoption → ⑤ / #30 LLM 砍 fork 內容 → ② / #31 simulated slash command → ② 真實 stdout 加固 / #32 LLM 不查 templates → ① init step 0 / #33 failure-mode 自報失效 → ② commit hook 邀請制 / #34 個體學習迴圈紀律缺失（**user 明示「框架必備」**、不走累積門檻直接條款化）→ ①
  9. **multi-perspective 第十四循環四方金礦完整落地**：結構師雙軸正交矩陣（① + ② 兩格） + 理念守護者「LLM 不可矯正」方向性誤讀指認（① 雙寫紀律對齊「集體記憶才重要」+「但個體記憶仍要寫 + 強制讀」）+ 工程師採用方層 vs 維護者層分離（③ adoption-lifecycle / uninstall-spec 採用方層、② commit hook 候選 vendor 層）+ 採用方 essential preset 真槓桿（⑤ 落地）
  10. **採用方文檔層 sync**：ADOPTION v1.11 / TUTORIAL v1.11 / QUICKSTART v1.1（首次有變更歷史段）/ README §核心通用條款 + §設計哲學第 6 條「個體學習迴圈 — 對 AI 角度的對稱補完」 / 第 6 個 walkthrough `examples/upgrades/v0.8.2-to-v0.9.0.md`（v0.x 階段 walkthrough 系列收齊 6 個升版場景）
- **v0.9.1〜v0.9.10 PATCH 系列**（2026-05-01〜2026-05-04）：doctor Gap 偵測 + Doctor 角色概念層 / `/checkpoints` 後置介紹 + 自動版本偵測 + handler 移 vendor/commons + 交班詢問 + reflection frontmatter 修正 + signal #38 修補 + BOOTSTRAP.md 入口檔（dogfood signal #21 修補）+ init-template vendor spec 誤讀防呆（signal #41 Kiro fallback）
- **v0.10.0「commit hook vendor 中立架構」MINOR release**（2026-05-05 ship、雙軸軸 1「結構強制」首次大規模落地）：`tools/commit-hook-spec.md` 新檔（H1-H6 校驗點 + spec-as-data 四欄結構）+ reference 實作 `charter-commit-checks.sh v1.0` + 安裝器 `install-git-hooks.sh v1.0`（git 原生 hook + agent-commons 共用 script、vendor 中立 — Claude/Gemini/Kiro/Cursor/人類 commit 全攔）+ `core/cross-ai-handoff §3.3` 「致 XXX」directive header 條款化。**6 條同源 signal 一次收編**：#33/#35/#42/#43/#44/#45
- **v0.10.1〜v0.10.6 PATCH 系列**（2026-05-06〜2026-05-21）：v0.10.1 charter version 主動通知 step 0.5（signal #47）/ v0.10.2 commit hook H7 schema-driven 強制必啟集合 BREAKING-LITE（signal #46/#31/#52 + REQ-001-F6）/ v0.10.3 純 spec sweep + maintainer-only lint binary（雙軸 framing 第三段、規範自動化「不讓 maintainer 記」）/ v0.10.4 vendor 介紹 charter 工具紀律 charter common 化（signal #53/#54）/ v0.10.5 Gemini CLI 預設 `generalist` 自動分包 PM init 必提醒（signal #55）/ v0.10.6 Claude PM v1.0 接入 + Gemini PM v1.8 best-of-breed 收斂（signal #59、path B dogfood 收編 pattern 第一次完整 LIVE 實證）
- **v0.11.0「Gemini CLI 棄用觸發 Antigravity vendor 接入」MINOR release**（2026-05-22 ship、A1 公理時運實證 + vendor 中立架構反向實證）：`roles/pm/antigravity-cli.md` v1.1（path A AI-DRAFTED-FROM-GEMINI-V1.8 + 同日 LIVE 第二輪校正、Skills 子目錄 `~/.gemini/skills/<name>/SKILL.md`）+ `roles/pm/gemini-cli.md` v1.9 標 LEGACY_AUTO_IMPORTED + walkthrough + UPGRADE.md 顯著警告段。**dogfood signal #60 LIVE 條款化候選**
- **v0.12.0「3 in 1 BREAKING-MEDIUM」MINOR release**（2026-05-22 ship、架構級概念 13 → 15、條款數 25 → 27）：(1) `core/vendor-lifecycle.md`（第 14 個架構級概念、收編 #5/#41/#55/#58/#59/#60 family）+ (2) `core/init-spec-schema.md`（第 15 個架構級概念、SSS S2.5 Canonical Init Spec + Vendor Adapter pattern、signal #61 條款化、解 dbSDK PM AI 報告三 vendor pm-init 差異 604/11842/1645 bytes）+ `roles/{pm,engineer}/init-spec.md` + `templates/vendor-adapters/*.tpl`（3 個）+ (3) agents-commons rename（`agent-commons/` → `agents-commons/`、`migrate-to-agents-commons.sh`）
- **v0.13.0「Engineer × Codex Desktop vendor 接入」MINOR release**（2026-05-23 ship、commit `cae8d3e`、v0.12.0 Follow-up 第一個 LIVE ship）：依 `core/ai-vendor-onboarding §3` 邀請制四步驟走完（Codex 一輪即過 step 4 簽收、無 regression）+ `roles/engineer/codex.md` v0.1（anti-`dogfood signal #41` 教科書級實證 — 拒絕宣稱 `.codex/commands/` 不存在的 native slash command、改用 Codex Skill schema）+ `templates/vendor-adapters/codex.skill.tpl` v1.0（第 4 個 adapter）。**Engineer 角色 vendor coverage 從 1 → 2**（Claude Code + Codex Desktop）。**dogfood signal #62 候選登記**（global skill version drift、#58 family 延伸）

**當前 4 preset enabled**：essential 5/27 / minimal 14/27 / standard 24/27 / strict 24/27（standard/strict 含 maintainer-only 1 條預設關 = 23 條採用方有效）
**Vendor coverage**：Engineer × {Claude Code v0.1, Codex Desktop v0.1} / PM × {Antigravity v1.1, Gemini v1.9 LEGACY, Claude v1.0} / Auditor / Validator / Doctor 概念層既有、vendor 層待邀請制
**採用案例**：YC_AIAgentCrew（v0.8.0+）/ 公司 dbSDK（v0.10.1+）/ CryptoBot（v0.10.1 反向接入、A3 公理對源頭反向迴圈閉環）

- **v0.13.x / v0.14.0 後續議程**：dogfood signal #62 候選累積 ≥ 2 次後評估 / Codex adapter Step 3 cross-platform sweep（#48 family）/ Cursor / Kiro vendor 接入（v0.12.0 Follow-up 第二項剩餘）/ antigravity-cli.md path A → SIGNED / SSS S1 設計深化（前置條件齊備）/ LICENSE + v1.0 公開化準備
