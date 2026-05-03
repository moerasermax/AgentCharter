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

### 3.5 軸 E：stale reference 檢查

驗證跨檔引用對齊當前 charter version + 偵測升版過程未同步的 stale 引用。

**檢查項**：

| ID | 檢查 | 嚴重度 |
|---|---|---|
| **E001** | 跨檔 `charter_version` 一致（profile.yaml / ADOPTION / TUTORIAL / vendor toml）| ERROR |
| **E002** | 文件 / vendor toml / template 提到的 spec section 編號（如「依 init-spec §3.3.2」）對齊當前 charter version 內 spec 實際 section 編號 | WARN |
| **E003** | 文件 / vendor toml / template 提到的 step 編號（如「依 QUICKSTART Step 3」）對齊當前 QUICKSTART 實際 step 順序 — **對應 v0.7.6 QUICKSTART swap 後 stale 引用偵測** | WARN |
| **E004** | 引用已棄用條款 / spec / 工具（如 v0.5.9 後 charter-init.py 引用 = stale） | WARN |

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
