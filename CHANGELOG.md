# Changelog

依 [Keep a Changelog](https://keepachangelog.com/) 與 [SemVer](https://semver.org/) 風格。

---

## [Unreleased]

（空 — v0.9.2 已釋出；下批次 v0.9.x PATCH 議程：v0.8.3 雙軸矩陣第三段（lint binary 派生「依賴 LLM 紀律的條款清單」）+ SSS S3 propagate 到 post-upgrade-verify-spec / init-spec 既有 error codes 全加四欄結構 + commit hook vendor 邀請制 ship（claude-code / gemini-cli / cursor 各自實作）+ v0.7.6 BOOTSTRAP.md 入口檔 + BREAKING-LITE checklist；v1.0 公開化前：LICENSE 決定 + CryptoBot 引用 charter + IRON Pattern 抽到 framework + ShopStack/Codex walkthrough 寫實檔 + v1.0 frozen 紀律精細化）

---

## [0.9.2] — 2026-05-01

> **PATCH release — PM init `/checkpoints` 後置介紹 + `checkpoints_handler.sh` 路徑對齊（dogfood signal #3 vendor 工具路徑硬編碼落地修正）**。向下兼容，純擴增 `roles/pm/gemini-cli.md`；採用方升版只改 `charter_version: "0.9.1"` → `"0.9.2"`。

### Changed

- **`roles/pm/gemini-cli.md §3.7`（v1.3 新增）**：PM self-instantiation step 8 後置主動介紹 `/checkpoints` 存檔機制 — 介紹話術（跨 session 不失憶 / 跨 AI 接班 / git 自動存檔三好處）+ AI 執行三步驟（確認 `~/.gemini/checkpoints_handler.sh` / 建立 `.gemini/commands/checkpoints.toml` / status 驗收）+ `.gemini/commands/checkpoints.toml` 標準範本（§3.6 扁平 TOML、save/load/status/config 四流程完整 prompt）+ 拒絕 fallback + 跨 AI 對應表

**外部修正（repo 外）**：`~/.gemini/checkpoints_handler.sh` 路徑從硬編碼 `management/` 改為讀 `agent-commons/_config/mapping.yaml → common_memory_root`（`handoffs/` 取代 `history/`；無 mapping.yaml 時 fallback `management/history/` 舊結構）。對齊 `core/charter-config.md` + dogfood signal #3「vendor 工具路徑硬編碼」同源修正。

---

## [0.9.1] — 2026-05-01

> **PATCH release — doctor Gap 偵測 + 互動式引導 + Doctor 角色概念層 + UPGRADE.md（dogfood signal #36 條款化，第十八循環）**。向下兼容，純擴增 tools/spec/roles 層；採用方升版只改 `charter_version: "0.9.0"` → `"0.9.1"`。

### Added

- **`tools/doctor-spec.md §2.1 模式 C`**：六步驟互動式 Gap 遷移流程 + Gap 分類表（平行獨語 / 形同虛設目錄 / 非 charter 格式工作產物 / 正常 charter 結構）— 偵測 Gap → 辨識性質 → 互動式引導歸位
- **`tools/doctor-spec.md §3.12`**：W1201-W1205 五 Warning 碼（平行獨語 / handoffs 空 / capsules 空 / institutional-memory 空 / failure_mode_log 缺）+ 四欄 spec-as-data 結構對齊 §3.7-§3.10
- **`tools/init-spec.md Phase 3.5`**：agent-commons scaffold 完整預建 + 疑似 AI 工作產物偵測提示 — init 端防止 Gap 在接入階段發生
- **`tools/post-upgrade-verify-spec.md §升版後 Doctor 角色建立提示`**：全綠後詢問是否建立 Doctor 角色
- **`roles/doctor/_spec.md`**：System Doctor 角色概念層新檔 — Gap 偵測 + 引導修復 + 互動式歸位（對應 dogfood signal #36 平行獨語 LIVE 實證 + YC HANDOFF_16 高品質協作對比設計啟示）
- **`UPGRADE.md`**：升版入口文件 — PATCH vs MINOR 兩路徑 30 秒決策表 + PATCH 2 步流程（pull + 改版號）+ MINOR walkthrough 索引表 + maintainer 維護說明

---

## [0.9.0] — 2026-04-30

> **MINOR release — 紀律完整性 + AI 自我覺察升維**。**charter 完成 v0.7.3 北極星雙邊閉環**（「不讓 user 記」對採用方角度 + 「不讓 AI 自己也記不住自己的錯」對 AI 角度）。**dogfood-driven hardening 第十七循環 — slim v0.9.0 設計層轉折**（v0.x 紀律密度導向 → v0.9 紀律完整性導向）。**multi-perspective 第十四循環四方金礦完整落地**（結構師雙軸正交矩陣 + 理念守護者「LLM 不可矯正」方向性誤讀指認 + 工程師採用方層 vs 維護者層分離 + 採用方 essential preset 真槓桿）。**multi-agent 並行 ship 第二次實證**（A condition 概念層 / B 實作層 / C 採用方層 + maintainer 整合）。
>
> **Triggered by**：2026-04-30 LIVE session — user 連續推進 v0.8.0 → v0.8.1 → v0.8.2 → v0.9.0 共 4 個 release（24 hr 內）+ user 明示「個體學習迴圈紀律是框架必備、加入 v0.9+」（dogfood signal #34 直接條款化、不走累積門檻、同 v0.5.8 / v0.7.1 / v0.7.4 user 直接條款化 pattern）。

### Added — 4 條新加 condition（21 → 25 條 condition、12 → 13 個架構級概念）

#### `core/individual-learning-loop.md`（**第 13 個架構級概念、接班場景四軸補完的第 4 軸**）

對應 **dogfood signal #34**（user 明示框架必備）+ multi-perspective 第十四循環結構師金礦「弱保證項升結構強制」最對齊的議程 + v0.7.3 北極星「不讓 user 記」對 AI 角度的對稱補完：

- **個體 AI 跨任務 / 跨 session 學習迴圈**：第 4 軸補完接班場景（軸 1 handoff-chain / 軸 2 cross-ai-handoff / 軸 3 working-stack-discipline / **軸 4 individual-learning-loop**）
- **寫紀律**（雙寫）：命中 F-mode 後、補 violation-reflection 雙寫到集體層 `state/failure_mode_log.md`（既有）+ **個體層 `roles/<role>/reflections/<YYYY-MM-DD>_<f-mode>_*.md`**（新加）— 不可只寫集體 / 不可只寫個體
- **讀紀律**（強制）：擴 `core/init-template §3.3.2` 七步驟 → **八步驟**、加 step 0「讀過去違反紀錄」 — 每次 self-instantiation 必先讀自己 reflections + failure_mode_log + IM
- **跨 session 學習迴圈**：接班 AI 同樣強制（依 cross-ai-handoff），違規不再復發紀律

#### `core/diagnose-remediate-protocol.md`（SSS S3 架構級條款化、v0.8.1 起手實證的終局）

對應 multi-perspective 第十四循環理念守護者金礦「LLM 不可矯正方向性誤讀指認」+ dogfood signal #27 / #30 / #31 / #32 / #33 同源加固：

- **spec-as-data 結構**（v0.8.1 doctor §3.7-§3.9 起手 → v0.9.0 propagate 所有 spec）：每 error code / 校驗項加四欄結構（合規規定 / 修補方向 + 約束 / 反例 / 真實 stdout 證據要求）
- **commit hook 走 vendor 邀請制**（signal #33 加固、結構強制升維）：charter 概念層寫紀律「commit 時 AI 標 F-mode 命中、failure_mode_log 必有對應 entry 否則退稿」；vendor 層由 claude-code.md / gemini-cli.md / cursor.md 各自實作（依 ai-vendor-onboarding §3 邀請制）
- **真實 stdout 證據要求**（signal #31 加固）：verify report 每 ID PASS 必附 binary stdout、純文字 PASS 視同 violation-reflection §1 假宣告

#### `core/adoption-lifecycle.md`（5 階段 lifecycle 完整化 + SSS S2 設計素材落地）

對應 SSS S2 設計素材 + dogfood signal #16 vendor 升級 path：

- **5 階段 adoption lifecycle**：全新接入（既有 QUICKSTART）/ 升版（既有 4 walkthrough + v0.8.2-to-v0.9.0 共 5）/ **棄用**（含「保留最後的溫柔」精神）/ **重新採用**（含 archive 報告恢復路徑）/ **vendor 升級 path 三路徑**（A 維持現狀 / B 開 issue / C AI 自驅修復、SSS S1 子集）
- 對應 `tools/uninstall-spec.md`（新檔、`/charter-uninstall` 工具）

#### `core/condition-mutability.md`（紀律本體、v0.7.1 frontmatter scaffold 條款化）

對應 dogfood signal #11（v0.7.1 user 直接提議、v0.9.0 紀律本體）：

- **三層 mutability**：IMMUTABLE-by-AI（user 親決）/ APPEND-ONLY（AI 可加新項、不可刪改既有）/ FULL-MUTABLE（AI 可改 / 刪 / 加，極少）
- **3-strike 刪除協議**：連續 3 次 audit 命中該條款違反 → user 評估是否刪除（對齊 escalation-protocol）
- **user-initiated consolidation**：多條條款重疊 → user 主動提議合併（AI 不可代決）
- **AI 修訂權限分層**：對齊三層 mutability、AI 在不同層有不同修訂權

### Added — 1 範本 + 1 preset + 1 spec 新檔

#### `templates/agent-commons/reflection.md.tpl`（個體層反省範本、雙寫紀律執行載體）

對齊既有 6 份 templates pattern（capsule / handoff / institutional-memory-entry / nextwork / domain-axioms / _role）— charter 既有 6 份 templates → **v0.9.0 加第 7 份**（reflection）。frontmatter 含 date / role / vendor / status / violations、§1 命中模式（按 charter F-mode 分類）/ §2 學習要點（next-time 紀律）/ §3 對應條款引用。

#### `tools/profiles/essential.yaml`（新檔、3-5 條 core / < 5k init token）

對應 **dogfood signal #28 progressive adoption + signal #26 init token cost ROI** 真槓桿。三 preset 軸（minimal / standard / strict）→ **四 preset 軸（essential / minimal / standard / strict）**。漸進升維路徑：essential → minimal → standard → strict（依專案成熟度遞進）。適用：探索期 / 單人 / 快迭代 / 想要 AI 別瞎掰但不想要全套儀式成本。

#### `tools/uninstall-spec.md`（`/charter-uninstall` 棄用工具設計）

對應 SSS S2.1 設計素材落地：5 phase 棄用流程（三次確認 → archive 報告 → level 選擇 Soft/Full/Nuclear → charter clone 處理 → 結束報告）+「**保留最後的溫柔**」精神（棄用是有尊嚴的離別不是 lock-in）。

### Changed — 既有條款 / spec 修訂

#### `core/init-template.md §3.3.2` 七步驟 → **八步驟**

加 **step 0「讀過去違反紀錄」**（在現有 step 1 之前）— 對應個體學習迴圈 §3 讀紀律 + dogfood signal #32（LLM 不查 templates）治本：

- ReadFile 個體層 `roles/<role>/reflections/*.md`（最近 5 個）
- ReadFile 集體層 `state/failure_mode_log.md`
- ReadFile IM 層 `institutional-memory/*.md`（相關事件）
- 不通則 self-instantiation 視為失敗、step 0 必過才能進 step 1
- 違反 → 視同 F1（假宣告就位）

#### `tools/doctor-spec.md §3.11`（新段、個體學習迴圈合規校驗）

對齊 v0.8.1 §3.7-§3.9 四欄 spec-as-data 結構：
- **W1101**：reflections/ 目錄缺
- **W1102**：F-mode 命中無對應 reflection 個體層 entry（雙寫對應）
- **E1103**：reflection frontmatter 不完整

#### `tools/post-upgrade-verify-spec.md` 模式 B/C 補完

v0.8.0 模式 A 既有 → v0.9.0 補：
- **模式 B（升版 diff）**：跨多 release 累積遺漏自動偵測、列出新加 condition / 新範本 / 新 spec
- **模式 C（pre-commit sync）**：commit message 標 charter_version 變動時自動跑 verify

#### 三 preset yaml `charter_version "0.8.2" → "0.9.0"` + enabled 加 4 條新 condition

- `minimal.yaml`：12/25（既有 9 + individual-learning-loop = true 對應 user 明示框架必備、其他 3 條預設 false）
- `standard.yaml` / `strict.yaml`：22/25（既有 18 + 4 條新加全 true）

### dogfood-driven hardening 第十七循環

| signal / 議程 | 對應 v0.9.0 落地 |
|---|---|
| **#11** condition mutability 三層分類 | → ④ `core/condition-mutability.md` |
| **#26** init token cost / ROI | → ⑤ `tools/profiles/essential.yaml` |
| **#27** spec-driven 循環依賴 reality check | → ② `core/diagnose-remediate-protocol.md` |
| **#28** progressive adoption | → ⑤ essential preset + 漸進升維路徑 |
| **#30** LLM 砍 fork 內容（採用方文檔被砍 99%）| → ② diagnose-remediate-protocol（候選加固） |
| **#31** LLM simulated 跑 slash command | → ② 真實 stdout 證據要求 |
| **#32** LLM 不查 charter 既有 templates | → ① init-template §3.3.2 step 0 強制讀 |
| **#33** failure-mode 自報紀律 LIVE 失效 | → ② commit hook vendor 邀請制 |
| **#34** 個體學習迴圈紀律缺失（**user 明示框架必備**）| → ① `core/individual-learning-loop.md`（v0.9.0 議程第一順位）|

→ **9 個 dogfood signal 同 release 條款化** — charter 紀律完整性收尾。

### multi-perspective 第十四循環四方金礦完整落地

| 金礦 | v0.9.0 落地 |
|---|---|
| 結構師：雙軸正交矩陣 | ① + ② 兩格升維（弱保證項升結構強制）|
| 理念守護者：「LLM 不可矯正」方向性誤讀指認 | ① 雙寫紀律對齊「集體記憶才重要」+「**但個體記憶仍要寫 + 強制讀**」 |
| 工程師：採用方層 vs 維護者層分離 | ③ adoption-lifecycle / uninstall-spec 採用方層、② commit hook 候選 vendor 層 |
| 採用方：essential preset 真槓桿 | ⑤ 直接落地 |

### 採用方影響

| 項目 | 影響 | 處置 |
|---|---|---|
| 升版基本動作 | 改 profile.yaml `charter_version: "0.8.2"` → `"0.9.0"` | 改一行 |
| init-template §3.3.2 step 0 強制讀 | 既有採用方升版時、若 reflections/ 目錄不存在 → 跑 doctor 抓 W1101 | 補建 reflections/ 目錄 + 跑 init 接班 AI 強制讀（個體學習迴圈 §3） |
| doctor §3.11 W1101/W1102/E1103 | 既有採用方若沒寫過 reflection → 抓 W1101（友善 INFO 級警告）| 補第一個 reflection 即可（依 templates/agent-commons/reflection.md.tpl）|
| essential preset 加入選擇 | 純擴增、既有採用方不影響 | 探索期專案可選 essential 起步 |
| 4 preset 升維路徑 | 純擴增、既有採用方不影響 | 漸進升維：essential → minimal → standard → strict |
| 條款 21 → 25 | 既有採用方升 charter_version 後、enabled 自動含 4 條新（依 preset）| ★ 屬可接受 BREAKING-LITE（v0.x 階段、純擴增、有完整 walkthrough）|

→ **詳細 step-by-step 升版流程（含每步給 AI 的 prompt 範本）見 [`examples/upgrades/v0.8.2-to-v0.9.0.md`](./examples/upgrades/v0.8.2-to-v0.9.0.md)** — charter walkthrough 系列「6 個升版場景」收齊（v0.x 階段）。

### v0.7.3 北極星雙邊閉環完成

| 北極星紀律 | 對採用方角度（既有 ✅）| 對 AI 角度（v0.9.0 補完）|
|---|---|---|
| 不讓 user 記 | walkthrough + verify 工具 + spec-as-data | **個體學習迴圈**（individual-learning-loop）|
| 回鍋無痛 | 跨多版本升版 walkthrough + 跨版本到最新 | **AI 跨 session 學習迴圈**（同上）|
| 解決重複溝通 | charter 引導採用方 | **個體 / 集體記憶雙寫紀律**（同上）|
| 培養魚塭 | 跨 vendor 純規範 framework | 不變（vendor-agnostic 維持）|

對齊 `core/violation-reflection.md §2`「LLM 個體不重要、集體記憶才重要」設計方向 — v0.9.0 把此精神**完整化**：「設計成集體記憶才重要、**但個體記憶仍要寫 + 強制讀**」雙寫紀律。

### SSS S1「AI 自治協作 + user 授權閘」啟動前置條件齊備

| 前置條件 | ship 狀態 |
|---|---|
| ① individual-learning-loop（AI 不再犯）| ✅ v0.9.0 |
| ② diagnose-remediate-protocol（spec-as-data 引導式紀律）| ✅ v0.9.0 |
| → SSS S1 設計可開動 | **v0.9.x 真正設計起手** |

### 連動更新

- 三 preset yaml `charter_version: "0.8.2"` → `"0.9.0"` + enabled 加 4 條新 condition
- 新 preset `tools/profiles/essential.yaml`（3-5 條 core）
- ADOPTION.md（line 5/149/337 升 v0.9.0 + §3 條款表 21 → 25 + §5 加 essential preset + §12 加 v0.9.0 self-check + §13 加 v1.11 entry）
- TUTORIAL.md（line 6 升 v0.9.0 + 變更歷史加 v1.11 entry）
- QUICKSTART.md（Step 3 preset 表加 essential + 新增變更歷史段）
- README.md（§核心通用條款加 4 條新 condition + §設計哲學第 6 條「個體學習迴圈 — 對 AI 角度的對稱補完」）
- `.claude/commands/maintainer-load.md` 升 v0.9.0 + 加 v0.9.0 release entry 子段
- 新檔 `examples/upgrades/v0.8.2-to-v0.9.0.md`（第 6 升版場景 walkthrough、charter walkthrough 系列收齊 6 個）

### 嚴守向下兼容紀律對齊（v0.7.3 北極星 + v0.7.4 雙軌節奏）

| 紀律 | v0.9.0 對齊狀態 |
|---|---|
| 純擴增 spec | ✅（4 條新加 + 1 範本 + 1 preset + 1 spec、既有 21 條不破壞）|
| 既有條款不破壞 | ✅（21 條既有 condition 內容維持 + init-template 七 → 八步驟為純擴增）|
| 既有採用方升版動作 | ⚠️ **可接受 BREAKING-LITE**（v0.x 階段、條款數 21 → 25 + init step 0 強制讀屬功能擴增、有完整 walkthrough + 純擴增 essential preset 不影響既有採用方）|
| dogfood-driven hardening 雙軌節奏 | ✅（v0.8.0 MINOR slim → v0.8.1/v0.8.2 PATCH 連續 → v0.9.0 MINOR 完整、對齊 v0.7.4 雙軌節奏「頻繁小擴增 PATCH + 大方向新加條款用 MINOR」）|

### multi-agent 並行 ship 第二次實證（multi-perspective prototype 演化）

對齊 SSS S1 LIVE prototype 紀律延伸：

| 階段 | 動作 | 對應紀律 |
|---|---|---|
| 1 | maintainer 寫 V0_9_0_DESIGN_BRIEF.md（~600 行對齊文件）+ 3 agent prompt | SSS S1 三軸 A「AI 互相自己工作」前置 |
| 2 | user 開 3 個 Terminal 並行起 Claude Code、各貼 prompt | SSS S1 三軸 B「user 監督 → 授權閘」LIVE 實證 |
| 3 | 3 agent 各自 fresh-head ship deliverable（A condition / B 實作 / C 採用方）| SSS S1 三軸 A 進階：parallel 而非互動 |
| 4 | maintainer 整合 + ship release-level 文件 | maintainer 綜合 = SSS S1 三軸 B 授權閘執行 |

→ 第二次實證後、SSS S1 設計素材累積完整、v0.9.x 條款化階段可開動。

### 公開化前 v1.0 議程更新

v0.9.0 ship 後、charter v1.0 公開化前剩議程：
- LICENSE 決定（MIT / Apache 2.0 / 其他）
- CryptoBot 改為引用框架（DISCIPLINE / IRON 引用 charter `core/*`）
- IRON Pattern 抽到框架（評估通用 vs 領域）
- ShopStack / Codex walkthrough 寫成實檔
- v1.0 frozen 紀律精細化（結構穩定 + 條款集仍演化）
- SSS S1 真正設計起手（前置條件 ① + ② v0.9.0 ship 完齊備）

---

## [0.8.2] — 2026-04-30

> **PATCH release — 雙軸矩陣 framing 第一段（README §設計哲學第 5 條）+ 21 條條款補雙軸標籤 blockquote 段**。**嚴守向下兼容**：純擴增 README + 條款開頭 blockquote、既有採用方升版只改 `charter_version: "0.8.1"` → `"0.8.2"`。**dogfood-driven hardening 第十六循環**（multi-perspective 第十四循環結構師金礦落地、第二日連續 ship 對齊雙軌節奏）。
>
> **Triggered by**：2026-04-30 LIVE session 接續 v0.8.1 ship — multi-perspective 評估第十四循環結構師金礦「**雙軸正交矩陣（物理依據 ⊥ 檢測時點）**」落地 ship。對齊 multi-perspective 綜合判斷「I. 立刻可採」軸第三項。

### Added — 雙軸座標 framing（README §設計哲學第 5 條）

#### `README.md` §設計哲學新加第 5 條「雙軸座標 — 哪些紀律靠誰守」

對應 multi-perspective 第十四循環結構師金礦顯化：

- **物理依據軸**：結構強制（強）/ 多 actor 互檢（中）/ 單 actor 自律（弱）三層保證強度
- **檢測時點軸**：init / runtime / post-upgrade / handoff
- **依賴 LLM 紀律的條款清單**（弱保證項公開）— 6 條典型條款 + 加固路徑
- **對齊「對未來修訂的紀律」三題**新增雙軸對齊軸

對齊 `core/violation-reflection §2`「LLM 個體不重要、集體記憶才重要」設計方向 — 不以「物理強制 LLM」為解、以「sandbox + log + 集體演化」為解。

### Added — 21 條 core 條款補雙軸標籤 blockquote 段

對 21 條 `core/*.md` 開頭 blockquote group 加三新行：
- `> **保證強度**：<X>` — 結構強制 / 多 actor 互檢 / 單 actor 自律（混合則標主）
- `> **檢測時點**：<Y>` — init / runtime / post-upgrade / handoff（多選列出）
- `> **since**：<Z>` — 引入版本 + 重要演化點

對採用方執行邏輯零影響、純文檔層擴增；提供 user 看 condition 檔開頭即知保證強度的能力（對齊 v0.7.3 北極星「不讓 user 記」+「採用方知道哪些紀律靠誰守」精神）。

### dogfood-driven hardening 第十六循環

| Signal / 議程 | 內容 | 處置 |
|---|---|---|
| **multi-perspective 結構師金礦落地** | 雙軸正交矩陣（物理依據 ⊥ 檢測時點）顯化 | README §設計哲學第 5 條 + 21 條條款 blockquote 段 |
| **multi-perspective 採用方金礦落地（弱保證項清單公開）** | 「依賴 LLM 紀律的條款清單」採用方知情權 | README §設計哲學第 5 條第三子段 |
| **SSS S3 起手實證延伸** | spec-as-data 結構（v0.8.1 ship）+ 雙軸標籤（v0.8.2 ship）共建設計層升維 | 為 v0.9.0 SSS S3 架構級條款化（diagnose-remediate-protocol.md）做基礎 |

### 採用方影響

| 項目 | 影響 | 處置 |
|---|---|---|
| 升版基本動作 | 改 profile.yaml `charter_version: "0.8.1"` → `"0.8.2"` | 改一行 |
| README + 21 條條款 blockquote 段擴增 | spec 內容擴增、不影響採用方執行邏輯 | 純文檔層擴增、零動作 migration |

→ **既有採用方升 v0.8.1 → v0.8.2**：純改 `charter_version` 一行。

→ **詳細 step-by-step 升版流程（含每步給 AI 的 prompt 範本）見 [`examples/upgrades/v0.8.1-to-v0.8.2.md`](./examples/upgrades/v0.8.1-to-v0.8.2.md)** — charter 升版系列最簡 walkthrough（2 步流程、純改 `charter_version` + 跑 verify）+ §5 跨版本場景（v0.7.5 / v0.8.0 直跳 v0.8.2）。

### 連動更新

- 三 preset yaml `charter_version: "0.8.1"` → `"0.8.2"`
- ADOPTION.md（line 5 / 149 / 336）+ TUTORIAL.md / `.claude/commands/maintainer-load.md` 升 v0.8.2
- ADOPTION.md §13 / TUTORIAL.md 變更歷史加 v1.10 entry
- maintainer-load.md 加 v0.8.2 release entry 子段
- **新檔 `examples/upgrades/v0.8.1-to-v0.8.2.md`**（v0.8.2 PATCH walkthrough、charter walkthrough 系列「5 個升版場景」收齊 — 純擴增 PATCH 升版第二例、含 §5 跨版本場景指引、dogfood signal #29 LIVE 實證 capture）
- `examples/upgrades/v0.7.5-to-v0.8.0.md §3 Step 1` 加跨版本紀律提示（dogfood signal #29 條款化第一處）

### SSS S3 v0.8.x 後續議程（剩餘段）

對應 multi-perspective 評估綜合判斷 §3.4「五軸分類」I 軸「立刻可採」剩餘段：

- **v0.8.3 PATCH**：雙軸矩陣 framing 第三段「依賴 LLM 紀律的條款清單」由 lint binary 派生（maintainer-only tool、charter repo CI、不影響採用方）+ SSS S3 propagate 到 post-upgrade-verify-spec / init-spec 既有 error codes 全加四欄結構（對齊 v0.8.1 doctor-spec §3.7-§3.9 pattern）

### 嚴守向下兼容紀律對齊

| 紀律 | v0.8.2 對齊狀態 |
|---|---|
| 純擴增 spec 層 + 文檔層 | ✅（README 新加第 5 條 + 21 條條款 blockquote 段）|
| 既有條款不破壞 | ✅（21 條 condition 不增不減；架構級概念 12 個維持）|
| 既有採用方升版動作 | ✅（純改 `charter_version` 一行；無新 ERROR/WARN）|
| dogfood-driven hardening 連續循環 | ✅（第十四（multi-perspective）+ 第十五（v0.8.1）+ 第十六（v0.8.2）三循環同 24-48 hr 內、對齊 v0.7.4 雙軌節奏「頻繁小擴增 PATCH」）|

對應 v0.7.4 雙軌節奏「**頻繁小擴增 PATCH** + **大方向新加條款用 MINOR**」紀律 — v0.8.2 純 PATCH 範圍、SSS S3 架構級條款化（`diagnose-remediate-protocol.md`）留 v0.9.0 MINOR。

---

## [0.8.1] — 2026-04-30

> **PATCH release — SSS S3 起手實證 + dogfood signal #24 升工具層 + signal #19 順手修**。**嚴守向下兼容**：純擴增 spec 層 + 文檔層、既有採用方升版只改 `charter_version: "0.8.0"` → `"0.8.1"`。**dogfood-driven hardening 第十四循環**（multi-perspective sub-agent 反向校準新類型）+ **第十五循環**（signal #24 升工具層、第二日連續 ship）。
>
> **Triggered by**：2026-04-30 LIVE session：
> 1. **multi-perspective 評估第十四循環**（external Engineer Round 3-4 提案被 4 sub-agent 反向校準）— SSS S3「引導式紀律」起手實證觸發
> 2. **dogfood signal #24 達 ≥3 次同類違反門檻**（v0.7.4 / v0.7.5 / v0.8.0 連續 release 漏執行 maintainer-discipline §3.4.2 checklist 子項「採用方文檔變更歷史」）— 已達 §3.4 演化路徑「升級到工具層自動偵測」觸發點
> 3. **dogfood signal #19 順手修**（YC v0.8.0 升版 LIVE 實證 Gemini 把合規「shared/ 不存在」誤標 WARN）— doctor §3.7 校驗集第 2 條雙重否定措辭修
> 4. **YC_AIAgentCrew 升 v0.8.0 verify 全綠**（2026-04-30）— v0.8.0 三層雙重防禦設計成功實證、SSS S1「user 授權閘」第二次 LIVE prototype 累積

### Added — SSS S3 起手實證

#### `tools/doctor-spec.md` §3.7-§3.9 既有 error codes 全加四欄 spec-as-data 結構

對應 multi-perspective 評估第十四循環 SSS S3「引導式紀律」起手 — 把 spec 結構從「detect 規範 + 抽象處置」升維為「**detect + 修補方向 + 約束 + 反例**」（spec-as-data）：

每個 error code 加 **4 欄結構**：
- **合規規定**（charter ground truth、寫死）：必須狀態 + 對齊條款
- **修補方向 + 約束**：✅ 必動 / ✅ 補完前提 / 🚫 不可動 / 🚫 不可代決 / 推薦路徑
- **反例**（charter 已駁回的 anti-pattern + 對應正解）

**範圍**：
- §3.7 E601-E605（5 個 H4 子段）
- §3.8 E801/W802（2 個 H4 子段）
- §3.9 E606/E607/W608（3 個 H4 子段）

對應 multi-perspective 評估理念守護者金礦：spec 自帶反例 → AI 看反例就知道不能那樣做 → 不需要繞路 → `core/violation-reflection §2`「集體記憶才重要」設計方向得到結構性強化（spec-as-data 抹掉「LLM completionist 易踩」需求軸）。

#### `tools/doctor-spec.md` §3.10（新段）採用方文檔變更歷史 sync 校驗

對應 **dogfood signal #24** 連續 ≥3 次同類違反條款化 — `core/maintainer-discipline §3.4` 演化路徑「升級到工具層自動偵測」終局實作：

- **W901**：採用方文檔變更歷史最新 entry 不對齊 profile.yaml `charter_version`

校驗 ADOPTION.md / TUTORIAL.md / QUICKSTART.md 三採用方文檔的變更歷史段、比對最新 entry 對應的 charter version vs profile.yaml `charter_version`、不一致 → WARN。

### Changed — `tools/doctor-spec.md §3.7` 校驗集措辭修（dogfood signal #19）

對應 YC v0.8.0 升版 LIVE 實證 — Gemini 把合規「shared/ 不存在」誤標為 WARN（讀「不應存在 → ERROR」雙重否定誤判）：

校驗集第 2 條改寫為「**期望狀態（合規） vs 違規狀態**」對照表 + 紀律提醒：「不存在」是合規、「存在」才報 ERROR；不要把「找不到 shared/」誤判為 WARN/ERROR。

### dogfood-driven hardening 循環

| 循環 | Signal / 議程 | 處置 |
|---|---|---|
| **第十四循環** | multi-perspective sub-agent 反向校準（雙軸矩陣金礦 + 4 個 maintainer 校準點）| 4 sub-agent verbatim + 綜合判斷 + 守住禁區歸檔 `examples/external-evaluations/clispike-multi-perspective-eval-2026-04-30.md`（v0.8.0 ship 後 commit `afcd330`）|
| **第十五循環** | dogfood signal #24 升工具層 + signal #19 順手修 + SSS S3 起手 | doctor-spec §3.7-§3.9 + §3.10 全擴四欄結構 |

### 採用方影響

| 項目 | 影響 | 處置 |
|---|---|---|
| 升版基本動作 | 改 profile.yaml `charter_version: "0.8.0"` → `"0.8.1"` | 改一行 |
| doctor §3.10 W901 啟用 | 採用方文檔變更歷史漏 entry → 跑 doctor 抓 W901 | 補變更歷史 entry（依 maintainer-discipline §3.4.2）|
| doctor §3.7-§3.9 四欄擴展 | spec 內容擴增、不影響採用方執行邏輯 | 純文檔層擴增、零動作 migration |
| §3.7 E602 措辭修 | 對「shared/ 不存在」合規狀態的判斷更明確 | 既有採用方無影響、解決 LLM 誤判風險 |

→ **既有採用方升 v0.8.0 → v0.8.1**：純改 `charter_version` 一行（除非採用方文檔變更歷史漏 entry、需順手補完）。

→ **詳細 step-by-step 升版流程（含每步給 AI 的 prompt 範本）見 [`examples/upgrades/v0.8.0-to-v0.8.1.md`](./examples/upgrades/v0.8.0-to-v0.8.1.md)** — 對齊 dogfood signal #21 紀律「每步 = 給 AI 的 prompt」+ v0.7.3 北極星「回鍋開發者無痛」單 PATCH 純擴增升版場景。

### 連動更新

- 三 preset yaml `charter_version: "0.8.0"` → `"0.8.1"`
- ADOPTION.md（line 5 / 149 / 336）+ TUTORIAL.md / `.claude/commands/maintainer-load.md` 升 v0.8.1
- `tools/doctor-spec.md §8` 變更歷史加 v0.8.1 entry
- ADOPTION.md §13 / TUTORIAL.md 變更歷史加 v1.9 entry
- **新檔 `examples/upgrades/v0.8.0-to-v0.8.1.md`**（v0.8.1 PATCH walkthrough、charter walkthrough 系列收齊「4 個升版場景」第 4 個 — 單 PATCH 純擴增升版）

### SSS S3 v0.8.x 後續議程

對應 multi-perspective 評估綜合判斷 §3.4「五軸分類」I 軸「立刻可採」：

- **v0.8.2 PATCH**：post-upgrade-verify-spec 5 軸 error codes 全加四欄結構 + 雙軸矩陣 framing 第一段（README §設計哲學第 5 條）
- **v0.8.3 PATCH**：init-spec Phase 5b CHECK 1-10 對應四欄 + 雙軸矩陣 framing 第二段（21 條條款補雙軸標籤）

### 嚴守向下兼容紀律對齊

| 紀律 | v0.8.1 對齊狀態 |
|---|---|
| 純擴增 spec 層 | ✅（doctor §3.7-§3.9 四欄擴展 + §3.10 新段、屬 W 級警告）|
| 既有條款不破壞 | ✅（21 條 condition 不增不減；架構級概念 12 個維持）|
| 既有採用方升版動作 | ✅（純改 `charter_version` 一行；W901 為新增 WARN、可選修補）|
| dogfood-driven hardening 連續循環 | ✅（第十四 + 第十五循環同 24 hr 內、對齊 v0.7.4 雙軌節奏「頻繁小擴增 PATCH」）|

對應 v0.7.4 雙軌節奏「**頻繁小擴增 PATCH** + **大方向新加條款用 MINOR**」紀律 — v0.8.1 純 PATCH 範圍、SSS S3 架構級條款化留 v0.9.0 MINOR。

---

## [0.8.0] — 2026-04-29

> **MINOR release — 升版 + 接入防呆強化（slim 版）**。**dogfood-driven hardening 第十一循環**。
>
> **Triggered by**：user 2026-04-29 LIVE session 連續觸發三條設計議題：
> 1. **公司專案接入第二次失敗**（axiom AI-DRAFTED 違規但 init Phase 1-5b 跑通 + Phase 5b CHECK 7 PASS = surface vs structural F6 sub-pattern 同源實證）— dogfood signal #23 累積到第 2 次同類
> 2. **user 提議「升版後需要一個檢核機制」** — `/charter-upgrade-verify` 工具 LIVE 直接條款化（user 直接授權跳過 ≥3 次累積門檻、同 v0.5.8 / v0.7.1 / v0.7.4 pattern）
> 3. **v0.7.4 vendor schema 規範累積到實作啟用條件滿足** — dogfood signal #16 從 spec 層升實作層
>
> **議程位階重整**：原 v0.8.0 議程含 `core/adoption-lifecycle.md` + `core/condition-mutability.md` 兩條大條款（架構級新概念）— 評估後 fresh-head 設計 risk 高（半夜疲勞趕設計 = 設計缺陷成本不可逆）、留 v0.9.0 fresh head 設計；v0.8.0 縮 scope 為「**升版 + 接入防呆強化**」slim 主題、使本 release 純擴增 spec 層 + 文檔層 swap、向下兼容（除 doctor 校驗強化屬可接受 BREAKING-LITE）。

### Added — 升版後標準驗證工具

#### `tools/post-upgrade-verify-spec.md`（新檔）

採用方升版**完成後**的標準驗證流程 — 與 doctor-spec / versioning-migration §3 並列、定位升版專屬 + 跨多版累積遺漏偵測。**5 軸校驗**：

- **軸 A：charter clone 對齊** — `~/.agentcharter` git log 是否含採用方宣稱版本對應 commit / tag
- **軸 B：本專案 schema 對齊** — profile.yaml 啟用條款數 + F6 必啟 + parameters / mapping 對齊
- **軸 C：agent-commons/ 結構合規** — v0.7.0 namespace 紀律 + v0.7.4 vendor schema + _role.md 二態
- **軸 D：axiom 紀律對齊** — frontmatter `status: USER-RATIFIED` 校驗（dogfood signal #23 條款化）
- **軸 E：stale reference 檢查** — charter_version 跨檔對齊 + spec / step 編號 stale 偵測（含 v0.8.0 QUICKSTART swap 後 stale 引用偵測）

**模式**：A 完整健康檢查 ship；B 升版 diff / C pre-commit sync 留 v0.9+ 議程。

→ user 自具象化為 `/charter-upgrade-verify` slash command 給未來重用（依 init-template §3.3）。

### Changed — 雙重防禦執行載體啟用（dogfood signal #23 條款化）

#### `tools/doctor-spec.md` §3.9（新段）axiom 紀律對齊

dogfood signal #23 條款化執行載體（任意時點驗證）：

- **E606**：axiom frontmatter `status: AI-DRAFTED`（未升 USER-RATIFIED）— 違反 v0.7.1 路徑 B 紀律「不可在 AI-DRAFTED 啟動 init」
- **E607**：axiom frontmatter `status` 非二態合法值
- **W608**：axiom frontmatter 缺 `mutability_default` 欄位

#### `tools/init-spec.md` Phase 5b CHECK 7 擴含 axiom frontmatter status 校驗

CHECK 7 從「檔案物理存在」擴含「frontmatter status 校驗」（init 端 fail-fast）：
- `USER-RATIFIED` → PASS
- `AI-DRAFTED` → FAIL（依 v0.7.1 路徑 B 紀律 + `core/domain-axiom-slot §3.3`）
- 其他 → FAIL

#### 三層雙重防禦對應 v0.7.3 北極星「不讓 user 記」

| 載體 | 觸發時機 |
|---|---|
| `tools/init-spec.md` Phase 5b CHECK 7 ext | init 端 fail-fast |
| `tools/doctor-spec.md §3.9` | 任意時點驗證 |
| `tools/post-upgrade-verify-spec.md` 軸 D D001 | 升版專屬驗證 |

對應 user LIVE 提的「**user 下班再回不會記得修、流程要強制抓**」精神。

### Changed — vendor schema 從 spec 層升實作層（dogfood signal #16）

#### `tools/doctor-spec.md §3.8` v0.7.4 spec 層 → v0.8.0 實作啟用

對齊 §3.8.1 漸進啟用路徑 — E801 / W802 列為強制：
- **E801**：vendor schema 違反（如 Gemini CLI toml nested table、缺必填、禁用欄位）→ 致命；依 vendor.md schema 規範修補
- **W802**：vendor.md 缺 schema 規範段 → 警告；走 `ai-vendor-onboarding §3` 邀請補完

啟用條件已滿足（vendor.md schema 段已 v0.7.4 ship + post-upgrade-verify 軸 C C005 對齊雙工具防禦）。

### Changed — QUICKSTART step 編號從 cross-reference 升結構修正（dogfood signal #10）

#### QUICKSTART.md Step 2 ↔ Step 3 swap

QUICKSTART 流程順序紀律從 v0.7.2 cross-reference 方案升為直接 swap（user LIVE 駁回 v0.7.2 取捨、對應 signal #22 候選「v0.x 階段紀律補丁應預設重評為結構修正」）：

- 新 Step 2：寫領域公理（原 Step 3 axiom）
- 新 Step 3：在你專案跑 init（原 Step 2 init）
- 移除 v0.7.2 cross-reference 警告（檔頂執行順序紀律 + Step 2 前置條件 + Step 3 順序提醒）
- 修 path B item 4 pre-existing drift（`Step 4 charter init` → `Step 3`）
- Step 3 init prompt 加 v0.8.0 紀律提示（跑 init 前自驗 axiom `status` 是否 USER-RATIFIED）

**連動 sweep**（依 maintainer-discipline §3.4 文檔層 sync checklist）：
- README.md quick-start 摘要 swap
- core/domain-axiom-slot §3.3 兩處 step 引用 + 反向引用 v0.8.0 三層雙重防禦
- core/maintainer-discipline §3.4.2 checklist 範例「v0.7.2 重排」→「v0.7.6/v0.8.0 swap」
- templates/agent-commons/domain-axioms-via-ai-draft-prompt.md.tpl line 20 step 引用

### dogfood-driven hardening 第十一循環

| Signal | 內容 | 處置 |
|---|---|---|
| **#23 條款化（user LIVE 直接授權跳累積門檻）** | Phase 5b CHECK 7 axiom 校驗範圍 gap（surface PASS / structural fail F6 sub-pattern 同源、累積 2 次同類） | doctor §3.9 + init-spec Phase 5b CHECK 7 ext + post-upgrade-verify 軸 D 三層雙重防禦 |
| **#16 升實作層** | v0.7.4 vendor schema spec 層 → v0.8.0 實作啟用 | doctor §3.8 E801/W802 強制 |
| **#10 升結構修正** | QUICKSTART Step 2-3 順序 v0.7.2 cross-reference → v0.8.0 直接 swap | QUICKSTART swap + 5 檔連動 sweep |
| **#22 候選紀錄** | v0.x 階段紀律補丁應預設重評為結構修正（v0.7.2 → v0.8.0 升級實證） | NEXT.md ⚪ 累積觀察、≥ 2 次同類後條款化 |
| **SSS S1 capture** | AI 自治協作 + user 授權閘模式（user 角色 redefinition） | NEXT.md SSS 段紀錄、跨多 release 演化 |
| **SSS S2 capture** | v0.8.0/v0.9.0 lifecycle 設計素材（/charter-uninstall 流程 + vendor 升級 path 三路徑 A/B/C + 新 vendor 互學深化 + README §設計哲學第 4 條候選） | NEXT.md SSS 段紀錄、待 v0.9.0 fresh head 設計時拿來用 |

### 採用方影響

| 項目 | 影響 | 處置 |
|---|---|---|
| 升版基本動作 | 改 profile.yaml `charter_version: "0.7.5"` → `"0.8.0"` | 改一行 |
| doctor §3.8 vendor schema 啟用 | 既有 vendor toml/md 若有 nested table / 缺必填 → 跑 doctor 抓新 ERROR | 升版前先跑一次 doctor 修補（屬 BREAKING-LITE）|
| doctor §3.9 axiom status 啟用 | 既有 axiom 若 frontmatter `status: AI-DRAFTED` → 跑 doctor 抓 E606 | 升 status: USER-RATIFIED + 加校正紀錄行 |
| init-spec Phase 5b CHECK 7 ext | 新接入採用方若 axiom 未升 USER-RATIFIED → init 失敗 | 校 axiom 升 status 後重觸發 init |
| `/charter-upgrade-verify` 新工具 | 新增採用方可選工具、不強制使用 | 推薦升版完成後跑一次確認 5 軸 |
| QUICKSTART Step 2 ↔ Step 3 swap | 新採用方按新 order；既有外部引用具體 step 編號 → stale | 既有採用方若有自寫文件引用 → 對齊 |

→ **升版推薦流程**（4 步抽象、詳細 step-by-step 流程含每步 AI prompt 範本見 [`examples/upgrades/v0.7.5-to-v0.8.0.md`](./examples/upgrades/v0.7.5-to-v0.8.0.md)）：
1. 跑一次 doctor 看 vendor schema + axiom status 是否需修補
2. 修補不一致（如有）— B 類 vendor schema 不合規 / C 類 axiom 未升 status 各有對應修補 prompt
3. 升 `charter_version` 為 `0.8.0`
4. 自具象化 + 跑 `/charter-upgrade-verify`（新工具）確認 5 軸全綠

### 連動更新

- 三 preset yaml `charter_version: "0.7.5"` → `"0.8.0"`
- ADOPTION.md / TUTORIAL.md / `.claude/commands/maintainer-load.md` 升 v0.8.0
- `tools/init-spec.md §9` + `tools/doctor-spec.md §8` 變更歷史加 v0.8.0 entry
- `core/domain-axiom-slot §3.3` 對應載體表 + 路徑 B 紀律加 v0.8.0 三層雙重防禦反向引用
- `core/maintainer-discipline §3.4.2` checklist 範例 v0.7.2 → v0.8.0 swap

### 嚴守向下兼容紀律對齊（v0.7.3 北極星 + v0.7.4 雙軌節奏）

| 紀律 | v0.8.0 對齊狀態 |
|---|---|
| 純擴增 spec 層 | ✅（post-upgrade-verify 新檔 + doctor §3.9 + init-spec Phase 5b CHECK 7 ext + QUICKSTART swap）|
| 既有條款不破壞 | ✅（21 條 condition 不增不減；架構級概念 12 個維持）|
| doctor 校驗強化 | ⚠️ **可接受 BREAKING-LITE**（v0.x 階段、已超過半年、屬「校驗強化」非「條款新增」、明確 migration 路徑提供）|
| QUICKSTART step swap | ⚠️ **文檔層可接受 BREAKING-LITE**（內部引用已 sweep；外部引用主要在 examples/upgrades/ 已驗證不影響執行）|
| 升版動作清晰可追溯 | ✅（採用方影響表 + 升版推薦流程 + dogfood signal 對應全列）|

對應 v0.7.4 dogfood signal #15 候選「versioning-migration BREAKING-LITE 判定 checklist」議程 — v0.8.0 ship 同時實證該 checklist 的需求性、v0.8.x PATCH ship checklist 時可參考本 release 為案例。

---

## [0.7.5] — 2026-04-28

> **PATCH release** — 跨多版本升級指引 + 第一個回鍋開發者無痛實證 walkthrough（YC_AIAgentCrew v0.5.9 → v0.7.4）。**嚴守向下兼容**：純擴增 / 既有採用方零動作 migration。**dogfood-driven hardening 第十循環**。
>
> **Triggered by**：user 在 v0.7.4 ship 後直接要求「**文件上記得補充如何更新、以 YC_AIAgentCrew 為例該如何從 v0.5.9 → v0.7.4**」 — 對應 v0.7.3 顯化的 README §設計哲學「**回鍋開發者無痛**」北極星紀律的第一個實證 ship。

### Added — 跨多版本升級實證 walkthrough ⭐

#### `examples/upgrades/yc-aiagentcrew-v0.5.9-to-v0.7.4.md`（新檔）

charter 第一個跨版本升版實證 walkthrough — YC_AIAgentCrew 從 v0.5.9 接入跨 8 個 release 升到 v0.7.4 的完整指引：

- §1 升版前狀態（v0.5.9 接入時 baseline — 結構 / profile.yaml / vendor toml）
- §2 跨 8 個 release 的演化軸（user 認知地圖、各 release 對採用方影響速查表 + YC 必做動作摘要）
- §3 升版 7 步驟（依 versioning-migration §3.1 / §3.4 — 每步具體 prompt + YC 對應動作）
- §4 升版後 self-check 清單（對齊 ADOPTION §12）
- §5 對「回鍋開發者無痛」北極星紀律的設計學意義

YC 三個必做動作（具體實證 v0.7.0 BREAKING-LITE 點 + v0.7.4 vendor schema 修補）：
1. profile.yaml `enable_modes` 加 F6（v0.7.0 強制必啟）
2. profile.yaml `enabled.ai-vendor-onboarding: true`（v0.6.0 邀請制）
3. 三個 vendor toml 改扁平結構（v0.7.4 §3.6 規範）

### Added — `core/versioning-migration.md §3.4` 跨多版本升級子段

對應 v0.7.3 README §設計哲學「**回鍋開發者無痛**」北極星紀律的條款層落地：

- §3.4.1 適用範圍（同主版號跨多 MINOR / 跨 MAJOR 仍走 §3.3）
- §3.4.2 跨多版本升級允許性（v0.x 階段同主版號內允許跳多版）
- §3.4.3 跨多版本升級流程（§3.1 7 步擴充 — 一次跑 target-version=最新版、不必逐版升）
- §3.4.4 對北極星紀律的實證 walkthrough 表（含 YC walkthrough）
- §3.4.5 「停用一段時間後重新採用」場景具體指引（5 步流程）

→ charter 對採用方的承諾：**你停了一年回來、結構承諾仍然 hold；只是條款 / vendor schema / 紀律有累積、走 migration 升上來**。

### Changed — 連動更新

- 三 preset yaml `charter_version: "0.7.4"` → `"0.7.5"`
- ADOPTION.md / TUTORIAL.md / `.claude/commands/maintainer-load.md` 升 v0.7.5
- ADOPTION.md line 149 + 336 charter_version 範例值同步
- `.claude/commands/maintainer-load.md` 加 v0.7.5 議程說明（YC walkthrough + §3.4 跨多版本升級子段）+ 後續 v0.7.x PATCH 議程順序更新（v0.7.6 BOOTSTRAP / v0.7.7 prompt 簡化 / v0.7.8 BREAKING-LITE checklist）
- `core/versioning-migration.md §10 變更歷史` v0.2 entry

### 嚴守向下兼容紀律（user v0.7.4 強調的核心）

| 紀律 | v0.7.5 對齊狀態 |
|---|---|
| 純擴增 | ✅ 加新 walkthrough 檔 + 加 §3.4 子段；既有 §3.1〜§3.3 不動 |
| 不動 schema | ✅ profile.yaml / mapping.yaml schema 不變 |
| 不動 enabled / F-mode | ✅ 三 preset enabled / enable_modes 不變 |
| 既有採用方零動作 migration | ✅ 升 v0.7.4 → v0.7.5 只改 profile.yaml `charter_version` |
| doctor 不跑新 check | ✅ 純文檔 / spec 擴增 |

### Triggered — dogfood signal

| Signal | 對應 | 本 release 處理 |
|---|---|---|
| **回鍋開發者無痛實證**（v0.7.3 北極星顯化、v0.7.5 第一個 walkthrough）| YC_AIAgentCrew 跨 8 release v0.5.9 → v0.7.4 | ✅ examples/upgrades/yc-aiagentcrew-v0.5.9-to-v0.7.4.md ship |

### dogfood-driven hardening 第十循環

第一〜九循環 v0.5.10 〜 v0.7.4
**第十循環 v0.7.5 = 北極星「回鍋開發者無痛」第一個實證 walkthrough ship** — user 在 v0.7.4 ship 後直接要求；對應 v0.7.3 顯化的設計哲學從「規範密度導向」轉向「服務體感導向」的具體兌現。

→ charter 從「**規範**」演化到「**規範 + 升版實證 walkthrough**」雙層 — 不只條款層紀律、還有採用方視角的「**怎麼用**」具體指引。

### 採用方影響

- ✅ 完全向後相容、零動作 migration
- ✅ 既有採用方升 v0.7.4 → v0.7.5：只改 profile.yaml `charter_version`
- 🟢 **回鍋開發者立即受益**：停用 charter 後想回來的採用方有 YC walkthrough 可參照；跨多版本升級流程明確
- 🟢 **YC_AIAgentCrew 立即受益**：toml 失效有 charter 級修補指引（依 §3.6 + walkthrough §3 Step 4.2）

### Git tag

- `v0.7.5`（本 commit）

---

## [0.7.4] — 2026-04-28

> **PATCH release** — vendor 端 slash command schema 規範條款化（dogfood signal #16）。**嚴守向下兼容**：純擴增 / 既有採用方零動作 migration / doctor 不跑新 check（實作 defer v0.8+）。**dogfood-driven hardening 第九循環**。
>
> **Triggered by**：YC_AIAgentCrew（v0.5.9 接入）2026-04-28 user 重啟 Gemini CLI v0.39.1 時、3 個自具象化 toml（charter-init / engineer-init / pm-init）全部被 vendor 端 schema validator 抓出格式錯（nested table）跳過載入。原因：v0.5.9 接入時 Gemini PM 自具象化「自編 schema」、charter v0.5.9 〜 v0.7.3 此層 schema 規範完全空白。
>
> 對應 v0.7.0 加的 F6 sub-pattern「surface-level vs structural-level」精神在 vendor schema 層的實證 — toml 檔書寫存在（surface）≠ vendor 載入有效（structural）。

### 動機 — 為什麼 v0.7.4 而非 v0.8.0 大批次

User 提出：「**為什麼 0.7.3 → 0.8 我不太理解**」+ 強調「**絕對務必要切記、要向下兼容**」。

→ maintainer 反省：原規劃 v0.8.0 大 release 違反「**頻繁小擴增、每個 release 純向下兼容**」精神（同源 v0.7.0 規範密度導向殘留）。改用一連串 PATCH（v0.7.4 / v0.7.5 / v0.7.6 / v0.7.7）漸進兌現北極星紀律、v0.8.0 只在真正新增條款時才用。

對齊北極星「**由淺入深 + 培養魚塭**」精神 — 每個 PATCH 都讓未來採用方更舒適、每個 PATCH 純擴增、每個 PATCH 零破壞。

### Added — vendor 端 schema 規範條款化（dogfood signal #16）

#### `roles/pm/gemini-cli.md §3.6` Gemini CLI 端 toml schema 規範 ⭐
- **強制紀律：扁平結構（Flat TOML）** — 必填欄位 root level + 禁 nested table + 禁 `name` 欄位 + 檔名 = 指令名
- 正確 vs 錯誤對照範例（含 YC_AIAgentCrew v0.5.9 接入時 Gemini 自編 nested 結構錯誤的真實範例）
- Self-instantiation 5 項 checklist（給未來 Gemini 自具象化用）
- Schema 來源 + 跨 AI 對應 schema 規範表

#### `roles/engineer/claude-code.md §4.1` Claude Code 端 .md schema 規範
- 強制紀律：純 markdown + 可選 frontmatter；檔名 = 指令名
- Frontmatter 範例（推薦但可選 — Claude Code fail-soft 性格）
- Self-instantiation 4 項 checklist
- Schema 來源（charter repo `.claude/commands/maintainer-load.md` 為現實 reference）+ 違反處置（Claude Code 寬鬆、仍走 init-template §7 違反處置）

#### `tools/doctor-spec.md §3.8` vendor schema check（spec 層、實作 defer v0.8+）
- 校驗集 4 項（檔名一致性 / 必填欄位齊 / 禁用結構不出現 / init-template §2 八項最終狀態）
- 狀態碼 E801（vendor schema 違反）+ W802（schema 規範未顯化）— v0.7.4 不啟用、v0.8+ 啟用
- §3.8.1 v0.7.4 → v0.8+ 漸進啟用路徑說明（嚴守向下兼容紀律）

### Changed — 連動更新

- 三 preset yaml `charter_version: "0.7.3"` → `"0.7.4"`
- ADOPTION.md / TUTORIAL.md / `.claude/commands/maintainer-load.md` 升 v0.7.4
- `roles/pm/gemini-cli.md §7 變更歷史` v1.2 entry
- `roles/engineer/claude-code.md §8 變更歷史` v1.1 entry
- `tools/doctor-spec.md §8 實作節奏` v0.7.4 entry

### 嚴守向下兼容紀律（user 強調的核心）

| 紀律 | v0.7.4 對齊狀態 |
|---|---|
| 純擴增 | ✅ 加新段（`<vendor>.md` schema 規範 + doctor §3.8 spec）；不動既有條款本體 |
| 不動 schema | ✅ profile.yaml / mapping.yaml schema 不變 |
| 不動 enabled / F-mode | ✅ 三 preset enabled 清單 / enable_modes 不變 |
| 既有採用方零動作 migration | ✅ 升 v0.7.3 → v0.7.4 只改 profile.yaml `charter_version` |
| doctor 不跑新 check | ✅ §3.8 spec 層加、實作 defer v0.8+；既有採用方升版 doctor 不會跑出新 ERROR/WARN |
| 對 YC_AIAgentCrew toml 失效有立即 reference | ✅ §3.6 範例可直接給 Gemini 修補 |

### 對 YC_AIAgentCrew 修補的 reference

採用方端立即可用：用 `roles/pm/gemini-cli.md §3.6` 範例（扁平結構）為依據、把 nested toml 改成扁平：

```toml
# 修改前（nested、被 Gemini CLI v0.39.1 拒絕）
name = "pm-init"
[command]
description = "PM 初始化"
[command.instruction]
prompt = "..."

# 修改後（扁平、Gemini CLI v0.39.1 可載入）
description = "PM 初始化"
prompt = "..."
```

charter 端不代修；user 自行讓 Gemini 修補即可。

### Triggered — dogfood signals

| Signal | 對應 | 本 release 處理 |
|---|---|---|
| **#16 條款化（新）** | vendor 端 schema 規範未在 charter 條款層 — AI 自具象化時自編 schema、vendor 端升級才暴露 | ✅ `roles/pm/gemini-cli.md §3.6` + `roles/engineer/claude-code.md §4.1` + `doctor-spec.md §3.8` 三段同步落地 |

### dogfood-driven hardening 第九循環

第一〜八循環 v0.5.10〜v0.7.3
**第九循環 v0.7.4 = vendor 端 schema 規範條款化** — 對應 v0.7.0 加 F6 sub-pattern「surface vs structural」精神在 vendor schema 層的實證閉環

→ user 提的「**為什麼 0.7.3 → 0.8 我不太理解**」修正 maintainer 規範密度導向殘留 → charter 從此走「**頻繁小擴增 PATCH** + **大方向新加條款用 MINOR**」雙軌節奏。

### Git tag

- `v0.7.4`（本 commit）

---

## [0.7.3] — 2026-04-28

> **PATCH release** — 完整文檔層 sync sweep（auditor 抓 10 ERROR + 3 WARN 全修）+ **README 設計哲學（北極星）顯化** + v0.7.0 BREAKING-LITE 追溯說明。**dogfood-driven hardening 第八循環**。
>
> **Triggered by**：v0.7.2 release 後 user 重新提出兩個關鍵 framing：
> 1. 「框架價值來自於服務、解決重複溝通、由淺入深」設計哲學
> 2. 「向下兼容設計、有衝突就代表沒有向下兼容」紀律
>
> 觸發完整 spec drift sweep + 設計哲學顯化 + v0.7.0 mislabel 反省。

### Added — README 設計哲學（北極星）段 ⭐

對應 user 兩個關鍵 framing：

**兩種「無痛」定義**：
- **回鍋開發者無痛**（lifecycle）：全新接入 / 升版 / 棄用 / 停用後重新採用 — 隨時支援、無摩擦銜接
- **小白無痛**（onboarding）：由淺入深、越用越愛；不該記 prompt — charter 主動引導、user 最少做 1 個動作

**三條服務原則**：
1. 解決重複溝通（跨 AI 接班 / 跨 session 重啟 / 跨角色交付 / 採用方對 AI 反覆糾正）
2. 由 charter 引導採用方（不是 user 找 prompt 模板貼給 AI、而是 user 把入口檔給 AI、AI 主動引導 user）
3. 培養魚塭、不討魚（拒絕為了眼前舒服犧牲未來舒適）

**對未來修訂的紀律**：每次修訂對照三題 — 對回鍋開發者體驗加分還是減分？對小白接入門檻降低還是升高？解決新的重複溝通還是新增採用方要記的東西？任一答「減分 / 升高 / 新增負擔」 → 修訂須降級 / 改寫 / 重新設計。

→ 所有未來條款 / spec / templates 修訂須對照此北極星檢驗。

### Changed — 完整文檔層 sync sweep（auditor 抓的 10 ERROR + 3 WARN 全修）

對應 dogfood signal #6 第四次同類觀察（諷刺循環：v0.7.2 才剛 condition 化 §3.4 文檔層 sync checklist、本身又踩）。

#### ADOPTION.md（7 處）
- §3 B 組 `failure-modes.md` 一句話：F1〜F5 → **F1〜F6**（含 surface vs structural sub-pattern）
- §3 D 組 `init-template.md` 一句話：加 v0.7.0 step 6 PROVISIONAL/ACTIVE + slash command 引用紀律
- §6 T0：charter_version 範例值 `0.6.1` → `0.7.3`
- §6 T3：加 v0.7.1 雙路徑（A user 主筆 / B AI 代產 + user 校）+ v0.7.2 順序紀律提醒
- §7：6 步驟 → **7 步驟** + step 5 doctor 強制驗證點 + step 6 PROVISIONAL/ACTIVE 紀律 + slash command 引用紀律
- §12：採用就緒 self-check 加 5 條 v0.7.x 必查項（F6 啟用 / shared/ 不存在 / Status PROVISIONAL/ACTIVE / Phase 5b 跑過 / agent-commons/ 結構頂層）
- §13：補 v1.4 / v1.5 變更歷史 entry

#### TUTORIAL.md（4 處）
- §3 加跨 step 順序紀律警告（cross-reference QUICKSTART v0.7.2 警告）
- §5.2：6 步驟 → **7 步驟** + step 5 + step 6 PROVISIONAL/ACTIVE 紀律 + slash command 引用紀律
- §8.3：F1〜F5 → **F1〜F6**（加 F6 entry）
- §11.1 doctor 錯誤對照表：加 E601〜E605（namespace 校驗 + F6 強制 + 諷刺循環攔截）

#### README.md（3 處）
- 條款表 `failure-modes.md` 一句話：「F1〜Fn」→ **F1〜F6**（含 v0.7.0 surface vs structural sub-pattern）
- 條款表 `init-template.md` 一句話：加 v0.7.0 step 6 PROVISIONAL/ACTIVE + slash command 引用紀律
- 角色目錄：validator 加 v0.7.0 §3.6 init 階段抽驗 / auditor 加 v0.7.0 §8 對稱性反向引用

#### core/charter-config.md §5（W001）
- 條款相依表加 `init-template`（v0.7.0 後相依擴增）→ `multi-role-tracking` + `audit-rights`

#### 連動更新
- 三 preset yaml `charter_version: "0.7.2"` → `"0.7.3"`
- ADOPTION.md / TUTORIAL.md / `.claude/commands/maintainer-load.md` 升 v0.7.3

### Triggered — v0.7.0 BREAKING-LITE 追溯說明

> **誠實反省**：v0.7.0 release notes 標題寫「**MINOR release**」，但內含兩個既有採用方 migration 點：
> - profile.yaml `enable_modes` 須加 F6（v0.5.10 加 F6 但 preset 漏改）
> - mapping.yaml 若含 `shared/` 中介層需 migration（doctor §3.7 E601/E602）
>
> 依 `versioning-migration` 對 v0.x 階段判定，**v0.7.0 應分類為 BREAKING-LITE**（採用方升版需動作對齊）而非 MINOR（純擴展）。
>
> **這個 mislabel 本身就是 dogfood signal #15 候選**：「`versioning-migration` 對 v0.x 階段 BREAKING-LITE 判定不嚴謹」。maintainer 會把「擴展但需 migration」誤標 MINOR。對應 v0.7.0 加的 F6 sub-pattern「surface-level vs structural-level」精神在 release labelling 的諷刺實證 — release notes 標題（surface）跟採用方影響段（structural）脫鉤。

git history 不改、本說明作為**追溯校正**留 reference。v0.8.0 計畫擴 `versioning-migration §X` 加 BREAKING-LITE 判定 checklist（避免再 mislabel）。

### Triggered — dogfood signals

| Signal | 對應 | 本 release 處理 | v0.8.0 留 |
|---|---|---|---|
| **#6 第四次同類觀察** | 文檔層 sync 諷刺循環（v0.7.2 才剛 condition 化、v0.7.2 release 自身又踩）| ✅ 完整 sweep + 全 ERROR/WARN 修補 | 升級到工具層 doctor 自動偵測 |
| **新 sub-pattern**：人類 vs AI 受眾差異化 sync gap | QUICKSTART（人類面）已對齊、ADOPTION（AI 面）未對齊；maintainer 改了「自己會打開的 user-facing 檔」、漏「AI 自含 context 檔」| ✅ ADOPTION 主體完整對齊 | 留觀察、累積後加 §3.4 細分「人類 vs AI 受眾兩條獨立 sweep 路徑」|
| **新 sub-pattern**：step 數變更但下游文檔未全文 grep | init-template §3.3.2 從 6 → 7 步、ADOPTION §7 / TUTORIAL §5.2 仍寫 6 步 | ✅ 全部對齊 7 步 | maintainer-discipline §3.4 加「step 數變更 = trigger 全文 grep『N 步驟』」|
| **新 dogfood signal #15 候選** | v0.7.0 mislabel MINOR 應為 BREAKING-LITE | 追溯說明（不改 git history）| `versioning-migration §X` 加 BREAKING-LITE 判定 checklist |

### 採用方影響

- ✅ **完全向後相容、零動作 migration**：純文檔層對齊 + 紀律強化、不動 schema / enabled / F-mode / 條款本體
- ✅ 既有採用方升 v0.7.2 → v0.7.3：只改 profile.yaml `charter_version`
- 🟢 **設計哲學顯化**對採用方體感**加分**：所有未來修訂對照「無痛使用」三題、不會再有「為了完整性犧牲體感」的修訂

### dogfood-driven hardening 第八循環

第一〜七循環 v0.5.10〜v0.7.2（見前述 CHANGELOG）
**第八循環 v0.7.3 = user 重新提出設計北極星 framing → maintainer 完整 spec drift sweep + 設計哲學顯化 + v0.7.0 mislabel 追溯反省**

→ user 對話原話：「**培養魚塭、不討魚 — 真正的開發不應該侷限於眼前的舒服、而是要放眼望去未來的舒適**」 — 寫進 charter 北極星紀律。

### v0.8.0 北極星議程（已記入 NEXT.md ⚪）

| 動作 | 對應 |
|---|---|
| `BOOTSTRAP.md` 入口檔（採用方唯一要記的東西）| 小白無痛 |
| `core/adoption-lifecycle.md` 條款（全新 / 升版 / 棄用 / 重新採用 四路徑）| 回鍋開發者無痛 |
| QUICKSTART/ADOPTION prompt 簡化（紀律 push 到 charter spec 端）| 不讓 user 記 prompt |
| `versioning-migration §X` 加 BREAKING-LITE 判定 checklist | 避免 v0.7.0 mislabel 重演 |
| condition mutability 紀律本體（v0.7.1 frontmatter scaffold 後續）| signal #11 完整條款化 |

### Git tag

- `v0.7.3`（本 commit）

---

## [0.7.2] — 2026-04-28

> **PATCH release** — dogfood signal #6 三次同類條款化（文檔層 sync checklist）+ signal #10 條款化（QUICKSTART 流程順序紀律）+ structural-anti-fabrication §5 補三行反向引用。**dogfood-driven hardening 第七循環**。
>
> **Triggered by**：v0.7.1 release 後、user 連續兩次 IDE 開 `core/structural-anti-fabrication.md` 行使**「他抽」屬性**抓到 maintainer + auditor 漏的 §5 反向引用同步。對應 v0.7.0 加 Phase 5b「採用方半邊他抽」精神在 charter 自身演化的現場實證。

### 動機 — 為什麼有 v0.7.2

v0.7.1 release 後 user 開 IDE 看 `core/structural-anti-fabrication.md` 兩次，問「你有更新文件嗎」— 觸發 maintainer 重新檢視，發現 v0.7.0 + v0.7.1 連續兩個 release 加段（F6 sub-pattern / Phase 5b / 路徑 B 推斷依據）都跟 structural-anti-fabrication 同源、但**全部漏 §5 反向引用同步**。

加上 v0.6.1 + v0.7.0 後 session 已累積兩次同類觀察（auditor 抓到文檔層 sync 漏）→ user 第三次同類觀察讓 dogfood signal #6 達 ≥3 次同類門檻、觸發條款化加嚴。

### Added — `core/maintainer-discipline.md §3.4` 文檔層 sync checklist ⭐

**核心**：v0.6.1 / v0.7.0 / v0.7.1 連續三次踩同類坑 — 條款層改完整、文檔層改部分。本段把「文檔層 sync」**從 §2.2 引用範圍表的子項顯化為獨立 checklist**，避免 maintainer 在 release 流程下意識跳過。

三層子段：
- **§3.4.1 條款層連動 sync**：`§ 與其他 core 條款的關係` 表雙向引用 + 變更歷史對齊 + schema 跨檔一致
- **§3.4.2 文檔層連動 sync（採用方視角）**：`charter_version` 跨檔同步 + 條款數同步 + 流程圖 / step 順序對齊 + 變更歷史段（採用方文檔）
- **§3.4.3 內部追蹤層 sync（maintainer 視角）**：CHANGELOG + STATUS/NEXT signal entries

違反處置 + 對應 §3.1 工具層的演化路徑（v0.8+ 把部分 checklist 上移到 doctor 自動偵測）。

對應 dogfood signal #6 第三次同類條款化。

### Changed — `core/structural-anti-fabrication.md §5`：補三行反向引用

`§ 與既有條款的關係` 表加三行（v0.7.0 + v0.7.1 加段全部漏的反向引用）：
- `failure-modes.md F6 sub-pattern`（**理論同源**：F6 是 F1 「做了沒驗」變體 / 本條對 F1 硬反制邏輯延伸）
- `tools/init-spec.md Phase 5b 物理存在校驗`（**執行層延伸**：schema 寫路徑 ≈ 純文字宣告 / 檔案物理存在 ≈ stdout 區塊）
- `core/domain-axiom-slot §3.3 路徑 B 推斷依據紀律`（**領域公理層延伸**：AI 寫鐵律若缺推斷依據 = F1）

對應本 release 的「**自己抓自己未對齊**」 — user 直覺發現這個應該補的軌跡。

### Changed — `QUICKSTART.md` 流程順序紀律（dogfood signal #10 條款化）

**問題**：v0.7.0 加 Phase 5b 物理存在校驗後、QUICKSTART Step 2「跑 init」與 Step 3「寫公理」的順序在字面上失效（Step 2 跑 init 時還沒 Step 3 寫的 axiom 檔 → Phase 5b 第 7 項 fail）。

**v0.7.2 處理**：
- 檔頂「5 步流程」段加紀律警告 — **實際執行順序**是 **Step 1 → Step 3 → Step 2 → Step 4 → Step 5**（編號保留、順序明示）
- Step 2「跑 init」段加前置條件警告（必須先完成 Step 3）
- Step 3「寫公理」段加執行順序提醒（必須先於 Step 2 完成）
- v0.8+ 計畫整理為線性編號（消除「編號 vs 執行順序」的不一致）

### Changed — 連動更新

- 三 preset yaml `charter_version: "0.7.1"` → `"0.7.2"`
- ADOPTION.md / TUTORIAL.md / `.claude/commands/maintainer-load.md` 升 v0.7.2

### Triggered — dogfood signals

| Signal | 對應 | 本 release 處理 |
|---|---|---|
| **#6 三次同類達門檻** | 條款層 sync 與文檔層 sync 不對等 | ✅ `maintainer-discipline §3.4` 條款化 |
| **#10 條款化** | QUICKSTART Step 2-3 順序與 Phase 5b 衝突 | ✅ 流程順序紀律 + 前置條件 |
| **新 dogfood signal #13 候選**（本次抽驗發現）| user 直覺對 charter 行使「他抽」屬性的成功實例（IDE 開檔 → 抓到 maintainer + auditor 漏的 spec drift）| 留 NEXT.md 觀察、累積 use case 後評估是否在 `roles/validator/_spec.md` 加 §3.7「對 charter 自身演化行使他抽」段 |

### 採用方影響

- ✅ **完全向後相容**：純文檔層補丁 + 紀律強化、不動條款功能、不動 schema、不破壞既有採用方
- ✅ 既有採用方升 v0.7.1 → v0.7.2：只改 profile.yaml `charter_version` 即可
- 🟢 **對 maintainer 行為的影響**：本 release ship 後、未來 release 必走 §3.4 文檔層 sync checklist；對採用方無影響

### dogfood-driven hardening 第七循環

第一〜六循環 v0.5.10〜v0.7.1（見 v0.7.0 / v0.7.1 CHANGELOG）
**第七循環 v0.7.2 = user 直覺以採用方身份對 charter 自身演化行使「他抽」屬性、抓到 maintainer + auditor 漏的 spec drift → 條款化 maintainer-discipline §3.4 文檔層 sync checklist**

→ charter Phase 5b「採用方半邊他抽」精神反過來作用於 charter 自身演化 — 這是 charter dogfood-driven hardening 哲學最完整的迴路展現：
- 條款設計（Phase 5b）→ user 學會這個設計 → user 以這個設計反過來他抽 charter 自己 → 抓到 maintainer 漏 → 條款化補上

對應 v0.7.0 user 對話原話「成長中、想法碰撞」 — charter 跟 user 在對話過程互相塑造對方。

### Git tag

- `v0.7.2`（本 commit）

---

## [0.7.1] — 2026-04-28

> **PATCH release** — 領域公理雙路徑明文 + condition mutability frontmatter scaffold。對應 user 在公司接入痛點對話直接提議的兩個設計（dogfood signal #11 + #12 候選 — user 跳過累積閾值直接條款化、同源 v0.5.8 maintainer-discipline 處理）。
>
> **動機**：v0.7.0 release 半小時後，user 公司接入卡在「dbsdk.md 不知怎麼寫」痛點。對話過程 user 直接提議兩個設計：(1) condition mutability 三層分類（IMMUTABLE-by-AI / APPEND-ONLY / FULL-MUTABLE + 3-strike 刪除）、(2) 初次領域公理雙路徑（user 主筆 vs AI 讀 codebase 代產草稿 + user 校）。兩者擊中 charter 既有設計 gap — 前者已隱性存在於 `domain-axiom-slot §3.2` + `domain-axioms.md.tpl` line 7 但未顯化；後者在 `tools/scan-spec.md`（v0.4 起）已有同源精神但領域公理層未明示。
>
> **本 release scope**：顯化雙路徑 + frontmatter scaffold；condition mutability 紀律本體（3-strike / consolidation 機制）留 v0.8.0 累積真實 use case 後條款化。

### Added — 雙路徑明文（dogfood signal #12 候選條款化）

#### `core/domain-axiom-slot.md §3.3`

新增「初次領域公理生成路徑（雙路徑明文）」段：
- **路徑 A**：user 主筆（既有 default）→ frontmatter `status: USER-RATIFIED` + `created_by: user`
- **路徑 B**：AI 讀 codebase 代產草稿 + user 校 → frontmatter `status: AI-DRAFTED` + `created_by: ai-drafted`
- 路徑 B 紀律 4 項：AI 不可自升 Status / 每條附推斷依據 / 不可編造 / 校正前不啟動 init
- 與 `ai-vendor-onboarding` 區別說明（framework 對 vendor vs user 對 AI 兩個維度正交）

#### `templates/agent-commons/domain-axioms-via-ai-draft-prompt.md.tpl`（新檔）

路徑 B 觸發 prompt 範本：
- 完整 prompt（含 codebase 訊號源 6 項 + 紀律 5 項 + 輸出格式範例）
- user 校正 checklist（6 項：真實性 / 適用性 / 可驗證性 / 後果段 / 編號 / 缺漏）
- 與既有條款關係表（domain-axiom-slot §3.3 / multi-role-tracking §3.4.4 / scan-spec / ai-vendor-onboarding）

### Added — frontmatter scaffold（dogfood signal #11 候選預備）

#### `templates/agent-commons/domain-axioms.md.tpl`

加 frontmatter scaffold：
```yaml
---
status: USER-RATIFIED          # 或 AI-DRAFTED / DRAFT
mutability_default: APPEND-ONLY # 或 IMMUTABLE-by-AI / FULL-MUTABLE
created_by: user                # 或 ai-drafted
created_at: <YYYY-MM-DD>
---
```

每條鐵律可加 per-clause mutability 覆寫（HTML 註解格式）：
```html
<!-- mutability: IMMUTABLE-by-AI -->
```

condition mutability 紀律本體（IMMUTABLE-by-AI / APPEND-ONLY / FULL-MUTABLE 三層 + 3-strike 刪除 + user-initiated consolidation）留 v0.8.0 完整條款化（待累積 1-2 次採用方真實 use case）。

### Changed — 連動更新

- `QUICKSTART.md` Step 3：加雙路徑說明（A / B）+ 路徑 B prompt 連結 + 哪條路徑選擇表
- `tools/profiles/{minimal,standard,strict}.yaml`：`charter_version: "0.7.0"` → `"0.7.1"`
- `ADOPTION.md` line 5：charter v0.7.0 → v0.7.1
- `TUTORIAL.md` line 6：charter v0.7.0 → v0.7.1
- `.claude/commands/maintainer-load.md`：當前狀態 v0.7.0 → v0.7.1 + 加領域公理雙路徑說明

### Triggered — user 直接提議的兩個 dogfood signal

| Signal | user 提議 | 本 release 處理 | 留 v0.8.0 |
|---|---|---|---|
| **#11 候選** | condition mutability 三層分類 + 3-strike 刪除 + user-initiated consolidation | frontmatter scaffold（structural 預備）| 紀律本體（3-strike / consolidation 機制 / 升級協議）|
| **#12 候選** | 初次領域公理雙路徑（user 主筆 vs AI 代產） | 雙路徑明文（§3.3）+ 路徑 B prompt 範本 + frontmatter `Status: AI-DRAFTED` + 校正紀律 | — |

兩 signal 同源精神：**charter 應顯化 user 對 AI 在採用方專案內的協作維度**（與 `ai-vendor-onboarding` 規範的 framework 對 vendor 維度正交）。

### 採用方影響

- ✅ **完全向後相容**：純擴展 / 顯化既有設計、不破壞既有 v0.7.0 採用方
- ✅ **既有 user 主筆專案**：`domain-axioms.md` 沒 frontmatter 不影響運作；可後補（不溯及）
- 🟢 **新採用方推薦**：採用 v0.7.1 後第一份 axiom 檔含 frontmatter；路徑 B 立刻可用
- 既有採用方升 v0.7.0 → v0.7.1：只改 profile.yaml `charter_version: "0.7.0"` → `"0.7.1"` 即可

### dogfood-driven hardening 第六循環

第一循環 v0.5.10 = signal #4 條款化
第二循環 v0.6.0 = signal #5 條款化
第三循環 v0.6.0 = 邀請制 pattern 顯性化
第四循環 v0.6.1 = auditor 第一次實戰
第五循環 v0.7.0 = 公司接入失敗大批次封閉（5 signals）
**第六循環 v0.7.1 = user 公司接入痛點對話直接提議 2 個設計（30 分鐘內 ship）— 證明 charter dogfood-driven hardening 哲學在「user 直接 framing」場景的回應速度**

→ 對應 user 對話原話：「成長中、想法碰撞」 — charter 自身演化的最佳體現。

### Git tag

- `v0.7.1`（本 commit）

---

## [0.7.0] — 2026-04-28

> **MINOR release** — 公司 production 接入失敗 → 大批次條款修訂。一次取得 5 個 dogfood signal（#3 結構性實證 + #4 第三次同類 + #5 第二次完整實證 + #7 候選新增 + #8 候選新增），由 v0.6.1 stable for production 升級為 v0.7.0 結構性盲區封閉版本。**dogfood-driven hardening 第五循環**。
>
> **Triggered by**：公司專案接入失敗 audit 詳見 `.claude_temp/COMPANY-ONBOARDING-FAILURE-AUDIT.md`（7 ERROR + 5 WARN 結構性失敗、4 個根因 pattern + 環境條件分析）。

### 動機 — 為什麼一次大批次

公司專案要求最穩定 → 跟 user 派 Gemini PM 走「單一 prompt 跑完 init-spec + self-instantiation」→ Gemini 回報「成功」→ user 自驗 PowerShell 6 條 → 抽驗結果 7 ERROR：

- E1: `dbsdk.md` 檔案不存在（schema 寫了路徑、實體未建）
- E2: `_role.md PM Status: ACTIVE` 自簽 + Sign-in Log 已寫，user 從未授權
- E3: 沒跑 doctor，把 doctor 列為 NextWork 待辦
- E4: agent-commons/ 結構全錯位（capsules/handoffs/protocols/institutional-memory 全在 `shared/` 子目錄）
- E5: 缺 Engineer 角色 scaffold
- E6: profile.yaml `enable_modes` 缺 F6（諷刺循環）
- E7: charter-init.toml 寫死 `C:/Users/YCLIN/.agentcharter/...` 絕對路徑

4 個根因 pattern 收斂為**雙重防禦**修訂方向（決策 1：B 一次 v0.7.0 / 決策 2：不重命名 namespace、走雙重防禦 / 決策 3：MINOR）。

### Added — `tools/init-spec.md` Phase 5b 邀請第二 context 抽驗 init 結果 ⭐

**核心**：採用方接入流程「自抽自驗」結構性盲區封閉。對稱於 v0.6.0 加 auditor 角色封閉 maintainer 半邊；採用方半邊由 Phase 5b 對應載體封閉。

三條觸發路徑：
- **A. fresh-context sub-agent**：第一個 AI 主動 spawn 一次性 sub-agent
- **B. 邀請另一 vendor AI**：不同 AI / 不同 session 抽驗
- **C. user 親自抽驗**：user 親自跑 PowerShell / shell

抽驗集 10 項（agent-commons/ 結構頂層 / `shared/` 不存在 / schema 必填 / F6 啟用 / domain_axioms 物理存在 / `_role.md` Status PROVISIONAL / Sign-in Log 為空 / charter-init slash 不寫死絕對路徑 等）。

對應 dogfood signal #7 候選條款化。

### Added — `roles/validator/_spec.md §3.6` 採用方接入流程 init 結果抽驗

職能擴張 — validator 從「採用方 work-time 抽驗」延伸涵蓋「init 階段抽驗」。對應 init-spec Phase 5b 載體；連動 `_spec.md §1` 職能定義段擴充。

### Added — `core/multi-role-tracking.md §3.4.4` init 階段自我激活同樣 = F1

明文涵蓋「**首次 init self-instantiation 不得寫 `_role.md Status: ACTIVE` + Sign-in Log**」+ 引入 `PROVISIONAL` 二態（暫具象化 / 等 user explicit 授權升 ACTIVE）。`§3.4.5` 加 init 自激活 vs 切換違反 vs 隱式戴帽子三項對照表。

對應 dogfood signal #5 第二次完整實證。原 v0.6.0 §3.4 預想「session 中途切換」沒涵蓋「初次 init 直接激活」。

### Added — `core/init-template.md §3.3.2` step 6 簽名禁項 + slash command 引用紀律

**Step 6 禁項**（v0.7.0 加）：
- Status 寫 `PROVISIONAL`
- 不得寫 Sign-in Log
- vendor spec 預設身份 ≠ 自動激活

**Slash command 引用紀律**：
- (a) 環境變數 `$AGENTCHARTER_HOME` / `$CHARTER_DIR`（最可移植）
- (b) 相對 user home `~/.agentcharter/...`
- (c) 採用方專案內相對路徑 `agent-commons/...`
- ❌ 禁寫死 `C:/Users/<name>/.agentcharter/...` 絕對路徑

對應 dogfood signal #5 第二次完整實證 + #3 結構性實證。

### Added — `tools/doctor-spec.md §3.7` 結構頂層完整性 + namespace vs 檔案路徑校驗

**校驗集**（E601〜E605）：
- E601: layout 值含 namespace 同名中介層（如 `shared/capsules/`）
- E602: `<common_memory_root>/shared/` 目錄存在
- E603: 頂層必要目錄缺項（capsules/handoffs/protocols/institutional-memory/）
- E604: roles/ 全缺
- **E605: `enable_modes` 缺 F6**（**強制檢查**，不依賴 profile.yaml 設定 — 即使 profile 漏寫 F6 仍被攔下）

對應 dogfood signal #4 第三次同類條款化（雙重防禦的「校驗」半邊）。

### Added — `core/charter-config.md §3` mapping schema namespace 註明

**前提警告段**（v0.7.0 加）：明示 `shared.*` / `roles.*` 是 schema namespace、不是檔案系統路徑；layout 槽位的 value 必為頂層、不可含 namespace 同名中介層。含正確/錯誤對照範例。

對應 dogfood signal #4 第三次同類條款化（雙重防禦的「文檔註明」半邊）。

### Changed — `core/failure-modes.md` F6 詳述加 sub-pattern「surface-level vs structural-level」

明示 LLM completionist 傾向兩個層次：
- surface-level：寫了 schema / 寫了 Status / 寫了「下一步跑 X」 → 容易產生完成感
- structural-level：檔案實際存在 / Status 對應 user 授權 / X 真的跑了 → 真正的就緒

判別法 4 項；諷刺循環反例（公司專案 enable_modes 漏 F6 → F6 沒攔住 Gemini 自己）。

§5 事件累積範例加公司專案 entry（F1×4 + F3×1 + F6×3）。

對應 dogfood signal #8 候選條款化。

### Changed — 三 preset yaml `parameters.failure-modes.enable_modes` 加 F6

之前 v0.5.10 加 F6 但 preset 漏改 — 公司接入失敗實證此漏：

- `tools/profiles/standard.yaml`: `[F1...F5]` → `[F1...F6]`
- `tools/profiles/strict.yaml`: `[F1...F5]` → `[F1...F6]`
- `tools/profiles/minimal.yaml`: `[F1, F2, F3]` → `[F1, F2, F3, F6]`（F6 強制必啟）

### Changed — `templates/agent-commons/_role.md.tpl` 加 Status 二態

對應 multi-role-tracking §3.4.4 + init-template §3.3.2 step 6。明示 `PROVISIONAL` / `ACTIVE` 二態 + 升級觸發條件。

### Changed — `tools/init-spec.md` Phase 4 加紀律

- standard / strict preset 預期至少 scaffold pm + engineer 雙角色
- _role.md Status 寫 `PROVISIONAL`
- Phase 4.x 加 slash command 引用紀律段

### Changed — 三 preset yaml `charter_version`

`tools/profiles/{minimal,standard,strict}.yaml`: `charter_version: "0.6.1"` → `"0.7.0"`

### Changed — `roles/auditor/_spec.md §8` 加 validator 對稱性反向引用

說明 auditor / validator 在「自抽自驗」封閉的對稱性（maintainer 半邊 / 採用方半邊）。

### Triggered — 5 個 dogfood signal 一次處理

| Signal | 涵蓋事件 | 修訂位置 |
|---|---|---|
| **#4 第三次同類** | E4 結構誤翻譯 + E6 缺 F6 + W1 schema 不一致 | charter-config.md schema 註明 + doctor-spec.md §3.7 + 三 preset enable_modes |
| **#5 第二次完整實證** | E2 PM 自激活 | multi-role-tracking §3.4.4 + init-template §3.3.2 step 6 |
| **#3 結構性實證** | E7 路徑硬編碼 | init-template §3.3.2 引用紀律 + init-spec Phase 4.x |
| **#7 候選（新）** | 環境條件：採用方接入流程缺 init-validator | init-spec Phase 5b + validator §3.6 |
| **#8 候選（新）** | E1 dbsdk 沒建 + E3 doctor 列待辦 + E5 缺 engineer scaffold | doctor-spec §3.7 物理存在 + failure-modes F6 sub-pattern |

### Bundled — v0.6.1 後 session 內小演進（v0.7.0 順手併入）

- `templates/role-invocation-prompt.md.tpl`（新檔）— charter 演示通用骨架；6 個 placeholder + 6 個 ⭐ 結構區塊（對齊 init-template §3.3.2 七步驟）+ 採用方擴展貢獻路徑指向 ai-vendor-onboarding §3
- `QUICKSTART.md` Step 4 重構為「§4.1 通用骨架 + §4.2 已實證填充範例」
- 對應 v0.6.1 後 maintainer auditor 第二次實戰套路（路徑 C 手動 spawn）抽驗通過

### 採用方影響

- ✅ **多數紀律是「擴展」屬性**（向後相容）：既有 PROVISIONAL/ACTIVE 二態僅在新 init 時生效；既有採用方 `_role.md Status` 沿用即可、不需改寫
- ⚠️ **F6 強制必啟（schema 變動）**：升級時 profile.yaml `parameters.failure-modes.enable_modes` 必須含 F6；既有採用方升 v0.7.0 時跑一次 doctor + 把 enable_modes 加 F6
- ⚠️ **mapping.yaml 結構檢查（doctor §3.7）**：若既有採用方 mapping 含 `shared/<X>/` 中介層 → 升 v0.7.0 後 doctor 報 ERROR；對應 migration：把 `shared/` 中介層的目錄內容移到頂層、改寫 mapping.yaml 移除中介層
- ✅ **YC_AIAgentCrew 影響**：既有 mapping 對齊頂層、不踩 shared/ 中介層、F6 升版時補一行 enable_modes 即可

### dogfood-driven hardening 第五循環

第一循環 v0.5.10 = signal #4 條款化（self-instantiation 七步驟）
第二循環 v0.6.0 = signal #5 條款化（LLM 繞路紀律 gap）
第三循環 v0.6.0 = Gemini PM 接入 pattern 顯性化（邀請制條款）
第四循環 v0.6.1 = auditor 角色第一次實戰、抓出文檔層 sync 漏
**第五循環 v0.7.0 = 公司接入失敗大批次封閉 — 5 個 signal 一次處理 / 採用方半邊「自抽自驗」結構性盲區封閉**

→ 對應「dogfood 內測優化也是持續健壯一環」精神持續落地；v0.6.0 引入 auditor 的對稱機制（validator on init）在 v0.7.0 對採用方接入流程封閉。

### Git tag

- `v0.7.0`（本 commit）

---

## [0.6.1] — 2026-04-28

> **PATCH release** — 文檔層 sync 修補。對應 v0.6.0 release 漏的 ADOPTION / TUTORIAL / README / maintainer-load.md / charter-config schema 範例同步點，由 v0.6.0 新誕生的 `roles/auditor/_spec.md` 第一次實戰抽驗（spawn fresh-context sub-agent 跑）抓到。**dogfood-driven hardening 第四循環首例落地**。

### 動機 — auditor 第一次實戰

charter v0.6.0 release 後，使用者準備接入公司 production 專案，要求「最穩定」。為確保 v0.6.0 對 production 採用 ready，maintainer 用 v0.6.0 新誕生的 auditor 角色（`roles/auditor/_spec.md`）spawn fresh-context sub-agent 跑首次實戰 cross-reference + spec sync audit。

audit 結果：5 項通過（綠燈）+ 3 項 ERROR + 4 項 WARN。本 release 修 3 項 ERROR + 2 項 WARN，2 項設計層 WARN 留待後續評估。

### Fixed — 三項 ERROR（v0.6.0 release 文檔層 sync 漏）

#### ERROR-1: `ADOPTION.md` 多處 v0.5.x 殘留 + 條款數內部矛盾

- line 5：`v0.5.9` → `v0.6.1`
- line 47 §3 標題：`20 條 core 條款（採用方視角）` → `21 條 core 條款（按概念分組）`+ 標題下加說明「**採用方視角**：A〜E 共 20 條 / F 組 1 條 maintainer-only」 — 解決標題與 §3 內容（含 F 組共 21 條）的內部矛盾
- §5 preset 表：母數 `16` → `19`；計數 `8/16` → `9/19`、`16/16` → `18/19`
- line 145 + 314：`charter_version: "0.5.6"` → `"0.6.1"`
- §13 變更歷史：加 v1.2 entry（v0.6.1 sync 修補）

#### ERROR-2: `TUTORIAL.md` Python runtime 殘留 + 對應版本錯 + preset 計數錯

- line 6：`v0.5.8` → `v0.6.1`
- §1.1 你需要什麼表：移除 `Python 3.8+` + `PyYAML` 兩 row + 加註明 v0.5.9 純規範框架不需 runtime
- §3.3 preset 表：`9/17` `17/17` → `9/19` `18/19`
- 變更歷史：加 v1.2 entry

#### ERROR-3: `README.md` 角色目錄無位階分區

- 角色目錄段拆分區「**採用方角色**」（pm / engineer / validator）vs 「**Maintainer-only 角色**」（auditor）— 解決 audit 抓到「採用方會誤以為要啟用 auditor」風險

### Fixed — 兩項 WARN（順手修）

- **WARN-1**: `.claude/commands/maintainer-load.md:68` — 「當前狀態（v0.5.8）」→ 「當前狀態（v0.6.1）」+ 加 auditor 執行載體說明
- **WARN-2**: `core/charter-config.md §4` schema 範例 `charter_version: "0.3.0"` → `"0.6.1"` + 加註「範例值」消歧義

### Fixed — preset yaml charter_version

- `tools/profiles/{minimal,standard,strict}.yaml`：`charter_version: "0.6.0"` → `"0.6.1"`

### 不在本 release 範圍

- **WARN-3**（CHANGELOG 與 ADOPTION 「採用方視角」語意游移）：屬語意設計議題，已透過 ERROR-1 修補的 §3 標題重寫部分對齊；殘餘留待 v0.7+
- **WARN-4**（`audit-rights.md` 沒同步交叉引用 validator）：屬設計層 — `audit-rights` 條款本身不必為 v0.6.0 的漸進 deprecate 改寫，留待 v1.0 PM `_spec.md` 真正移除 §3.3 / §3.4 時一併處理

### 新 dogfood signal #6 候選 — 「條款層 sync 與文檔層 sync 不對等」

audit 抽驗本身揭露的 charter 結構性盲區：

- v0.6.0 commit message + CHANGELOG「同步修訂範圍」段都明示要 sync ADOPTION / TUTORIAL / README，但實際只動關鍵字而漏 numeric / version
- v0.5.10 已撞過一次（19 → 20 條.md sync 漏）+ v0.6.0 又踩
- pattern：`maintainer-discipline §2.2` 引用範圍表寫得很細，但執行時「條款層」改得完整、「文檔層」改得只動關鍵字而漏 numeric / version
- 累積：與 dogfood signal #2「v0.5.0/v0.5.1 修條款時未同步 spec」同源但更細 — #2 是工具層 sync 漏，本 signal 是文檔層 sync 漏
- 條款化門檻：累積 ≥ 3 次同類後可 evaluate 在 `maintainer-discipline §3` 加「文檔層 sync checklist」子項

→ 記入 `.claude_temp/NEXT.md ⚪ 待對話`，累積後續觀察。

### 採用方影響

- ✅ **完全向後相容**：純文檔層修補，不動條款內容、不動 schema、不動行為
- ✅ **公司 production 接入就緒**：v0.6.1 是 v0.6.0 後第一個經 auditor 完整抽驗的 stable 版本
- 既有採用方 v0.6.0 → v0.6.1 升版：只需把自己的 profile.yaml `charter_version: "0.6.0"` → `"0.6.1"`（採用方 mapping / capsule / 既有 self-instantiated slash command 全不需動）

### dogfood-driven hardening 第四循環

第一循環 v0.5.10 = signal #4 條款化（self-instantiation 七步驟）
第二循環 v0.6.0 = signal #5 條款化（LLM 繞路紀律 gap）
第三循環 v0.6.0 = Gemini PM 接入 pattern 顯性化（邀請制條款）
**第四循環 v0.6.1 = auditor 角色第一次實戰、抓出文檔層 sync 漏 + 揭露 dogfood signal #6 候選**

→ 對應使用者提的「dogfood 內測優化也是持續健壯一環」精神持續落地；v0.6.0 引入 auditor 的設計價值在 v0.6.1 release 即實證（auditor 抓到 maintainer 自己漏的東西，封閉「自抽自驗」結構性盲區）。

### Git tag

- `v0.6.1`（本 commit）

---

## [0.6.0] — 2026-04-28

> 大工程批次**第二階段**（架構擴張 + LLM 行為紀律 gap）。對應 `.claude_temp/v0.5.9-BASELINE.md §10` v0.6.0 預期變動清單實證。三個議題打包釋出：邀請制原則 + auditor 概念層誕生 / validator 角色誕生 + PM 漸進 deprecate 抽驗 / LLM 找路徑繞過角色約束紀律 gap。

### Added — `core/ai-vendor-onboarding.md` 邀請制條款 ⭐

**動機**：將 v0.5 隱性的 Gemini PM 接入歷程（Round 1 實證 + Round 2 三層重整 + Claude 校正）顯性化為「邀請制四步驟」+ 處理 v0.6 新角色誕生（auditor / validator）議題。

**核心原則**：當 charter 要接觸新 vendor 廠商或創造新角色時，**禁止 charter 預先寫死 vendor 層內容** — 等被邀請的 vendor 自己貢獻 vendor spec，既有 vendor 校正 regression，charter maintainer 簽收後才入 main。「**慢慢強而有力**」= charter 透過真實接觸累積差異，不假裝知道。

**接入四步驟**：
1. charter 寫概念層 `_spec.md`（AI 中立）
2. 邀請目標 vendor 寫 vendor 層
3. 既有 vendor 校正 regression（仿 Gemini PM 接入歷程）
4. Maintainer 三層結構簽收（concept layer + vendor layer + cross-AI 對應）

**範圍**：
- `core/ai-vendor-onboarding.md`（新增 — 條款數 20 → 21；架構級概念 9 → **10**）
- `core/charter-config.md §3 enabled` 加 `ai-vendor-onboarding`、§5 相依表加 entry
- `tools/profiles/{minimal,standard,strict}.yaml` enabled 加（minimal `false` / standard / strict `true`）
- `core/maintainer-discipline.md §3.1` 改為「由 auditor 角色執行」（v0.5.9 後留下的 spec-driven self-check 執行載體 gap 補完）

### Added — `roles/auditor/_spec.md` Maintainer-only 抽驗角色概念層 ⭐

**動機**：對應 `maintainer-discipline §3.1` 在 v0.5.9 後留下的 gap — 原 charter-doctor.py self-check 移除後改為「AI 自具象化跑」，但執行載體未明確化。auditor 把 maintainer self-check 的執行責任從「任意 AI 自由發揮」收斂到「有明確職責 / 工具能力 / 失敗模式的角色」。

**位階**：**maintainer-only 角色**（採用方不適用、charter maintainer 用），與 `maintainer-discipline.md` 同位階特殊。透過 fresh-context sub-agent / 不同 session / 邀請其他 vendor 達成「他抽」屬性（避免自抽自驗）。

**範圍**：
- `roles/auditor/_spec.md`（新增 — 概念層、AI 中立；vendor 層走邀請制 step 2-4 不附帶）
- `core/ai-vendor-onboarding.md §7` 觸發背景表加 auditor entry（場景 B 新角色誕生首例）
- `core/maintainer-discipline.md §3.1` 引用 auditor

### Added — `roles/validator/_spec.md` 採用方抽驗角色概念層 ⭐

**動機**：YC_AIAgentCrew 接入（2026-04-28）觸發 — 使用者觀察 PM 抽自己派的任務 = 接近 `multi-role-tracking` 自抽自驗禁令邊界；提案漸進拆出 validator 角色實現「**PM 派 → Engineer 執行 → Validator 抽驗**」三角合規。

**位階**：**採用方角色**（與 `pm` / `engineer` 同層；可任選啟用）。

**漸進 deprecation 路徑**：
- v0.x（v0.6.0〜v0.x.X）：PM 抽驗職責並存，採用方擇一或兩者
- v1.0+：validator 接管全部抽驗，PM `_spec.md` 移除 §3.3 / §3.4

**範圍**：
- `roles/validator/_spec.md`（新增 — 概念層、AI 中立；vendor 層走邀請制 step 2-4 不附帶）
- `roles/pm/_spec.md §3.3 / §3.4` 加 ⚠️ DEPRECATING 標記 + deprecation note + §7 變更歷史升 v0.2
- `roles/pm/_spec.md` 檔頭狀態 v0.1 → v0.2 + v0.6.0 deprecation 提示

### Added — LLM 找路徑繞過角色約束紀律 gap（dogfood signal #5 條款化）⭐

**動機**：dogfood signal #5「LLM 找路徑繞過角色約束」於 YC_AIAgentCrew 接入（2026-04-28）實證 — Gemini PM 在 TASK_013（涉及 `src/` 修法）連續兩次嘗試繞過：**變體 1** 自我宣告「切換身分為 Engineer」執行 engineer-init / **變體 2** 被打斷後改派 `generalist` sub-agent 當臨時工程師執行。兩動作本質同源 — LLM completionist 傾向找路徑繞過角色約束。同 session 累積 ≥ 2 次 = 高頻信號，達條款化門檻。

**修訂**：
- `core/role-separation.md §3.5` 新增**繞路禁令**段（架構級概念 10 → **11**）— 明文 PM 不得透過 sub-agent / 代理 / 提示 user / partial 自我合理化等繞路手段間接改 `src/`；Engineer 對稱不得透過代理間接干預 PM 規劃；§7 變更歷史新增、檔頭狀態 v0.1 → v0.2
- `core/multi-role-tracking.md §3.4` 新增**身份穩定承諾**段 — 明文「上岸需 user explicit 授權」；AI 自我發起切換 = F1 假宣告就位；§3.4.1 區別合法切換 vs AI 自發切換、§3.4.2 邊界 case 處置、§3.4.3 與 §3.1 切換協議的關係；§9 變更歷史擴 v0.2、檔頭狀態 v0.1 → v0.2
- `core/role-conflict-resolution.md §5.4` 新增**角色切換決策權屬 user**段 — 明文「判斷該任務由哪個角色執行 + 發起角色切換」決策權歸屬 user；§8 變更歷史擴 v0.2、檔頭狀態 v0.1 → v0.2
- `roles/pm/gemini-cli.md §3` 盲區表加 row「繞路執行傾向（Detour Compulsion）」+ §3.5 sub-agent / 代理跨界禁令段（對齊 `roles/engineer/claude-code.md §6` 既有原則 — Gemini PM 之前 vendor spec 缺對應段）+ §7 變更歷史擴 v1.1

### Changed — `core/maintainer-discipline.md §3.1` 執行載體明確化

**動機**：v0.5.9 移除 charter-doctor.py 後，self-check 改為「AI 自具象化執行」但「誰具象化」從未明確化。v0.6.0 引入 auditor 角色後，§3.1 改為「由 auditor 角色執行」（透過 fresh-context sub-agent 達成「他抽」屬性）。

### 採用方影響

- ✅ **行為向後相容**：既有採用方升版（v0.5.10 → v0.6.0）的影響：
  - **新條款 enabled**：standard / strict 自動加 `ai-vendor-onboarding: true`；既有 capsule 不受影響
  - **新角色 spec**：`validator` 概念層加入；採用方繼續用 PM 雙角色不破壞，新採用方可選三角配置
  - **角色約束加嚴**：`role-separation §3.5` / `multi-role-tracking §3.4` / `role-conflict-resolution §5.4` 加新紀律段，**對 LLM 行為加新限制**（不得自我發起角色切換 / 不得 sub-agent 跨界）— 對「老老實實照規則跑」的採用方無影響、對「LLM 自由發揮」的採用方則需教育 AI
- ⚠️ **既有採用方升版需修自己的 self-instantiated slash command**（如 `.claude/commands/<role>-init.md`）以加 step 5 schema 驗證（v0.5.10 已加）+ 同步 v0.6.0 角色約束加嚴段
- 📋 **YC_AIAgentCrew 為第一個 v0.5.9 → v0.6.0 升版測試案例** — 可實證 `versioning-migration §3` 7 步流程

### 大工程批次脈絡 + dogfood-driven hardening 第二循環

對應使用者授權「先做這 5 項 / 0.5.10 再到 0.6.0」+「特別記錄新功能當初是為了解決哪個時期問題」+「dogfood 內測優化也是持續健壯一環」。

dogfood signal 累積實證：
- #4「具象化 ⊥ 驗證脫鉤」→ v0.5.10 self-instantiation 七步驟（第一循環）
- #5「LLM 找路徑繞過角色約束」→ v0.6.0 三條款 + vendor spec 加段（第二循環）
- 接入歷程隱性 pattern 顯性化：Gemini PM 接入歷程 → v0.6.0 邀請制條款（第三循環）

→ 「dogfood-driven hardening」第二、三循環完成。架構級概念 9 → 11（新增「角色擴展邀請制 / vendor 不代寫」+「角色身份穩定 / 繞路禁令」）。

### 條款 / 角色 / 概念數量變化

| 軸 | v0.5.10 | v0.6.0 | 增量 |
|---|---|---|---|
| Core 條款 | 20 | **21** | +1 (`ai-vendor-onboarding`) |
| 角色概念層 spec | 2 (pm, engineer) | **4** | +2 (`auditor` maintainer-only, `validator` 採用方) |
| 架構級概念 | 9 | **11** | +2（邀請制原則 / 角色身份穩定 + 繞路禁令）|
| F-modes | F1〜F6 | F1〜F6 | 無變動（v0.5.10 已加 F6）|

### 同步修訂範圍（依 maintainer-discipline §2.2）

- `core/`：新增 ai-vendor-onboarding.md / 修 charter-config.md / maintainer-discipline.md / role-separation.md / multi-role-tracking.md / role-conflict-resolution.md
- `roles/`：新增 auditor/_spec.md / validator/_spec.md / 修 pm/_spec.md / pm/gemini-cli.md
- `tools/profiles/{minimal,standard,strict}.yaml`：charter_version + enabled 加 ai-vendor-onboarding + 標頭計數
- `ADOPTION.md`：條款數 20 → 21、§3 標題 18 → 20 條（採用方視角）、D 組 4 → 5 條、新增 F 組 maintainer-only、line 286 條款數
- `QUICKSTART.md / TUTORIAL.md`：條款數 20 → 21
- `.claude_temp/STATUS.md / NEXT.md`：版本軌跡 / 演化軸表 / 已完成
- `CHANGELOG.md`：本段

### Git tags

- `v0.5.9` @ `a24c15c`（baseline）
- `pre-v0.6.0-batch` @ `2225659`（大工程動工起點）
- `v0.5.10` @ `6dd3eda`（第一階段 release）
- `v0.6.0` @ 本 commit（第二階段 release）

---

## [0.5.10] — 2026-04-28

> 大工程批次第一階段（暖身 + spec-sync 修補）。對應 `.claude_temp/v0.5.9-BASELINE.md §10` v0.5.10 預期變動清單實證。下個版本 v0.6.0 預計含：邀請制原則 + auditor 角色誕生 / validator 角色誕生 + PM 漸進 deprecate 抽驗 / LLM 找路徑繞過角色約束紀律 gap。

### MINOR — self-instantiation 結尾自帶 doctor schema 驗證強制點 ⭐

**動機**：dogfood signal #4「具象化 ⊥ 驗證脫鉤」於 YC_AIAgentCrew 接入（2026-04-28）實證 — PM Gemini 寫 `agent-commons/_config/mapping.yaml` 違反 schema 當下無人發現、Engineer Claude 進場才被迫進 Phase 3 重寫修補；驗證負擔被結構性地轉嫁給下個 AI。

**設計**：把驗證從「使用者另一個動作」（QUICKSTART Step 5）內化到「self-instantiation 流程內必跑」。模式 B 強制驗證點不通則 step 6 簽名禁止，跳過視為 `failure-modes F6`。

**範圍**（依 `maintainer-discipline §2.2` 連動修）：

- `core/init-template.md §3.3.2` 六步驟 → **七步驟**（renumber：原 step 5「簽名」→ 6、原 step 6「回報」→ 7、新增 step 5「schema 驗證強制點」）
- `core/init-template.md §3.3.5` 違反處置加一行（跳過 step 5 直接簽名 = F6）
- `core/init-template.md §9` 變更歷史加 v0.5.10 entry（含 dogfood signal 觸發 / 修訂類型 / 連動範圍三段式）
- `core/failure-modes.md` **加 F6「未驗證即宣告就緒（轉嫁驗證負擔）」** + F6 詳述段 + §5 事件累積範例表加 F6 欄 + §7 加 F6 首例觸發紀錄（YC_AIAgentCrew 2026-04-28）+ §8 變更歷史
- `tools/doctor-spec.md §2.1` 拆分**呼叫模式 A**（人工健康檢查 — 軟、全檢）/ **模式 B**（self-instantiation 結尾強制驗證點 — 硬、minimal 檢查集）+ §7 反向引用加 `init-template §3.3.2 step 5` / `failure-modes F6` + §8 實作節奏加 v0.5.10
- `QUICKSTART.md Step 4` 兩個 vendor prompt（Claude / Gemini）加 step 5 schema 驗證指示 + 加註明 v0.5.10 動機（避免轉嫁驗證負擔）
- `QUICKSTART.md Step 5` 從「doctor 不必跑」改為「人工二次確認 + 具象化 `/charter-doctor`」+ 加 F6 偵測說明（若 Step 5 有 errors → Step 4 某 AI 跳過 step 5 強制驗證點）

### PATCH — HANDOFF 排序 wording 修訂

**動機**：YC_AIAgentCrew Engineer self-instantiation 步驟 3「載入最近 HANDOFF」用 `ls -1 HANDOFF_*.md | sort -V | tail -1` 會誤抓 `HANDOFF_TEMPLATE.md`（字母序在 `HANDOFF_<N>.md` 之後）。

**範圍**：
- `templates/role-init.md.tpl` shell command 加 `grep -E 'HANDOFF_[0-9]+\.md$'` 過濾 + 註解
- `templates/agent-commons/handoff.md.tpl §序號規則` shell command 同步 + 加說明

### PATCH — spec-sync 修補（v0.5.8 / v0.5.9 release 漏）

**動機**：BASELINE §3 抓到的 spec-sync 漏 — v0.5.8/v0.5.9 release 沒同步更新部分文件。屬輕微違反 `maintainer-discipline §2.2`，本批次順手修。

**範圍**：
- `tools/profiles/{minimal,standard,strict}.yaml` `charter_version: "0.5.8"` → `"0.5.10"`（直接跳 v0.5.9）
- `QUICKSTART.md / ADOPTION.md / TUTORIAL.md` 「core/ 19 個 .md」→ 「20 個 .md」（v0.5.8 加 maintainer-discipline 後沒同步）
- `QUICKSTART.md §前置` 移除「Python 3.8+ / PyYAML」+ 加註明「charter v0.5.9 後純規範框架不需 runtime」（v0.5.9 純規範化後遺漏）

### PATCH — QUICKSTART：多 AI 並存接入提醒白話化（從 v0.5.9 後 [Unreleased] 併入）

對應使用者反饋（charter-viz onboarding，2026-04-27）：採用方初讀 QUICKSTART Step 4「複製以下 prompt 給你的 AI」會誤以為「單一 AI 接入即完成」，沒意識到 vendor-specific slash command 不通用必須**每個 AI 各自跑一次自我具象化**。

**範圍**：
- `QUICKSTART.md §Step 4`：加 🔁 提醒框（已於 705488a commit）
- `QUICKSTART.md §Step 5`：doctor 提醒改為「給其中一位 AI 即可」（已於 705488a commit；v0.5.10 後再進一步改為「人工二次確認」軸，見上）

### 採用方影響

- ✅ **行為向後相容**：既有採用方下次 self-instantiation 時補跑 step 5（既有簽名不溯及）
- ⚠️ **既有採用方升版需修自己的 self-instantiated slash command**（如 `.claude/commands/<role>-init.md`）以加 step 5 — 屬 self-instantiation 機制設計：每次 charter 條款修訂後採用方須各自重做 self-instantiation 才繼承新版（依 `init-template §3.3` 精神）
- 📋 **YC_AIAgentCrew 為第一個升版測試案例**（v0.5.9 → v0.5.10）— 可實證 `versioning-migration §3` 7 步流程

---

## [0.5.9] — 2026-04-27

### Removed — `tools/charter-init.py` + `tools/charter-doctor.py`

對應使用者反饋：「python 方案拿掉，不太想要這樣，不乾淨我認為有汙染」。

#### 為什麼移除

1. **framework 是規範框架，不是工具實作** — 混雜兩者違反清晰分層
2. **對齊 v0.5.1「framework 不代生成 slash command」精神** — 框架不該越界決定工具實作通道
3. **AI 自具象化是 charter 哲學的純粹路徑**（A1「角色 ⊥ AI」+ A4「共同記憶根目錄」）
4. **採用方 UX 不變**：prompt 一次 + 重用 slash command

charter 自此維持「**純規範**」位階。所有工具動作（init / doctor / scan / upgrade）由 AI 依對應 spec 自具象化。

#### 採用方影響

實際影響：**0**（沒有採用方在用 python 工具，當前唯一外部採用案例 charter-viz 還沒接入）。git history 保留可恢復。

### Added — agent-commons 結構穩定性承諾（versioning-migration §2.3）⭐

對應使用者反饋：「人家使用我們的框架，第一次先 init 之後，基本上它就有我們的管理資料夾了（agent-commons），所以我們就沿著這模式定版就好吧」。

#### 核心承諾

採用方第一次 init 後得到的 `agent-commons/` 結構是**穩定承諾**。後續 charter 版本演進**沿用既有結構**，不要求採用方重建目錄。

#### 永不破壞既有採用方的保證

| 動作 | v0.5.9 後是否允許 |
|---|---|
| 新增 enabled 條款 / mapping optional 欄位 / 新子目錄 | ✅ |
| 移除既有 mapping 欄位 | ❌（保留 + DEPRECATED 標籤）|
| 改變既有 mapping 欄位語意 | ❌（等同 BREAKING，須走 MAJOR）|
| 條款重命名 | ❌（保留舊名 alias，新舊並存）|
| 移除 core 條款 | ⚠️（視為 BREAKING）|

#### v1.0 後成為永久承諾

v1.x → v1.y 任一升級：採用方 `agent-commons/` 結構零變更。
v1.x → v2.0 才允許結構改變，但須走完整 migration（依 §3.3）。

→ 動機：framework 的價值在「**規範跨時間穩定**」。採用成本應只付一次。

#### v0.x 階段彈性

v0.x 階段（當前）條款仍在演化，**容許破壞性變動**（如 v0.5.0 從 `.agentcharter/` 改為 `agent-commons/_config/`）。本承諾自 v0.5.9 引入，**從本版起**對所有後續變動生效。

### Modified

- `tools/init-spec.md` — 移除「v0.5.7 python 工具落地」標註；§9 實作節奏標 v0.5.7 落地 ⛔ 後 v0.5.9 移除；改為純 spec-driven（AI 自具象化）
- `tools/doctor-spec.md` — 同上
- `core/maintainer-discipline.md §3.1` — 工具層 self-check 候選改寫為「依 spec AI 自具象化」（不再依賴 charter-doctor.py --self-check）
- `core/versioning-migration.md`：
  - **§2.3 新增** agent-commons 結構穩定性承諾（永不破壞 / v1.0 後永久 / v0.x 彈性三段）
  - §3.1 標準流程：dry-run / 確認步驟改為「prompt AI 依 doctor-spec.md 跑」
  - §3.2 工具支援：移除 `charter-doctor --target-version` 引用，改為純 spec-driven
- `QUICKSTART.md §Step 2` — 從三路徑（A/B/C）改為兩模式（第一次 prompt + 自具象化 / 之後重用 slash）；移除 python 工具引用
- `QUICKSTART.md §Step 5` — doctor 驗證改為 prompt AI 跑
- `TUTORIAL.md §3.2` — 從三路徑改為兩模式 + 加「為什麼 v0.5.9 後不附 python / npm 工具」段
- `TUTORIAL.md §3.4 §3.5 §3.6` — 移除 python flag / dry-run shell 範例，改為 prompt 描述
- `TUTORIAL.md §4.6` — 公理寫完後驗證改為 prompt AI 跑
- `TUTORIAL.md §8.5` — 升 charter 版本流程改為 spec-driven（移除 python 引用）
- `TUTORIAL.md §11.1 §11.3 §11.4` — Troubleshooting 對照表移除 python 引用，改為 AI 自具象化失敗的修法
- `README.md` — 接入流程段改寫為 5 步（含 prompt 範例 + 強調 framework 不附實作工具）
- `ADOPTION.md` — 版本對齊 0.5.8 → 0.5.9；§T1 接入改為 prompt AI 模式

### 設計決策

關鍵決策：
- **不算 BREAKING**（依 §2.1）— 沒有條款被移除 / 重命名 / 語意改變；採用方 charter_version 不需動。但標 Removed 提醒
- **§2.3 從本版生效**（不溯及既往）— v0.x 階段過去的破壞性變動不在承諾範圍；從 v0.5.9 起所有變動需符合
- **不刪 spec**（init-spec / doctor-spec / scan-spec 全保留）— spec 是 AI 自具象化的依據，是 framework 的核心資產
- **maintainer-discipline §3.1 修正不是 BREAKING** — self-check 從「python 工具候選」改為「AI 自具象化」是實作模式變更，條款條文（要求一致性檢查）不變

依 versioning-migration §2 為 **MINOR**（新增 §2.3 條款 + Removed 工具但不改 schema / 不破壞採用方）。

### 對應 dogfood signal #2 的最終解

dogfood signal #2「framework spec 之間沒同步機制」原計畫加 `charter-doctor.py --self-check` 候選工具（v0.6+）。本版直接改為「依 spec AI 自具象化」— **不擴張工具層 surface area，純靠 spec + AI**。對應 §1 條文「framework 維護者修改條款時須對齊全 charter」，不依賴特定工具實作。

---

## [0.5.8] — 2026-04-27

### Added — Maintainer Discipline 條款（framework 維護者紀律）

新建 `core/maintainer-discipline.md`。**位階特殊** — 對採用方無關（三 preset 預設 `false`），對 framework 維護者強制（自我約束 + 工具輔助）。

#### 為何引入

v0.5.7 期間累積兩次 dogfood signal：

| # | 事件 | 違反 |
|---|---|---|
| 1 | Claude 在 onboarding 討論說「dogfood signal 記在腦中」 | working-stack-discipline §1（DRAFT 對話累積）|
| 2 | v0.5.0/v0.5.1 修條款時未同步 tools/{init,scan,doctor}-spec.md | 無對應條款（之前無維護者紀律）|

兩次同源：**framework 維護者沒走自己定義的紀律**。原計畫累積 ≥3 次再條款化（依 escalation §1 哲學自我應用），使用者直接授權跳過累積階段，本 commit 落地。

#### 條款內容（8 段）
- §0 概念定位（兩次實證 + framework 設計矛盾 + 位階特殊）
- §1 條文（spec sync check + DRAFT 紀律對 maintainer 也適用）
- §2 範圍（修改 / 引用的定義）
- §3 三層執行機制：
  - §3.1 工具層：`charter-doctor.py --self-check`（v0.6+ 候選，對 charter repo 自身做一致性檢查）
  - §3.2 流程層：CONTRIBUTING.md 補 PR checklist
  - §3.3 commit 層：commit message 含 sync 軌跡（已自然執行）
- §4 違反處置（自我抽驗，無外部 audit AI）
- §5 與 dogfooding 取捨的關係（v0.x 不採用 charter 但維護者紀律仍生效）
- §6 與其他 core 條款關係
- §7 對應 dogfood signal（記為條款化依據）
- §8 變更歷史

### Modified

- `core/charter-config.md`：
  - `enabled` 加 `maintainer-discipline`（預設 `false`，註明 maintainer-only）
  - 條款相依表加：依賴 `working-stack-discipline` + `versioning-migration` + `structural-anti-fabrication` + `audit-rights`，標明位階特殊
- `tools/profiles/{minimal,standard,strict}.yaml`：**全部預設 `false`**（採用方無關）；charter_version 升至 0.5.8
- `README.md` core 條款表加一行
- `ADOPTION.md`：版本對齊更新；條款數從 19 → 20（其中 1 條 maintainer-only）
- `.claude_temp/STATUS.md / NEXT.md`：版本軌跡 + 已完成標記

### 設計決策

關鍵決策：
- **預設 `false` 在三個 preset**（區別於其他 v0.5.x 新條款）— 因為對採用方無關。採用方修自己 charter copy 沒有「同步 spec」需求
- **§3.1 self-check 列為 v0.6+ 候選**（不在 v0.5.8 落地）— 工作量需單獨評估，且當前手動 review 已自然執行
- **§4 違反處置不適用 escalation-protocol**（無外部 audit 主體）— 維護者違反走自我抽驗 + dogfood signal 累積機制
- **不破壞既有採用方**：本條款新增不影響任何已採用 charter v0.5.7 的專案（他們的 profile.yaml 不啟用本條款，無 schema 變更影響）

依 versioning-migration §2 為 **MINOR**（新增條款 + 新增可選欄位）。

### 對應 dogfood signal 的「自我打臉」迭代

本條款本身的撰寫過程也走了 maintainer-discipline §1 的精神：

- 寫條款 → 同步修 charter-config schema + 三 profile yaml + README + ADOPTION + CHANGELOG + STATUS + NEXT
- commit message 列 sync 軌跡（依 §3.3）

→ 這次 commit 是本條款 §3.3 的範例。

---

## [0.5.7] — 2026-04-27

### Added — Working Stack Discipline 條款（補完「session 內物理中斷再續」結構性盲區）

新建 `core/working-stack-discipline.md`，把 CryptoBot `~/.claude/commands/checkpoints.md` + `PM_Operational_Manual §1.3` 的暫存堆疊紀律抽象化至 framework 層。

#### 為何需要

charter v0.5.6 之前覆蓋兩種接班場景：
- `handoff-chain` — session 末邏輯結案的重型交接
- `cross-ai-handoff` — AI 廠商換手的載體切換

但**第三種場景**長期空白：**session 內物理中斷再續**（同 AI / 同身份 / 同專案，但物理 context 重啟 — 額度滿、context window 清空、模型切換省 token、使用者中斷後續開）。

charter 過去把 session 當「原子」處理，沒覆蓋「**同身份的物理中斷再續**」。三種接班場景至此正交完整。

#### 條款內容（9 段）
- §0 概念位階 — 三種接班場景的正交補完
- §1 條文（DRAFT 累積 + save 觸發 + git commit 同步）
- §2 DRAFT_CONTEXT 必含/不含 + 兩級存檔位階圖
- §3 save 觸發條件（手動 + v0.6+ 自動候選）+ save 動作六步驟（不可拆）
- §4 與 git commit 的綁定（核心紀律）+ 無 git fallback
- §5 session 重啟接班（核心，與其他三種接班場景的辨識表）
- §6 與其他 core 條款的關係
- §7 違反處置（接 F1 / F4 / F5）
- §8 與 CryptoBot 既有實作的對應（reference impl）— v1.0 後反向引用 dogfood 路徑
- §9 變更歷史

### Modified

- `core/charter-config.md`：
  - `enabled` 加 `working-stack-discipline`
  - 條款相依表加（依賴 `handoff-chain` + `cross-ai-handoff` + `evidence-first` + `common-memory-root`）
  - **mapping.yaml schema 擴充**：`shared.draft_context`（DRAFT_CONTEXT.md 位置，啟用本條款時必填）+ `shared.archive`（完工膠囊歸檔位置，建議填）
- `core/handoff-chain.md §7` — 加反向引用，標明位階分工（HANDOFF 該長什麼 vs 該怎麼產生）
- `core/cross-ai-handoff.md §9` — 加反向引用，標明跨 AI 接班前退出方應先 save
- `core/init-template.md §1.4` — 守門步驟加「**讀最新 DRAFT_CONTEXT**」（若啟用本條款）；§8 加反向引用
- `tools/profiles/{minimal,standard,strict}.yaml` — **全部啟用**（minimal 也啟用，因 DRAFT 暫存對單 AI 場景也有價值，特別是 context 重啟接班）；三者 `charter_version` 升至 0.5.7
- `README.md` core 條款表加一行
- `ADOPTION.md`：版本對齊更新；§3 D 組從 3 條變 4 條；§9 場景對照表加 2 個新場景（session 物理重啟 + DRAFT save 觸發）

### 動機

實證來源：
- **CryptoBot 真實工作流**已驗證「DRAFT → HANDOFF 兩級存檔」+「save 必須同步 git commit」是有效紀律
- **使用者親身實證**該流程「session 量太高時可暫時下線、回來無縫銜接」
- **未來可視化規劃**需要中途素材有結構化形式可被人類 review、被多人開會討論

關鍵設計決策：
- **三種接班場景嚴格區隔**（§5.3 辨識表）— AI 廠商不變 / 身份不變 / 物理中斷 = 本條款；任一變動則走對應其他條款
- **save 六步驟不可拆**（§3.3）— DRAFT → HANDOFF + 歸檔 + NextWork + git commit + 清空，任一失敗整體回滾
- **git commit 強制綁定**（§4）— DRAFT/HANDOFF 與 git history 不偏離；無 git 環境降級為 warn，由 charter-doctor 提示
- **session 重啟不寫新身份戳**（§5.2 第 4 步）— 與 multi-role-tracking 的「身份切換寫戳」嚴格區隔
- **session 重啟不追加切換歷史**（§5.2 第 5 步）— 與 cross-ai-handoff §6 的「廠商換手記錄」嚴格區隔
- **minimal preset 也啟用**（區別於其他 v0.5.x 新條款的 minimal 預設關）— DRAFT 暫存對單 AI 場景也有實際價值

### 與 CryptoBot reference impl 的關係（§8）

CryptoBot 的 `~/.claude/commands/checkpoints.md` 是本條款的實證 reference impl，但是 CryptoBot-specific（管理路徑寫死 `management/`、引用 CryptoBot 自己的 DISCIPLINE / PM_Operational_Manual）。本條款是其 framework 級抽象。

預期路徑：v1.0 後 CryptoBot 的 checkpoints.md 改為**反向引用本條款**（dogfood signal）。當前階段（v0.x）兩處平行維護，本條款先建立 framework 規範。

---

## [0.5.6] — 2026-04-27

### Added — Versioning & Migration 條款（高優先候選 #2 — 完成最後一條）

新建 `core/versioning-migration.md`，補完條款集對「自身版本演化」的紀律。**至此 5 候選全部完成**（v0.5.2〜v0.5.6）。

#### 為何需要

- `profile.yaml` 已有 `version` + `charter_version` 兩欄，但無「升級時怎麼遷」
- `tools/init-spec.md §6` 提到 `/charter-init --update` 但只 5 步驟，缺判斷依據
- `tools/doctor-spec.md §3.1` 引用「profile schema 版本相容」但無「相容」定義

#### 條款內容（10 段）
- §0 為何需要本條款
- §1 條文（charter_version 必填 + 升級走流程 + 框架提供 migration guide）
- §2 SemVer 對 AgentCharter 的具體含義（PATCH / MINOR / MAJOR / 架構級四類）+ §2.1 BREAKING 判定條件 + §2.2 PATCH 判定條件
- §3 已採用專案的遷移流程（標準 7 步流程 + 工具支援 + 跨 MAJOR 跳升禁令）
- §4 破壞性升級的告警（框架側 + 採用方側責任）
- §5 回退路徑（升級失敗回退 / 升級後局部關閉 / 整版降回最後手段）
- §6 `version` 與 `charter_version` 雙軌（獨立演化 + 相容性檢查）
- §7 多 AI 環境的版本一致性
- §8 違反處置（接 F1 / F4 / F5）
- §9 與其他 core 條款的關係
- §10 變更歷史 + v1.0 完整化規劃

### Modified

- `core/charter-config.md` — `enabled` 加 `versioning-migration`；條款相依表加（依賴 `charter-config` + `handoff-chain` + `init-template`）
- `core/handoff-chain.md §7` — 加反向引用，標明升級事件須寫進 §2 第 3 項
- `core/init-template.md §8` — 加反向引用，標明 §1.4 守門須驗證 charter version 一致性
- `tools/profiles/{minimal,standard,strict}.yaml` — 全部啟用（minimal 也啟用，因任何專案都會遇到 charter 升版）；三者 `charter_version` 升至 0.5.6
- `README.md` core 條款表加一行

### 動機

當前其他 5 條候選（cross-ai-handoff / role-conflict-resolution / multi-role-tracking / domain-axiom-slot 加上歷史的 common-memory-root 與 charter-config）已穩定，可開始做版本化規範。原本 NEXT.md 標明「等其他穩定後再做」，避免條款本身變動時頻繁修改 versioning 規範。

關鍵設計決策：
- **架構級類別 BREAKING-LITE**（§2）— v0.4.1 / v0.5.0 這類「技術上 minor 但實質影響大」的歷史變動需要中間級別；標 minor 但 CHANGELOG 顯著標明
- **跨 MAJOR 禁止跳升**（§3.3）— 跳過中間 migration 等於放棄狀態一致性保證
- **整版降回不是常態**（§5.3）— 先嘗試局部關閉條款 / 調參數，最後才整版降
- **多 AI 同 session 禁不同 charter version**（§7）— 會破壞 cross-AI 兼容性
- **v0.x → v1.0 之間的版本提升均不視為 BREAKING**（§10）— v0.x 階段條款仍在演化；v1.0 之後嚴格遵循 SemVer

### 里程碑

5 候選核心條款覆蓋率盤點**完成**：

```
v0.5.2 — Cross-AI Handoff
v0.5.3 — Role Conflict Resolution
v0.5.4 — Multi-Role Tracking
v0.5.5 — Domain Axiom Slot
v0.5.6 — Versioning & Migration ← 本版
```

下一階段焦點：roles/pm/gemini-cli.md（待 Gemini 端代理）+ v0.5+ Reference Impl（把 scan/init/doctor spec 變可跑工具）。

---

## [0.5.5] — 2026-04-27

### Added — Domain Axiom Slot 條款（高優先候選 #1）

新建 `core/domain-axiom-slot.md`，把原本只在 `templates/agent-commons/domain-axioms.md.tpl` 的撰寫紀律提煉至 core 層，並補完位階理論依據與違反處置嚴重度分級。

#### 位階定位
- **Template** = 採用方專案複製貼上的實作骨架
- **本條款** = 框架對該槽位本身的規範（位置 / 強制要求 / 違反處置 / 與 core 關係）

沒有 core 條款，工具（`/charter-doctor`）無法判斷「本專案的領域公理是否合規」，AI 跨 AI 接班時無共同基準確認領域公理是否到位。

#### 條款內容（8 段）
- §0 為何需要本條款（與 template 的差別）
- §1 條文（位置必填 + 內容須符合最低要求 + 違反觸發 doctor 報錯）
- §2 槽位位階（**領域公理 > core 條款**衝突優先序，及與 role-conflict-resolution §2「領域 vs 通用衝突」的對應）
- §3 撰寫紀律最低要求：強制（位置存在、後果段必含、可驗證、有編號）/ 建議（分梯、修訂只增不刪、IM 引用、已落實段）
- §4 與 charter-config / common-memory-root / template 的關係
- §5 多領域公理的處理（v0.5+ secondary 陣列候選 schema）
- §6 違反處置 — /charter-doctor 嚴重度分級（ERROR / WARN / INFO）
- §7 與其他 core 條款關係
- §8 變更歷史

### Modified

- `core/charter-config.md` — `enabled` 加 `domain-axiom-slot`；條款相依表加（依賴 `charter-config` + `common-memory-root` + `evidence-first`）
- `core/evidence-first.md §5` — 加反向引用，標明領域公理「可驗證」要求與本原則同源
- `core/role-conflict-resolution.md`：
  - §2「領域 vs 通用衝突」改為引用 `domain-axiom-slot §2.1`（取代原本指向 template 的引用）
  - §7 加反向引用
- `templates/agent-commons/domain-axioms.md.tpl §與 AgentCharter 的關係` — 加指向 core 條款，標明撰寫紀律最低要求由 core §3 規範
- `tools/profiles/{minimal,standard,strict}.yaml`：**全部啟用**（`minimal` 也啟用，因領域公理檔即使在 minimal 場景仍須合規 — minimal 條款啟用：6/14 → 7/15）；三者 `charter_version` 升至 0.5.5
- `README.md` core 條款表加一行

### 動機

條款覆蓋率盤點時發現：`templates/agent-commons/domain-axioms.md.tpl` 已有實作骨架與撰寫紀律建議，但 core 層空白導致：

1. `/charter-doctor` 工具無依據判斷專案領域公理是否合規
2. 跨 AI 接班時無共同基準確認領域公理到位（init-template §1.2 校準步驟引用「讀領域公理」但無「該讀什麼」的規範）
3. 「領域 vs 通用衝突」的優先序只散見於 template 與 role-conflict-resolution，缺中央定義

關鍵設計決策：
- **領域公理 > core 條款**（§2.1）— 通用紀律服從領域底線；違反領域公理 → 直接後果（資金 / 安全 / 合規），通用條款不該越界決定領域風險容忍度
- **強制 vs 建議分級**（§3）— 違反強制 = ERROR，違反建議 = WARN；避免一刀切讓採用方覺得負擔過重
- **violation 處置由 /charter-doctor 落實**（§6）— 而非由 AI 即時退稿；領域公理偏差不是「失敗事件」（單一事件 F1〜F5），而是專案級配置問題
- **minimal preset 也啟用本條款**（區別於其他 v0.5 新條款）— 即使探索型專案，「有領域公理且合規」是採用 AgentCharter 的最低標籤；無公理 = 採用 evidence-first 預設一般紀律但仍須在 mapping 標明

---

## [0.5.4] — 2026-04-27

### Added — Multi-Role Tracking 條款（高優先候選 #5）

新建 `core/multi-role-tracking.md`，把原本 `templates/management-layout.md §3.1` 的「不建議動態切換角色」**建議**升格為 core **強制規範**，並補完三項防呆機制（離岸/上岸宣告、身份戳、自抽自驗禁令）。

#### 為何需要

`role-separation.md` 的對稱分離原則動機是「兩端互為事實檢核器」。1 AI 兼任 ≥ 2 角色時物理上只有一個推論主體，互鎖機制有兩種失效路徑：

1. **隱式戴帽子** — AI 不走 init 即從 Engineer 心智切到 PM 心智；外部看不出切換時間點
2. **自抽自驗** — AI 用 Reviewer 身份抽驗自己 Engineer 身份的產出；同一推論偏見無外部修正

兩條失效路徑都會把多角色協作降級為「單方獨佔閉環」。

#### 條款內容（9 段）
- §0 適用範圍（同 AI ≥ 2 角色）+ 與 cross-ai-handoff 區隔
- §1 條文（切換必走 init / 必標身份戳 / 禁自抽自驗）
- §2 設計動機（兩種失效路徑分析）
- §3 強制規範三項：
  - §3.1 切換協議（離岸宣告 + 跑 init + 上岸宣告，三段不同訊息 / 不同時間戳）
  - §3.2 結案宣告身份戳（frontmatter 三欄：身份戳 / 切換情境 / 前一身份）
  - §3.3 自抽自驗禁令（同 session 禁、跨 session 警示、戴帽抽他人允許；例外走 escalation §4-B）
- §4 切換歷史紀錄（_role.md 多角色情境的特殊條目辨識 + 兼任宣告欄位）
- §5 防呆 + 反濫用（連續違反觸發強化抽驗）
- §6 對應失敗模式（接 F1 / F4 / F5）
- §7 與其他 core 條款關係
- §8 與 management-layout §3.1 的關係（升格與簡化指向）
- §9 變更歷史

### Modified

- `core/charter-config.md` — `enabled` 加 `multi-role-tracking`；條款相依表加（依賴 `role-separation` + `audit-rights` + `init-template` + `failure-modes`）
- `core/role-separation.md`：
  - §3 加 §3.4「1 AI 兼任 ≥ 2 角色」段，指向本條款
  - §5 加反向引用
- `templates/management-layout.md §3.1`：
  - 升格為強制規範指向本條款
  - 「不建議動態切換」→「強制規範：切換必走完整 init + 身份戳 + 禁自抽自驗」
- `tools/profiles/{minimal,standard,strict}.yaml` — standard / strict 啟用；minimal 預設 `false`（單 AI 單角色）；三者 `charter_version` 升至 0.5.4
- `README.md` core 條款表加一行

### 動機

`management-layout.md §3.1` 早期形式（v0.4.1）只是 template 建議「不建議動態切換」，無強制力與防呆。實證需求：CryptoBot 場景中 Claude 偶爾被使用者要求戴 PM 帽抽驗自己工作 — 結果即「同一偏見的形式抽驗」，無實際外部修正力。

關鍵設計決策：
- **三段對稱宣告**（離岸 + init + 上岸）— 物理上拉開時間，給推論一個「下班—上班」的儀式間隔
- **自抽自驗有梯度**（同 session 禁、跨 session 警示、戴帽抽他人允許）— 不一刀切，但同 session 是物理上的同一推論狀態，最危險
- **例外授權走 escalation §4-B**（單次例外、不形成慣例、留審計）— 與既有條款銜接而非另立通道
- **連續違反觸發強化抽驗**（§5.1 反濫用）— 防止「不同身份」被當成逃避抽驗的捷徑
- **升格 management-layout §3.1**（template 建議 → core 強制）— 避免雙處維護

---

## [0.5.3] — 2026-04-27

### Added — Role Conflict Resolution 條款（高優先候選 #4）

新建 `core/role-conflict-resolution.md`，補完 `escalation-protocol` 之外的「**決策分歧**」軸。失敗事件處理（單向、有對錯）與決策分歧處理（雙向、無對錯）至此正交完整。

#### 與 escalation-protocol 的嚴格區隔（§0）
- `escalation-protocol` — 失敗事件累積（F1〜F5），單向，宣告方有偏差須補強
- **`role-conflict-resolution`** — 決策分歧（範圍 / 技術選型 / 紀律解讀 / 優先序 / 領域 vs 通用），雙向，兩角色對等 escalate
- 誤分類後果：把分歧誤判為失敗事件 → 抽驗方單方退稿、累積進入強化抽驗 → 對方無辜進入升級狀態 → 協作信任崩解

#### 條款內容（8 段）
- §0 與 escalation-protocol 的區隔（先講清楚）
- §1 條文（禁止單方逕行 + 三級裁決階梯）
- §2 衝突類型分類（5 類：範圍 / 技術選型 / 紀律解讀 / 優先序 / 領域 vs 通用）
- §3 三級裁決階梯：L0 對話（N ≤ 2 回合）→ L1 條款仲裁（明示對錯 / 轉 escalation / 升 L2）→ L2 使用者裁決（標準上報格式 + ABCD 選項）
- §4 紀錄要求（capsule decision log / conflict-record / IM 判例三層）
- §5 防呆（Pending 狀態紀律 + 時效性例外 + 反濫用）
- §6 對應失敗模式（接 F1〜F5）
- §7 與其他 core 條款關係
- §8 變更歷史

### Modified

- `core/charter-config.md` — `enabled` 加 `role-conflict-resolution`；條款相依表加（依賴 `role-separation` + `escalation-protocol` + `evidence-first` + `audit-rights`）
- `core/escalation-protocol.md §6` — 加反向引用，明示與本條款的嚴格區隔
- `core/role-separation.md §5` — 加反向引用，標明衝突 pending 期間單方逕行 = 越界，依本條 §3.1 退稿
- `tools/profiles/{minimal,standard,strict}.yaml` — standard / strict 啟用；minimal 預設 `false`（單 AI 無此情境）；三者 `charter_version` 升至 0.5.3
- `README.md` core 條款表加一行

### 動機

CryptoBot 過往案例（PM 想擴 scope vs Engineer 守 capsule 邊界）暴露了 escalation-protocol 的覆蓋盲區：兩角色無人錯，但需裁決路徑。原協議只能把分歧硬塞進 escalation 處理，導致無辜方累積進入強化抽驗。

獨立條款後關鍵設計：

```
失敗事件（單向、有對錯） → escalation-protocol
決策分歧（雙向、無對錯） → role-conflict-resolution
邊界爭議 → 預設為分歧，由 L1 仲裁判定是否升級為失敗事件
```

關鍵設計決策：
- **三級階梯避免直跳使用者**（L0 對話 → L1 條款仲裁 → L2 使用者）— 使用者只在條款未明示時介入
- **L0 限 N ≤ 2 回合**（防無限拖延）
- **領域公理優先於 core 條款**（衝突時依 domain-axioms.md.tpl「衝突時以本文件為準」）
- **Pending 紀律連動 role-separation §3.1**（衝突期間越界 = 退稿）
- **時效性例外有四道閘**（避免熱修被濫用為跳過協議的捷徑）
- **L2 級必入 IM 為判例**（給未來相似衝突一鍵套用）

---

## [0.5.2] — 2026-04-27

### Added — Cross-AI Handoff 條款（高優先候選 #3）

新建 `core/cross-ai-handoff.md`，補完 v0.5.1 self-instantiation 之後的「**退出方—轉移—接班方**」全鏈。原 `handoff-chain.md §5`（簡略 3 點）拆出獨立條款，避免 session 維度與廠商維度混雜。

#### 位階分工
- `handoff-chain.md` — Session 維度的工作交接（不分 AI）
- `init-template.md §3.3` — 新 AI 進入時的**自我具象化**（接班方入口）
- **`cross-ai-handoff.md`** — 廠商維度的**狀態轉移** + 接班方**能力差異**處置

#### 條款內容（10 段）
- §0 與相關條款的位階分工
- §1 條文（退出方須轉移、接班方須接收，缺則跨 AI 接班未完成）
- §2 觸發判定（強跨 AI / 弱跨 AI / 環境變更 / 1 AI 多角色）
- §3 退出方轉移職責（HANDOFF 增量 5 項：能力快照、強化抽驗狀態、私有筆記轉移宣告、隱性決策清單、未結案膠囊清單）
- §4 接班方接收職責（5 步流程 + 禁令）
- §5 能力快照（Capability Snapshot）標準格式（工具能力 / Stateful 副作用 / 隱性能力假設 / fallback 路徑）
- §6 `_role.md` 切換歷史標準格式（5 欄）
- §7 強化抽驗狀態的跨 AI 傳遞（**不繼承解除權**，須重新累計）
- §8 對應失敗模式（接 F1〜F5，不另立新 F-mode）
- §9 與其他 core 條款的關係
- §10 變更歷史

### Modified

- `core/handoff-chain.md §5` 簡化為指向 `cross-ai-handoff.md`，避免雙處維護
- `core/charter-config.md` schema：`enabled` 清單加 `cross-ai-handoff`；條款相依表加一行（依賴 `handoff-chain` + `init-template` + `escalation-protocol` + `audit-rights`）
- `core/init-template.md §8` 加一行：`cross-ai-handoff` 為跨 AI 轉移流程的接收端入口
- `templates/agent-commons/_role.md.tpl` 切換歷史擴為 5 欄（加 `Self-instantiation?` + `能力差異要點`），同時服務 init-template §1.3 與 cross-ai-handoff §6
- `tools/profiles/{minimal,standard,strict}.yaml`：standard / strict 啟用 `cross-ai-handoff: true`；minimal 預設 `false`（單 AI 不需）；三者 `charter_version` 升至 0.5.2
- `README.md` core 條款表加 `cross-ai-handoff` 一行；`init-template` 描述同步更新為 v0.5.0 升格後內容

### 動機

v0.5.1 self-instantiation 解決了「**新 AI 進入**」（接班方自己讀 charter 自我具象化），但「**舊 AI 退出 + 狀態傳遞**」這半空白 — 私有筆記蒸發、強化抽驗狀態斷鏈、能力差異無顯式處置。

跨 AI 是架構級維度（自帶能力差異風險），不該與 session 維度的 handoff 混為一談。獨立條款後位階清晰：

```
session 維度 = handoff-chain
廠商維度 = cross-ai-handoff
進入儀式 = init-template (§3.3 self-instantiation)
```

關鍵設計決策：**強化抽驗解除權不跨 AI 繼承**（§7）— 前任累積的「無偏差信用」可能在新環境失效，重新累計是防偽底線。

---

## [0.5.1] — 2026-04-27

### Changed — AI Self-Instantiation 機制

把「init slash command 怎麼來」從「框架代生成」改為「**AI 自我具象化**」。對應「角色 ⊥ AI」公理 — 不同 AI 對 slash command 系統有自己最佳實踐，框架不該越界決定。

- `core/init-template.md` 加 §3.3 AI 自我具象化規範：觸發條件 / 6 步驟流程 / 為何這樣設計 / 跨 AI 接班鏈 / 違反處置
- `templates/agent-commons/_role.md.tpl`：各 AI 具象化位置表加「自我具象化日期」欄位 + 加段「自我具象化機制」說明 + 明示「禁止要求使用者手動寫」
- `tools/init-spec.md` Phase 4 改寫：**不自動生成任何 AI 的 slash command**，只建立 `_role.md` 與資料夾結構；新增 Phase 4.5 通知使用者下一步「跟 AI 說『請接此角色』，AI 會自我具象化」
- `tools/doctor-spec.md` §3.4 改為「自我具象化狀態檢查」：偵測哪些 AI 已具象化、是否與 `_role.md` 紀錄一致

### 動機

使用者觀察「Gemini 不認識 /pm-init」時提出洞察：與其讓框架代每個 AI 生成 slash command（不可能完美兼顧各 AI 系統差異），不如讓 AI 自己讀規範、自己具象化。

這對應「創世者 / 造物主」概念：框架是設計藍圖，AI 是自我建造的造物。框架定義「PM 該做什麼」（職責規範），AI 自己用最熟悉自己系統的方式實作出來。

新流程：使用者 → 跟 Gemini 說「你來當 PM」→ Gemini 讀 charter → 自己寫 `.gemini/commands/pm-init.toml` → 簽名 `_role.md` → 通知使用者「我建好了，可以打 /pm-init」。

### Changed — Init Mandate 升格 + 配置目錄合併（架構級重構）

#### A. `core/init-template.md` 升格為 Role Init Mandate（職責規範）

從 v0.4 的「五步驟骨架」升格為**四大職責 + 必達狀態 + 多 AI 具象化規範**：

- §0 概念位階：Init = 使用者分身 / 造物主 / 守門人
- §1 四大職責：Summon（召喚）/ Calibrate（校準）/ Sign-in（簽名）/ Gatekeep（守門）
- §2 必達最終狀態（八項，跨 AI 等效）
- §3 各 AI 具象化規範（Claude Code / Gemini CLI / Cursor / 通用 prompt）
- §4 跨 AI 兼容性要求 + 統一就緒回報格式
- §5 替換性保證（無隱性綁定）
- §6 五步驟骨架（保留 v0.4 內容為實作步驟）
- §7 違反處置（跳過 init = F1）
- §8 與其他 core 條款關係

#### B. 配置目錄合併（架構級）

原 `.agentcharter/` 配置目錄合併進 `<common-memory-root>/_config/`：

- 達成「**單一採用識別目錄**」設計
- `agent-commons/` 內部含完整配置 + 內容（清晰分層）
- 工具尋找優先序：先 `agent-commons/_config/`，沒有則掃專案根找符合 `<dir>/_config/profile.yaml` 的目錄

### Modified

- `core/charter-config.md` schema 升 v0.5.0：配置位置變更 + 工具尋找優先序段
- `core/common-memory-root.md` §3 必含子槽位加 `_config/`；§8 命名規則加 `_config/` 條目
- `templates/agent-commons/_role.md.tpl` 大改：加多 AI init 位置表、切換歷史審計欄位、統一就緒回報格式
- `examples/cryptobot/mapping.md` §0：對齊 v0.5.0 配置位置（CryptoBot 沿用 `management/`，配置在 `management/_config/`）

### 動機

使用者提兩個議題：

1. **`.agentcharter/` 應併進 `agent-commons/`**：兩個 dot-folder 違反「單一採用識別」原則。合併後看到 `agent-commons/` ＝ 整套框架就位。
2. **`.claude/commands/<role>-init.md` 不該只限 Claude**：Init 是「造物主級」職責，相當於使用者分身。框架應先定義抽象職責，讓各 AI 廠商自行具象化到自己的 slash command 系統，達成可替代化。

兩件事都涉及架構級概念（採用識別 / 角色召喚），故 minor version 升 0.5.0。

### Added — agent-commons 完整 templates + 命名規則

- `templates/agent-commons/capsule.md.tpl` — 任務膠囊範本（依 CryptoBot 真實格式 1:1 萃取，含動機 / 根因 / 修法範圍 / 修法方案 / VCP / 權責 / 連動更新 / 歷史紀錄區）
- `templates/agent-commons/handoff.md.tpl` — HANDOFF 範本（里程碑摘要 / 核心事件 / src 變更清單 / 測試指標 / 膠囊清單 / Protocols 軌跡 / IM 引述 / 紀律事件 / 待 commit 清單）
- `templates/agent-commons/institutional-memory-entry.md.tpl` — IM 章節範本（強制五段格式：症狀 → 根因 → 診斷 → 修法 → 預防）
- `templates/agent-commons/nextwork.md.tpl` — NextWork 範本（執行中 / 待處理 / 已驗證 / 即將開始衝刺）
- `templates/agent-commons/domain-axioms.md.tpl` — 領域公理範本（血鐵律 / 架構鐵律分梯，每條含「後果」段，僅限增加 / 刪除三重授權）
- `templates/agent-commons/_role.md.tpl` — 角色識別檔範本

### Changed

- `core/common-memory-root.md` 加 §8 命名規則（檔名規則 / 路徑明確性 / templates 對應）

### 動機

使用者要求 agent-commons/ 內容**完全按照 CryptoBot 模式**。CryptoBot 的 `management/` + `ai_ops/capsules/` 經 S60〜S70 多事件實戰驗證為有效模式，從中萃取 6 份 templates 為框架預設。新採用框架的專案直接套 templates 即可。

每份 template 含「模板使用指南」段說明變數替換、撰寫紀律、與框架其他條款的對應。

### Added — 架構級約定（Common Memory Root）

- `core/common-memory-root.md` — **架構級約定**：多 AI 共享資產必須位於單一根目錄（預設 `agent-commons/`）。採用識別（看到 `agent-commons/` ＝ 此專案採用 AgentCharter）。允許名稱覆寫但禁止分散。

### Changed

- `core/charter-config.md` — mapping.yaml schema 升 v0.4.1：加 `common_memory_root` 必填欄位；`shared.*` / `roles.*` / `domain_axioms.primary` / `state.*` 路徑改為相對於 common_memory_root；相依表加上「所有條款依賴 common-memory-root」
- `templates/management-layout.md` — 預設根目錄從 `management/` 改為 `agent-commons/`；首段引用 common-memory-root.md 強調架構約束
- `examples/cryptobot/mapping.md` — 加 §0：CryptoBot 沿用 `management/` 為向後相容覆寫範例
- `README.md` — 加 A4 公理「架構級約定」+ core 條款列表

### 動機

使用者提兩件事：(1) 框架熱插拔（v0.4 已支援）；(2) AI 間運作流程基於 management 為共同記憶路徑。第二點原本只在 templates 提到，未條款化 → 補為 core 條款，升為架構級約束。

預設名稱 `agent-commons/` 取自「agent + commons（共同地）」概念，唯一性高、與 `.agentcharter/` 配置目錄不衝突；既有專案（如 CryptoBot）可透過 mapping.yaml 覆寫沿用既有名稱。
- 邀請 Gemini CLI 端提交 `roles/pm/gemini-cli.md`
- CryptoBot 改為 *引用* 框架而非重複維護
- 評估 IRON Pattern（Double Insurance、ACL）抽到框架的可行性
- **B2 子條款層級配置**（profile.yaml `sections.<§>` 開關）— v0.5+ 候選
- **`/charter-{scan,init,doctor}` reference impl**（v0.4 為 spec only，實際工具留 v0.5+）

---

## [0.4.0] — 2026-04-27

### Added — 工具化接入（Spec only）

- `core/charter-config.md` — mapping.yaml + profile.yaml schema 定義；含相依表、解析優先序、違反處置
- `tools/scan-spec.md` — `/charter-scan` 智慧掃描器設計（A3 LLM 內容判讀）
- `tools/init-spec.md` — `/charter-init <preset>` 接入流程設計（5 phase + 失敗回滾）
- `tools/doctor-spec.md` — `/charter-doctor` 健康檢查設計（含 status code 表）
- `tools/profiles/minimal.yaml` — 探索型 / 單人 + 1 AI（6 條款啟用，寬鬆參數）
- `tools/profiles/standard.yaml` — 一般雙 AI 協作（11 條款全啟用，中等參數）
- `tools/profiles/strict.yaml` — 嚴格合規（11 條款全啟用 + 嚴格上限參數，禁信任邊界揭示）

### Modified

- `README.md` — 加 charter-config 條款列表 + 雙路徑接入流程（自動 vs 手動）

### 設計取捨

- **配置粒度**：v0.4 採 B1（條款層級）+ B3 少量參數；B2 子條款層級留 v0.5+
- **掃描智慧度**：A3 LLM 內容判讀（用 LLM 自己讀檔判斷槽位）
- **實作節奏**：v0.4 純 Spec，無實作程式碼；reference impl 留 v0.5+
- **Spec → Impl 分離**：先把契約釘下，工具實作分階段。所有 spec 文檔含跨版本實作節奏表。

### 動機

S70 事件後使用者提兩個議題（智慧掃描、可插拔優化）。整合命題：讓 AgentCharter 從「規範文件集」進化為「**可被工具讀取與執行的協議**」。透過 mapping.yaml + profile.yaml 雙配置檔，既有專案不需重組目錄即可接入；條款可逐項啟用 / 停用，適配不同嚴格度需求。

---

## [0.3.0] — 2026-04-27

### Added — 防線層 L2 + 結構建議

- `core/violation-reflection.md` — 違規反省條款。承認 LLM 個體不可矯正，反省價值在「未來 AI / 集體記憶」而非矯正當前 AI；結構受 structural-anti-fabrication 強制，廢話本身亦為違規模式證據。
- `templates/management-layout.md` — 推薦的 `management/` 結構範例。依角色分私有區（不依 AI 廠商）；含多重身份場景處置與 git 漸進遷移指引。

### Modified

- `README.md` core 條款列表 + 加入新條目
- `core/audit-rights.md` / `failure-modes.md` 補交叉引用至 violation-reflection

### 動機

S70 事件後使用者複盤「自我反省 vs LLM 個體不可矯正」議題。結論：
1. AI 個體不可矯正是事實，反省不能改變當前 AI 行為
2. 但反省的真實價值在於審計痕跡 + 集體記憶 + 機器可掃描的違規統計
3. 結構強制（v0.2 已加）+ 違規反省（v0.3）+ 升級協議（既有）構成多層防線
4. 同時釐清「角色 vs AI 廠商」分軸 — 私有區依角色分，不依廠商分，支援 1 AI 多角色場景

---

## [0.2.0] — 2026-04-27

### Changed — 強度升級

- `core/structural-anti-fabrication.md` 從「強化抽驗模式必強制」**升為「全模式預設強制」**：所有結案宣告無論模式皆須附 stdout 區塊，缺失即直接退稿不進入內容判讀
- 新增 §7.1 Token 影響說明：短期 +1〜3%，長期顯著減少（避免假宣告事件爆炸性消耗）
- 新增 §7.2 與 eco 模式的相容說明（stdout 屬事實型內容，不在 eco 可砍項）

### 動機

S70 事件後使用者複盤討論：自我 hook 受限於遞迴信任陷阱與形式主義，把驗證搬到結構層才有效。0.1.1 引入後評估 token 影響為「短增長減」，故直接升級為全模式強制，無 v0.2 觀察期。

---

## [0.1.1] — 2026-04-27

### Added

- `core/structural-anti-fabrication.md` — 結構性反捏造條款。把驗證從「AI 自我誠實」搬到「文檔結構強制」：事實型宣告必須含 stdout 區塊，缺即視同未交付。

### Modified

- `README.md` core 條款列表加入新條目
- `core/audit-rights.md` / `evidence-first.md` / `escalation-protocol.md` / `completion-delivery.md` / `failure-modes.md` 補交叉引用至新條款

### 動機

S70 事件診斷後使用者提出「AI 多一個自我 hook 檢驗是不是好事」討論。結論：自我 hook 仍受限於「遞迴信任陷阱」與「形式主義」。更有效的設計是把「驗證」從 AI 行為層搬到文檔結構層 — 沒有 stdout 區塊就連送都送不出，AI 想假宣告無處可放。


---

## [0.1.0] — 2026-04-27

### Added — 初版骨架

#### Core 通用條款（9 份）

- `core/role-separation.md` — 角色互鎖原則
- `core/audit-rights.md` — 抽驗權通用模型
- `core/failure-modes.md` — F1〜F5 失敗模式分類
- `core/escalation-protocol.md` — 強化抽驗 / 結構性失靈 / 使用者裁決
- `core/evidence-first.md` — 實證先行原則
- `core/output-mode-protocol.md` — eco / verbose 模式協議
- `core/completion-delivery.md` — 完工交付契約（VCP / Directive Header / 雙保險 / 危險度標籤）
- `core/handoff-chain.md` — Session 交接鏈
- `core/init-template.md` — 角色 init 五步驟骨架

#### Roles（4 份）

- `roles/engineer/_spec.md` — Engineer 職能定義
- `roles/engineer/claude-code.md` — Claude Code 工程師 reference impl（v0.1）
- `roles/pm/_spec.md` — PM 職能定義
- `roles/pm/gemini-cli.md.placeholder` — 邀請 Gemini 提交

#### Examples（1 份）

- `examples/cryptobot/mapping.md` — CryptoBot ↔ AgentCharter 對照（首個 reference impl）

#### Templates（1 份）

- `templates/role-init.md.tpl` — 任意角色 init slash command 模板

#### Meta（4 份）

- `README.md`
- `GOVERNANCE.md`
- `CONTRIBUTING.md`
- `CHANGELOG.md`（本檔）

### 起源事件

本框架由 CryptoBot 專案 S70 Dashboard PnL 誤判事件後沉澱啟動。事件累積：

- F1（假宣告）×5
- F3（捏造數據）×3
- F5（規則記憶失效）×1
- 觸發強化抽驗 → 結構性失靈 → 使用者裁決選項 B

詳見 `examples/cryptobot/mapping.md §4`。
