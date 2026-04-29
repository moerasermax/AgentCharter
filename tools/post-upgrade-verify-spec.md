# /charter-upgrade-verify — 升版後標準驗證流程設計

> **狀態**：v0.8.0（純 spec — 由 AI 自具象化執行）
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
/charter-upgrade-verify
/charter-upgrade-verify --json     # 輸出 machine-readable 格式
/charter-upgrade-verify --strict   # 將 WARN 升為 ERROR（CI/pre-commit 用）
```

### 2.1 呼叫模式

| 模式 | 觸發者 | 用途 | 失敗處置 |
|---|---|---|---|
| **A. 完整健康檢查（Full Verify）** | 採用方使用者 | 升版完成後 / 任意時點驗證升版完整度 | 列 errors / warnings；user 決定是否修補 |
| **B. 升版 diff 模式**（v0.9+ 議程） | — | 對比上次 verify 結果、顯化本次升版引入的新 ERROR/WARN | — |
| **C. pre-commit sync-check**（v0.9+ 議程） | git pre-commit hook | 只跑軸 E（stale reference）+ 軸 B/C 部分項 | hook fail 阻止 commit |

> **本 v0.8.0 ship 模式 A**；模式 B / C 屬 spec 層提及、實作層留 v0.9+ 議程。對齊 v0.7.3 北極星「向下兼容嚴守」紀律。

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

**對應檢查命令範例**：

```bash
# A001
cd $AGENTCHARTER_HOME
git log --oneline | grep -i "v$(yq '.charter_version' agent-commons/_config/profile.yaml)"

# A003
cd $AGENTCHARTER_HOME && git status --porcelain
```

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

### v0.1（自 v0.8.0 引入）

初版 — user LIVE 直接條款化（跳過 ≥3 次累積門檻、同 v0.5.8 / v0.7.1 / v0.7.4 user 直接條款化 pattern）。
含：
- 5 軸校驗（A clone / B schema / C structure / D axiom / E stale ref）
- 模式 A 完整健康檢查 ship；模式 B/C 留 v0.9+ 議程
- self-instantiation 規範（依 init-template §3.3 七步驟）
- structural-anti-fabrication 對齊（含實際 stdout 區塊強制）

**對應 SSS S1「AI 自治協作 + user 授權閘」**：本工具自動化驗證機制是 SSS S1 子集 — 自動驗證後 AI 自提升版完整度報告 → user 授權閘批准下一步 release lifecycle 推進。S1 ship 時可擴本工具加自治模式。
