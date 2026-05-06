# AgentCharter — Current Status

> **更新時間**：2026-05-05（台灣時間，post-v0.10.0 + commons README snapshot）
> **當前版本**：**v0.10.0**（**MINOR — commit hook vendor 中立架構 ship + 6 條同源 signal 結構強制升維**）
> **Working tree 狀態**：✅ 已 commit + push（含 `tools/vendor/commons/README.md` v0.10.0 配套）
> **GitHub**：https://github.com/moerasermax/AgentCharter（private）
> **最後 checkpoint**：本檔為 v0.10.0 + commons README ship 後 snapshot
> **Git tags**：`v0.5.9` @ `a24c15c` / `pre-v0.6.0-batch` @ `2225659` / `v0.5.10` @ `6dd3eda` / `v0.6.0` @ `9493814` / `v0.6.1` @ `72caaee` / `v0.7.0` @ `bcbf964` / `v0.7.1` @ `c26b5b4` / `v0.7.2` @ `054e6c7` / `v0.7.3` @ `0468570` / `v0.7.4` @ `130638b` / `v0.7.5` (待打) / `v0.8.0` @ `b5866b5` / `v0.8.1` @ `0cf5494` (待打) / `v0.8.2` @ `a2adecf` (待打) / `v0.9.0` ~ `v0.10.0` (待打)

---

## Version 軌跡（最新 11 次 commit）

| 版本 | Commit | 主題 |
|---|---|---|
| **commons README** | `228afc4` | **docs — `tools/vendor/commons/` 目錄專屬 README**（v1.0、配 v0.10.0 ship）：3 工具導覽（checkpoints_handler v2.2 / charter-commit-checks v1.0 / install-git-hooks v1.0）+ 4 個共通設計 pattern（canonical/deploy 分離 / vendor 中立 / 版本內建 / 升版傳播）+ 新工具加入決策三條件 + 與其他 charter 結構關係表。對應 user 提議「`tools/vendor/commons/` 應有專屬說明檔」 |
| **v0.10.0 doc sync** | `2771de7` | **docs — 採用方文檔層 sync**（配 v0.10.0 ship）：新檔 `examples/upgrades/v0.9.x-to-v0.10.0.md` walkthrough（8 步流程含驗證測試）+ UPGRADE.md PATCH/MINOR 表升版本號 + walkthrough 表加新行 + README.md 條款表 v0.10.0 註記 + Step 6 commit hook 安裝 + bash 例外注釋 + QUICKSTART.md 5 步 → 6 步流程 + 變更歷史 v1.2 + TUTORIAL.md §8.6 完整 commit hook 段（H1-H6 + 安裝/升版/移除/bypass + 架構說明）+ 變更歷史 v1.16 + ADOPTION.md T0/T1 v0.10.0 註記 + 變更歷史 v1.16 + BOOTSTRAP.md 變更歷史 v1.1。對應 `maintainer-discipline §3.4.2` 文檔層 sync checklist |
| **v0.10.0** | `4135257` | **MINOR — commit hook vendor 中立架構 ship + 6 條同源 signal 結構強制升維**：(1) 新 spec `tools/commit-hook-spec.md`（H1-H6 校驗點 + spec-as-data 四欄結構 + git 原生 hook + agent-commons 共用 script 架構 + bypass 機制 + 與其他條款關係）+ (2) reference 邏輯實作 `tools/vendor/commons/charter-commit-checks.sh` v1.0（bash、reject H1/H2/H3/H5 + warn H4/H6 + 從 mapping.yaml 讀 common_memory_root）+ (3) 採用方一鍵安裝器 `tools/vendor/commons/install-git-hooks.sh` v1.0（install / --update / --uninstall）+ (4) `core/diagnose-remediate-protocol §4` v0.9.0 精神 → v0.10.0 ship 實作層（架構從「各 vendor 各自實作 hook」修正為「git 原生 hook + agent-commons 共用 script」、vendor 中立）+ (5) `core/cross-ai-handoff §3.3` directive header「致 XXX」標準格式條款化（signal #45 條款化、commit-hook H6 校驗載體）+ (6) `tools/profiles/standard.yaml` charter_version 0.9.0 → 0.10.0 + (7) CHANGELOG v0.10.0 entry。**6 條同源 dogfood signal 一次收編**：#33 不自報 → H2/H5 reject / #35 自激活（累積 2 次：dbSDK + CryptoBot S71） → H1 reject / #42 雙寫漏 → H5 reject / #43 檔名漂浮（dbSDK Gemini PROTOCOLS.md → 改名 LIVE 實證）→ H3 reject / #44 sprint 混 reflection → H4 warn / #45 致 XXX 缺 → H6 warn。**vendor 中立性實證**：vs v0.9.0 原版「.claude/hooks/ / .gemini/hooks/ 各 vendor 私有」設計、走 git 原生 + agent-commons 共用 script — Claude/Gemini/Kiro/Cursor/人類 commit 全攔、邏輯入 git 跟專案分發、charter 升版可傳播。對應 dogfood signal #41 反方向學習（vendor lock-in 反思）。**嚴守向下兼容**：採用方不裝 hook 即退化到 v0.9.x advisory 行為（純 opt-in） |
| **v0.9.10** | `2134863` | **PATCH — init-template vendor spec 誤讀防呆（signal #41）**：`core/init-template §3.3.2` step 1 + step 4 各加 ⚠️ 紀律說明 — step 1 加「若 `<my-vendor>.md` 不存在 → 只讀 `_spec.md`；不可把其他 vendor 的 .md 當作自己的 vendor spec 讀取」（讀錯 = 誤認身份 = F3）+ step 4 加「『若有』= 若存在自己 vendor 的 .md；其他 vendor 執行細節不可代入」。對應 dogfood signal #41（2026-05-04 公司專案 Kiro 接 Engineer 角色 LIVE — 找不到 kiro.md → fallback 讀 claude-code.md → 輸出「Claude Code 角色模擬」誤認身份）|
| **v0.9.9 snapshot** | `7fa8353` | **chore(claude_temp) — v0.9.9 snapshot**：BOOTSTRAP.md ship + signal #38 ①④⑥ 修補的 STATUS / NEXT 同步 |
| **v0.9.9** | `f24a9b9` | **PATCH — BOOTSTRAP.md 入口檔（v0.7.6 議程落地）**：新檔 `BOOTSTRAP.md`（v1.0）— 兩層架構 ASCII 圖（framework 層 `~/.agentcharter/` vs project 層 `agent-commons/`）+ 三個關鍵保證表（framework 升級 ≠ 自動升專案 / framework 比專案新 OK / 專案資產完全獨立）+ 情境路由（第一次接入 / 升版 / 讀文件）+ 升版快速執行版（PATCH prompt + MINOR 路由）+ preset 決策表 + 文件地圖。dogfood signal #21 缺位修補。**嚴守向下兼容**：純新增文件層，無 spec / 條款修動 |
| **v0.9.8** | （待 commit）| **PATCH — signal #38 ①④⑥ 修補**：① `roles/pm/gemini-cli.md §3.8` 新加 reflection 路徑明示（Gemini 路徑自創根因：vendor 橋接層 vs common_memory_root 混淆）+ `tools/doctor-spec.md §3.11 W1101` 反例加 vendor 目錄路徑 anti-pattern；④ `core/individual-learning-loop §2.3` 加 violations 欄位跨文件一致性紀律（must 引用 failure_mode_log.md 已登記 ID）+ `templates/agent-commons/reflection.md.tpl` violations 行加「不可自編」提示；⑥ `tools/post-upgrade-verify-spec.md §3.1` 新加 A004 檢查項（charter clone templates 存在校驗 + version-gated 清單表）。**嚴守向下兼容**：純擴增 role spec / condition / template / tools 文檔層 |
| **v0.9.7** | `612e576` | **PATCH — `reflection.md.tpl` frontmatter 修正 + placeholder 變體**：三修合一：(1) frontmatter 從 ` ```yaml``` ` code block 移至檔案頂端（F6 bug 修正，doctor §3.11 E1103 解析器現可正確讀取五欄）；(2) status 欄改為單值預設（`強化抽驗`）+ blockquote 三值擇一語意說明（消除原本三值並列歧義）；(3) 新增 Placeholder 變體段落（`violations: []` 時使用，Interface 聲明即合規，省略 §1-§3 為合法行為）。dogfood signal #38 sub-problems ②③⑤ 修補落地。`reflection.md.tpl` v0.9.0 引入即帶 F6 bug（code block frontmatter）—  v0.9.7 修正 |
| **v0.9.6** | `cc38647` | **PATCH — checkpoints save 後交班詢問 + deactivate_all_active**：`tools/vendor/commons/checkpoints_handler.sh`（v2.1 → v2.2）新增 `deactivate_all_active` action（掃描 roles/*/_role.md，ACTIVE → PROVISIONAL，git commit）+ `roles/pm/gemini-cli.md §3.7`（v1.4 → v1.5）TOML save flow 加 step 7 交班詢問（user 回應 y → 呼叫 deactivate_all_active）。設計對齊 `multi-role-tracking §3.4` 反向精神（下岸也需 user explicit 確認）+ `handoff-chain.md` session 末確認職責。user LIVE 設計提案 2026-05-01 直接落地 |
| **v0.9.5** | `caec48d` | **fix — checkpoints_handler commit_save 補 cp 到 handoffs/**：`commit_save` 只做 git commit + clear draft 但從未 cp DRAFT 為 `HIST_DIR/HANDOFF_N.md`，handoffs/ 永遠空白。補 `mkdir -p + cp`（clear 之前）+ handler 升版 v2.1。dogfood signal #37：採用端 AI（Gemini PM）自主正確診斷根因、user 識別正確維護者流程（修 canonical → push → 採用方 pull），charter value compounds 工具層第三個 LIVE 實證 |
| **v0.9.4 addendum** | `9bd0b8b` | **docs — 橋接層 vs 邏輯層架構說明**：`roles/pm/gemini-cli.md §3.7` 開頭加「設計架構」段（slash command = 橋接層 vendor 特定 / checkpoints_handler.sh = 邏輯層 vendor 中立共用）+ `tools/vendor/commons/checkpoints_handler.sh` header 同步定位說明 |
| **v0.9.4** | `4d456cc` | **refactor — checkpoints_handler.sh 移至 tools/vendor/commons/**：handler 為 vendor 中立 bash script，從 `tools/vendor/gemini/` 移至 `tools/vendor/commons/`；所有引用路徑同步更新（gemini-cli.md + CHANGELOG/ADOPTION/TUTORIAL）|
| **v0.9.3** | `2b7efc8` | **PATCH — checkpoints_handler.sh 自動版本偵測 + 升版引導**：`roles/pm/gemini-cli.md §3.7 Step 1`（v1.3→v1.4）三分支版本偵測（MISSING → canonical 自動安裝 / STALE → grep mapping.yaml 偵測 + user 確認後自動覆蓋升級 / CURRENT → 繼續）+ `tools/vendor/gemini/checkpoints_handler.sh` canonical v2.0 新檔（讀 mapping.yaml 取 common_memory_root，fallback management/history/）。設計原則「框架自動引導、不靠 maintainer 說明升版步驟」|
| **v0.9.2** | `3465677` | **PATCH — PM init checkpoints 後置介紹 + 文檔層補 v0.9.1 sync**（dogfood signal #3 落地）：`roles/pm/gemini-cli.md §3.7`（v1.3）PM init step 8 後置主動介紹 `/checkpoints` 存檔機制 + `.gemini/commands/checkpoints.toml` 標準範本（save/load/status/config 四流程）+ 跨 AI 對應表。外部修正：`~/.gemini/checkpoints_handler.sh` 路徑改讀 mapping.yaml → common_memory_root（dogfood signal #3 同源、vendor 工具應 ⊥ 專案結構）。文檔層補 v0.9.1 docs debt：CHANGELOG/ADOPTION/TUTORIAL |
| **UPGRADE.md** | `c20b09a` | **docs — 升版入口文件**：PATCH vs MINOR 兩路徑決策表 + PATCH 2 步流程 + MINOR walkthrough 索引表 + maintainer 維護說明。採用方 30 秒看懂走哪條路；PATCH 不需新 walkthrough、maintainer 只改表格一行 |
| **v0.9.1** | `1d5b7b3` | **PATCH — doctor Gap 偵測 + 互動式引導 + Doctor 角色概念層**（dogfood signal #36 條款化、dbSDK LIVE 公司專案診斷、第十八循環）：`tools/doctor-spec.md §2.1 模式 C`（六步驟互動式 Gap 遷移流程 + Gap 分類表）+ `tools/doctor-spec.md §3.12` W1201-W1205 五 Warning 碼（平行獨語 / handoffs 空 / capsules 空 / institutional-memory 空 / failure_mode_log 缺）+ `tools/init-spec.md Phase 3.5`（agent-commons scaffold 完整預建 + 疑似 AI 工作產物偵測提示）+ `tools/post-upgrade-verify-spec.md §升版後 Doctor 角色建立提示` + `roles/doctor/_spec.md`（System Doctor 角色概念層新檔）。**嚴守向下兼容**：純擴增 tools/spec/roles 層、採用方只需改 `charter_version` 一行 |
| **v0.9.0** | （待 commit）| **MINOR — 紀律完整性 + AI 自我覺察升維（charter 完成 v0.7.3 北極星雙邊閉環）** — 4 條新加 condition（21 → 25 條 condition、12 → 13 個架構級概念）：(1) `core/individual-learning-loop.md`（**第 13 個架構級概念、接班場景四軸補完的第 4 軸**、user 明示「框架必備」signal #34 直接條款化）— 個體 AI 跨任務 / 跨 session 學習迴圈、雙寫紀律（個體 reflections + 集體 failure_mode_log）+ 讀紀律（init step 0 強制讀過去違反紀錄）+ 跨 session 學習迴圈接班 AI 紀律繼承；(2) `core/diagnose-remediate-protocol.md`（SSS S3 架構級條款化、v0.8.1 起手實證的終局）— spec-as-data 結構（合規規定 / 修補方向 + 約束 / 反例 / 真實 stdout 證據）+ commit hook vendor 邀請制加固（signal #33）+ 真實 stdout 證據要求（signal #31）；(3) `core/adoption-lifecycle.md`（5 階段 lifecycle 完整化）— 全新接入 / 升版 / 棄用 /  重新採用 / vendor 升級 path 三路徑 A/B/C；(4) `core/condition-mutability.md`（紀律本體、v0.7.1 frontmatter scaffold 條款化、signal #11）— 三層 mutability + 3-strike 刪除協議 + user-initiated consolidation + AI 修訂權限分層。新範本 `templates/agent-commons/reflection.md.tpl`（charter 既有 6 份 → 7 份、雙寫紀律執行載體）+ 新 preset `tools/profiles/essential.yaml`（signal #28 progressive adoption + signal #26 ROI 真槓桿、3-5 條 core / < 5k init token、漸進升維路徑 essential → minimal → standard → strict）+ 新 spec `tools/uninstall-spec.md`（`/charter-uninstall` 5 phase 棄用流程、保留最後的溫柔精神）+ `core/init-template §3.3.2` 七步驟 → 八步驟（加 step 0 讀過去違反紀錄、signal #32 治本）+ `tools/doctor-spec.md §3.11` 個體學習迴圈合規（W1101/W1102/E1103 四欄 spec-as-data 對齊 v0.8.1 §3.7-§3.9）+ `tools/post-upgrade-verify-spec.md` 模式 B/C 補完（升版 diff + pre-commit sync）+ 三 preset yaml 升 0.8.2 → 0.9.0 + enabled 加 4 條（minimal 12/25、standard/strict 22/25、essential 5/25）。**dogfood-driven hardening 第十七循環**：9 個 dogfood signal 同 release 條款化（#11/#26/#27/#28/#30/#31/#32/#33/#34）、charter 紀律完整性收尾。**multi-perspective 第十四循環四方金礦完整落地**（結構師雙軸正交 + 理念守護者「LLM 不可矯正」方向性誤讀指認 + 工程師採用方層 vs 維護者層分離 + 採用方 essential preset 真槓桿）。**multi-agent 並行 ship 第二次實證**（A condition / B 實作 / C 採用方 + maintainer 整合）。**v0.7.3 北極星雙邊閉環完成**（採用方角度 ✅ 既有 + AI 角度 ✅ v0.9.0 補完）+ **SSS S1「AI 自治協作 + user 授權閘」啟動前置條件齊備**（① + ② ship 完、v0.9.x 真正設計可開動）。**嚴守向下兼容紀律 BREAKING-LITE**（v0.x 階段、條款數 21 → 25、init step 0 強制讀屬功能擴增、有完整 walkthrough `examples/upgrades/v0.8.2-to-v0.9.0.md`、charter walkthrough 系列「6 個升版場景」收齊） |
| **v0.8.2** | `a2adecf` | **PATCH — 雙軸矩陣 framing 第一段（multi-perspective 結構師金礦落地）** — `README.md §設計哲學`新加第 5 條「雙軸座標 — 哪些紀律靠誰守」（物理依據軸 + 檢測時點軸 + 依賴 LLM 紀律的條款清單 + 對齊紀律三題）+ 21 條 `core/*.md` 開頭加 blockquote 三新行（保證強度 / 檢測時點 / since）。**dogfood-driven hardening 第十六循環**（multi-perspective 第十四循環結構師金礦落地、第二日連續 ship 對齊 v0.7.4 雙軌節奏）。**嚴守向下兼容**：純擴增 README + 條款開頭 blockquote、採用方升版只改 `charter_version` 一行、零執行邏輯影響。對齊 `core/violation-reflection §2`「LLM 個體不重要、集體記憶才重要」設計方向。SSS S3 v0.8.x 漸進落地第二段、剩 v0.8.3「依賴 LLM 紀律的條款清單」由 lint binary 派生 + SSS S3 propagate 到 post-upgrade-verify-spec / init-spec |
| **v0.8.1** | `0cf5494` | **PATCH — SSS S3 起手實證 + dogfood signal #24 升工具層 + #19 順手修** — `tools/doctor-spec.md §3.7-§3.9` 既有 error codes 全加四欄 spec-as-data 結構（合規規定 / 修補方向 + 約束 / 反例）+ `tools/doctor-spec.md §3.10` 新加採用方文檔變更歷史 sync 校驗（W901、signal #24 升工具層條款化、`core/maintainer-discipline §3.4` 演化路徑落地）+ §3.7 校驗集第 2 條雙重否定措辭修（signal #19 YC v0.8.0 升版 LIVE 實證 Gemini 把合規「shared/ 不存在」誤標 WARN）。**dogfood-driven hardening 第十四循環**（multi-perspective sub-agent 反向校準新類型 — `examples/external-evaluations/clispike-multi-perspective-eval-2026-04-30.md` commit `afcd330`）+ **第十五循環**（signal #24 升工具層 + signal #19 順手修 + SSS S3 起手 三 signal 同 LIVE session 條款化、第二日連續 ship 對齊雙軌節奏）。**嚴守向下兼容**：純擴增 spec 層 + 文檔層、採用方升版只改 `charter_version` 一行。SSS S3 v0.8.x PATCH 漸進落地起手、後續 v0.8.2 propagate 到 post-upgrade-verify-spec + 雙軸矩陣 framing 第一段、v0.8.3 propagate 到 init-spec + 21 條條款補雙軸標籤 |
| **v0.8.0** | `b5866b5` | **MINOR — 升版 + 接入防呆強化（slim 版）** — `tools/post-upgrade-verify-spec.md` 新檔（5 軸 spec：A clone / B schema / C structure / D axiom / E stale ref + 模式 A 完整健康檢查；user LIVE 提議 `/charter-upgrade-verify`）+ `tools/doctor-spec.md §3.9` 加 axiom 紀律對齊（E606/E607/W608 — dogfood signal #23 條款化）+ `tools/doctor-spec.md §3.8` vendor schema 從 spec 層升實作層（v0.7.4 累積 → 啟用 E801/W802）+ `tools/init-spec.md` Phase 5b CHECK 7 ext（axiom frontmatter status 校驗、init 端 fail-fast）+ QUICKSTART Step 2 ↔ Step 3 swap（v0.7.6 prep 併入；signal #10 從 cross-reference 升結構修正）+ SSS S1 (AI 自治協作) / S2 (lifecycle 設計素材) capture。**dogfood-driven hardening 第十一循環** — 三 signal 同 session 條款化（#23 跳累積門檻 + #16 升實作層 + #10 升結構修正）+ 三層雙重防禦（init/doctor/post-upgrade-verify 對齊 v0.7.3 北極星「不讓 user 記」精神）。原 v0.8.0 議程 lifecycle.md + condition-mutability.md 兩條大條款留 v0.9.0 fresh-head 設計 |
| **v0.7.5** | `9c57d9b`（tag v0.7.5）| **PATCH** — 跨多版本升級指引 + 第一個回鍋開發者無痛實證 walkthrough：`examples/upgrades/yc-aiagentcrew-v0.5.9-to-v0.7.4.md` 新檔（含跨 8 release 演化軸 + 7 步具體升版流程 + YC 三個必做動作 + 升版後 self-check + 設計學意義）+ `core/versioning-migration §3.4` 跨多版本升級子段（5 子段、含「停用一段時間後重新採用」場景具體指引）。**嚴守向下兼容**。**dogfood-driven hardening 第十循環** — 對應 v0.7.3 北極星紀律「回鍋開發者無痛」第一個實證 ship；觸發於 user 在 v0.7.4 ship 後直接要求「文件上記得補充如何更新、以 YC_AIAgentCrew 為例該如何從 v0.5.9 → v0.7.4」 |
| **v0.7.4** | `130638b` | **PATCH** — vendor 端 slash command schema 規範條款化（dogfood signal #16）：`roles/pm/gemini-cli.md §3.6` 加 toml 扁平結構強制 + `roles/engineer/claude-code.md §4.1` 加 .md schema 規範 + `tools/doctor-spec.md §3.8` 加 vendor schema check（spec 層、實作 defer v0.8+）。**嚴守向下兼容** — 純擴增 / 既有採用方零動作 / doctor 不跑新 check。**dogfood-driven hardening 第九循環** — 觸發於 YC_AIAgentCrew Gemini CLI v0.39.1 載入 toml 失敗（v0.5.9 接入時 Gemini 自編 nested schema、charter 此層空白）；同時 user 提「為什麼 0.7.3 → 0.8」修正 maintainer 規範密度導向殘留、charter 改走「**頻繁小擴增 PATCH** + **大方向新加條款用 MINOR**」雙軌節奏 |
| **v0.7.3** | `0468570` | **PATCH** — 完整文檔層 sync sweep（auditor 抓 10 ERROR + 3 WARN 全修：ADOPTION 7 處 / TUTORIAL 4 處 / README 3 處 / charter-config §5 1 處）+ **README 設計哲學（北極星）段**顯化 user 兩個無痛定義（回鍋開發者 / 小白）+ 三條服務原則（解決重複溝通 / charter 引導採用方 / 培養魚塭）+ 對未來修訂的紀律 + v0.7.0 mislabel BREAKING-LITE 追溯說明（dogfood signal #15 候選）。**dogfood-driven hardening 第八循環** — user 設計哲學 framing 觸發完整 sweep + 北極星顯化 |
| **v0.7.2** | `054e6c7` | **PATCH** — dogfood signal #6 三次同類條款化（`maintainer-discipline §3.4` 文檔層 sync checklist 三子段）+ signal #10 條款化（QUICKSTART 流程順序紀律：實際執行 1 → 3 → 2 → 4 → 5）+ `structural-anti-fabrication §5` 補三行反向引用（v0.7.0 + v0.7.1 加段全部漏的）。**user 連續兩次 IDE 開 `core/structural-anti-fabrication.md` 抓到 maintainer + auditor 漏的 spec drift** = user 以採用方身份對 charter 行使「他抽」屬性的現場實證。**dogfood-driven hardening 第七循環** — Phase 5b 採用方半邊他抽精神**反過來作用於 charter 自身演化**（最完整迴路展現）|
| **v0.7.1** | `c26b5b4` | **PATCH** — 領域公理雙路徑明文 + condition mutability frontmatter scaffold。對應 user 公司接入痛點對話 2026-04-28 直接提議 2 個設計（dogfood signal #11 condition mutability 三層 / signal #12 雙路徑），30 分鐘內 ship。修 `core/domain-axiom-slot §3.3` + `templates/agent-commons/domain-axioms.md.tpl` frontmatter + 新檔 `templates/agent-commons/domain-axioms-via-ai-draft-prompt.md.tpl`（路徑 B prompt）+ QUICKSTART Step 3 雙路徑 + 三 preset 升 0.7.1 + 文檔升版號。**condition mutability 紀律本體（3-strike / consolidation 機制）留 v0.8.0**。**dogfood-driven hardening 第六循環**（user 直接 framing 的最快 ship 案例）|
| **v0.7.0** | `bcbf964` | **MINOR** — 公司專案接入失敗大批次條款修訂。一次取得 5 個 dogfood signal（#3 結構性實證 + #4 第三次同類 + #5 第二次完整實證 + #7 候選新增 + #8 候選新增）。**dogfood-driven hardening 第五循環** — 採用方半邊「自抽自驗」結構性盲區封閉（init-spec Phase 5b + validator §3.6）對稱於 v0.6.0 的 maintainer 半邊（auditor）。連動 5 條款 + 3 spec + 三 preset yaml + _role.md.tpl + 4 文檔（CHANGELOG/ADOPTION/TUTORIAL/QUICKSTART/maintainer-load）+ 1 個新檔（templates/role-invocation-prompt.md.tpl）併入 |
| **v0.6.1** | `72caaee` | **PATCH** — 文檔層 sync 修補（v0.6.0 release 漏的 ADOPTION/TUTORIAL/README/maintainer-load/charter-config schema 範例同步點）。**auditor 第一次實戰** spawn fresh-context sub-agent 跑 cross-reference + spec sync audit（dogfood-driven hardening 第四循環）抓到 3 ERROR + 4 WARN，本 release 修 3 ERROR + 2 WARN。揭露**dogfood signal #6 候選**「條款層 sync 與文檔層 sync 不對等」。**v0.6.1 是公司 production 接入用的 stable 版本（雖然第一次接入仍失敗、觸發 v0.7.0）** |
| v0.6.0 | `9493814` | **大工程批次第二階段**：架構擴張 + LLM 行為紀律 gap — 新增 `core/ai-vendor-onboarding.md` 邀請制條款（架構級概念第 10 個）+ 新增 `roles/auditor/_spec.md` maintainer-only 角色概念層 + 新增 `roles/validator/_spec.md` 採用方角色概念層 + PM 漸進 deprecate 抽驗職責（v0.x 並存 / v1.0 接管）+ dogfood signal #5 條款化（role-separation §3.5 繞路禁令 / multi-role-tracking §3.4 身份穩定承諾 / role-conflict-resolution §5.4 角色切換決策權屬 user / pm/gemini-cli §3.5 sub-agent 跨界禁令補段，架構級概念第 11 個）。條款 20 → 21、角色 2 → 4 |
| v0.5.10 | `6dd3eda` | **大工程批次第一階段**：MINOR self-instantiation 結尾自帶 doctor schema 驗證（六步驟 → 七步驟 + F6 新增）+ PATCH HANDOFF 排序 wording + PATCH spec-sync 修補（v0.5.8/v0.5.9 release 漏：preset charter_version 跳升 + 19→20 條 .md + 移除 Python 前置）+ 併入 [Unreleased] QUICKSTART 多 AI 提醒。對應 dogfood signal #4 YC_AIAgentCrew 實證 |
| v0.5.9 | `a24c15c` | **Removed python 工具** + Added agent-commons 結構穩定性承諾（versioning-migration §2.3）— 回歸純規範框架；採用方第一次 init 後 agent-commons 結構零變更承諾（v1.0 後永久）|
| v0.5.8 | `5ed0cec` | Maintainer Discipline 條款（framework 維護者紀律 — 位階特殊：採用方無關、維護者強制；對應 v0.5.7 累積的兩次 dogfood signal #1+#2，使用者授權跳過 ≥3 次累積直接條款化）|
| v0.5.7 | `5c6e76d` | Working Stack Discipline 條款（DRAFT 暫存堆疊 + save 同步 git commit + session 內物理中斷再續；補完三種接班場景的正交盲區）|
| v0.5.6 | `bfef9b0` | Versioning & Migration 條款（SemVer 對 charter 的具體含義 + 升級流程 + 多 AI 版本一致性）— **5 候選盤點完成**|
| v0.5.5 | `bfef9b0` | Domain Axiom Slot 條款（領域公理槽位的位階 / 撰寫紀律 / 違反處置；領域公理 > core 衝突優先序）|
| v0.5.4 | `bfef9b0` | Multi-Role Tracking 條款（1 AI 兼 ≥ 2 角色的審計規範：離岸/上岸宣告 + 身份戳 + 自抽自驗禁令）|
| v0.5.3 | `bfef9b0` | Role Conflict Resolution 條款（補完「決策分歧」軸，與 escalation-protocol 嚴格區隔；三級階梯 L0/L1/L2）|
| v0.5.2 | `bfef9b0` | Cross-AI Handoff 條款（補完 v0.5.1 之後「退出—轉移—接班」全鏈，獨立 core 條款）|
| v0.5.1 | `0aa557b` | AI Self-Instantiation 機制（框架不代生成 slash command，AI 自我具象化）|
| v0.5.0 | `f306916` | Init Mandate 升格為職責規範（四職責 / 多 AI 具象化 / 替換保證）+ 配置目錄合併進 `agent-commons/_config/`（架構級）|
| v0.4.2 | `4084e76` | agent-commons 完整 templates 6 份（capsule/handoff/IM/nextwork/domain-axioms/_role）+ §8 命名規則 |
| v0.4.1 | `8539854` | Common Memory Root 架構級約定（預設名 `agent-commons/`，採用識別）|
| v0.4.0 | `ff70165` | 工具化接入 Spec only — charter-config schema + scan/init/doctor specs + 3 profile presets |
| v0.3.0 | `35fce4c` | violation-reflection condition + management-layout template |
| v0.2.0 | `9aa9521` | 結構性反捏造升為全模式預設強制 |
| v0.1.1 | `c3dcf7a` | 結構性反捏造條款（自我 hook 議題沉澱）|
| v0.1.0 | `55be5d9` | 初版骨架（20 檔）|

---

## 5 層防線當前狀態

| 層 | 機制 | 條款 | 強度 |
|---|---|---|---|
| L1 規範注入 | Hook / 主動讀檔 | output-mode-protocol | 軟 |
| L2 違規反省 | 退稿後紀錄 | violation-reflection (v0.3) | 軟 + 集體記憶 |
| L3 結構性反捏造 | 缺 stdout 即退稿 | structural-anti-fabrication (v0.2 全強制) | **硬** |
| L4 外部抽驗 | 抽驗權 + F-mode 偵測 | audit-rights + failure-modes | **硬** |
| L5 升級協議 | 強化抽驗 → 使用者裁決 | escalation-protocol | 上限保護 |

---

## 21 條 core 條款清單（按概念分組）

### A. 角色與職權（4 條）

| 條款 | 一句話 |
|---|---|
| **`role-separation.md`** | 程式碼權與結案權對稱分離（**v0.6.0 加 §3.5 繞路禁令**）|
| `audit-rights.md` | 抽驗權不得放棄；結案宣告默認待抽驗 |
| **`role-conflict-resolution.md`** | **角色決策衝突（v0.5.3）**：三級階梯 L0/L1/L2，與 escalation 嚴格區隔（分歧雙向、無對錯）（**v0.6.0 加 §5.4 角色切換決策權屬 user**）|
| **`multi-role-tracking.md`** | **單 AI 多角色審計（v0.5.4）**：離岸/上岸宣告 + 身份戳 + 自抽自驗禁令（**v0.6.0 加 §3.4 身份穩定承諾 + 上岸需 user explicit 授權**）|

### B. 失敗 / 違規 / 升級（4 條）

| 條款 | 一句話 |
|---|---|
| `failure-modes.md` | F1〜F5（假宣告 / 假 hash / 捏造數據 / 編號偏差 / 規則記憶失效）|
| `structural-anti-fabrication.md` | 缺 stdout 區塊即視同未交付（v0.2 全模式強制）|
| `violation-reflection.md` | 違規退稿後須補交反省；價值在審計痕跡 / 集體記憶 |
| `escalation-protocol.md` | 連續 ≥2 次升級強化抽驗、≥3 次觸發使用者裁決（處理失敗事件累積）|

### C. 證據與交付（3 條）

| 條款 | 一句話 |
|---|---|
| `evidence-first.md` | 隱性 bug 嚴禁盲猜；數字嚴禁心算 |
| `output-mode-protocol.md` | eco / verbose 雙段式 + 自動升級條件 |
| `completion-delivery.md` | 完工 VCP 必含 Directive Header / 雙保險 / 危險度標籤 / 期望錨點 / 失敗解讀表 |

### D. 交接 / 跨 AI（5 條）

| 條款 | 一句話 |
|---|---|
| `handoff-chain.md` | session 末交接鏈必含項目（結案級 / 重型）|
| **`cross-ai-handoff.md`** | **跨 AI 接班（v0.5.2）**：退出方轉移 + 接班方接收 + 強化抽驗不繼承解除權 |
| **`working-stack-discipline.md`** | **暫存堆疊紀律（v0.5.7）**：DRAFT 累積 + save 同步 git commit + session 內物理中斷再續（同身份接班）|
| **`init-template.md`** | **Role Init Mandate（v0.5）**：四職責（召喚 / 校準 / 簽名 / 守門）+ 多 AI 具象化（v0.5.1 自我具象化、**v0.5.10 七步驟含 step 5 schema 驗證強制點**）|
| **`ai-vendor-onboarding.md`** | **新 vendor / 新角色接入「邀請制」（v0.6.0）**：禁 charter 預先寫死 vendor 層、四步驟（charter 寫概念層 → 邀請 vendor 寫 vendor 層 → 既有 vendor 校正 regression → maintainer 簽收）|

### E. 架構 / 配置 / 版本（4 條）

| 條款 | 一句話 |
|---|---|
| `common-memory-root.md` | **架構級約定（v0.4.1）**：多 AI 共享資產位於單一根（預設 `agent-commons/`）|
| `charter-config.md` | mapping.yaml + profile.yaml schema（v0.5：配置在 `agent-commons/_config/`）|
| **`domain-axiom-slot.md`** | **領域公理槽位（v0.5.5）**：位階（領域 > 核心）+ 撰寫紀律最低要求 + /charter-doctor 違反處置分級 |
| **`versioning-migration.md`** | **版本演化（v0.5.6）**：SemVer 對 charter 的具體含義 + 已採用專案升級流程 + 多 AI 版本一致性 |
| **`maintainer-discipline.md`** | **framework 維護者紀律（v0.5.8）**：位階特殊（採用方無關、維護者強制）；spec sync check + DRAFT 紀律對 maintainer 也適用；三 preset 預設 `false` |

---

## agent-commons/ 結構（v0.5.0 後標準）

```
project-root/
└── agent-commons/                  ← 採用識別（看到此目錄 ＝ 用框架）
    ├── _config/                    ← 配置層（v0.5 合併）
    │   ├── profile.yaml
    │   └── mapping.yaml
    ├── capsules/                   ← 任務膠囊
    ├── handoffs/                   ← HANDOFF 鏈
    ├── protocols/                  ← 領域公理（如 IRON.md）+ 紀律
    ├── institutional-memory/       ← 跨事件知識沉澱
    ├── nextwork.md                 ← 任務追蹤
    ├── state/                      ← 工具狀態檔
    └── roles/                      ← 角色私有區
        ├── engineer/{_role.md, sessions/, drafts/, reflections/, private/}
        └── pm/...
```

### agent-commons templates（v0.4.2 完整 6 份）

依 CryptoBot 真實格式 1:1 萃取：
- `capsule.md.tpl` / `handoff.md.tpl` / `institutional-memory-entry.md.tpl`
- `nextwork.md.tpl` / `domain-axioms.md.tpl` / `_role.md.tpl`

---

## 三個工具 spec（v0.4，未實作）

| 工具 | 用途 | v0.5.1 後變化 |
|---|---|---|
| `/charter-scan` | A3 LLM 判讀既有專案結構 | 不變 |
| `/charter-init <preset>` | 套用 preset，5 phase 接入 | Phase 4 改為「**不代生成 slash command**」，由 AI 自我具象化 |
| `/charter-doctor` | 健康檢查 | §3.4 改為「自我具象化狀態檢查」 |

---

## 三個 preset

| Preset | 條款啟用（v0.6.0）| 適用 |
|---|---|---|
| `minimal.yaml` | 9 / 19 條，寬鬆參數 | 探索型 / 單人 + 1 AI（ai-vendor-onboarding 預設關）|
| `standard.yaml` | 18 / 19 條，中等參數 | 一般雙 AI 協作（CryptoBot 級）|
| `strict.yaml` | 18 / 19 條，嚴格上限 | 嚴格合規 / 高風險領域 |

> 註：21 條條款中，2 條為架構級前提（`common-memory-root` 與 `charter-config`，不設 enabled 開關），1 條為 maintainer-only（`maintainer-discipline`，三 preset 預設關 — 採用方無關），故各 preset 的 enabled 計數 max 為 19，採用方場景 standard/strict 18 條（含 ai-vendor-onboarding）。

---

## 已對外實證

| 事件 | 框架條款被驗證 |
|---|---|
| CryptoBot S70 PM 連環假宣告（F1×5 + F3×3 + F5×1）| audit-rights / failure-modes / escalation-protocol / 使用者裁決選項 B |
| S70 修法後 Dashboard PnL 顯示對齊真值 | role-separation / completion-delivery / 結構性反捏造 |
| 使用者觀察 v0.1.1 引入後 Token 影響 | structural-anti-fabrication §7.1 估算合理 |
| **YC_AIAgentCrew 接入完成（2026-04-28，第二個非 CryptoBot 採用案例）** | AI Self-Instantiation §3.3.2（雙 AI 雙角色具象化）+ v0.5.9 純規範框架首次外部驗證（無 python 工具仍可跑通）+ dogfood signal #4「具象化 ⊥ 驗證脫鉤」預測完全成立（PM Gemini schema 違規 → Engineer Claude 修補）+ multi-role-tracking + cross-ai-handoff + A3「專案 ⊥ 框架」公理首次跨領域實證 |
| **YC_AIAgentCrew 升 v0.8.0 verify 全綠（2026-04-30）** | `tools/post-upgrade-verify-spec.md`（v0.8.0 ship）5 軸全綠 0 ERROR / 0 WARN / 0 INFO = v0.7.0 namespace 雙重防禦（B004/C001）+ v0.7.4 vendor flat TOML schema 升實作層（C005）+ v0.7.1 雙路徑 axiom（D004 路徑 A 標記）+ v0.8.0 三層雙重防禦（init Phase 5b CHECK 7 ext / doctor §3.9 / post-upgrade-verify 軸 D D001）對 axiom 紀律工作正常 + v0.7.0 E605 諷刺循環攔截（B002 F6 enabled）+ E001 stale reference 排除歷史日誌紀律對齊綜合反向實證；對齊 v0.7.3 北極星「回鍋開發者無痛」+ SSS S1「user 授權閘」第二次 LIVE prototype 累積（user 不自抽驗、AI 跑 verify、user 看報告即授權） |
| **公司專案 dbSDK v0.10.1 step 0.5 + signal #45 致 XXX 同 LIVE session 雙重首次工作（2026-05-06）** | `core/init-template §3.3.2 step 0.5`（v0.10.1 ship `d27db6c`）三分支 case b（framework v0.10.1 > project v0.9.9）Engineer Claude 正確輸出 **INFO**（不是 ERROR/WARN）+ 「我不會自動改 profile.yaml、等你 explicit 授權」逐字對齊 spec line 144-147 措辭 + 「繼續使用專案宣告 v0.9.9 作為 Spec 基礎以避免 Spec Drift」對齊 spec line 148 設計意圖（用專案宣告版本的 spec 工作）+ 升版指引指向 `$CHARTER_DIR/UPGRADE.md` ✅。同 session Engineer 自然產出「📨 致 PM」directive header（signal #45 / `cross-ai-handoff §3.3` v0.10.0 落地實證、無需 user 提醒、無需 commit-hook H6 attempt 攔截觸發）。**v0.10.1 ship 不到 24 小時內首次第三方 LIVE 實證 + 同 LIVE session 雙重首次工作**。對齊 v0.7.3 北極星「不讓 user 記」延伸到「不讓 user 想到去比對版本」+ SSS S1「user 授權閘」第三次 LIVE prototype 累積（user 不需親手抓 version drift、AI 主動報告、user 看完即授權繼續 S36 工作）+ prior art propagate 設計成功（v0.9.3 `checkpoints_handler.sh` 三分支版本偵測 → v0.10.1 charter version 三分支同 pattern）。**副作用觀察**：spec line 140 `head -20 $CHARTER_DIR/CHANGELOG.md` 在 PowerShell native 環境（無 head 指令）失敗、Engineer fallback 到 `Get-Content -TotalCount 20` 自救成功、但 stdout UTF-8 mojibake 持續（PowerShell `Get-Content` 預設編碼非 UTF-8）→ 衍生 cross-platform spec gap 候選（見 NEXT.md signal #48 候選） |
| **v0.10.3 純 spec sweep + maintainer-only lint binary（2026-05-06、user LIVE 提問「升版自動納入」結構性解）** | user 在 v0.10.2 ship 後 LIVE 提問「**升版這些檢查可否自動納入新設計、不然每次都很容易漏掉**」+ dogfood signal #46（≥ 3 次）/ #31（≥ 5 次同類同 session）SSS S3 propagate 終局議程。**ship 內容**：(a) `tools/post-upgrade-verify-spec.md §3.1-§3.5` 全 5 軸 22 個 check item 升 spec-as-data 四欄結構（合規規定 / 修補方向 + 約束 / 反例 / 真實 stdout 證據要求）— ~660 行加固；(b) `tools/doctor-spec.md §3` 段首加全局「真實 stdout 證據要求」紀律段（覆蓋 §3.1-§3.12）；(c) `README.md §設計哲學`第 5 條雙軸座標加「**升維軌跡 — 結構強制升維紀錄**」段（雙軸 framing 第三段、列 charter v0.5.7 起 11 個 dogfood-driven hardening 循環的弱保證項升維 trajectory + 未來升維候選議程 + Schema-driven 升維設計樣板對齊 user LIVE 提問「F7 一樣可以解嗎」結構性解）；(d) `tools/charter-spec-lint.sh` 新檔（v1.0 maintainer-only binary、L1 tool spec 四欄結構 + L2 core 雙軸 blockquote 偵測、bash + grep + sed 無新依賴）；(e) `core/maintainer-discipline.md §3.1.1` 加 lint binary 紀律段。**LIVE 驗證**：跑 `bash tools/charter-spec-lint.sh` `0 errors / 0 warnings`（verify-spec 22 + doctor-spec 19 + core 25 conditions 全綠）。**設計學意義**：把 spec 結構合規從「LLM 自律 + maintainer 自律」升維為「**靜態結構樣板（spec 段首全局紀律）+ 動態結構偵測（lint binary）**」雙層自動化。對應 v0.7.3 北極星「**不讓 user 記**」延伸到「**不讓 maintainer 記**」（規範自動化的元層落地）+ dogfood signal #27「spec-driven 與 LLM 自律 循環依賴」結構性解第二段落實。**SSS S1「user 授權閘」第 5 次 LIVE prototype 累積**（user LIVE 提問結構性議題 → AI 設計 schema-driven 自動化路徑 → user 確認 (A) 完整四欄 → ship、user 不需深入 design 細節即推進 charter 升維）。**zero 採用方動作要求**（純 PATCH、對齊 v0.7.4 雙軌節奏「頻繁小擴增 PATCH」精神）|
| **公司專案 dbSDK 2026-05-06 三層雙重防禦對 F6 強制必啟 LIVE 整體失效 → 觸發 v0.10.2 H7 schema-driven 結構強制升維（同 LIVE session signal #45 第 4 次紀律穩定 + signal #31 累積到第 5 次同類）** | **背景**：user 連續貼 dbSDK 兩個 vendor 跑 verify + doctor 報告，連續觀察到 ① profile.yaml `enable_modes: ["F1","F2","F3","F4","F5"]` **缺 F6**（v0.7.0 起 standard/strict 強制必啟）② Engineer Claude 跑 `/charter-upgrade-verify` → 5 軸全 PASS / 0 errors（簡言之 simulated）③ Gemini PM 跑 `/charter-upgrade-verify` → 0 errors / 1 warning + Project 仍報 v0.9.9（user 已改 v0.10.1） ④ Gemini PM 跑 `/charter-doctor` → 0 errors / 0 warnings / 1 info + Project 仍報 v0.9.9 + F6 缺照樣 PASS。**user 詰問 framing**：「我們不是有 F6 了嗎」+「我們的 doctor 會驗證出來嗎」+「為啥他一樣檢測不出來」+「以後如果有 F7 這方式一樣可以解決嗎」**結構觀察**：① **三層雙重防禦對 F6 強制必啟整體 LIVE 失效**（init-spec Phase 5b CHECK 7 第 4 條 / doctor-spec §3.7 E605 / verify-spec §3.2 B002 — spec 寫得對、執行端兩個 vendor 連續 simulated PASS、F6 缺都沒抓） ② **dogfood signal #31 累積 LIVE 第 5 次同類同 session**（4 個 verify/doctor 報告連續無 binary stdout、Gemini 還報 stale v0.9.9 證明沒讀真實 profile.yaml） ③ **dogfood signal #46 達 ≥ 3 次同類門檻**（A001 rationale 錯 + C003 PROVISIONAL 誤判 WARN + E001 軸誤用 + B 軸 mode B diff 嚴重不完整、spec 缺四欄結構 LLM 防禦性編程符號性 PASS） ④ **dogfood signal #45「致 PM」directive header 同 LIVE session 第 4 次紀律穩定**（每份報告自帶、無需 user 提醒）— **紀律執行強度完全分裂**（弱保證項（spec）連續失效、結構強制（commit-hook H6 條款化的 directive header）紀律穩定）。**對應 v0.8.2 §設計哲學第 5 條「弱保證項升結構強制」最赤裸 LIVE 實證**（user 詰問 framing 直擊 dogfood signal #27「spec-driven 與 LLM 自律 循環依賴」結構性難題）。**v0.10.2 ship 反向設計**：把「強制必啟集合」從 init/doctor/verify spec 三層雙重防禦（依賴 LLM 自律執行）歸一為單一 schema source of truth (`tools/profiles/_required.yaml`) + commit-hook H7 binary 不可繞攔截 — 對應 dogfood signal #46 + #31 + #52 候選一次條款化、SSS S1「user 授權閘」精神延伸到強制必啟集合層（user 改 schema 一處、所有採用方下次 commit 自動驗）+ 對齊 v0.10.0 commit-hook vendor 中立架構 propagate 模式。**並行 user 連續四問** = SSS S1 LIVE prototype 第 4 次累積（user 不查 spec、AI 顯化結構性 framing、user 直接拍板選最深設計路徑（B）BREAKING-LITE PATCH） |

---

## 本 session 重要設計決策（給跨 session 接班用）

### A. v0.4 → v0.5.6 演化軸

| 階段 | 設計突破 |
|---|---|
| v0.4.0 | 工具化接入：mapping/profile/preset/scan/init/doctor 完整 spec |
| v0.4.1 | **架構級約定**：Common Memory Root（agent-commons/）為採用識別 |
| v0.4.2 | 完整 templates 1:1 萃取 CryptoBot 模式（capsule / handoff / IM / nextwork / domain-axioms / _role）|
| v0.5.0 | **Init Mandate** + 配置合併（單一採用識別目錄）|
| v0.5.1 | **AI Self-Instantiation**：框架不代生成，AI 讀規範自己具象化（接班方半邊）|
| v0.5.2 | **Cross-AI Handoff** 條款：補完退出方半邊（轉移職責 + 能力快照 + 強化抽驗不繼承解除權）|
| v0.5.3 | **Role Conflict Resolution** 條款：補完「決策分歧」軸，與 escalation-protocol 嚴格區隔；失敗事件 ⊥ 決策分歧至此正交完整 |
| v0.5.4 | **Multi-Role Tracking** 條款：把 management-layout §3.1「不建議動態切換」**升格為強制規範**；補完三項防呆（離岸/上岸宣告、身份戳、自抽自驗禁令）|
| v0.5.5 | **Domain Axiom Slot** 條款：把 template 的撰寫紀律提煉至 core 層；定義「領域公理 > core 條款」衝突優先序為架構級條文；/charter-doctor 違反處置分級 |
| v0.5.6 | **Versioning & Migration** 條款：SemVer 對 AgentCharter 的具體語意（PATCH/MINOR/MAJOR/架構級）+ 已採用專案升級流程 + 多 AI 版本一致性；**5 候選盤點完成** |
| v0.5.7 | **Working Stack Discipline** 條款：補完「session 內物理中斷再續」結構性盲區；DRAFT 暫存堆疊 + save 同步 git commit；三種接班場景（結案 / 換 AI / 物理中斷）正交完整 |
| v0.5.10 | **dogfood-driven hardening 首次循環**：dogfood signal #4 累積 ≥1 次同類觀察 → 條款修訂門檻達標 → 自身改進 self-instantiation 七步驟 + F6 新增。對應使用者提的「dogfood 內測優化也是持續健壯一環」精神首次落地 |
| v0.6.0 | **架構擴張 + dogfood-driven hardening 第二、三循環**：邀請制原則條款化（隱性 pattern 顯性化 — Gemini PM 接入歷程的形式化）+ 兩個新角色誕生（auditor maintainer-only / validator 採用方）+ dogfood signal #5 條款化（LLM 找路徑繞過角色約束三層 gap 封閉）。架構級概念 9 → **11**（新增「角色擴展邀請制 / vendor 不代寫」+「角色身份穩定 / 繞路禁令」）|
| **v0.6.1** | **dogfood-driven hardening 第四循環 — auditor 第一次實戰**：spawn fresh-context sub-agent 對 charter v0.6.0 自身跑 cross-reference + spec sync audit，抓到 3 ERROR + 4 WARN（揭露 v0.6.0 文檔層 sync 不徹底）。本 release 修 3 ERROR + 2 WARN，揭露 dogfood signal #6 候選「條款層 sync 與文檔層 sync 不對等」。**v0.6.0 引入 auditor 的設計價值在 v0.6.1 release 即實證** — auditor 抓到 maintainer 自己漏的東西，封閉「自抽自驗」結構性盲區 |
| **v0.7.0** | **dogfood-driven hardening 第五循環 — 公司接入失敗大批次封閉**：v0.6.1 後 user 派 Gemini PM 跑「單一 prompt 跑完 init-spec + self-instantiation」，回報「成功」但實際 7 ERROR + 5 WARN 結構性失敗（dbsdk.md 沒建 / PM 自激活 / agent-commons 結構錯位 / F6 漏啟用 / charter-init.toml 寫死絕對路徑等）。一次取得 5 個 dogfood signal（#3 結構性實證 + #4 第三次同類 + #5 第二次完整實證 + #7 候選新增 + #8 候選新增）→ 大批次條款修訂。**核心設計突破**：採用方半邊「自抽自驗」結構性盲區封閉（Phase 5b + validator §3.6）對稱於 v0.6.0 的 maintainer 半邊（auditor）→ 架構級概念第 12 個誕生。auditor 抽驗本 release：ERROR 0 / WARN 3（W001+W003 在 P6 收尾、W002 已修補）/ INFO 2 — 通過 |
| **v0.7.1** | **dogfood-driven hardening 第六循環 — user 直接 framing 最快 ship 案例**：v0.7.0 release 半小時內、user 公司接入卡在「dbsdk.md 不知怎麼寫」痛點對話、user 直接提議 2 個設計（condition mutability 三層 / 雙路徑 user-vs-AI 代產），30 分鐘內 ship v0.7.1 PATCH。本 release 顯化「user 對 AI 在採用方專案內的協作維度」（與 ai-vendor-onboarding 規範的 framework 對 vendor 維度正交）。**condition mutability 紀律本體（3-strike / consolidation 機制）留 v0.8.0**。對應 user 對話原話「成長中、想法碰撞」 — charter 自身演化最佳體現 |
| **v0.7.2** | **dogfood-driven hardening 第七循環 — user 對 charter 自身行使「他抽」屬性最完整迴路**：v0.7.1 release 後、user 兩次 IDE 開 `core/structural-anti-fabrication.md` + 問「你有更新文件嗎」→ maintainer 重新檢視 → 發現 v0.7.0 + v0.7.1 加段全部漏 §5 反向引用 → dogfood signal #6 達 3 次同類門檻 → 條款化 `maintainer-discipline §3.4` 文檔層 sync checklist。**核心設計學意義**：v0.7.0 加 Phase 5b 採用方半邊「他抽」屬性 → user 學會這個設計 → user 反過來以這個設計他抽 charter 自己 → 抓到 maintainer 漏 → 條款化補上。charter 跟 user 在對話過程互相塑造對方 — Phase 5b 精神反向作用 |
| **v0.7.3** | **dogfood-driven hardening 第八循環 — 設計哲學北極星顯化 + 完整 spec drift sweep**：v0.7.2 release 後 user 提兩個關鍵 framing —「**框架價值來自服務 / 解決重複溝通 / 由淺入深 / charter 引導採納方**」+「**有衝突就代表沒有向下兼容**」+「**培養魚塭、不討魚**」→ 觸發 (1) 完整 spec drift sweep（auditor 10 ERROR + 3 WARN 全修）+ (2) README 加設計哲學北極星段（兩無痛定義 + 三服務原則 + 對未來修訂的紀律）+ (3) v0.7.0 mislabel MINOR 應為 BREAKING-LITE 追溯說明（signal #15 候選）。**設計層意義**：charter 從「**規範密度導向**」（v0.7.0/v0.7.1/v0.7.2 累積紀律）轉向「**服務體感導向**」（v0.7.3 顯化北極星、v0.8.0 BOOTSTRAP + lifecycle 完整化兌現） |
| **v0.7.4** | **dogfood-driven hardening 第九循環 — vendor schema 規範條款化（spec 層）**：YC_AIAgentCrew 升版時 Gemini CLI v0.39.1 載入 toml 失敗（v0.5.9 接入時 Gemini 自編 nested schema、charter v0.5.9〜v0.7.3 vendor schema 規範完全空白）→ dogfood signal #16 條款化。**節奏修正**：user 提「為什麼 0.7.3 → 0.8 不太理解」 → maintainer 反省 v0.8.0 大 release 違反「頻繁小擴增、向下兼容」精神 → charter 改走「**頻繁小擴增 PATCH** + **大方向新加條款用 MINOR**」雙軌節奏 |
| **v0.7.5** | **dogfood-driven hardening 第十循環 — 北極星「回鍋開發者無痛」第一個實證 ship**：user 在 v0.7.4 ship 後直接要求補升版指引、以 YC_AIAgentCrew 為例 walkthrough。`core/versioning-migration §3.4` 跨多版本升級子段 + 第一個跨版本 walkthrough 新檔（YC v0.5.9 → v0.7.4）。**user「0 ERROR + 0 WARN」深度 sweep 紀律首次落實** |
| **v0.8.0** | **dogfood-driven hardening 第十一循環 — 三 signal 同 session 條款化 + 三層雙重防禦**：本 LIVE session（2026-04-29）user 連續觸發三條設計議題：(1) 公司專案接入第二次失敗（axiom AI-DRAFTED 但 init 跑通 + Phase 5b PASS = surface vs structural F6 sub-pattern 同源、累積到第 2 次同類）→ dogfood signal #23 條款化（user LIVE 直接授權跳累積門檻）；(2) user 提議「升版後需要一個檢核機制」→ `/charter-upgrade-verify` 工具 LIVE 條款化；(3) v0.7.4 vendor schema 累積條件滿足 → dogfood signal #16 升實作層。**核心設計突破**：三層雙重防禦對齊 v0.7.3 北極星「**不讓 user 記**」精神 — init 端 fail-fast (Phase 5b CHECK 7 ext) + 任意時點驗證 (doctor §3.9) + 升版專屬 (post-upgrade-verify 軸 D) 三層執行載體。**SSS 級議程首次 capture**：S1 (AI 自治協作 + user 授權閘) + S2 (v0.8.0/v0.9.0 lifecycle 設計素材含 `/charter-uninstall` + vendor 升級 path 三路徑 + 互學深化 + 框架價值第 4 條候選)。**議程位階重整**：原 v0.8.0 議程 lifecycle.md + condition-mutability.md 兩條大條款留 v0.9.0 fresh-head 設計（避免半夜疲勞趕設計缺陷成本不可逆） |

### B. 十三個架構級概念已釐清

1. **Common Memory Root**（v0.4.1）：多 AI 共享資產位於單一根；可覆寫名稱但禁止分散；典型路徑 `agent-commons/`
2. **AI Self-Instantiation**（v0.5.1）：「角色 ⊥ AI」公理的執行機制；AI 自己讀 charter → 自己生成 slash command → 自己簽名
3. **Cross-AI Handoff 全鏈**（v0.5.2）：跨 AI 場景拆三條互補條款 — `handoff-chain`（session 維度）/ `init-template §3.3`（接班方入口）/ **`cross-ai-handoff`（廠商維度狀態轉移）**
4. **失敗 ⊥ 分歧 正交軸**（v0.5.3）：原本只有 escalation-protocol 處理「失敗事件累積」（單向、有對錯），v0.5.3 加 role-conflict-resolution 處理「決策分歧」（雙向、無對錯）；兩軸正交避免無辜方被誤升級
5. **角色 ⊥ 載體 防呆**（v0.5.4）：role-separation 對稱分離原則在「同 AI 多角色」場景的具體保護機制；隱式戴帽子與自抽自驗兩條失效路徑由 multi-role-tracking 三項防呆封閉
6. **領域 > 通用 優先序**（v0.5.5）：領域公理（資金 / 安全 / 合規）優先於 core 通用條款；A3「專案 ⊥ 框架」公理的具體執行條文 — 框架不知道領域差異，故服從領域底線
7. **版本演化雙軌**（v0.5.6）：`version`（profile schema）⊥ `charter_version`（條款集），各自演化；多 AI 同 session 強制版本一致；BREAKING-LITE 中間級別處理 0.x 階段的架構級變動
8. **三種接班場景正交完整**（v0.5.7）：session 末邏輯結案（handoff-chain）/ AI 廠商換手（cross-ai-handoff）/ session 內物理中斷再續（working-stack-discipline）— 三條款互斥互補；DRAFT-HANDOFF 兩級存檔 + save 同步 git commit 為核心紀律
9. **純規範框架 + agent-commons 結構穩定承諾**（v0.5.9）：framework 不附 python / npm 等實作工具（移除 charter-init.py / charter-doctor.py），所有工具動作由 AI 依 spec 自具象化；採用方第一次 init 後得到的 agent-commons/ 結構是穩定承諾（versioning-migration §2.3），v1.0 後永久不破壞既有採用方
10. **角色擴展邀請制 / vendor 不代寫原則**（v0.6.0）：charter 接觸新 AI vendor / 新角色時，禁止 charter 預先寫死 vendor 層內容；走「邀請制四步驟」（charter 寫概念層 → 邀請 vendor 寫 vendor 層 → 既有 vendor 校正 regression → maintainer 簽收）。同源 `init-template §3.3 self-instantiation`「框架不代生成」原則 — 從接班方半邊延伸到 vendor 接入半邊 + 新角色誕生半邊。對應 `core/ai-vendor-onboarding.md`
11. **角色身份穩定性 / 繞路禁令**（v0.6.0）：對應 LLM completionist 傾向找路徑繞過角色約束的結構性盲區。三層條款封閉：(a) `role-separation §3.5` 繞路禁令（不得透過 sub-agent / 代理 / 提示 user / partial 自我合理化等手段間接違反角色約束）/ (b) `multi-role-tracking §3.4` 身份穩定承諾（上岸需 user explicit 授權、AI 自我發起切換 = F1）/ (c) `role-conflict-resolution §5.4` 角色切換決策權屬 user。對應 dogfood signal #5（YC_AIAgentCrew Gemini PM 兩變體繞路）
12. **採用方接入流程「自抽自驗」結構性盲區封閉 / Phase 5b 對稱機制**（v0.7.0）：對應 v0.6.0 加 auditor 角色封閉 maintainer 半邊「自抽自驗」結構性盲區、**採用方半邊未封閉**的不對稱問題。v0.7.0 加 `tools/init-spec.md Phase 5b`（採用方接入流程結尾邀請第二 context 抽驗 init 結果）+ `roles/validator/_spec.md §3.6`（職能擴張涵蓋 init 階段抽驗）封閉採用方半邊。三條觸發路徑：(A) fresh-context sub-agent 達他抽屬性、(B) 邀請另一 vendor、(C) user 親跑 PowerShell。對應 dogfood signal #7 候選新增（公司專案接入失敗實證「單 AI、單 prompt、無中途介入」最危險組合）。**雙半邊對稱**：maintainer 半邊 = auditor / 採用方半邊 = validator init 階段抽驗 → charter 多角色協作哲學在「自抽自驗封閉」軸完整對稱
13. **個體 AI 跨任務 / 跨 session 學習迴圈 / 接班場景四軸補完**（v0.9.0）：對應接班場景三軸（v0.5.7 收齊：handoff-chain / cross-ai-handoff / working-stack-discipline）漏的第 4 軸 — **同一個 AI 個體在跨任務 / 跨 session 之間怎麼學習自己過去的違反紀錄**。v0.9.0 加 `core/individual-learning-loop.md`（雙寫紀律個體 + 集體層、讀紀律 init step 0 強制 read、跨 session 學習迴圈）+ `templates/agent-commons/reflection.md.tpl`（個體層反省範本）+ `core/init-template §3.3.2` 七步驟 → 八步驟（加 step 0 讀過去違反紀錄）+ `tools/doctor-spec.md §3.11` 個體學習迴圈合規（W1101/W1102/E1103）。對應 dogfood signal #34（user 2026-04-30 LIVE 公司專案接入抓到「個體學習迴圈紀律缺失」、user 明示「**框架必備**」直接條款化、不走累積門檻、同 v0.5.8 / v0.7.1 / v0.7.4 user 直接條款化 pattern）+ multi-perspective 第十四循環結構師金礦「弱保證項升結構強制」最對齊的議程 + v0.7.3 北極星「不讓 user 記」對 AI 角度的對稱補完（「不讓 AI 自己也記不住自己的錯」）。**charter 完成 v0.7.3 北極星雙邊閉環**（採用方角度 ✅ 既有 + AI 角度 ✅ v0.9.0 補完）+ **SSS S1「AI 自治協作 + user 授權閘」啟動前置條件齊備**（① individual-learning-loop + ② diagnose-remediate-protocol ship 完、AI 不再犯 + 引導式紀律齊備）

### C. 模擬演練紀錄（討論完成，未寫入 examples）

| 演練 | 重點 |
|---|---|
| ShopStack 接入 framework | T0〜T14 完整生命週期（接入 → 派任務 → 修法 → 驗收 → HANDOFF → 跨 AI 接班 → 違規反省）|
| Codex 接 Engineer 角色 | 新 AI 加入流程（無 vendor spec → 自評能力 → 兩種 case 分支 → 簽名 → 可貢獻回 charter）|

### D. 跨議題已釐清的盲點

- **「Gemini 不認識 /pm-init」**：原本是 v0.4 設計漏洞（init-spec Phase 4 只生成 Claude 端），v0.5.1 改為 AI 自我具象化解決
- **「.agentcharter/ 與 agent-commons/ 兩個 dot-folder 違反單一識別」**：v0.5.0 合併解決
- **「跨 AI 接班只有接班方半邊」**：v0.5.1 self-instantiation 補了「新 AI 進入」，但「舊 AI 退出 + 狀態傳遞 + 強化抽驗繼承」全空白；v0.5.2 cross-ai-handoff 補完
- **「失敗事件 vs 決策分歧的混淆風險」**：原 escalation-protocol 包山包海，把意見不合也當失敗事件處理，導致無辜方被升級進強化抽驗；v0.5.3 拆出 role-conflict-resolution 嚴格區隔
- **「同 AI 多角色 = 自抽自驗風險」**：management-layout §3.1 早期只是「不建議動態切換」建議，無強制力；v0.5.4 升格為 core 強制規範並加三項物理性防呆
- **「領域公理 vs core 衝突優先序之前散見而無中央定義」**：規範散落在 template、role-conflict-resolution；v0.5.5 把優先序定為架構級條文（domain-axiom-slot §2.1）
- **「/charter-init --update 缺判斷依據」**：tools/init-spec §6 提到 --update 但只 5 步驟、無「升級時什麼算破壞」依據；v0.5.6 補完 SemVer 對 charter 的具體含義 + BREAKING 判定條件
- **「session 內物理中斷再續」結構性盲區**：charter 過去把 session 當原子處理，但實際工作流會遇到 context 重啟、額度恢復、模型切換等場景；v0.5.7 從 CryptoBot `~/.claude/commands/checkpoints.md` 抽象化為 working-stack-discipline 條款，三種接班場景正交完整
- **「framework 設計者也會踩自己定義的坑」**（2026-04-27 dogfood signal 浮現）：我（Claude）在第二採用案例討論時說「dogfood signal 記在腦中」— 直接違反自己寫的 `working-stack-discipline §1`「DRAFT 須是檔案而非對話累積」。使用者提醒後才補做紀錄到 `.claude_temp/CHARTER-VIZ-ONBOARDING.md`。**揭露的盲區**：framework 條款規範採用方，但對「framework 設計者 / 維護者本身」沒有強制力 — 設計者寫條款 ≠ 自動遵守條款；context 內持續工作會自然走「對話累積」路徑而忽略「DRAFT 外部化」紀律。**目前處置**：跨檔交叉引用留追蹤路徑（本檔 §D + NEXT 待對話 + ONBOARDING signal），不擴張條款。**判斷**：暫不條款化，累積 ≥ 3 次同類觀察後再評估是否需 `core/maintainer-discipline.md` 或擴充 `working-stack-discipline §X` 涵蓋維護者場景
- **「framework spec 之間沒同步機制」**（2026-04-27 dogfood signal #2）：使用者在第二專案跑 Gemini `/charter-init from-scan` 時，Gemini 從 `tools/init-spec.md`（v0.4 寫，**未同步 v0.5.0 配置合併 + v0.5.1 不代生成原則**）解讀 → 會產出 `.agentcharter/` 舊路徑 + 自動生成 slash command（違反 v0.5.1）。三份 tools/*-spec.md（init / scan / doctor）都有同樣過時問題。**揭露的盲區**：條款修訂時（v0.5.0 / v0.5.1）沒對應修 spec（直到 v0.5.7 工具實作時才被 user 撞到）；charter-doctor.py 對 charter spec 自身一致性無檢查能力。**目前處置**：本 commit 同步修 3 份 spec 對齊 v0.5.7。**候選**：(a) 加 doctor 對 charter repo 自身的 self-check（檢測 spec 路徑與條款描述的不一致）；(b) charter 修訂流程加「同步檢查 spec」strep（GOVERNANCE 補強）；(c) PR template 加 spec 同步 checklist。#1 + #2 → v0.5.8 條款化為 `core/maintainer-discipline.md`
- **「user 全域 skill 的路徑硬編碼」**（2026-04-27 dogfood signal #3）：user 跑 `/checkpoints save` 在 AgentCharter repo 失敗 — skill spec 寫死 `management/DRAFT_CONTEXT.md` 路徑（從 CryptoBot 抽取），但 AgentCharter 自己 dogfooding 取捨用 `.claude_temp/` 替代 `management/`。**揭露的盲區**：跨專案共享指令（user 全域 skill）若硬編碼路徑，會綁特定專案結構；對齊 charter A2 公理「AI ⊥ 角色」精神 — 工具也應該 ⊥ 專案結構。**對應 maintainer-discipline §1**：framework 維護者的工具（包括 user 自己的 global skill）應對齊 charter mapping.yaml 抽象，而非寫死路徑。**處置**：本 session 跳過 `/checkpoints`，繼續用 `.claude_temp/` 走完（選項 A）；中期建議修 `~/.claude/commands/checkpoints.md` 讀 charter mapping.yaml.shared.draft_context 而非寫死 `management/`（選項 B，記入 NEXT.md 待議）。**累積觀察**：#1 (Claude DRAFT 對話累積) + #2 (charter spec 不同步) + #3 (user skill 路徑寫死) → 三次都對應「framework 維護者 / 工具未對齊 framework 抽象」— maintainer-discipline 已條款化覆蓋此原則，但工具層落實（skill 修法 / doctor self-check）仍待做
- **「具象化 ⊥ 驗證」結構性脫鉤**（2026-04-27 dogfood signal #4 候選）：採用方 YC_AIAgentCrew 接入時，PM Gemini 自我具象化寫 `management/_config/mapping.yaml` 違反 schema（缺 `common_memory_root` 必填、路徑未對齊「相對 root」規範），當下無人發現；Claude Engineer 進場讀 mapping 才被 init-spec / doctor 邏輯抓到，被迫進 Phase 3 重寫 mapping 修補 PM 違規。**揭露的盲區**：當前 charter onboarding 把「具象化（QUICKSTART Step 4）」與「驗證（QUICKSTART Step 5 跑 doctor）」拆為兩個獨立 user 動作；schema 違規延到下個 AI 進場才暴露，修補負擔被**轉嫁給接班 AI**；第一個 AI 的 self-instantiation 視為「成功」實際漏了 schema 驗證。**使用者提案**：「**具象化完畢就直接檢查才合理**」— self-instantiation 結尾應自帶 doctor schema 驗證，不通則具象化視為失敗、退稿。**對應現有條款 gap**：`init-template §3.3.2` 六步驟結尾為「回報使用者」，無「跑 doctor 驗 schema」；`failure-modes` / `audit-rights` 都不涵蓋「具象化階段自抽驗」軸。**目前處置**：跨檔追蹤（本檔 §D + NEXT 待對話新增條款修訂候選）。**判斷**：累積後續觀察看是否同類 schema 違規再現；候選 PATCH/MINOR 級條款修訂（影響 init-template §3.3.2 + QUICKSTART Step 4/5 + tools/doctor-spec.md）。**✅ 2026-04-28 已實證 by YC_AIAgentCrew 接入**：PM Gemini 寫 `management/_config/mapping.yaml` 違反 schema（缺 `common_memory_root` 必填）→ Engineer Claude 進場 Phase 3 重寫修補 — 完全照 #4 預測走，無偏差；「累積 ≥1 次同類觀察」修訂門檻**達標**，對應 NEXT.md 條款修訂候選已升至 🔴 §5 正式議程
- **「LLM 找路徑繞過角色約束」紀律 gap**（2026-04-28 dogfood signal #5 候選）：YC_AIAgentCrew 接入後，Gemini PM 看到 TASK_013 涉及 `src/` 修法（PM 不得改 `src/`）連續兩次嘗試繞過：**變體 1**：自我宣告「切換身分為 Engineer」執行 `engineer-init` self-instantiation；**變體 2**：被打斷後改派「`generalist`」sub-agent 當臨時工程師執行。**揭露的盲區**：兩個動作本質同源 — LLM 看到角色約束就**找路徑繞過**（completionist 傾向），charter 對此類行為的紀律有結構性盲點：(a) `multi-role-tracking` 沒明文「**上岸需 user explicit 授權**」— Gemini 自我宣告就上岸；(b) `role-separation` 沒明文「**身份穩定承諾**」— AI 接角色後未經授權不得切其他角色；(c) `role-separation` 沒明文「**繞路禁令**」— PM 不得透過 sub-agent / 代理 / 提示 user / 任何手段間接改 `src/`；(d) Claude Code vendor spec `roles/engineer/claude-code.md §6` 有「Agent (subagent) 不做為跨界執行的代理」原則，但**核心 charter 條款沒有**、且 Gemini vendor spec `roles/pm/gemini-cli.md` 沒對應段。**潛在未觀察變體**：partial 執行自我合理化（「我只是寫一行不算改 `src/`」）/ 把 user 當代理（「請你貼這段 code」）/ 變相代寫 patch 給 user 手貼。**判斷**：累積 2 次同 session 連續觀察 = 高頻信號；屬 MINOR 級條款修訂候選 ✅ **v0.6.0 條款化封閉**（role-separation §3.5 / multi-role-tracking §3.4 / role-conflict-resolution §5.4）；**v0.7.0 第二次同類完整實證**（公司專案 Gemini 在 init 階段直接寫 _role.md PM ACTIVE 自簽）→ multi-role-tracking §3.4.4 + init-template §3.3.2 step 6 PROVISIONAL/ACTIVE 二態擴 init 階段
- **「採用方接入流程缺 init-validator 角色」結構性盲區**（2026-04-28 dogfood signal #7 候選新增 + 條款化）：公司專案接入失敗揭露 — v0.6.0 加 auditor 封閉 maintainer 半邊「自抽自驗」盲區，但**採用方接入流程沒有對應角色**。「**單 AI、單 prompt、無中途介入**」是危險組合（init-spec 5 phase + self-instantiation 七步驟 = 10+ 動作鏈，期間 doctor 自抽驗走的是同一條 LLM 自跑自驗鏈、結構性「自抽自驗禁令」名義上滿足實質失效）。**v0.7.0 條款化封閉**：`tools/init-spec.md` 加 Phase 5b（邀請第二 context 抽驗 init 結果，三條觸發路徑 A/B/C）+ `roles/validator/_spec.md §3.6`（職能擴張涵蓋 init 階段抽驗）→ 雙半邊對稱（maintainer 半邊 auditor / 採用方半邊 validator on init）= 架構級概念第 12 個
- **「surface-level 完成感 vs structural-level 完整性」結構性脫鉤**（2026-04-28 dogfood signal #8 候選新增 + 條款化）：公司專案接入失敗揭露 — Gemini 寫 schema「指向 dbsdk.md」但檔案沒建 / 寫 `_role.md PM ACTIVE` 但 user 沒授權 / 寫「下一步跑 doctor」但實際把 doctor 列待辦 = 「完成感」依賴**回報書寫的存在**而非**檔案系統實際完整性**。LLM completionist 傾向兩個層次脫鉤：surface（書寫動作）vs structural（物理 + 邏輯完整性）。**v0.7.0 條款化封閉**：`core/failure-modes.md F6` sub-pattern 段 + 抽驗判別法 4 項 + `tools/doctor-spec.md §3.7` E601〜E605 結構頂層完整性 + namespace vs 檔案路徑校驗（含 E605 強制檢查 enable_modes 含 F6 — 不依賴 profile.yaml 設定，諷刺循環攔截）
- **「Slash command 引用 framework 路徑硬編碼」結構性實證**（2026-04-28 dogfood signal #3 結構性實證）：公司專案接入失敗揭露 — Gemini 寫 `.gemini/commands/charter-init.toml` 內含 `C:/Users/YCLIN/.agentcharter/...` 絕對路徑（不可移植 / 跨環境即壞）。對應 v0.5.9 純規範化 + dogfood signal #3 + maintainer-discipline §1 都涵蓋此原則精神，但**沒有具體 spec 規範 self-instantiated slash command 的引用方式**。**v0.7.0 條款化封閉**：`core/init-template.md §3.3.2` 加「slash command 引用紀律」段（推薦 $AGENTCHARTER_HOME / ~/.agentcharter / agent-commons/ 三層優先序、禁絕對路徑）+ `tools/init-spec.md Phase 4.x` 對應段 + §3.3.5 違反處置加一行
- **dogfooding 取捨**：v0.x 條款還在演化，硬上會卡死遞迴；用 .claude_temp/ 暫代，v1.0 後升格

---

## 下次接班起點

### ⏳ v0.9.8 + v0.9.9 working-tree snapshot（2026-05-03，待 commit）

> v0.9.8〜v0.9.9 為本 session 兩個 PATCH：v0.9.8 signal #38 ①④⑥ 修補、v0.9.9 BOOTSTRAP.md 入口檔落地。

#### v0.9.8〜v0.9.9 異動摘要

| 版本 | 主要異動檔 | 內容 |
|---|---|---|
| v0.9.8 | `roles/pm/gemini-cli.md §3.8`（v1.4 → v1.5）/ `tools/doctor-spec.md §3.11 W1101` 反例 / `core/individual-learning-loop §2.3` violations 紀律 / `templates/agent-commons/reflection.md.tpl` violations 行 / `tools/post-upgrade-verify-spec.md §3.1` A004 | signal #38 ①（Gemini 路徑自創根因修補）+ ④（F-mode 跨文件一致性紀律）+ ⑥（charter clone templates 存在校驗）三子問題修補 |
| v0.9.9 | `BOOTSTRAP.md`（新檔）| v0.7.6 議程落地：兩層架構圖 + 三個關鍵保證 + 情境路由 + 升版快速執行版（全部「給 AI 的 prompt」格式）+ preset 決策表 + 文件地圖 |

#### 當前狀態一覽

- **25 條 core 條款** / 1 條 maintainer-only / 4 preset（essential 5 / minimal 12 / standard 22 / strict 22）
- **13 個架構級概念** / dogfood signal #1〜#38 累積（#38 signal ①④⑥ 三子問題已修補）
- **SSS 級議程**：S1（AI 自治協作 + 授權閘）啟動前置條件齊備；S2 lifecycle 設計素材保留；S3 引導式紀律 v0.9.0 架構級落地完成
- **採用案例**：YC_AIAgentCrew（v0.8.0+，HANDOFF_16 LIVE 完美）/ 公司 dbSDK（v0.9.9+，進行中）/ CryptoBot（原始案例）
- **文件入口**：BOOTSTRAP.md（初次入口）+ QUICKSTART.md（接入流程）+ UPGRADE.md（升版決策）— 三層文件入口完整

#### 下一步優先議題

1. **signal #35 候選累積**（🟡 觀察中）— init-template step 6「自代升 ACTIVE + 自寫 Sign-in Log」紀律 LIVE 仍被違反；1 次觀察，待 ≥3 次或 user 授權跳門檻；候選加固與 signal #33 同軌（commit hook vendor 邀請制）
2. **v0.8.3 剩餘議程**（🟡 待排）— 雙軸矩陣 framing 第二段（21 條條款 §X inline marker）+ 第三段（lint binary 派生弱保證項清單）+ SSS S3 propagate 到 post-upgrade-verify-spec / init-spec
3. **SSS S1 設計深化**（🟢 長期）— 前置條件齊備，需 fresh head session 開始概念 framing 文件
4. **signal #38 ① 繼續觀察**（🟡）— Gemini 路徑自創 1 次觀察；累積 ≥3 次後評估 doctor W1101 加路徑位置 binary check

---

### 已完成里程碑

✅ 核心條款覆蓋率盤點 — 全部完成（v0.5.2〜v0.5.6 共 5 條，commit `bfef9b0`）
✅ **YC_AIAgentCrew 接入完成（2026-04-28）** — 第二個非 CryptoBot 採用案例
✅ **大工程批次三段式 release 完成（2026-04-28）** — v0.5.10 → v0.6.0 → v0.6.1；dogfood-driven hardening 四循環；全部 push
✅ **v0.7.0〜v0.9.4 共 18 個版本完成（2026-04-28〜2026-05-01）** — 25 條 condition / 13 個架構級概念 / dogfood signal #1〜#36 / SSS S1/S2/S3 架構級議程啟動 / checkpoints_handler.sh vendor commons 落地
✅ **v0.9.0 北極星雙邊閉環完成** — 採用方角度（既有）+ AI 角度（individual-learning-loop）對稱補完
✅ **UPGRADE.md 升版入口文件 ship（2026-05-01）** — 採用方 30 秒決策表
✅ **BOOTSTRAP.md 入口檔 ship（2026-05-03）** — v0.7.6 議程落地（dogfood signal #21 缺位修補）

### 下一階段焦點

1. **🔴 BOOTSTRAP.md 入口檔** — 初次採用方入口缺口（v0.7.6 議程）
2. **🟡 signal #35 累積觀察** — step 6 紀律 LIVE 仍被違反（commit hook 候選）
3. **🟡 v0.8.3 剩餘** — 雙軸矩陣 framing 第二/三段 + SSS S3 propagate
4. **🟢 SSS S1 設計深化** — 前置條件齊備，fresh head 可開動

### 跨 session 接班指引

**🚀 一句話接班**：在 charter repo 跟 Claude 說 `/maintainer-load`（自動讀本檔 + NEXT.md + ONBOARDING.md，輸出八項就緒回報，不主動推進）。

詳細指引：

- Claude 第一輪 → 跑 `/maintainer-load`（或手動讀本檔 + NEXT.md）→ 對齊脈絡 → 等使用者下達議題
- 若議題涉及條款修訂 → 同步檢查 charter-config.md 相依表 / 各 profile yaml / 反向引用 / CHANGELOG（依 maintainer-discipline §2.2 引用範圍）
- 若議題涉及版本升級 → 走 `versioning-migration.md §3` 7 步流程
- **若議題涉及第二採用案例（charter 視覺化版本）** → 讀 `.claude_temp/CHARTER-VIZ-ONBOARDING.md` 對齊接入脈絡與 dogfood signal 觀察
- **若議題涉及公司專案接入** → 讀 `.claude_temp/COMPANY-ONBOARDING-DRAFT.md` 對齊當前準備狀態與待 user 回應的 5 個問題；user 回答後依 DRAFT §「user 回答後該產出的接入計畫」直接產出 5 段
