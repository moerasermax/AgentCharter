# /charter-upgrade-verify — 升版後標準驗證流程設計

> **狀態**：v0.9.0（純 spec — 由 AI 自具象化執行；模式 A v0.8.0 ship、模式 B/C v0.9.0 ship）
> **位階**：tools / 設計文檔；與 `init-spec.md` / `doctor-spec.md` / `scan-spec.md` 並列
> **觸發來源**：user 2026-04-29 LIVE 提議「**升版後需要一個檢核機制、看目前的文件狀態、`~/.agentcharter`、目前 agent-commons 哪些標準的格式不合規等**」+ YC v0.7.4 → v0.7.5 升版實證 + dogfood signal #23（Phase 5b CHECK 7 axiom status gap）累積 2 次同類觸發
> **實作模式**：採用方對 AI 下 prompt「依本 spec 自具象化 `/charter-upgrade-verify` slash command 給未來重用」，AI 完成具象化後 user 跑 `/charter-upgrade-verify` 取得 5 軸校驗報告。

---

## 1. 目標

驗證採用方升版**完成後**的狀態完整性 — **vs `doctor-spec`** 的通用 schema validation 補充：

- charter clone 對齊（user 宣稱版本 vs charter clone 實際 git 狀態）
- 本專案 schema 對齊當前 charter spec
- agent-commons/ 結構合規（含 v0.7.0 namespace 紀律 + v0.7.4 vendor schema）
- axiom 紀律對齊（含 v0.7.1 路徑 B status 紀律 — dogfood signal #23 條款化執行載體）
- stale reference 跨檔對齊（含 v0.7.6 QUICKSTART swap 後 step 編號 stale 偵測）

**vs `versioning-migration §3` 升版過程流程**：本工具規範升版**之後**驗證；§3 規範升版**過程**動作流。

**vs `doctor-spec` 通用健康檢查**：doctor 任意時點驗 schema；本工具升版專屬 + 跨多版累積遺漏偵測。

---

## 2. 用法

```
/charter-upgrade-verify                # 模式 A 完整 5 軸（預設）
/charter-upgrade-verify --diff         # 模式 B 升版 diff（v0.9.0 加）
/charter-upgrade-verify --mode-c       # 模式 C pre-commit sync-check 子集（v0.9.0 加）
/charter-upgrade-verify --json         # 輸出 machine-readable 格式
/charter-upgrade-verify --strict       # 將 WARN 升為 ERROR（CI/pre-commit 用）
/charter-upgrade-verify --diff --json  # 模式 B + JSON 輸出（升版 walkthrough 自動化用）
```

### 2.1 呼叫模式

| 模式 | 觸發者 | 用途 | 失敗處置 |
|---|---|---|---|
| **A. 完整健康檢查（Full Verify）** | 採用方使用者 | 升版完成後 / 任意時點驗證升版完整度 | 列 errors / warnings；user 決定是否修補 |
| **B. 升版 diff 模式**（v0.9.0 ship） | 採用方使用者 / 升版 walkthrough Step 5 | 對比 charter clone 跨 commit 變動、顯化本次升版引入的新 condition / 新範本 / 新 spec / 新 ERROR/WARN | 列 introduced 項目；user 對齊 walkthrough Step 3 修補 |
| **C. pre-commit sync-check**（v0.9.0 ship） | git pre-commit hook（採用方 vendor 邀請制） | commit message 標 charter_version 變動時、自動跑軸 E（stale reference）+ 軸 B/C 部分項 | hook fail 阻止 commit；走 vendor 邀請制（charter 不附 binary、依 `core/ai-vendor-onboarding §3`）|

> **v0.8.0 ship 模式 A**；**v0.9.0 ship 模式 B + C**（dogfood signal #34 條款化同期、charter 紀律完整性升維配套）。對齊 v0.7.3 北極星「向下兼容嚴守」紀律 — 模式 B/C 既有採用方升版前**不強制**、走 walkthrough Step 5 推薦或 vendor 自主邀請。

---

## 3. 五軸校驗範圍

### 3.1 軸 A：charter clone 對齊

驗證採用方使用的 charter 副本（`~/.agentcharter` 或 `$AGENTCHARTER_HOME`）是否真的對應採用方 profile.yaml 宣稱的版本。

**檢查項**：

| ID | 檢查 | 嚴重度 |
|---|---|---|
| **A001** | `~/.agentcharter` git log 含採用方 profile.yaml `charter_version` 對應 tag / commit | ERROR |
| **A002** | charter clone `core/*.md` 數量對齊當前 charter version 預期（依 charter `__version__` 寫死或 schema 推算） | WARN |
| **A003** | `~/.agentcharter` 是否乾淨 git working tree（無 uncommitted 修改 — 防 user 自改 charter 後忘記） | WARN |
| **A004** | charter clone `templates/agent-commons/` 含當前版本引入的 key templates（version-gated；如 v0.9.0 引入 `reflection.md.tpl`）| WARN |

**對應檢查命令範例**：

```bash
# A001
cd $AGENTCHARTER_HOME
git log --oneline | grep -i "v$(yq '.charter_version' agent-commons/_config/profile.yaml)"

# A003
cd $AGENTCHARTER_HOME && git status --porcelain

# A004（以 v0.9.0 為例）
ls $AGENTCHARTER_HOME/templates/agent-commons/reflection.md.tpl 2>/dev/null \
  && echo "A004 PASS" || echo "A004 WARN: reflection.md.tpl missing — charter clone pre-v0.9.0"
```

**A004 version-gated template 清單（依 charter 版本累積）**：

| charter 版本 | 引入 template | 缺則 A004 WARN |
|---|---|---|
| v0.4.2 | `capsule.md.tpl` / `handoff.md.tpl` / `institutional-memory-entry.md.tpl` / `nextwork.md.tpl` / `domain-axioms.md.tpl` / `_role.md.tpl` | 6 份基礎 templates — 若缺表示 charter clone 嚴重過舊 |
| v0.9.0 | `reflection.md.tpl` | 個體學習迴圈範本（`core/individual-learning-loop §2` 寫紀律執行載體）|

#### A001 詳盡引導（v0.10.3 加；SSS S3 spec-as-data propagate 終局）

**合規規定**：
- 觸發：每次跑 verify、軸 A 起手第一項
- 必須狀態：framework `~/.agentcharter` git log 含**採用方 profile.yaml `charter_version` 對應 commit / tag**（不是 framework HEAD commit）
- 對齊條款：`core/charter-config.md §3` charter_version 紀律 + `core/init-template §3.3.2 step 0.5`（v0.10.1 step 0.5 三分支：framework > project = 合法 INFO / framework < project = 異常 ERROR）

**修補方向 + 約束**：
- ✅ 必動：framework < project 時跑 `cd $AGENTCHARTER_HOME && git pull origin main`（拉 framework 升版）
- 🚫 不可動：採用方 profile.yaml `charter_version` 自降到 framework 當前版本（保留歷史宣告版本、user 升專案是 explicit 動作）
- 🚫 不可代決：framework > project（合法）不該報 ERROR — 是 INFO（step 0.5 case b 設計）；AI 不可建議「升 profile.yaml 對齊 framework」
- **推薦路徑**：framework > project → 報 INFO 不擋執行 / framework == project → PASS / framework < project → ERROR 中止

**反例**：
- ❌ AI 報「d27db6c 為 v0.10.1 最新 commit、A001 PASS」← framework HEAD commit、不是 v0.9.9 grep 結果（dogfood signal #46 第 2 次 LIVE、2026-05-06 dbSDK Engineer Claude verify、rationale 錯但結論碰巧 PASS）
  - ✅ 正解：實跑 `git log --oneline | grep -i "v0.9.9"` → 看 stdout 含 v0.9.9 對應 commit hash
- ❌ AI 看「project v0.9.9 vs framework v0.10.1」直接報 WARN（dogfood signal #46 第 1 次 LIVE、2026-05-04 CryptoBot Gemini PM verify）
  - ✅ 正解：軸 A 嚴重度只有 PASS / ERROR，沒 WARN 選項；framework > project = git log 必含 project commit = PASS（step 0.5 case b 設計、framework 比 project 新合法）
- ❌ AI 不實跑 git log grep、靠推斷編 stdout 報 PASS（dogfood signal #31 family、≥ 5 次同類）
  - ✅ 正解：必貼 binary stdout（見「真實 stdout 證據要求」）

**真實 stdout 證據要求**：
- check 命令：`cd $AGENTCHARTER_HOME && git log --oneline | grep -i "v$(yq '.charter_version' agent-commons/_config/profile.yaml)"`
- PASS 時 stdout 必含：grep 結果至少一行（commit hash + 訊息含 project version 字樣）
- ERROR 時 stdout 必含：grep 無輸出（exit code != 0）+ git log first 5 lines（顯示 framework 最新但不含 project version）
- 純文字 PASS / FAIL 缺 stdout = `core/violation-reflection §1` 假宣告（抽驗方有權直接退稿）

#### A002 詳盡引導（v0.10.3 加）

**合規規定**：
- 觸發：軸 A 第二項、A001 PASS 後續跑
- 必須狀態：charter clone `core/*.md` 數量對齊當前 charter version 預期（v0.9.0 起 25 條、v0.10.x 仍 25 條）
- 對齊條款：`README.md §核心通用條款` + `core/condition-mutability §1`

**修補方向 + 約束**：
- ✅ 必動：數量不對齊 → 跑 `cd $AGENTCHARTER_HOME && git pull origin main` 拿最新 charter
- 🚫 不可動：自加 condition 到 charter clone（charter 是規範庫、採用方無權自加）
- ⚠️ **WARN 不擋**：數量偏差不該升 ERROR — 屬「charter clone 過舊」提示、合規但建議升

**反例**：
- ❌ 採用方 fork charter 後砍掉幾條 condition（如「我們不需要 audit-rights」）→ core/*.md 23 條而不是 25
  - ✅ 正解：fork 應在 profile.yaml.enabled 關閉條款、不刪 charter clone 檔案
- ❌ AI 看「core/*.md 25 條」就報 PASS、沒實跑 ls / find 命令
  - ✅ 正解：必貼 ls 實際 stdout、看到具體 25 個檔名

**真實 stdout 證據要求**：
- check 命令：`ls $AGENTCHARTER_HOME/core/*.md | wc -l`
- PASS 時 stdout：`25`（v0.10.x 預期值）
- WARN 時 stdout：實際數字（如 `23` / `21`）+ 「charter clone 過舊建議 git pull」提示

#### A003 詳盡引導（v0.10.3 加）

**合規規定**：
- 觸發：軸 A 第三項
- 必須狀態：framework `~/.agentcharter` 是乾淨 git working tree（無 uncommitted 修改）
- 對齊條款：`core/maintainer-discipline §3` 三層機制（framework 端紀律、不該被採用方修改）

**修補方向 + 約束**：
- ✅ 必動：發現 modified → user review 是否誤改 charter clone、若是 user 真要改 charter（如試 patch）應 fork 而非直接改 clone
- 🚫 不可動：自動丟棄 user modified（可能 user 在試新 idea、不該 force checkout）
- ⚠️ **WARN 不擋**：user 知情下試 patch 是合法、本 check 是「提醒」非「攔截」

**反例**：
- ❌ user 在 `~/.agentcharter/core/` 改條款試效果、忘記 commit → working tree dirty
  - ✅ 正解：A003 提醒 user 看到 modified 狀態 → user 決定是 commit / discard / fork
- ❌ AI 直接 `git checkout .` 強制清乾淨（破壞 user 在試的 patch）
  - ✅ 正解：列 modified 檔案、user 自決

**真實 stdout 證據要求**：
- check 命令：`cd $AGENTCHARTER_HOME && git status --porcelain`
- PASS 時 stdout：空（無輸出）
- WARN 時 stdout：modified 檔案列表（如 ` M core/audit-rights.md`）

#### A004 詳盡引導（v0.10.3 加）

**合規規定**：
- 觸發：軸 A 第四項
- 必須狀態：charter clone `templates/agent-commons/` 含當前 charter version 引入的 key templates（version-gated 清單見上方表格）
- 對齊條款：`core/individual-learning-loop §2` 雙寫紀律（reflection.md.tpl 是執行載體、v0.9.0 引入）

**修補方向 + 約束**：
- ✅ 必動：缺 key template → `cd $AGENTCHARTER_HOME && git pull origin main` 拿最新（template 變動跟著 charter version 升）
- 🚫 不可動：自寫 template 替代缺檔（charter source of truth 在 framework、不在採用方）
- ⚠️ **WARN 不擋**：缺 template 採用方仍可工作（advisory 模式）、但個體學習迴圈紀律降級

**反例**：
- ❌ charter clone 在 v0.8.x 沒升、`reflection.md.tpl` 不存在、採用方 AI 命中 F-mode 後自編 reflection 格式（dogfood signal #38 同源）
  - ✅ 正解：升 framework 到 v0.9.0+、reflection.md.tpl 自帶
- ❌ AI 看「目錄裡好像有就 PASS」、沒實 ls 確認檔名
  - ✅ 正解：實跑 ls 命令、看到具體檔名

**真實 stdout 證據要求**：
- check 命令：`ls $AGENTCHARTER_HOME/templates/agent-commons/reflection.md.tpl 2>/dev/null && echo PASS || echo "WARN: missing"`
- PASS 時 stdout：`<path>` + `PASS`
- WARN 時 stdout：`WARN: missing`（具體列哪份缺）

### 3.2 軸 B：本專案 schema 對齊

驗證 profile.yaml + mapping.yaml 對齊當前 charter spec 預期。

**檢查項**：

| ID | 檢查 | 嚴重度 |
|---|---|---|
| **B001** | profile.yaml 啟用條款數對齊當前 charter spec preset 預期（standard = 18/19、minimal = 9/19、strict = 18/19）| ERROR |
| **B002** | profile.yaml `enable_modes` 含當前 charter 強制必啟 modes（v0.7.0+ 必啟 F6） | ERROR |
| **B003** | profile.yaml `parameters.<condition>.*` 對齊條款 spec 預期欄位（schema-driven、依 charter clone 條款 frontmatter） | WARN |
| **B004** | mapping.yaml `common_memory_root` 必填 + layout namespace 結構合規（v0.7.0 charter-config §3 namespace 紀律）| ERROR |
| **B005** | mapping.yaml `working_stack_discipline.shared.draft_context` + `archive` 必填（v0.5.7） | ERROR |

#### B001 詳盡引導（v0.10.3 加）

**合規規定**：
- 觸發：軸 B 起手第一項
- 必須狀態：`profile.yaml.enabled` 條款數對齊當前 charter version preset 預期：
  - **standard**：22 / 25（v0.9.0+）
  - **strict**：22 / 25（同 standard、嚴格度差在 parameters）
  - **minimal**：12 / 25
  - **essential**：5 / 25（v0.9.0 加）
- 對齊條款：`tools/profiles/standard.yaml` / `strict.yaml` / `minimal.yaml` / `essential.yaml`（charter 端 source of truth）

**修補方向 + 約束**：
- ✅ 必動：條款數低於 preset 預期 → 補對應 condition 到 enabled list（依 charter clone preset yaml 對齊）
- 🚫 不可動：preset 名（如 standard）改名以躲檢查（preset 是強制集合定義、改名 = 違反 schema）
- 🚫 不可代決：「這條 condition 我不啟用」如果 preset 預期啟用、屬 spec drift；走 `core/condition-mutability §3` 三層 mutability 紀律 + maintainer 簽收

**反例**：
- ❌ profile.yaml `preset: standard` 但 enabled 只 18 條（漏新加的 4 條 v0.9.0 condition）→ B001 ERROR
  - ✅ 正解：升 charter_version 時對齊 preset yaml 補 4 條（diagnose-remediate-protocol / individual-learning-loop / adoption-lifecycle / condition-mutability）
- ❌ AI 自動把 enabled 縮減到 18 條 + 改 preset name 到「standard-lite」躲檢查
  - ✅ 正解：要關 condition 走 condition-mutability §3 user-initiated consolidation、不可繞 schema

**真實 stdout 證據要求**：
- check 命令：`yq '.enabled | length' agent-commons/_config/profile.yaml` + `yq '.enabled | length' $AGENTCHARTER_HOME/tools/profiles/<preset>.yaml`
- PASS 時 stdout：兩數相等（如 `22` / `22`）
- ERROR 時 stdout：兩數不等 + 列差集（如 `enabled diff: 缺 [diagnose-remediate-protocol, individual-learning-loop, ...]`）

#### B002 詳盡引導（v0.10.3 加；對應 v0.10.2 H7 binary 攔截 advisory 雙層）

**合規規定**：
- 觸發：軸 B 第二項、profile.yaml schema 必跑
- 必須狀態：`parameters.failure-modes.enable_modes` 含**當前 charter 強制必啟 modes**（v0.7.0+ 必啟 `F6`、未來 F7/F8 由 `tools/profiles/_required.yaml` 規範）
- 對齊條款：`tools/profiles/_required.yaml` REQ-001-F6（v0.10.2 ship、schema source of truth）+ `core/failure-modes §F6` + `tools/doctor-spec.md §3.7 E605` + `tools/commit-hook-spec.md §3 H7`

**修補方向 + 約束**：
- ✅ 必動：補缺項到 enable_modes 列表（如 `["F1","F2","F3","F4","F5","F6"]`）
- 🚫 不可動：縮減 enable_modes（如改成 `["F1","F2","F3"]` 躲驗）
- 🚫 不可代決：F6 不可不啟、AI 不可建議「諷刺循環、沒 F6 也沒關係」（v0.7.0 公司接入失敗 + 2026-05-06 dbSDK LIVE 兩次同類）

**反例**：
- ❌ profile.yaml `enable_modes: ["F1","F2","F3","F4","F5"]`（缺 F6、dogfood signal #52 LIVE 範本、2026-05-06 dbSDK 公司專案抓到）
  - ✅ 正解：補 F6 → `["F1","F2","F3","F4","F5","F6"]`
- ❌ AI 跑 verify 報「全 PASS」、實際 profile 缺 F6、沒抓（dogfood signal #46 + #31 LIVE — 三層雙重防禦對 F6 整體 LIVE 失效）
  - ✅ 正解：v0.10.2 後 H7 binary commit 時擋、advisory 層（本 B002 + doctor §3.7 E605）依舊 advisory 抓
- ❌ AI 建議「跳過 F6」/「F6 沒啟用也能跑」/「諷刺循環沒關係」
  - ✅ 正解：F6 攔截不可繞、是 dogfood signal #4 條款化要求；E605 / H7 設計是攔截「沒 F6」狀態本身、AI 不可繞過

**真實 stdout 證據要求**：
- check 命令：`yq '.parameters.failure-modes.enable_modes' agent-commons/_config/profile.yaml | grep -c '"F6"'`
- PASS 時 stdout：`1`（含 F6）
- ERROR 時 stdout：`0`（缺 F6）+ 完整 enable_modes 列表 + 修法路徑指向 `_required.yaml` REQ-001-F6

#### B003 詳盡引導（v0.10.3 加）

**合規規定**：
- 觸發：軸 B 第三項
- 必須狀態：`profile.yaml.parameters.<condition>.*` 各 condition 的參數欄位對齊 charter clone condition spec frontmatter（schema-driven、依 condition .md 開頭 yaml frontmatter 推算）
- 對齊條款：`core/charter-config §B2 子條款層級配置` + 各 condition .md frontmatter

**修補方向 + 約束**：
- ✅ 建議動：依 condition spec 補對應參數欄位（如 audit-rights 加 level / autorun_keywords 等）
- 🚫 不可動：寫不存在的欄位（自編 schema）
- ⚠️ **WARN 不擋**：參數欄位偏移屬 spec drift、不必擋 commit；user 可逐個對齊

**反例**：
- ❌ profile.yaml `parameters.audit-rights.level: "Ultra"`（不存在的值、應為 `lite/standard/strict`）
  - ✅ 正解：依 condition spec 列出 valid values、選一個
- ❌ 自加 `parameters.audit-rights.custom_field: "abc"`（非 spec 定義欄位）
  - ✅ 正解：B003 抓 WARN 提示「欄位非 charter spec 定義」、user 移除或 escalate maintainer

**真實 stdout 證據要求**：
- check 命令（每 condition 跑）：`yq '.parameters.<condition> | keys' agent-commons/_config/profile.yaml` 對比 `head -30 $AGENTCHARTER_HOME/core/<condition>.md` frontmatter `parameters_schema:` 段
- WARN 時 stdout：列出 unknown / missing fields

#### B004 詳盡引導（v0.10.3 加）

**合規規定**：
- 觸發：軸 B 第四項
- 必須狀態：`mapping.yaml.common_memory_root` 必填（非空字串）+ `layout.<key>` 各 value 不含 namespace 同名中介層（如 `shared/<X>/`、違反 v0.7.0 namespace 紀律）
- 對齊條款：`core/charter-config §3` mapping schema namespace 紀律 + `tools/doctor-spec.md §3.7 E601`

**修補方向 + 約束**：
- ✅ 必動：移除 mapping value 中的 `shared/` 中介層（如 `shared/capsules/` → `capsules/`）+ 物理目錄同步搬移到頂層
- 🚫 不可動：layout key 名（key 是 schema namespace 標識、value 才是檔案路徑）
- 🚫 不可代決：自加新 layout key 不在 charter charter-config schema 中（schema-driven、不可自編）

**反例**：
- ❌ mapping.yaml `layout.capsules: "shared/capsules/"` + 物理目錄 `agent-commons/shared/capsules/` 存在（違反 v0.7.0 namespace 紀律、F6 surface vs structural sub-pattern）
  - ✅ 正解：mapping `layout.capsules: "capsules/"` + 物理目錄 `agent-commons/capsules/`
- ❌ common_memory_root 設為空字串或不存在（schema fail）
  - ✅ 正解：設為 `"agent-commons"`（charter 預設、對應 `core/common-memory-root.md`）

**真實 stdout 證據要求**：
- check 命令：`yq '.common_memory_root' agent-commons/_config/mapping.yaml` + `yq '.layout' agent-commons/_config/mapping.yaml | grep -E "shared/"`
- PASS 時 stdout：common_memory_root 非空 + grep 無輸出（沒 shared/ 中介層）
- ERROR 時 stdout：common_memory_root 空 OR grep 有輸出（顯示違反項）

#### B005 詳盡引導（v0.10.3 加）

**合規規定**：
- 觸發：軸 B 第五項
- 必須狀態：mapping.yaml `working_stack_discipline.shared.draft_context` 必填 + `working_stack_discipline.shared.archive` 必填（v0.5.7 條款化的 DRAFT 暫存堆疊執行載體）
- 對齊條款：`core/working-stack-discipline §3` DRAFT 紀律

**修補方向 + 約束**：
- ✅ 必動：補兩 field 到 mapping.yaml（推薦 default：`draft_context: "drafts/DRAFT_CONTEXT.md"` / `archive: "drafts/archive/"`、對應 charter scaffold）
- 🚫 不可動：刪除 working_stack_discipline 欄位繞檢（這是 charter 強制必啟 schema 必填）

**反例**：
- ❌ mapping.yaml 完全沒 `working_stack_discipline.*`（v0.5.6 之前的 mapping 漏升）
  - ✅ 正解：補完整 working_stack_discipline.shared 段
- ❌ 寫 `draft_context: ""` 空字串
  - ✅ 正解：設具體相對路徑

**真實 stdout 證據要求**：
- check 命令：`yq '.working_stack_discipline.shared.draft_context, .working_stack_discipline.shared.archive' agent-commons/_config/mapping.yaml`
- PASS 時 stdout：兩 field 都有具體值
- ERROR 時 stdout：null 或 missing

### 3.3 軸 C：agent-commons/ 結構合規

驗證 agent-commons/ 物理結構符合 v0.4〜v0.7 累積紀律。

**檢查項**：

| ID | 檢查 | 嚴重度 |
|---|---|---|
| **C001** | `agent-commons/shared/` **不存在**（v0.7.0 namespace 紀律 — `shared.*` 是 schema namespace 不是檔案目錄） | ERROR |
| **C002** | agent-commons/ 頂層含 capsules / handoffs / protocols / institutional-memory / state（不在 shared/ 子層） | ERROR |
| **C003** | `agent-commons/roles/<role>/_role.md` Status 為 `PROVISIONAL` 或 `ACTIVE`（v0.7.0 二態紀律） | ERROR |
| **C004** | `ACTIVE` 狀態的 `_role.md` 必有 Sign-in Log 至少一筆（user explicit 授權追溯） | ERROR |
| **C005** | vendor 端 toml / md 檔案結構符合 vendor schema（v0.7.4 §3.6 / §4.1 — 本軸 v0.8+ 啟用、依 doctor §3.8 對齊） | ERROR |

#### C001 詳盡引導（v0.10.3 加；對齊 doctor §3.7 E602 advisory 雙層）

**合規規定**：
- 觸發：軸 C 起手第一項
- 必須狀態：`<common_memory_root>/shared/` 物理目錄**不存在**（v0.7.0 namespace 紀律：`shared.*` 是 schema namespace、不是檔案目錄）
- 對齊條款：`core/charter-config §3` mapping namespace 紀律 + `tools/doctor-spec.md §3.7 E602` + `core/failure-modes §F6`（surface vs structural、shared/ 物理存在 = surface mistake）

**修補方向 + 約束**：
- ✅ 必動：清掉 `agent-commons/shared/` 目錄、把內容搬到頂層（如 `agent-commons/shared/capsules/*` → `agent-commons/capsules/*`）
- ✅ 配套必動：同步改 mapping.yaml `layout.<key>` value 移除 `shared/` 前綴
- 🚫 不可動：保留 shared/ 子目錄當作 namespace 表達（charter schema 不該被翻譯為檔案系統目錄、是 F6 surface vs structural 反例）

**反例**：
- ❌ `agent-commons/shared/capsules/TASK_001.md`（屬 v0.7.0 公司接入失敗 LIVE 範本、Gemini 把 schema namespace 翻譯為檔案系統目錄、命中 F6 sub-pattern）
  - ✅ 正解：`agent-commons/capsules/TASK_001.md`（頂層）+ mapping.yaml `layout.capsules: "capsules/"`
- ❌ AI 跑 verify 沒實 ls、自報「shared/ 不存在 PASS」
  - ✅ 正解：實跑 `ls -la agent-commons/shared 2>&1` + 看到 `No such file or directory` 才能報 PASS

**真實 stdout 證據要求**：
- check 命令：`ls -la $PROJ_ROOT/agent-commons/shared 2>&1`
- PASS 時 stdout：`ls: cannot access ... shared: No such file or directory`
- ERROR 時 stdout：列出 shared/ 子目錄結構（如 `drwxr-xr-x ... shared/capsules/`）+ 提示「依 v0.7.0 namespace 紀律清掉」

#### C002 詳盡引導（v0.10.3 加）

**合規規定**：
- 觸發：軸 C 第二項、C001 PASS 後續跑
- 必須狀態：agent-commons/ 頂層含 `capsules/` / `handoffs/` / `protocols/` / `institutional-memory/` / `state/` 五目錄（v0.4.2 standard scaffold）
- 對齊條款：`core/common-memory-root §2` agent-commons 結構紀律 + `tools/init-spec.md` Phase 3.5（v0.9.1 加 scaffold 預建、避免「平行獨語」反模式）

**修補方向 + 約束**：
- ✅ 必動：缺項目錄 → mkdir 補建（lazy create OK、空目錄留 .gitkeep）
- 🚫 不可動：把目錄移到 shared/ 子層（違反 v0.7.0 namespace、命中 C001 同源錯誤）
- 🚫 不可代決：合併目錄（如 capsules + handoffs 合一）— charter 設計這五目錄各有職責邊界

**反例**：
- ❌ `agent-commons/` 只有 `_config/` + `roles/`、缺五目錄（v0.9.1 dogfood signal #36「平行獨語」反模式 LIVE）
  - ✅ 正解：跑 doctor `--fix` 模式 C 互動式 Gap 遷移、或手動 mkdir + .gitkeep
- ❌ AI 不實 ls 確認、自報「結構合規 PASS」
  - ✅ 正解：實跑 ls + 看到具體五目錄

**真實 stdout 證據要求**：
- check 命令：`ls -d $PROJ_ROOT/agent-commons/{capsules,handoffs,protocols,institutional-memory,state} 2>&1`
- PASS 時 stdout：五個目錄路徑全部列出
- ERROR 時 stdout：缺項顯示 `cannot access ... No such file or directory` + 列出缺哪幾個

#### C003 詳盡引導（v0.10.3 加；對應 v0.10.0 commit-hook H1 binary 攔截 advisory 雙層）

**合規規定**：
- 觸發：軸 C 第三項、依採用方有幾個 role 跑幾次
- 必須狀態：`agent-commons/roles/<role>/_role.md` 的 Status 欄位為 **`PROVISIONAL`** 或 **`ACTIVE`**（v0.7.0 二態紀律、no third state）
- 對齊條款：`core/init-template §3.3.2 step 6`（自我具象化 Status 寫 PROVISIONAL）+ `core/multi-role-tracking §3.4.4`（上岸需 user explicit 授權）+ `tools/commit-hook-spec.md §3 H1`（status 升 ACTIVE 須含 user 授權字樣 binary 攔截）

**修補方向 + 約束**：
- ✅ 必動：Status 是其他值（如 `已內化自檢` / `READY` / `已激活`）→ 改回 PROVISIONAL 或 ACTIVE
- 🚫 不可動：自升 PROVISIONAL → ACTIVE 不寫對應 user 授權字樣（commit-hook H1 reject、binary 不可繞）
- 🚫 不可代決：「Status 三態好像更精確」自編三態（charter 設計二態是 invariant）

**反例**：
- ❌ Gemini PM 跑 doctor 報「Role Status (PM): WARN — 最後 Log 為 PROVISIONAL」（dogfood signal #46 第 2 次 LIVE、2026-05-06 dbSDK Engineer 把 PROVISIONAL 誤判 WARN）
  - ✅ 正解：PROVISIONAL **是合法 PASS 狀態**、不該報 WARN（spec C003 嚴重度只有 PASS / ERROR、PROVISIONAL 屬 PASS）
- ❌ Gemini PM 自寫 Status: `已內化自檢`（dogfood signal #38 LIVE 範本）
  - ✅ 正解：嚴格 binary 二態、其他值都 ERROR
- ❌ Gemini PM init 完直接寫 Status: ACTIVE（dogfood signal #35、自激活、F1 假宣告）
  - ✅ 正解：init 完寫 PROVISIONAL、等 user explicit 授權後才升 ACTIVE 並寫 Sign-in Log（H1 binary 攔截）

**真實 stdout 證據要求**：
- check 命令：`grep -E '^\*\*Status\*\*' agent-commons/roles/*/\_role.md`
- PASS 時 stdout：每行末為 `PROVISIONAL` 或 `ACTIVE`
- ERROR 時 stdout：列出非二態值的檔案 + 該行內容

#### C004 詳盡引導（v0.10.3 加；對應 v0.10.0 commit-hook H1 binary 雙層）

**合規規定**：
- 觸發：軸 C 第四項、僅對 Status: ACTIVE 的 _role.md 跑
- 必須狀態：ACTIVE 狀態的 `_role.md` 必有 Sign-in Log 至少一筆 entry、含 user explicit 授權字樣（如 `由 user 於 <date> explicit 授權` / `user 授權` / `explicit 授權`）
- 對齊條款：`core/multi-role-tracking §3.4.4` 上岸 user 授權追溯紀律 + `tools/commit-hook-spec.md §3 H1`

**修補方向 + 約束**：
- ✅ 必動：補 Sign-in Log entry（含日期 + user 授權字樣 + 觸發來源 prompt 摘錄）
- 🚫 不可動：自編造 user 授權字樣（如「user 應該已授權吧」、F1 假宣告 + F3 捏造）
- 🚫 不可代決：Sign-in Log 不可由 AI 補寫、必須是 user 真實對話痕跡

**反例**：
- ❌ Status: ACTIVE 但 Sign-in Log 區塊空 / 不存在（dogfood signal #35 LIVE）
  - ✅ 正解：降回 PROVISIONAL 等 user 授權、或補真實授權追溯（user 真實對話）
- ❌ Sign-in Log 寫「由 PM 自身於 <date> 完成 self-instantiation」（沒 user 授權、AI 自激活）
  - ✅ 正解：Sign-in Log 必須含 user 字樣（如「由 user 於 2026-05-04 explicit 授權我接 PM 角色、原文：『你可以登入了』」）

**真實 stdout 證據要求**：
- check 命令（對每個 ACTIVE role）：`grep -A 20 "Sign-in Log" agent-commons/roles/<role>/_role.md | grep -E "user explicit 授權|user 授權|explicit 授權"`
- PASS 時 stdout：grep 找到含授權字樣的行
- ERROR 時 stdout：grep 無輸出 + 完整 Sign-in Log 區塊（協助 user 看到當前狀態）

#### C005 詳盡引導（v0.10.3 加；對齊 doctor §3.8 advisory 雙層）

**合規規定**：
- 觸發：軸 C 第五項、依採用方有幾個 vendor 跑幾次
- 必須狀態：vendor 端 toml / md 檔案對齊 vendor schema：
  - **Gemini CLI** `.gemini/commands/*.toml`：扁平結構（無 nested table、key=value pair only）
  - **Claude Code** `.claude/commands/*.md`：純 markdown（無 frontmatter 必填以外的特殊結構）
  - **Cursor** `.cursor/rules/*.mdc`：依 vendor schema
- 對齊條款：`tools/doctor-spec.md §3.8 E801/W802` + `roles/pm/gemini-cli.md §3.6` + `roles/engineer/claude-code.md §4.1`

**修補方向 + 約束**：
- ✅ 必動：toml nested table → 改扁平 key=value pair（如 `[command.args]` 段移除、改用 `arg_<name> = ...`）
- 🚫 不可動：自編 vendor schema 變體（vendor schema 是 vendor 端定義、charter 端只規範對齊）
- 🚫 不可代決：「nested 比較好讀」自決保留（vendor 端 schema validator 會報錯、commit 後其他 AI 跑不了）

**反例**：
- ❌ Gemini CLI v0.39.1 toml `[args.target]` nested table（dogfood signal #16 LIVE、YC 接入時 v0.39.1 schema validator 直接拒載入）
  - ✅ 正解：扁平 `arg_target = ...`
- ❌ AI 不查 vendor 文檔、自編 toml 結構
  - ✅ 正解：對齊 `roles/pm/gemini-cli.md §3.6` 範本

**真實 stdout 證據要求**：
- check 命令（依 vendor 不同）：對 toml 跑 `python3 -c "import toml; toml.load(open('<path>'))"` 或 `grep -E '^\[' .gemini/commands/*.toml`
- PASS 時 stdout：parse 成功 / grep 無 nested table
- ERROR 時 stdout：parse error stack OR nested table 行列出

### 3.4 軸 D：axiom 紀律對齊（dogfood signal #23 條款化）

驗證領域公理檔案的 frontmatter 對齊 v0.7.1 雙路徑紀律。

**檢查項**：

| ID | 檢查 | 嚴重度 |
|---|---|---|
| **D001** | `agent-commons/protocols/<axiom>.md` frontmatter `status` 為 `USER-RATIFIED`（v0.7.1 路徑 B 紀律）| **ERROR** |
| **D002** | axiom 檔案物理存在（呼應 doctor §3.7、本軸更精確驗 frontmatter） | ERROR |
| **D003** | axiom frontmatter 含 `mutability_default` 欄位（v0.7.1 scaffold） | WARN |
| **D004** | frontmatter `status` 值非 `USER-RATIFIED` 也非 `AI-DRAFTED`（違反 v0.7.1 二態紀律） | ERROR |

**D001 嚴重度說明**：dogfood signal #23（v0.7.0 公司接入第一次失敗 + v0.7.6 LIVE 公司專案接入第二次同類）累積到第 2 次同類後 user explicit 授權跳過 ≥3 次累積門檻直接條款化。執行載體本軸 D001 + `tools/init-spec.md` Phase 5b CHECK 7 ext 雙重防禦。

#### D001 詳盡引導（v0.10.3 加；對齊 doctor §3.9 E606 advisory 雙層）

**合規規定**：
- 觸發：軸 D 起手第一項、對每個 axiom 檔跑
- 必須狀態：`agent-commons/protocols/<axiom>.md` frontmatter `status` 欄位值為 **`USER-RATIFIED`**（v0.7.1 雙路徑紀律 — 路徑 A user 主筆預設 USER-RATIFIED / 路徑 B AI-DRAFTED 待 user 校正升 USER-RATIFIED）
- 對齊條款：`core/domain-axiom-slot §3.3` 雙路徑紀律 + `templates/agent-commons/domain-axioms.md.tpl` frontmatter scaffold + `tools/doctor-spec.md §3.9 E606`

**修補方向 + 約束**：
- ✅ 必動：status: AI-DRAFTED → user 親自校 axiom 內容 + 升 USER-RATIFIED + 加校正紀錄行（追溯校正動作）
- 🚫 不可動：AI 直接把 status: AI-DRAFTED 改 USER-RATIFIED 而 user 沒校（命中 F1 假宣告 + F6 surface vs structural、繞過 user 校正紀律）
- 🚫 不可代決：「我覺得 axiom 寫得對、自升 USER-RATIFIED」 — 違反「user 是領域權威、AI 不可代決」原則

**反例**：
- ❌ axiom 路徑 B 創建時 status: AI-DRAFTED、init 跑通 + Phase 5b PASS（v0.7.0 前 surface 通過、structural 違反）
  - ✅ 正解：v0.8.0 後 init Phase 5b CHECK 7 ext 強制 status USER-RATIFIED、init 失敗中止、user 校正後再跑 init
- ❌ AI 直接 sed 改 status: USER-RATIFIED 沒實 user 校正
  - ✅ 正解：跑 doctor / verify 抓 D001 ERROR、AI 報 user 「請校正並升 status」、等 user 完成

**真實 stdout 證據要求**：
- check 命令：`head -10 agent-commons/protocols/<axiom>.md | yq '.status'`
- PASS 時 stdout：`USER-RATIFIED`
- ERROR 時 stdout：`AI-DRAFTED` 或其他值（如 null / `READY` / 自編值）

#### D002 詳盡引導（v0.10.3 加）

**合規規定**：
- 觸發：軸 D 第二項
- 必須狀態：`mapping.yaml.domain_axioms.primary` 指向的 axiom 檔案物理存在於 `agent-commons/protocols/<axiom>.md`
- 對齊條款：`core/charter-config §3` mapping.yaml schema + `core/domain-axiom-slot §1` 領域公理位階

**修補方向 + 約束**：
- ✅ 必動：mapping 指 axiom 檔 / 物理存在 — 兩者對齊（mapping 改檔名 → 同步 mv 物理檔；mv 物理檔 → 同步改 mapping）
- 🚫 不可動：mapping 寫死路徑後物理檔不創建（schema 寫了不算、檔案實在才算、F6 surface vs structural）
- 🚫 不可代決：mapping 指多個 axiom 但只有一個 primary — `domain_axioms.primary` 是單值 invariant

**反例**：
- ❌ mapping 寫 `domain_axioms.primary: "protocols/IRON.md"` 但檔案不存在（v0.7.0 公司接入時 dbsdk.md 沒建 LIVE）
  - ✅ 正解：實建檔 + frontmatter scaffold + user 校正內容 + 升 USER-RATIFIED
- ❌ AI 不實 ls 確認、自報「axiom 存在 PASS」
  - ✅ 正解：實跑 ls 命令、看到具體檔名

**真實 stdout 證據要求**：
- check 命令：`AXIOM_PATH=$(yq '.domain_axioms.primary' agent-commons/_config/mapping.yaml) && ls -l "agent-commons/$AXIOM_PATH"`
- PASS 時 stdout：檔案實際 stat 資訊
- ERROR 時 stdout：`No such file or directory` + 提示「mapping 與物理檔不對齊」

#### D003 詳盡引導（v0.10.3 加；對齊 doctor §3.9 W608 advisory）

**合規規定**：
- 觸發：軸 D 第三項
- 必須狀態：axiom frontmatter 含 `mutability_default` 欄位（v0.7.1 scaffold 加、值為 `flexible` / `firm` 二態）
- 對齊條款：`templates/agent-commons/domain-axioms.md.tpl` frontmatter scaffold + `core/condition-mutability §2` 三層 mutability

**修補方向 + 約束**：
- ✅ 建議動：補 frontmatter `mutability_default: flexible`（路徑 A user 主筆 default）/ `firm`（高合規領域如金融、醫療）
- 🚫 不可動：寫不存在的 mutability 值（自編三態 / 四態）
- ⚠️ **WARN 不擋**：mutability_default 是 v0.7.1 加的設計擴增、舊 axiom 沒這欄位是 spec drift、補上即可

**反例**：
- ❌ axiom v0.5.x 時期創建、frontmatter 只有 `status` 沒 `mutability_default`
  - ✅ 正解：補 `mutability_default: flexible`
- ❌ 寫 `mutability_default: "看情況"` 自編值
  - ✅ 正解：嚴格 `flexible` 或 `firm`

**真實 stdout 證據要求**：
- check 命令：`head -10 agent-commons/protocols/<axiom>.md | yq '.mutability_default'`
- PASS 時 stdout：`flexible` 或 `firm`
- WARN 時 stdout：`null` 或自編值

#### D004 詳盡引導（v0.10.3 加；對齊 doctor §3.9 E607 advisory）

**合規規定**：
- 觸發：軸 D 第四項
- 必須狀態：axiom frontmatter `status` 值為 **二態 binary**（`USER-RATIFIED` 或 `AI-DRAFTED`、不接受第三態）
- 對齊條款：`core/domain-axiom-slot §3.3.1` 二態紀律 + `templates/agent-commons/domain-axioms.md.tpl`

**修補方向 + 約束**：
- ✅ 必動：寫了第三態值 → 改回二態之一
- 🚫 不可動：「我覺得三態好、加個 IN-REVIEW」自編三態（charter 設計二態是 invariant、第三態 = spec drift）

**反例**：
- ❌ status: `IN-REVIEW`（自編第三態）
  - ✅ 正解：根據實際情況選 `AI-DRAFTED`（待 user 校）或 `USER-RATIFIED`（已校）
- ❌ status: `READY` / `ACTIVE` / 中文「已校正」（自編值）
  - ✅ 正解：嚴格英文 binary 二態

**真實 stdout 證據要求**：
- check 命令：`head -10 agent-commons/protocols/<axiom>.md | yq '.status'`
- PASS 時 stdout：`USER-RATIFIED` 或 `AI-DRAFTED`
- ERROR 時 stdout：其他任何值 + 提示二態紀律

### 3.5 軸 E：stale reference 檢查

驗證跨檔引用對齊當前 charter version + 偵測升版過程未同步的 stale 引用。

**檢查項**：

| ID | 檢查 | 嚴重度 |
|---|---|---|
| **E001** | 跨檔 `charter_version` 一致（profile.yaml / ADOPTION / TUTORIAL / vendor toml）| ERROR |
| **E002** | 文件 / vendor toml / template 提到的 spec section 編號（如「依 init-spec §3.3.2」）對齊當前 charter version 內 spec 實際 section 編號 | WARN |
| **E003** | 文件 / vendor toml / template 提到的 step 編號（如「依 QUICKSTART Step 3」）對齊當前 QUICKSTART 實際 step 順序 — **對應 v0.7.6 QUICKSTART swap 後 stale 引用偵測** | WARN |
| **E004** | 引用已棄用條款 / spec / 工具（如 v0.5.9 後 charter-init.py 引用 = stale） | WARN |

#### E001 詳盡引導（v0.10.3 加；對齊 doctor §3.10 W901 advisory 雙層）

**合規規定**：
- 觸發：軸 E 起手第一項
- 必須狀態：跨檔 `charter_version` 引用一致：
  - `agent-commons/_config/profile.yaml.charter_version`
  - 採用方文檔（ADOPTION / TUTORIAL / QUICKSTART）變更歷史最新 entry 對應 charter version
  - vendor toml / md（`.gemini/commands/*.toml` / `.claude/commands/*.md`）內如有引用 charter version 字樣
- 對齊條款：`core/maintainer-discipline §3.4` 文檔層 sync checklist + `tools/doctor-spec.md §3.10 W901`

**修補方向 + 約束**：
- ✅ 必動：升 charter_version 同時補對齊所有引用點（profile.yaml + ADOPTION 變更歷史 + TUTORIAL 變更歷史 + QUICKSTART 變更歷史）
- ✅ 配套：vendor toml 如引用版本號、同步升
- 🚫 不可動：自編 charter_version（如 `0.10.99`、不存在的版本）
- 🚫 不可代決：「以後再補變更歷史」 — dogfood signal #6 / #24 family、累積 ≥ 3 次連續違反條款化進 W901

**反例**：
- ❌ profile.yaml 升 v0.10.2 但 ADOPTION 變更歷史最新 entry 仍 v0.10.0（dogfood signal #24 LIVE 範本、v0.7.4-v0.8.0 連續 3 次同類違反）
  - ✅ 正解：升版同 commit 補 ADOPTION/TUTORIAL/QUICKSTART 變更歷史 entry（對齊 §3.4.2 文檔層 sync checklist）
- ❌ AI 跑 verify 沒實 grep / 沒實對比、自報「跨檔一致 PASS」
  - ✅ 正解：實跑 grep 各檔 charter_version 引用、看實際值

**真實 stdout 證據要求**：
- check 命令：`grep -hE "charter_version|charter v0\." agent-commons/_config/profile.yaml ADOPTION.md TUTORIAL.md QUICKSTART.md | head -20`
- PASS 時 stdout：所有引用都對齊當前 profile.yaml charter_version
- ERROR 時 stdout：列出不對齊的引用 + 哪檔 + 哪版本

#### E002 詳盡引導（v0.10.3 加）

**合規規定**：
- 觸發：軸 E 第二項
- 必須狀態：文件 / vendor toml / template 提到的 spec section 編號（如「依 init-spec §3.3.2」）對齊當前 charter clone 內 spec 實際 section 編號
- 對齊條款：`core/maintainer-discipline §3.4.1` 條款層 sync 紀律

**修補方向 + 約束**：
- ✅ 建議動：spec drift 偵測到 → 對應 cross-reference 修補
- 🚫 不可動：自編 spec section 編號（如「依 init-spec §99.99」、不存在的段落）
- ⚠️ **WARN 不擋**：spec section 編號偏移屬 maintainer-discipline 範圍、採用方層只報、不擋升版

**反例**：
- ❌ 文件寫「依 init-spec §3.3.1」但 init-spec 實際是 §3.3.2（v0.5.0 後重編號 LIVE）
  - ✅ 正解：grep 出 stale 引用、改對齊
- ❌ AI 不實 cross-check、自報「cross-reference 對齊 PASS」
  - ✅ 正解：實跑 cross-reference grep（如 `grep -rE "init-spec §[0-9]" .`）

**真實 stdout 證據要求**：
- check 命令：`grep -rEho "(init-spec|doctor-spec|verify-spec|commit-hook-spec) §[0-9.]+" . | sort -u | head -30`
- PASS 時 stdout：所有引用都實存在於對應 spec
- WARN 時 stdout：列出可疑引用 + 對應 spec 實際 section 列表

#### E003 詳盡引導（v0.10.3 加）

**合規規定**：
- 觸發：軸 E 第三項
- 必須狀態：文件 / vendor toml / template 提到的 step 編號（如「依 QUICKSTART Step 3」）對齊當前 charter clone QUICKSTART.md 實際 step 順序
- 對齊條款：`core/maintainer-discipline §3.4.2` 文檔層 sync checklist + v0.7.6 QUICKSTART Step 2 ↔ Step 3 swap 教訓

**修補方向 + 約束**：
- ✅ 建議動：偵測到 stale step 編號 → 對齊 QUICKSTART 實際順序
- 🚫 不可動：自編 step 編號（如「依 QUICKSTART Step 99」）
- ⚠️ **WARN 不擋**：step 編號 stale 屬文檔層 sync drift、提示 user 看 QUICKSTART 變更歷史補對齊

**反例**：
- ❌ vendor toml 寫「跑 QUICKSTART Step 2 寫 axiom」但 v0.7.6 swap 後 axiom 改在 Step 3（dogfood signal #10 LIVE 範本）
  - ✅ 正解：grep 出 stale step 引用、對齊當前 QUICKSTART 順序

**真實 stdout 證據要求**：
- check 命令：`grep -rEho "QUICKSTART Step [0-9]+|TUTORIAL Step [0-9]+" . | sort -u`
- PASS / WARN：對比當前 QUICKSTART 實際 step 編號 / 內容

#### E004 詳盡引導（v0.10.3 加）

**合規規定**：
- 觸發：軸 E 第四項
- 必須狀態：文件 / vendor toml / template 不引用已棄用 condition / spec / 工具（如 v0.5.9 後 `charter-init.py` 引用 = stale、應走 spec-driven AI 自具象化）
- 對齊條款：`core/versioning-migration §3.4` 跨多版本升級 + `tools/uninstall-spec` v0.9.0「保留最後的溫柔」精神

**修補方向 + 約束**：
- ✅ 建議動：grep 出已棄用引用 → 對齊當前替代方案（如 charter-init.py → AI 自具象化）
- 🚫 不可動：自加引用到「未來會棄用」的條款（spec drift 預先植入）
- ⚠️ **WARN 不擋**：已棄用引用屬歷史殘留、提示 user 清理但不擋升版

**反例**：
- ❌ ADOPTION 文件仍引用「跑 charter-init.py」（v0.5.9 已移除 python 工具）
  - ✅ 正解：改為「對 AI 下 prompt 自具象化 /charter-init slash command」（對齊 init-template §3.3.2）
- ❌ vendor toml 引用 `tools/charter-doctor.py`（v0.5.9 已移除）
  - ✅ 正解：改為 spec-driven 跑 `/charter-doctor` slash command

**真實 stdout 證據要求**：
- check 命令：`grep -rEho "charter-(init|doctor|scan)\.py|python tools/" . | head -10`
- PASS 時 stdout：grep 無輸出
- WARN 時 stdout：列出 stale 引用位置（檔名 + 行）

### 3.6 模式 B：升版 diff 細節（v0.9.0 ship）

**動機**：模式 A 答「當前狀態是否合規」；模式 B 答「**本次升版引入了什麼新東西、採用方需要對齊哪些**」— 對應升版 walkthrough Step 5（self-check「五軸全綠」之前的 diff 校準）。

**前提**：採用方知道**前次 charter_version**（profile.yaml 變更歷史 OR `~/.agentcharter/.last_verify_version` 持久化、hook 寫入）。

**校驗集**：

```
對 ~/.agentcharter（charter clone）git log 範圍 [前次 charter_version tag, 當前 charter_version tag]：

1. 列出新加 condition：
   git diff <prev>..<curr> --name-only -- core/ | grep -E '^core/.*\.md$' | filter「新檔」
   → 對每條新 condition 列：path + frontmatter 抽 status / since / 保證強度 / 檢測時點

2. 列出新加 template：
   git diff <prev>..<curr> --name-only -- templates/agent-commons/ | grep -E '\.tpl$' | filter「新檔」

3. 列出新加 spec / 新加 profile preset：
   git diff <prev>..<curr> --name-only -- tools/ | filter「新檔」

4. 列出新引入的 ERROR/WARN code（doctor-spec / init-spec / post-upgrade-verify-spec / uninstall-spec）：
   grep doctor-spec.md / init-spec.md / 等 — 對比前後版本新引入的 W/E code
   → 列：code / 對應 spec 段 / 修補方向摘要

5. 列出條款計數變動：
   profile preset enabled 條目數對比、計數標頭（如「條款啟用：21 / 19」→「22 / 25」）

6. 對比現專案 profile.yaml.charter_version vs charter clone 當前 version：
   不對應 → 報「升版未完成、profile.yaml 未升 charter_version」（軸 A A001 同源）
```

**輸出格式**（模式 B 專屬段、附在標準 5 軸報告之後）：

```markdown
## 模式 B：升版 diff（<prev_version> → <curr_version>）

### 新加 condition（N 條）
| condition | since | 保證強度 | 檢測時點 | 對齊 walkthrough Step |
|---|---|---|---|---|
| <name> | <since> | <X> | <Y> | <step ref> |

### 新加 template（N 個）
| template | 對應 condition |
|---|---|
| <name>.md.tpl | <condition ref> |

### 新加 spec / preset
| 檔案 | 用途摘要 |
|---|---|

### 新引入的 ERROR/WARN code
| code | spec 段 | 修補方向摘要 |
|---|---|---|
| W1101 | doctor-spec §3.11 | 補建 reflections/ + 寫第一個 reflection |

### 條款計數變動
- preset standard: 18 / 21 → 22 / 25
- preset minimal: 9 / 21 → 10 / 25
- preset strict: 18 / 21 → 22 / 25
- preset essential（v0.9.0 新加）: 5 / 25
```

**強度**：模式 B 全部報告為 **INFO**（不是 ERROR/WARN）— 升版 diff 是**資訊層、不是合規層**；合規軸由模式 A 5 軸 + 升版 walkthrough Step 3 完成。

### 3.7 模式 C：pre-commit sync-check 細節（v0.9.0 ship）

**動機**：對應 dogfood signal #6 + #24 終局實作層 — charter_version 變動 / 採用方文檔 sync 漏寫常見於 commit 階段（升版 PR 漏改 ADOPTION 變更歷史 / 升 charter_version 但 vendor toml 未同步）— hook 在 commit 時自動攔截、減少漏寫流入主分支。

**前提**：採用方願意走 vendor 邀請制（charter 不附 hook binary、依 `core/ai-vendor-onboarding §3` 邀請各 vendor 自實作 hook）— **本 spec 只規範紀律 + 校驗集、不寫死 vendor-specific hook 實作**。

**觸發條件**（hook 邏輯）：

```
git diff --cached（staged 變動）含以下任一：
  - <common-memory-root>/_config/profile.yaml 中 charter_version 行變動
  - commit message 含 "charter_version" / "charter v" 字串（升版 commit 慣例 tag）
  - <common-memory-root>/_config/profile.yaml preset 行變動
  - 採用方文檔（ADOPTION / TUTORIAL / QUICKSTART）變動
→ 觸發模式 C
```

**校驗集**（模式 C 跑、僅子集）：

```
1. 軸 E E001（跨檔 charter_version 一致）— 全跑
2. 軸 E E003（step 編號 stale）— 採用方文檔變動才跑
3. 軸 B B001（preset 啟用條款數對齊）— charter_version 變動才跑
4. 軸 B B002（enable_modes 含 F6）— charter_version 變動才跑
5. 軸 C C003（_role.md Status 二態）— 全跑（commit 不應出現 ACTIVE → PROVISIONAL 退降）

不跑：
- 軸 A（charter clone 對齊 — 採用方專案 commit 階段不一定有 ~/.agentcharter 連線）
- 軸 D（axiom 紀律 — frontmatter 變動屬 user 親操作、不該在 commit hook 攔）
- 軸 C C001/C002/C004/C005（結構 / Sign-in Log / vendor schema — 屬 doctor 範圍、commit 階段太晚）
```

**hook 失敗處置**：

```
hook 抓到 WARN/ERROR：
  - exit code != 0、阻止 commit
  - stderr 列：失敗 ID + spec 段引用 + 修補方向摘要
  - 提示：「跑 /charter-upgrade-verify --strict 完整檢查 / 跑 /charter-doctor 看細節」

hook 設計紀律（vendor 自實作時必守）：
  - hook 失敗訊息禁寫死 vendor-specific 路徑（同 init-template §3.3.2 引用紀律）
  - hook 必可被 git commit --no-verify 繞過（user explicit 授權閘）
  - hook 不可代決：exit 1 即停、不嘗試 auto-fix（auto-fix 屬 doctor --fix 範圍、commit hook 不越界）
```

**vendor 邀請制執行載體**：

依 `core/ai-vendor-onboarding §3`、各 vendor 在 `roles/<role>/<vendor>.md` 加 hook 實作段：

| vendor | hook 位置 | 推薦實作 |
|---|---|---|
| Claude Code | `.claude/hooks/pre-commit` | shell 腳本呼叫 `/charter-upgrade-verify --strict --mode-c` |
| Gemini CLI | `.gemini/hooks/pre-commit`（依 vendor 慣例）| 同上 |
| Cursor | 依 vendor hook 機制 | 同上 |
| 通用 git hook | `.git/hooks/pre-commit` | shell 腳本、user 自手動裝 |

> charter 概念層只規範紀律 + 校驗集（本 §3.7）— vendor 層自實作位置 + 細節（依邀請制 step 2-4）。

**對齊雙軌節奏**：模式 C 屬「結構強制 × pre-commit」格（multi-perspective 結構師金礦雙軸矩陣）— 補完 charter v0.9.0 引入的「結構強制」軸三格之一（① individual-learning-loop pre-init / ② diagnose-remediate-protocol runtime / **本 § pre-commit**）。

---

## 4. 檢查觸發 + 結果處置

### 4.1 觸發時機

- **升版完成後**（versioning-migration §3 第 7 步「跑 doctor」可擴為「跑 doctor + 跑 post-upgrade-verify」、預設後者為升版完整度驗證）
- **重新採用後**（versioning-migration §3.4.5「停用一段時間後重新採用」場景的標準 step）
- **任意時點 sync-check**（user 主動跑、確認當前狀態對齊）

### 4.2 失敗處置

| 軸 | ERROR 處置 | WARN 處置 |
|---|---|---|
| A | charter clone 不對齊 → user 跑 `git pull origin main` 或 `git checkout <tag>` | charter clone 修改未 commit → user review |
| B | schema 違規 → 依條款 spec 修補 profile.yaml | 條款參數欄位偏移 → user 看 condition 變更歷史補對齊 |
| C | 結構錯位 → 依 v0.7.0 namespace 紀律修 mapping.yaml + 物理結構 | — |
| D | axiom AI-DRAFTED → user 校 axiom + 升 USER-RATIFIED（**對應 dogfood signal #23 LIVE 流程強制抓**）| frontmatter 缺欄位 → user 補 |
| E | charter_version 跨檔不一致 → 統一升 | spec section / step 編號 stale → 依 maintainer-discipline §3.4 文檔層 sync 修補 |

---

## 5. self-instantiation 規範

採用方對 vendor AI 下 prompt 自具象化為 slash command（依 `core/init-template §3.3` 七步驟、引用 framework 路徑禁寫死絕對路徑）：

```
我採用了 AgentCharter v0.8.0+，charter 在 ~/.agentcharter/。

請依 ~/.agentcharter/tools/post-upgrade-verify-spec.md 自具象化為
/charter-upgrade-verify slash command 到你廠商標準位置（依 init-template §3.3）。

紀律提示：
- step 5（v0.5.10 加）— 簽名前必跑 doctor schema 驗證
- step 6（v0.7.0 加）— Status 必為 PROVISIONAL（未經 user explicit 授權）
- 引用 framework 路徑禁寫死 user home 絕對路徑
  （推薦 $AGENTCHARTER_HOME / ~/.agentcharter / agent-commons/ 三層）
- 預設執行模式為本 spec §2.1 模式 A（完整健康檢查、跑全 5 軸）
- 結尾貼出五軸校驗 stdout（不要只回報「成功」摘要、對齊
  structural-anti-fabrication 紀律）
- 每軸獨立報告 ERROR / WARN / INFO 計數 + 詳細項目
```

具象化後 user 打 `/charter-upgrade-verify` 直接重用。

---

## 6. 輸出格式

依 `structural-anti-fabrication.md` 強制：含實際 stdout 區塊、非純文字結論。

```markdown
# AgentCharter Upgrade Verify Report — <project-name>

> 產生時間：<UTC + 本地>
> Charter version (declared)：0.8.0
> Charter version (actual ~/.agentcharter)：v0.8.0 @ <commit-hash>
> Profile preset：standard
> 整體狀態：✅ 全綠 / ⚠️ N 個警告 / ❌ N 個錯誤

## 軸 A：charter clone 對齊

​```bash
cd $AGENTCHARTER_HOME && git log --oneline -3
​```

​```text
<實際輸出>
​```

| ID | 檢查 | 結果 |
|---|---|---|
| A001 | charter_version 對應 commit/tag 在 git log | ✅ PASS |
| A002 | core/*.md 數量對齊預期 | ✅ PASS |
| A003 | charter clone working tree 乾淨 | ✅ PASS |

## 軸 B：本專案 schema 對齊

[...]

## 軸 C：agent-commons/ 結構合規

[...]

## 軸 D：axiom 紀律對齊

​```bash
head -5 agent-commons/protocols/<axiom>.md
​```

​```text
<實際 frontmatter 輸出>
​```

| ID | 檢查 | 結果 |
|---|---|---|
| D001 | axiom frontmatter status: USER-RATIFIED | ❌ ERROR — 實際為 AI-DRAFTED |

→ 修補建議：user 校 axiom 內容後手動改 frontmatter status: AI-DRAFTED → USER-RATIFIED + created_by: ai-drafted → user-ratified-from-ai-draft + 加校正紀錄行（依 v0.7.1 路徑 B 紀律）

## 軸 E：stale reference 檢查

[...]

---

📊 **Summary**：
- ❌ 1 ERROR（軸 D D001）
- ⚠️ 0 WARN
- ℹ️ 0 INFO

**狀態**：升版未完整、需處理 D001 後重跑。
```

---

## 7. 與其他 spec / condition 的關係

| 對應 | 關係 |
|---|---|
| `tools/doctor-spec.md` | 並列 — doctor 通用 schema validation；本工具升版專屬 + 跨多版累積驗證；本工具軸 D 與 doctor §3.7 物理存在校驗互補（更精確驗 frontmatter）；本工具軸 C C005 與 doctor §3.8 vendor schema 對齊 |
| `tools/init-spec.md` Phase 5b CHECK 7 | 同源 — 兩處都驗 axiom frontmatter status（**dogfood signal #23 雙重防禦**：init 階段 Phase 5b CHECK 7 fail-fast、升版後 post-upgrade-verify 補抓）|
| `core/versioning-migration §3` | 補充 — §3 規範升版過程；本工具規範升版**之後**驗證；§3 第 7 步「跑 doctor」可擴為「跑 doctor + 跑 post-upgrade-verify」 |
| `core/init-template §3.3.2` step 5 | 同源 — step 5 是 self-instantiation 結尾 schema 驗證；本工具是升版後完整度驗證；都呼應「具象化 ⊥ 驗證脫鉤」(dogfood signal #4) 解 gap |
| `core/structural-anti-fabrication §5` | 反向引用 — 軸 D「axiom status 校驗」是 v0.7.1 路徑 B 紀律「不可在 AI-DRAFTED 啟動 init」的執行載體；軸 D D001 + Phase 5b CHECK 7 ext 雙重防禦 |
| `core/domain-axiom-slot §3.3` | 反向引用 — 路徑 B 紀律的執行載體 |
| `core/maintainer-discipline §3.4` | 補充 — §3.4.2 文檔層 sync checklist 抽驗範圍與本工具軸 E stale reference 檢查重疊 |
| `core/adoption-lifecycle.md`（v0.9.0 議程）| 預備 — 本工具是 lifecycle「升版」階段的標準動作；v0.9.0 lifecycle.md ship 時收編引用 |

---

## 8. 觸發 / 累積紀錄

- v0.8.0（自 v0.8.0 引入）—— 初版。對應：
  - user 2026-04-29 LIVE 提議「升版後需要一個檢核機制」（直接條款化、跳過 ≥3 次累積門檻、同 v0.5.8 / v0.7.1 user 直接條款化 pattern）
  - YC v0.7.4 → v0.7.5 升版實證觸發
  - dogfood signal #23（v0.7.0 公司接入第一次 + v0.7.6 LIVE 公司專案接入第二次）= 軸 D D001 條款化執行載體

---

## 9. 變更歷史

### v0.2（自 v0.9.0 引入）

**動作**：
1. **§3.6 模式 B 升版 diff 細節**新增：6 條校驗集（新加 condition / 新加 template / 新加 spec / preset / 新引入 ERROR/WARN / 條款計數變動 / charter_version 對齊）+ 專屬輸出格式（INFO 級、不是合規層）
2. **§3.7 模式 C pre-commit sync-check 細節**新增：觸發條件 + 5 條校驗子集（軸 E E001/E003、軸 B B001/B002、軸 C C003）+ hook 失敗處置 + vendor 邀請制執行載體（charter 概念層只規範紀律 + 校驗集、不附 hook binary）
3. §2 用法新增 `--diff` / `--mode-c` flag + 對應段
4. §2.1 呼叫模式表「v0.9+ 議程」標記改 v0.9.0 ship、補完模式 B/C 觸發者 / 用途 / 失敗處置
5. 對齊雙軌節奏：模式 C 屬「結構強制 × pre-commit」格 — 補完 charter v0.9.0 雙軸矩陣「結構強制」軸三格之一

**觸發**：
- (a) charter v0.9.0 主軸「紀律完整性 + AI 自我覺察升維」配套 ship — 模式 B/C 與 dogfood signal #34（individual-learning-loop）+ #6/#24（採用方文檔 sync）同期條款化
- (b) v0.7.3 北極星「不讓 user 記」對 AI 角度補完延伸：模式 C pre-commit hook 是「不讓採用方升版漏寫」結構強制執行載體
- (c) multi-perspective 結構師金礦雙軸矩陣「結構強制 × pre-commit」格落地

**修訂類型**：MINOR — 純擴增（模式 A 既有不變、模式 B/C 新加）；既有採用方升版**不強制**跑模式 B/C、走 walkthrough Step 5 推薦。

**連動範圍**（依 `maintainer-discipline §2.2`）：
- `tools/uninstall-spec.md`（v0.9.0 加；模式 C hook 設計紀律對齊「不可繞 user explicit 授權閘」精神 → uninstall 三次確認）
- `core/ai-vendor-onboarding §3` 邀請制（模式 C hook 走 vendor 邀請制、不寫死 vendor-specific 實作）
- `core/diagnose-remediate-protocol.md`（v0.9.0 加；模式 C hook 屬其「結構強制 × runtime」延伸）

### v0.1（自 v0.8.0 引入）

初版 — user LIVE 直接條款化（跳過 ≥3 次累積門檻、同 v0.5.8 / v0.7.1 / v0.7.4 user 直接條款化 pattern）。
含：
- 5 軸校驗（A clone / B schema / C structure / D axiom / E stale ref）
- 模式 A 完整健康檢查 ship；模式 B/C 留 v0.9+ 議程
- self-instantiation 規範（依 init-template §3.3 七步驟）
- structural-anti-fabrication 對齊（含實際 stdout 區塊強制）

**對應 SSS S1「AI 自治協作 + user 授權閘」**：本工具自動化驗證機制是 SSS S1 子集 — 自動驗證後 AI 自提升版完整度報告 → user 授權閘批准下一步 release lifecycle 推進。S1 ship 時可擴本工具加自治模式。

---

## 升版後 Doctor 角色建立提示（v0.9.1 加）

> 設計動機（dogfood signal #36）：doctor 角色功能持續擴增（v0.9.0 §3.11 個體學習迴圈 + v0.9.1 §3.12 Gap 偵測），對需要多 AI 協作的採用方具備高槓桿價值。升版 verify 全綠後，自然是詢問是否建立 doctor 角色的最佳時機 — 使用者剛完成升版、心智帶寬充裕、且剛接觸到新功能說明。

### 提示條件

```
若 post-upgrade-verify 全綠（0 E、0 W 或全 SKIP）
且 roles/doctor/_spec.md 存在（v0.9.1 ship 後）
且 agent-commons/roles/doctor/ 目錄不存在 或 agent-commons/roles/doctor/_role.md 不存在
→ 輸出 Doctor 角色建立提示
```

### 提示文本（可自具象化為 slash command output）

```
✅ 升版驗證全綠！

你的專案目前沒有 Doctor 角色。
Charter v0.9.1 強化了 /charter-doctor 的能力：
  • §3.12 Gap 偵測（W1201 平行獨語 / W1202-W1204 形同虛設 / W1205 log 缺失）
  • 模式 C 互動式 Gap 遷移（六步驟引導、全程確認）
  • init Phase 3.5 scaffold 預防機制

建立 Doctor 角色後，任意 AI 可執行 /charter-doctor 對專案進行健康檢查與 Gap 修復引導。

是否現在建立 Doctor 角色？(y/n)
  y → AI 依 roles/doctor/_spec.md 自具象化 /charter-doctor slash command（含 §2.1 三模式）
  n → 略過（可隨時手動建立：「請依 roles/doctor/_spec.md 自具象化 /charter-doctor」）
```

### 執行約束

```
🚫 僅提示、不自動建立（角色建立屬 self-instantiation 流程、需 user 明示）
✅ user 回 y 後，AI 依 core/init-template.md §3.3 self-instantiation 精神執行
✅ 提示可跳過（不影響升版完成狀態）
```
