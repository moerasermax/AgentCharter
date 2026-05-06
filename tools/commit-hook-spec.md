# /charter-commit-hook — Commit 時結構強制攔截 spec

> **狀態**：v0.10.2（v0.10.0 ship H1-H6、v0.10.2 加 H7 schema-driven 強制必啟集合）
> **位階**：tools / 設計文檔 + reference impl 提供。
> **保證強度**：結構強制（git 原生 pre-commit hook + binary 校驗、commit 時攔截）
> **檢測時點**：commit（pre-commit）
> **since**：v0.10.0（H1-H6）/ v0.10.2（H7）
>
> **動機（H1-H6、v0.10.0）**：6 條同源 dogfood signal（#33 / #35 / #42 / #43 / #44 / #45）累積觀察 — 全部「**單 actor 自律弱保證項**」家族（multi-role-tracking §3.4 PROVISIONAL→ACTIVE 自激活、failure-mode 不自報、individual-learning-loop 雙寫漏對應、reflection 檔名漂浮、reflection vs project state 邊界混淆、cross-AI handoff 缺 directive header）。對應 v0.8.2 §設計哲學第 5 條雙軸「結構強制 > 多 actor 互檢 > 單 actor 自律」— 從自律升結構強制。
>
> **動機（H7、v0.10.2 BREAKING-LITE PATCH）**：3 條同源 dogfood signal 累積爆量觀察 — **#46**（spec 缺四欄結構、≥ 3 次同類）+ **#31**（simulated 跑 spec、≥ 5 次同類）+ **#52** 候選（三層雙重防禦對 F6 強制必啟整體 LIVE 失效）。2026-05-06 公司專案 dbSDK 同 LIVE session：(1) Engineer Claude 跑 verify 全 PASS、F6 缺 = 沒抓 / (2) Gemini PM 跑 doctor 全 PASS + 仍報 stale v0.9.9 = 沒讀真實 profile.yaml + F6 缺 = 沒抓。**spec 紀律寫得再完整、執行載體 LLM 仍可 simulated** — 對應 v0.8.2 §設計哲學第 5 條「弱保證項升結構強制」最赤裸 LIVE 實證 + dogfood signal #27「spec-driven 與 LLM 自律 循環依賴」結構性解。H7 把「強制必啟集合」（如 v0.7.0+ F6）從 init/doctor/verify spec 三處重複描述、歸一為單一 source of truth（`tools/profiles/_required.yaml`）+ binary 攔截不可繞。

---

## 1. 目標

把以下 7 條 LIVE 違反從「LLM 讀規範自律」升級到「commit 時 binary 攔截」：

| 校驗 | 對應 signal | 嚴格度 | since |
|---|---|---|---|
| **H1** `_role.md` Status 升 ACTIVE 字樣校驗 | #35（自激活）| **reject** | v0.10.0 |
| **H2** F-mode 雙寫（commit 提 F-mode → log 必有 entry）| #33（不自報）| **reject** | v0.10.0 |
| **H3** Reflection 檔名 regex 校驗 | #43（檔名漂浮）| **reject** | v0.10.0 |
| **H4** Reflection 含 sprint 編號邊界檢查 | #44（state 混 reflection）| **warn** | v0.10.0 |
| **H5** Log entry 對應 reflection 雙寫 | #42（雙寫漏對應）| **reject** | v0.10.0 |
| **H6** Cross-AI handoff directive header | #45（致 XXX 缺）| **warn** | v0.10.0 |
| **H7** profile.yaml 強制必啟集合校驗（schema-driven） | #46 / #31 / #52（三層防禦對 F6 LIVE 失效）| **reject** | **v0.10.2** |

對應 `core/diagnose-remediate-protocol §4`（v0.9.0 寫精神、v0.10.0 ship H1-H6 實作層、v0.10.2 H7 升維 schema-driven 結構強制最赤裸）。

---

## 2. 架構

### 2.1 三層分工

```
charter 層（規範 + reference）             採用方專案層（每專案自帶）
─────────────────────────────             ───────────────────────────────────
tools/commit-hook-spec.md                 agent-commons/_config/hooks/
  本檔 — 定義 H1-H7 校驗紀律                charter-commit-checks.sh    ← reference 實作 copy
                                             （charter clone / pull 後同步更新）
tools/profiles/_required.yaml ← H7 schema source of truth
  強制必啟集合（v0.10.2 加）

tools/vendor/commons/
  charter-commit-checks.sh   ← canonical  .git/hooks/pre-commit       ← thin shim、3 行
  install-git-hooks.sh       ← 安裝器        exec bash agent-commons/_config/hooks/charter-commit-checks.sh "$@"
                                             （install-git-hooks.sh 一次性裝、不入 git）
```

### 2.2 設計原則

1. **vendor 中立**：攔截走 git 原生 `pre-commit` hook、不寫進 `.claude/hooks/` 或 `.gemini/hooks/` 等 vendor 私有目錄 — 任何工具（Claude Code / Gemini CLI / Kiro / Cursor / 人類手動）執行 `git commit` 都觸發。
2. **跟專案分發**：實際 check 邏輯在 `agent-commons/_config/hooks/`（入 git）、不在 `.git/hooks/`（local-only）。charter 升新檢項 → user `git pull` → 自動帶最新邏輯。
3. **opt-in 安裝**：thin shim 在 `.git/hooks/pre-commit`（local-only），由 `install-git-hooks.sh` 一次性裝入；不裝就不攔（採用方主動權、對齊 `ai-vendor-onboarding §0.3` 邀請制原則）。
4. **bypass 機制**：`git commit --no-verify` 可繞過（user 知情前提）；charter 不阻止這條 git 既有逃生口、但 maintainer-discipline 紀律上記錄繞過事件（依 §6）。

---

## 3. 校驗項（H1-H7 spec-as-data 結構）

> 對齊 `core/diagnose-remediate-protocol §2` 四欄結構（合規規定 / 修補方向 + 約束 / 反例 / 真實 stdout 證據）。

### H1 — `_role.md` Status 升 ACTIVE 字樣校驗（reject）

**合規規定**（charter ground truth）：
- 觸發：commit diff 含 `roles/<role>/_role.md` 內 `Status: PROVISIONAL` → `Status: ACTIVE` 變更
- 必須狀態：該 commit 的 `_role.md` 內含字樣 `Status: ACTIVE — 由 user 於 <date> explicit 授權` **或** Sign-in Log 新增 entry 的「觸發原因」欄含 `user explicit 授權` / `user 授權` 字串
- 對齊條款：`core/multi-role-tracking §3.4.4` + `core/init-template §3.3.2 step 6`

**修補方向 + 約束**：
- ✅ 必動：補 user explicit 授權字樣到 _role.md 或 Sign-in Log entry
- 🚫 不可動：升 ACTIVE 本身（前提：是否真的 user 授權？沒授權就不該升 ACTIVE 而非補假字樣）
- 🚫 不可代決：user 授權字樣不可由 AI 編造 — 必須是 user 真實對話痕跡（如「你可以登入了」/「我授權你接此角色」）

**反例**：
- ❌ AI 自跑 `/engineer-init` → 自改 `Status: ACTIVE` → commit message：「init 完成、role 就緒」 → 無 user 授權字樣
  - ✅ 正解：保持 PROVISIONAL、回報 user「已具象化、等你 explicit 授權」、user 回覆後才升 ACTIVE 並寫授權字樣
- ❌ AI 編造「Status: ACTIVE — 由 user 於 2026-05-04 explicit 授權」字樣但 user 從未說過
  - ✅ 正解：F1 假宣告、應拒絕自升 ACTIVE

**真實 stdout 證據要求**：
- hook reject 後 console 必輸出：`[H1 REJECT] _role.md Status 升 ACTIVE 缺 user explicit 授權字樣（multi-role-tracking §3.4.4）` + 違反檔案路徑

---

### H2 — F-mode 雙寫（reject）

**合規規定**：
- 觸發：commit message 或 diff 內含 F-mode ID（`F1`/`F2`/`F3`/`F4`/`F5`/`F6`、整詞匹配）或 keyword（「假宣告」/「捏造」/「未驗證即宣告」等 F-mode anti-pattern 詞）
- 必須狀態：該 commit 須同時包含 `<common_memory_root>/state/failure_mode_log.md` 新 entry 行 + 對應 `<common_memory_root>/roles/<role>/reflections/<YYYY-MM-DD>_<f-mode>_<short>.md` 新檔
- 對齊條款：`core/individual-learning-loop §2.3` 雙寫紀律 + `core/diagnose-remediate-protocol §4`

**修補方向 + 約束**：
- ✅ 必動：補 log entry + reflection 檔（兩處）
- 🚫 不可動：commit message（保留命中 F-mode 的事實宣告）
- 🚫 不可代決：F-mode 編號 — 必須對齊 failure_mode_log 已登記 ID（不可自編）

**反例**：
- ❌ commit message：「fix F1 假宣告」、但 log 沒新 entry、reflection 沒新檔
  - ✅ 正解：commit 應同時含三處（message + log entry + reflection 檔）

**真實 stdout 證據要求**：
- `[H2 REJECT] commit 提 F-mode <ID> 但雙寫缺漏（individual-learning-loop §2.3）— 缺 <log entry / reflection 檔>`

---

### H3 — Reflection 檔名 regex（reject）

**合規規定**：
- 觸發：commit diff 在 `<common_memory_root>/roles/<role>/reflections/` 路徑下新增 `.md` 檔
- 必須狀態：檔名匹配 regex `^\d{4}-\d{2}-\d{2}_[a-z0-9_-]+\.md$`
- 對齊條款：`core/individual-learning-loop §2.3` 命名紀律 + `templates/agent-commons/reflection.md.tpl` 範本

**修補方向 + 約束**：
- ✅ 必動：rename 檔案匹配 regex
- 🚫 不可動：reflection 內容（命名問題不影響 reflection 內容紀律）

**反例**：
- ❌ `PROTOCOLS.md` / `2026-05-04_PM_Notes.md`（大寫）/ `reflection-on-s36.md`（無日期前綴）
  - ✅ 正解：`2026-05-04_pm_coordination_protocols.md` / `2026-05-04_s36_decision.md`

**真實 stdout 證據要求**：
- `[H3 REJECT] reflection 檔名違反 regex（^\d{4}-\d{2}-\d{2}_<topic>.md$）— <實際檔名>`

---

### H4 — Reflection 含 sprint 編號邊界（warn）

**合規規定**：
- 觸發：H3 通過後額外校驗（reflection 新檔內容掃 regex `\bS\d+\b` 或 capsule 引用）
- 必須狀態：reflection 應為 meta-knowledge、project state 應在 capsules / nextwork
- 對齊條款：`core/individual-learning-loop §2.4` 邊界紀律（reflection vs project state）

**修補方向 + 約束**：
- ✅ 建議動：把 sprint 編號相關內容搬到 capsules 或 nextwork、reflection 留 meta-knowledge
- 🚫 不可動：正當引用（如「S70 違反史複習」是 meta-knowledge 引用、合法）
- ⚠️ **warn 不擋**：因正當引用存在、binary reject 誤殺率高；user 知情後決定是否搬

**反例（warn 提示）**：
- ⚠️ reflection 內容含「S36 決策：先做 S36 再做 S35」（project state 寫進 reflection）
  - ✅ 正解：S36 決策應在 capsule、reflection 寫「跨 AI 協作的優先順序決策應由 PM 寫進 nextwork」（meta-knowledge）

**真實 stdout 證據要求**：
- `[H4 WARN] reflection <檔名> 含 sprint 編號 <S36>，可能誤把 project state 寫入 meta-knowledge 倉（individual-learning-loop §2.4）`

---

### H5 — Log entry 對應 reflection 雙寫（reject）

**合規規定**：
- 觸發：commit diff 包含 `<common_memory_root>/state/failure_mode_log.md` 新 entry 行
- 必須狀態：同 commit 須含對應 `<common_memory_root>/roles/<role>/reflections/<YYYY-MM-DD>_<f-mode>_<short>.md` 新檔
- 對齊條款：`core/individual-learning-loop §2.3` 雙寫紀律（H2 從 commit message 反查、H5 從 log 新 entry 反查、互補）

**修補方向 + 約束**：
- ✅ 必動：補對應 reflection 檔
- 🚫 不可動：log entry 本身（除非真誤加）

**反例**：
- ❌ commit 加 log entry「F1 - 2026-05-05 - 假宣告膠囊已建」、但無對應 reflection 檔
  - ✅ 正解：同 commit 含 `roles/<role>/reflections/2026-05-05_F1_<short>.md`

**真實 stdout 證據要求**：
- `[H5 REJECT] failure_mode_log 加 entry 但對應 reflection 缺檔（個體層雙寫缺漏）`

---

### H6 — Cross-AI handoff Directive Header（warn）

**合規規定**：
- 觸發：commit diff 包含 `<common_memory_root>/handoffs/HANDOFF_<N>.md` 新檔 或 commit message 含「轉交」/「移交」/「致 」字樣
- 必須狀態：handoff 文件須含 `^---\n致 [^\n]+\n` 起始 directive header（regex）
- 對齊條款：`core/cross-ai-handoff §6`（v0.10.0 同步擴增 directive header 紀律明文）

**修補方向 + 約束**：
- ✅ 建議動：handoff 文件加 directive header
- ⚠️ **warn 不擋**：v0.10.0 為 directive header 紀律首次條款化、binary reject 太早；先 warn 累積樣本、v0.10.x+1 再評估升 reject

**反例（warn 提示）**：
- ⚠️ HANDOFF_5.md 內容直接列任務、無 `致 Kiro (Engineer)` 起始
  - ✅ 正解：文件起始 `---\n致 Kiro (Engineer)\n\n<任務內容>\n---`

**真實 stdout 證據要求**：
- `[H6 WARN] handoff <檔名> 缺 directive header「致 XXX」起始（cross-ai-handoff §6）`

---

### H7 — profile.yaml 強制必啟集合校驗（reject、v0.10.2 加）

**合規規定**（charter ground truth）：
- 觸發：每次 commit（profile.yaml 不存在則 graceful skip — pre-init 採用方專案）
- 必須狀態：採用方 `<common_memory_root>/_config/profile.yaml` 對齊 `$CHARTER_DIR/tools/profiles/_required.yaml` 各 entry
- 當前涵蓋（v0.10.2 ship）：
  - **REQ-001-F6**：`parameters.failure-modes.enable_modes` 必含 `F6`（v0.7.0+ standard/strict 強制必啟）
- 對齊條款：
  - `tools/profiles/_required.yaml`（schema source of truth）
  - `core/failure-modes.md §F6`
  - `core/diagnose-remediate-protocol.md §commit hook 結構強制升維紀律`（v0.9.0）
  - `tools/doctor-spec.md §3.7 E605`、`tools/post-upgrade-verify-spec.md §3.2 B002`、`tools/init-spec.md Phase 5b CHECK 7 第 4 條`（三層雙重防禦 spec 層、本 H7 為 binary 強制執行載體）

**修補方向 + 約束**：
- ✅ 必動：依 `_required.yaml` 對應 entry「修法」欄位補 profile.yaml 缺項（如 REQ-001-F6 → `enable_modes` 補 `F6`）
- 🚫 不可動：`_required.yaml` 本身（charter 端 source of truth、採用方無權改）
- 🚫 不可代決：強制必啟集合不可繞、AI 不可建議「跳過 F6」/「縮減 enable_modes」/「諷刺循環沒關係」
- ⚠️ **schema-driven 紀律**：charter maintainer 加新強制必啟欄位（如未來 F7）→ 改 `_required.yaml` 加 entry + 改 `charter-commit-checks.sh` 補對應 inline check function（5-10 行 bash）→ 採用方 `git pull` + `install-git-hooks.sh --update` → 下次 commit 自動驗、採用方無需任何動作

**反例**：
- ❌ profile.yaml `enable_modes: ["F1","F2","F3","F4","F5"]`（缺 F6、dogfood signal #52 LIVE 範本、2026-05-06 dbSDK 公司專案 LIVE 抓到）
  - ✅ 正解：`enable_modes: ["F1","F2","F3","F4","F5","F6"]`
- ❌ AI 跑 doctor / verify 報「全 PASS」、實際 profile.yaml 缺 F6（dogfood signal #46 + #31 family LIVE — spec 紀律 LLM simulated 繞過、binary 攔截不可繞）
  - ✅ 正解：H7 binary 攔截 commit、user 看到 `[H7 REJECT]` 訊息 + 修法路徑、補完才能 commit
- ❌ AI 自改 profile.yaml `enable_modes` 縮減到 `[F1, F2, F3]`（違反 v0.7.0+ 紀律、AI 應保持完整 F1-F6）
  - ✅ 正解：F6 攔截不可繞、E605 / H7 設計是攔截「沒 F6」狀態本身、AI 不可繞過

**真實 stdout 證據要求**：
- hook reject 後 console 必輸出：`[H7 REJECT] profile.yaml parameters.failure-modes.enable_modes 缺 F6 — 見 $CHARTER_DIR/tools/profiles/_required.yaml REQ-001-F6（v0.7.0+ standard/strict 強制必啟、對應 doctor §3.7 E605 / verify §3.2 B002 / init Phase 5b CHECK 7）`

---

## 4. 嚴格度演化階段

| Phase | 範圍 | 嚴格度 |
|---|---|---|
| **Phase 1（v0.10.0 ship）** | spec + reference impl + 安裝器 | H1/H2/H3/H5 reject / H4/H6 warn |
| **Phase 1.5（v0.10.2 ship）** | 加 H7 schema-driven 強制必啟集合（`_required.yaml`）+ 對應 hook H7 inline check | H7 reject（BREAKING-LITE — 採用方升完若 profile 漏強制必啟欄位、下次 commit 被擋）|
| **Phase 2（v0.10.x+1 評估）** | H4/H6 累積 ≥ 5 樣本後評估 + H7 schema 擴 enabled_conditions / mapping / axiom 等 | H4/H6 從 warn 評估升 reject + H7 schema 擴 |
| **Phase 3（v1.x 後）** | 全 binary | 全 reject（除非 user 主動 --no-verify）|

---

## 5. Reference 實作

| 檔案 | 位置 | 用途 |
|---|---|---|
| `tools/vendor/commons/charter-commit-checks.sh` | charter repo（canonical） | 檢項邏輯 reference 實作（bash） |
| `tools/vendor/commons/install-git-hooks.sh` | charter repo（canonical） | 安裝器（裝 thin shim 進 .git/hooks/pre-commit）|
| **`tools/profiles/_required.yaml`**（v0.10.2 加） | charter repo（canonical） | **H7 schema source of truth — 強制必啟集合定義**（採用方無權改、charter 升新欄位即傳播）|
| `agent-commons/_config/hooks/charter-commit-checks.sh` | 採用方專案內 | 從 canonical copy / 升級時 sync |

→ `tools/vendor/commons/` 是 charter 的「vendor 中立共用工具集」目錄、其他工具同住於此（如 `checkpoints_handler.sh`）。完整目錄導覽見 [`tools/vendor/commons/README.md`](./vendor/commons/README.md)。

採用方安裝步驟：

```
# Step 1（charter-init Phase 4.5 順手帶 / 採用方手動）：
bash ~/.agentcharter/tools/vendor/commons/install-git-hooks.sh

# Step 2（charter 升版時 user 跑）：
bash ~/.agentcharter/tools/vendor/commons/install-git-hooks.sh --update
```

charter 升新檢項 → user `git pull ~/.agentcharter` → 跑 `--update` → `agent-commons/_config/hooks/charter-commit-checks.sh` 自動同步。

---

## 6. Bypass 機制（git --no-verify）

git 原生提供 `git commit --no-verify` 繞過 pre-commit hook。charter 不阻止此通道（git 既有設計、不該破壞），但：

| 情境 | 紀律 |
|---|---|
| user 主動 bypass（如緊急修補）| ✅ 合法 — git 既有逃生口 |
| AI 自主 bypass（如 commit 失敗後改用 --no-verify 繞過）| ❌ **F1 假宣告 / 結構性繞路**（依 `core/role-separation §3.5` 找路徑繞過角色約束 = F1）|

未來加固（v0.10.x+1 候選）：post-commit hook 偵測上一次 commit 是否用 --no-verify、若是 AI 觸發則記錄到 `state/failure_mode_log.md` 自動 entry（候選、不在 v0.10.0 範圍）。

---

## 7. 與其他條款的關係

| 條款 | 關係 |
|---|---|
| `core/diagnose-remediate-protocol §4` | v0.9.0 寫精神、本 spec v0.10.0 落實實作層；§4 從「精神階段」升「ship 階段」 |
| `core/individual-learning-loop §2.3` | H2 / H3 / H5 是該條款雙寫紀律 + 命名紀律的執行載體 |
| `core/individual-learning-loop §2.4` | H4 是該條款 reflection vs project state 邊界的執行載體 |
| `core/multi-role-tracking §3.4.4` | H1 是該條款「自激活 = F1」的結構強制執行載體 |
| `core/init-template §3.3.2 step 6` | H1 是 step 6「Status 寫 PROVISIONAL、不寫 Sign-in Log」的結構強制執行載體 |
| `core/cross-ai-handoff §6` | H6 是 directive header 紀律的執行載體（v0.10.0 同步擴增 §6 紀律明文）|
| `core/ai-vendor-onboarding §0.3` | 邀請制原則：採用方自主決定是否安裝 hook（opt-in） |
| `core/failure-modes §F1` | bypass 機制裡 AI 自主 --no-verify = F1 結構性繞路（依 role-separation §3.5）|
| `core/failure-modes §F6` | **H7 是 F6 強制必啟紀律的 binary 執行載體**（v0.10.2 加 — spec 三層雙重防禦 LLM simulated 失效後的結構強制兜底）|
| **`tools/profiles/_required.yaml`**（v0.10.2 加）| **H7 schema source of truth、charter 端強制必啟集合單一定義** |
| `tools/doctor-spec.md` | doctor = 任意時點 advisory 校驗、commit hook = commit 時 binary 攔截；兩層互補（doctor 不擋 commit、hook 擋）。doctor §3.7 E605 是 H7 REQ-001-F6 的 advisory 雙層 |
| `tools/post-upgrade-verify-spec.md` | verify = 升版後 advisory 校驗。verify §3.2 B002 是 H7 REQ-001-F6 的 advisory 雙層；H7 為 commit-time binary 攔截 |
| `tools/init-spec.md Phase 4.5` | charter-init 完成後可呼叫 install-git-hooks.sh 順手裝（採用方體驗）|
| `tools/init-spec.md Phase 5b CHECK 7 第 4 條` | init 端 fail-fast advisory；H7 為 commit-time 結構強制兜底（init advisory + commit binary 雙層）|

---

## 8. 採用方升版指南

| 採用方狀態 | 升版動作 |
|---|---|
| 已採用 charter v0.9.x、未裝 commit hook | charter pull 後跑 `bash ~/.agentcharter/tools/vendor/commons/install-git-hooks.sh`（一次性）+ `agent-commons/_config/profile.yaml` `charter_version: "0.10.0"` |
| 已採用 charter v0.10.0/v0.10.1、新增檢項 | `git pull ~/.agentcharter` 後跑 `install-git-hooks.sh --update` 同步 `charter-commit-checks.sh` |
| **已採用 charter v0.10.x、升 v0.10.2（BREAKING-LITE）** | (1) `git pull ~/.agentcharter` 拿新 `_required.yaml` + H7 hook 邏輯<br>(2) `install-git-hooks.sh --update` 同步 deploy script<br>(3) **檢查 profile.yaml 對齊 `_required.yaml`**（如 REQ-001-F6 → 確認 `enable_modes` 含 F6、補缺項）<br>(4) 改 `charter_version: "0.10.2"`<br>(5) 下次 commit H7 自動驗、有缺項 → reject + 修法路徑 |
| 拒絕安裝 hook（保留 v0.8.x 行為）| 不跑 install-git-hooks.sh、charter v0.10.x 條款仍可用、僅缺 binary 攔截層 |

→ v0.10.0 安裝 hook 不破壞既有專案（純擴增 binary 攔截層、不改既有檔結構）。
→ **v0.10.2 是 BREAKING-LITE PATCH** — 採用方升完若 profile.yaml 漏強制必啟欄位（如缺 F6）、下次 commit 被 H7 擋；對齊 v0.7.0 mislabel 教訓 + user 紀律「有衝突就代表沒有向下兼容」。詳見 `examples/upgrades/v0.10.1-to-v0.10.2.md` walkthrough。

---

## 9. 變更歷史

- **v0.10.0（2026-05-05）** — 初版 spec + reference impl 一次 ship。對應 6 條 dogfood signal（#33/#35/#42/#43/#44/#45）同源「弱保證項升結構強制」家族整合條款化；落實 `core/diagnose-remediate-protocol §4` v0.9.0 精神到實作層。架構走 git 原生 hook + agent-commons 共用 script（vendor 中立）、對齊 v0.7.4 雙軌節奏「頻繁小擴增 PATCH + 大方向新加條款用 MINOR」— 本 ship 為 MINOR（新加 spec 檔 + reference impl + 5 條 condition 加固）。
- **v0.10.2（2026-05-06）** — **BREAKING-LITE PATCH**：加 H7 schema-driven 強制必啟集合 binary 攔截。新檔 `tools/profiles/_required.yaml` 為 H7 source of truth（v0.10.2 ship REQ-001-F6 — `enable_modes` 必含 F6）。`charter-commit-checks.sh` v1.0 → v1.1（加 `check_h7` + `h7_check_f6_enabled`）。對應 dogfood signal 累積爆量（#46 ≥ 3 次 / #31 ≥ 5 次 / #52 候選三層雙重防禦對 F6 LIVE 失效），2026-05-06 公司專案 dbSDK LIVE 抓到 — Engineer Claude verify + Gemini PM doctor 兩個 vendor 同 session 連續 simulated PASS、F6 缺都沒抓、user 親手抓。對應 v0.8.2 §設計哲學第 5 條「弱保證項升結構強制」最赤裸 LIVE 實證 + dogfood signal #27「spec-driven 與 LLM 自律 循環依賴」結構性解。**標 BREAKING-LITE 對齊 user 歷史紀律**「有衝突就代表沒有向下兼容」（v0.7.0 mislabel 教訓）— 升完採用方若 profile 漏強制必啟欄位、下次 commit 被擋。詳見 walkthrough `examples/upgrades/v0.10.1-to-v0.10.2.md`。**未來擴展紀律**：charter 加新強制必啟欄位（如未來 F7）→ 改 `_required.yaml` 加 entry + 改 hook 補對應 inline check function（5-10 行 bash）→ 採用方 git pull 即傳播，不需再加 H8/H9。
