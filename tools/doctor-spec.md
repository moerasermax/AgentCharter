# /charter-doctor — 健康檢查設計

> **狀態**：v0.5.9（純 spec — 由 AI 自具象化執行）
> **位階**：tools / 設計文檔。
> **v0.5.9 演化軌跡**：原 v0.4 spec 寫 `.agentcharter/` 路徑 → v0.5.0 合併到 `agent-commons/_config/` → v0.5.1 加 self-instantiation 狀態檢查 → v0.5.7 曾落地為 python 工具 → **v0.5.9 移除 python 工具回歸純 spec**（framework 不附實作工具）。
> **實作模式**：採用方對 AI 下 prompt「依本 spec 跑健康檢查」或「依本 spec 自具象化 `/charter-doctor` slash command 給未來重用」，AI 完成檢查並輸出 stdout 報告。

---

## 1. 目標

驗證專案的 AgentCharter 接入狀態完整，可隨時 `/charter-doctor` 檢視：

- 啟用的條款是否依賴完整
- mapping 對映的路徑是否實際存在
- 領域公理檔案是否存在
- 角色 init slash command 是否就緒
- profile schema 版本是否與 AgentCharter 相容

---

## 2. 用法

```
/charter-doctor
/charter-doctor --fix       # 互動式修復建議
/charter-doctor --json      # 輸出 machine-readable 格式
```

### 2.1 呼叫模式

| 模式 | 觸發者 | 用途 | 失敗處置 |
|---|---|---|---|
| **A. 人工健康檢查** | 採用方使用者 | 任意時點驗證接入狀態 / 升版前 dry-run | 列 errors / warnings；使用者決定是否修 |
| **B. self-instantiation 結尾強制驗證點**（v0.5.10 加）| 自我具象化中的 AI | `core/init-template.md §3.3.2 step 5` 強制呼叫；AI 寫完 mapping/profile/領域公理後**必跑一次** | **0 errors 才允許 step 6 簽名**；非 0 則 step 5 失敗、回 step 2-3 修補；違反視為 `failure-modes.md F6`（未驗證即宣告就緒） |
| **C. 互動式 Gap 遷移修復**（v0.9.1 加）| 採用方使用者 | `--fix` 旗標手動觸發 / §3.12 W120x 命中後自動提示；AI 掃描全專案 → Gap 分類 → 互動式引導遷移至正確 charter 路徑 | **全程互動式確認**；AI 不自動執行任何遷移動作；user 逐項確認後才建檔 / 搬移 |

> 模式 B 的設計動機：對應 dogfood signal #4「具象化 ⊥ 驗證脫鉤」（YC_AIAgentCrew 2026-04-28 實證 — PM Gemini 寫 mapping schema 違規當下無人發現，Engineer Claude 進場才被迫重寫修補）。把驗證從「使用者另一個動作」（QUICKSTART Step 5）內化到「self-instantiation 流程內必跑」，避免轉嫁驗證負擔給下個 AI。

> **模式 C 的設計動機**（v0.9.1 加、dogfood signal #36 條款化）：對應「平行獨語 (Parallel Monologue)」反模式 — 多個 AI 各自維護分散狀態檔（如 `kiro-sync-point-01~10.md`、`checkpoint_gemini.md`），無共享 handoff 文件，導致協作中斷且 charter 結構形同虛設。根因：專案在接入前（或接入不完整時）已累積 AI 工作產物，這些產物以 charter 看不懂的路徑與格式存在，doctor 過去只能 WARN 「目錄不存在」，無法指引如何**把現有內容歸位**。模式 C 的北極星：**偵測 Gap → 辨識性質 → 互動式引導歸位 → 縮小 Gap 至零**。全程互動式確認、AI 不自主執行任何搬移或建立動作。

模式 C 互動式 Gap 遷移流程（六步驟）：

```
Step 1 【觸發】
  - 使用者下 /charter-doctor --fix，或
  - 模式 A 全量掃描命中 §3.12 W120x（自動提示進入模式 C）

Step 2 【掃描】
  AI 掃描專案根目錄（含子目錄），收集所有疑似 AI 工作產物的檔案
  - 匹配模式：*-sync-point-*.md / checkpoint_*.md / S\d+-*.md / *history*.md /
    *-instructions.md / GEMINI.md / CLAUDE.md（若在非標準位置）/ *reflection*.md（未在 reflections/）

Step 3 【分類】
  AI 依 §3.12 Gap 分類表逐一判定每個檔案的「Gap 性質」與「charter 目標路徑」
  輸出分類清單（含建議操作：搬移 / 轉格式 / 合併 / 保留原位）

Step 4 【提案】
  AI 以條列方式輸出遷移計畫，每項包含：
  - 📄 原始路徑
  - 🎯 charter 目標路徑
  - 🔄 操作描述（如「以 kiro-sync-point-01~10.md 建立 roles/kiro/sessions/ 目錄並分別存入」）
  - ⚠️ 格式轉換說明（若需）
  - ❓詢問 user：apply / skip / explain more

Step 5 【確認】
  user 逐項回應（apply / skip / explain more）
  - apply → 進入 Step 6 單項執行後回 Step 5 繼續下一項
  - skip → 標記「user 決定保留原位」並繼續
  - explain more → AI 展開說明 Gap 性質 + charter 條款依據 + 跳過的後果

Step 6 【執行（單項）】
  AI 依確認項目執行操作（mkdir + 搬移 / 複製 / 建立轉換版本）
  執行後輸出實際 stdout 結果（對齊 structural-anti-fabrication.md 強制 stdout 要求）
  🚫 此步驟僅在 user 明確 apply 後執行
```

模式 C 的執行約束：

```
🚫 不可自主遷移：每一個檔案操作都需 user apply
🚫 不可覆蓋現有 charter 內容：若目標路徑已有同名檔案，提示衝突、停下等待 user 裁定
🚫 不可偽造格式：若原始檔案格式與 charter template 不符，提供轉換建議、不自動轉換
✅ 可自動建立空目錄（scaffold）
✅ 可保留原始檔案（搬移前先確認，或建立副本後再搬）
✅ 可建立 MIGRATION_NOTE.md 說明遷移歷程（可選、user 同意後才建）
```

模式 B 的 minimal 檢查集（不需跑全部 §3 檢查）：

```
必驗（v0.5.10）：
  §3.1 結構完整性（profile.yaml / mapping.yaml schema 必填欄位）
  §3.3 路徑對映（mapping 指向的路徑實際存在）
  §3.5 領域公理（公理檔存在 + 結構非空）

必驗（v0.7.0 加，dogfood signal #4 第三次同類條款化）：
  §3.7 結構頂層完整性 + namespace vs 檔案路徑校驗
  （E601/E602/E603/E604/E605 全部跑；尤其 E605 不依賴 profile.yaml 的 enable_modes 設定）

必驗（v0.8.0 加，dogfood signal #23 條款化）：
  §3.9 axiom 紀律對齊（E606/E607/W608 — axiom frontmatter status 二態紀律執行載體）

啟用（v0.8.0 加，dogfood signal #16 spec 層 → 實作層）：
  §3.8 vendor 端 slash command schema 校驗（E801/W802 — v0.8.0 實作啟用）

必驗（v0.9.0 加，dogfood signal #34 條款化）：
  §3.11 個體學習迴圈合規 W1101 + E1103
  （W1102 雙寫對應依賴 failure_mode_log 累積、self-instantiation 階段太早可能無 entry、屬模式 A 全量、可跳過模式 B）

可選：
  §3.2 條款相依、§3.4 角色 init 狀態、§3.6 失敗模式累積（self-instantiation 階段太早，可跳過）
```

模式 A / B 共用同一套檢查實作；差別僅在**強制性**（A 軟、B 硬）+ **檢查集**（A 全、B minimal）。

---

## 3. 檢查項

> **真實 stdout 證據要求 — 全 §3 適用紀律**（v0.10.3 加；對齊 `core/diagnose-remediate-protocol §2.4` + dogfood signal #31 family ≥ 5 次同類同 session 累積）：
>
> 以下所有 check item 的 PASS / WARN / ERROR 結論 **必須附 binary stdout 證據**（如 `ls` / `grep` / `yq` / `git log` 等命令的真實輸出）。**純文字 PASS / FAIL 缺 stdout 視同 `core/violation-reflection §1` 假宣告**、抽驗方有權直接退稿。
>
> - **PASS**：必附「實際命令 + stdout 顯示合規狀態」（如 grep 找到對應行、ls 列出檔案、yq 取值正確）
> - **WARN**：必附「實際命令 + stdout 顯示偏移狀態」+ 修補方向引用
> - **ERROR**：必附「實際命令 + stdout 顯示違規狀態」+ exit code（如 `git log | grep` 無輸出 = exit 1）
>
> 對應 v0.9.0 `core/diagnose-remediate-protocol §2.4` 真實 stdout 證據要求紀律 propagate 到本 spec 全 §3.7-§3.12 既有四欄結構（v0.8.1-v0.9.1 ship）+ §3.7-§3.12 新加 check item 必對齊。執行載體：`tools/commit-hook-spec.md §3 H1-H7`（commit 時 binary 攔截）+ user 抽驗時依 `core/audit-rights §3` SOP。

### 3.1 結構完整性

| 檢查 | 狀態碼 | 失敗處置 |
|---|---|---|
| `<common-memory-root>/_config/profile.yaml` 存在 | E001 | 建議跑 `/charter-init` |
| `<common-memory-root>/_config/mapping.yaml` 存在 | E002 | 建議跑 `/charter-init` |
| profile schema 版本相容 | E003 | 建議跑 `/charter-init --update` |
| 必填欄位齊全（依 charter-config §3 / §4）| E004 | 列出缺項 |

### 3.2 條款相依

依 `core/charter-config.md §5` 相依表逐一驗：

```
若 enabled.violation-reflection = true:
  則 enabled.audit-rights 必須 true
  且 enabled.failure-modes 必須 true
  且 enabled.structural-anti-fabrication 必須 true
```

| 失敗 | 狀態碼 | 處置 |
|---|---|---|
| 條款啟用但依賴未啟用 | E101 | 列出依賴鏈，建議啟用或停用該條款 |

### 3.3 路徑對映

```
對 mapping.yaml 內每個指向的路徑：
  1. 路徑是否存在
  2. 是否為對應類型（檔案 vs 目錄）
  3. 是否可讀（permission）
  4. 對 institutional_memory 列表內每個檔，個別檢查
```

| 失敗 | 狀態碼 | 處置 |
|---|---|---|
| 路徑不存在 | W201 | 警告（可能是計畫中還沒建的目錄）|
| 路徑類型錯（指向檔但實為目錄）| E202 | 修正 mapping |
| 無讀權限 | E203 | 檢查 OS 權限 |

### 3.4 角色 init slash command（自我具象化狀態）

對 enabled 的每個角色：

```
1. 讀 <common-memory-root>/roles/<role>/_role.md
2. 比對「各 AI 具象化位置」表中標為 ✅ 的 AI，其對應檔案是否實際存在
3. 內容是否滿足 core/init-template.md §2 八項最終狀態
```

| 失敗 | 狀態碼 | 處置 |
|---|---|---|
| 全部 AI 都未自我具象化（全 ❌）| I301 | INFO：等使用者指派 AI 角色，AI 會自我具象化 |
| `_role.md` 標 ✅ 但檔案不存在 | E302 | 表記錄與實際不符；可能 AI 簽名後未真正寫入 |
| 自我具象化內容缺步驟 | W303 | 該實作為次品；建議重做自我具象化 |
| 同角色多個 AI 已具象化 | I304 | INFO：跨 AI 接班鏈正常 |

### 3.5 領域公理

```
1. domain_axioms.primary 路徑指向的檔存在
2. 含至少一個「條款」型結構（依 grep 啟發式偵測 §/##）
```

| 失敗 | 狀態碼 | 處置 |
|---|---|---|
| 公理檔不存在 | E401 | 致命錯誤，無領域公理協議無法運作 |
| 公理檔結構薄弱（< 5 個 § 或 ##）| W402 | 建議補充內容 |

### 3.6 失敗模式累積紀錄

```
1. 是否有對應追蹤紀錄（位置由 mapping.state.failure_mode_log 指向）
2. 最新事件是否仍在「強化抽驗模式」
3. 最近 3 筆事件的 F-mode 分布
```

| 觀察 | 狀態碼 | 處置 |
|---|---|---|
| 當前處於強化抽驗模式 | I501 | INFO，提醒下個 session 接班 AI |
| 結構性失靈未解 | W502 | 警告，提醒使用者裁決尚未結 |

### 3.7 結構頂層完整性 + namespace vs 檔案路徑校驗（v0.7.0 加）

對應 dogfood signal #4 第三次同類（公司專案接入失敗 2026-04-28，見 `.claude_temp/COMPANY-ONBOARDING-FAILURE-AUDIT.md` Pattern B）— charter mapping schema 的 `shared.*` namespace 容易被 LLM 誤翻譯為檔案系統目錄。

**校驗集**（v0.7.0 必跑、為模式 B minimal 集合的擴充）：

```
1. 對 mapping.yaml 內 layout.<key>: <value> 的每對：
   檢查 value 字串是否以 namespace 同名的中介層開頭（如 shared/<...>）
   命中 → ERROR

2. 校驗 <common_memory_root>/ 下實際結構：
   - 期望狀態（合規）：shared/ 目錄**不存在**
   - 違規狀態：<common_memory_root>/shared/ 目錄**存在** → ERROR
   ⚠️ 紀律提醒（v0.8.1 加、對應 dogfood signal #19）：「不存在」是合規、「存在」才報 ERROR；
   不要把「找不到 shared/」誤判為 WARN/ERROR（YC v0.8.0 升版 LIVE 實證 Gemini 把合規「shared/ 不存在」誤標 WARN）

3. standard / strict preset 下的頂層必要目錄都存在：
   capsules/ / handoffs/ / protocols/ / institutional-memory/
   缺項 → ERROR

4. standard / strict preset 下，roles/ 子目錄至少含 pm 和 engineer 之一：
   全缺 → ERROR；只缺一個（且 profile 顯示對應 role 啟用）→ WARN

5. profile.yaml `parameters.failure-modes.enable_modes` 含 F6（v0.5.10 加）：
   缺 F6 → ERROR
```

| 失敗 | 狀態碼 | 處置 |
|---|---|---|
| layout 值含 namespace 同名中介層（如 `shared/capsules/`）| **E601** | 致命；移除中介層、對齊頂層路徑 |
| `<common_memory_root>/shared/` 目錄存在 | **E602** | 致命；mkdir 出來的錯目錄要清掉、把內容移到頂層 |
| 頂層必要目錄缺項 | **E603** | 列出缺項；對應 init-spec phase 1-3 結構建立漏 |
| roles/ 全缺 | **E604** | 致命；standard/strict preset 至少一個角色 scaffold |
| `enable_modes` 缺 F6 | **E605** | ERROR；補上 F6（dogfood signal #4 條款化要求）|

**諷刺循環攔截**：E605（F6 沒啟用）本身是 F6 行為的高發誘因（沒啟用 → 沒攔住未驗證即宣告就緒）。doctor 模式 B 強制檢查 §3.7 → 即使 profile.yaml 漏寫 F6、doctor 仍會抓到（因為這條 check 不依賴 enable_modes，是強制執行）。

#### E601 詳盡引導（v0.8.1 加；SSS S3 spec-as-data）

**合規規定**（charter ground truth）：
- 必須狀態：`mapping.yaml` 內 `layout.<key>: <value>` 的 value 不含 namespace 同名中介層（如 `shared/<...>`）
- 對齊條款：
  - `core/charter-config.md §3` mapping schema namespace 註明（v0.7.0 加）
  - `core/failure-modes.md §F6` surface-level vs structural-level 完成感脫鉤

**修補方向 + 約束**：
- ✅ 必動：移除 mapping value 中的 `shared/` 中介層、改為頂層路徑（如 `shared/capsules/` → `capsules/`）
- 🚫 不可動：mapping schema 結構（保 `layout.<key>: <value>` pattern、不重命名 key）
- 🚫 不可代決：是否 mkdir 新目錄 → 走 `/charter-init` 流程、不可繞過
- **推薦路徑**：依 `tools/init-spec.md Phase 1-3` 重新跑結構建立流程（不要手動 mkdir）

**反例**（charter 已駁回的 anti-pattern）：
- ❌ AI 看到 `layout.capsules: shared/capsules/` → 解讀為「應 mkdir shared/ 然後在底下建 capsules/」
  - ✅ 正解：value 是 namespace 標記、頂層 capsules/ 才是實際路徑、mapping 內 value 應改為 `capsules/`
- ❌ AI 把 `shared.*` namespace 翻譯為實際目錄結構（v0.7.0 公司接入失敗 dogfood signal #4 第三次同類）
  - ✅ 正解：`shared.*` 是 schema 邏輯命名空間、charter 已明示「不是檔案路徑」

#### E602 詳盡引導（v0.8.1 加）

**合規規定**：
- 必須狀態：`<common_memory_root>/shared/` 目錄**不存在**（charter 設計、頂層扁平結構）
- 對齊條款：`core/charter-config.md §3` namespace vs 檔案路徑分離（v0.7.0 加）

**修補方向 + 約束**：
- ✅ 必動：移除已誤建的 `<common_memory_root>/shared/` 目錄、把內容（如有）移到頂層
- 🚫 不可動：頂層既有目錄結構（capsules/ / handoffs/ / protocols/ / institutional-memory/）
- 🚫 不可代決：合併移動內容時可能的衝突 → user explicit 決定（不可 AI 自代）
- **推薦路徑**：
  1. `mv <common_memory_root>/shared/<sub>/* <common_memory_root>/<sub>/`（每個子目錄）
  2. `rmdir <common_memory_root>/shared/`
  3. 跑 `/charter-doctor` 重驗 → E602 解除

**反例**：
- ❌ AI 看到「shared/ 目錄不存在 → ERROR」誤判：「找不到 shared/ 目錄、可能要建」（**dogfood signal #19**、YC v0.8.0 升版 LIVE 實證）
  - ✅ 正解：「禁存在」是合規狀態、`shared/` 不存在 = PASS、AI 看到此狀態應該不報錯
- ❌ AI 主動建議「結構遷移：mkdir shared/ + mv 所有資產進去」（**dogfood signal #20**、YC v0.8.0 升版 LIVE 實證、Gemini 主動推 anti-pattern + 編造論述「對齊 v0.7.5 標準命名空間結構」）
  - ✅ 正解：v0.7.0 起 charter 主動明示「不重命名 namespace、namespace 是邏輯標記不是檔案路徑」、不要 mkdir shared/

#### E603 詳盡引導（v0.8.1 加）

**合規規定**：
- 必須狀態：頂層必要目錄齊全（capsules/ / handoffs/ / protocols/ / institutional-memory/）— standard/strict preset 強制
- 對齊條款：`tools/init-spec.md Phase 1-3` 結構建立流程

**修補方向 + 約束**：
- ✅ 必動：補建缺項目錄（依 init-spec phase 1-3 順序）
- 🚫 不可動：既有頂層目錄結構
- **推薦路徑**：跑 `/charter-init` 補建缺項

**反例**：
- ❌ AI 把 `capsules/` 缺項解讀為「不需要 capsules/ 此 preset」 → 違反 standard/strict preset 紀律
  - ✅ 正解：standard/strict preset 強制此 4 個頂層目錄、不可省

#### E604 詳盡引導（v0.8.1 加）

**合規規定**：
- 必須狀態：`roles/` 子目錄至少含 pm 或 engineer 之一（standard/strict preset）
- 對齊條款：`core/init-template.md §3.3 self-instantiation` + A1 公理「角色 ⊥ AI」

**修補方向 + 約束**：
- ✅ 必動：建立 `roles/<role>/` scaffold（依 `templates/agent-commons/_role.md.tpl`）
- 🚫 不可動：跨 vendor 預設機制（A1 公理「角色 ⊥ AI」）
- 🚫 不可代決：哪個 vendor 擔該角色 → user explicit 決定
- **推薦路徑**：邀請 AI 自具象化 role（不要 maintainer 寫死 vendor）

**反例**：
- ❌ AI 直接 mkdir 空 `roles/pm/` 目錄但無 `_role.md`
  - ✅ 正解：依 `templates/agent-commons/_role.md.tpl` 建立、含 init-template §2 八項最終狀態
- ❌ AI 寫死 `roles/pm/_role.md` 內含「PM = Gemini」（vendor lock-in）
  - ✅ 正解：A1 公理「角色 ⊥ AI」、_role.md 寫角色職責、不寫死 vendor

#### E605 詳盡引導（v0.8.1 加；諷刺循環攔截軸的執行載體）

**合規規定**：
- 必須狀態：`profile.yaml` `parameters.failure-modes.enable_modes` 含 `F6`（v0.7.0 起 standard/strict preset 預設）
- 對齊條款：
  - `core/failure-modes.md §F6`（surface-level vs structural-level、dogfood signal #4 條款化要求）
  - `tools/profiles/standard.yaml` / `strict.yaml` 預設值

**修補方向 + 約束**：
- ✅ 必動：在 `enable_modes` 列表加上 `F6`
- ✅ 補完前提：`enable_modes` 是 list 結構（如 `[F1, F2, F3, F4, F5, F6]`）
- 🚫 不可動：`profile.yaml` 其他段（domain_axioms / preset / charter_version 等）
- 🚫 不可代決：F6 不可缺、AI 不可建議「跳過 F6」（諷刺循環設計、E605 攔截「沒 F6」狀態本身）
- **推薦路徑**：直接在 `enable_modes` 列表末加 `F6`、不需動其他欄位、跑 `/charter-doctor` 重驗 → PASS

**反例**：
- ❌ AI 自作主張改 `enable_modes` 縮減到 `[F1, F2, F3]`（不含 F6）→ 違反 v0.7.0 後 standard/strict 紀律
  - ✅ 正解：完整含 F1-F6
- ❌ AI 建議「諷刺循環、沒 F6 也沒關係」（v0.7.0 公司接入失敗 dogfood signal #4 第三次同類、YC v0.8.0 升版 LIVE Gemini 編造同類）
  - ✅ 正解：F6 攔截不可繞、是 dogfood signal #4 條款化要求；E605 設計是攔截「沒 F6」狀態本身、AI 不可繞過

### 3.8 vendor 端 slash command schema 校驗（v0.7.4 spec 層 → v0.8.0 實作啟用）

> **動機**：對應 dogfood signal #16 條款化 — YC_AIAgentCrew（v0.5.9 接入）2026-04-28 user 重啟 Gemini CLI v0.39.1 時，3 個自具象化 toml（charter-init / engineer-init / pm-init）全部被 vendor 端 schema validator 抓出格式錯（nested table）跳過載入。原因：v0.5.9 接入時 Gemini PM 自具象化「自編 schema」、charter v0.5.9 〜 v0.7.3 此層 schema 規範完全空白。
>
> 對應 v0.7.0 加的 F6 sub-pattern「surface-level vs structural-level」精神在 vendor schema 層的實證 — toml 檔書寫存在（surface）≠ vendor 載入有效（structural）。本段把 vendor schema check 從「採用方踩坑後手動修」前移到「doctor 自動偵測」。

**校驗集**（v0.7.4 spec 層加 → v0.8.0 實作啟用、E801 / W802 列為強制；既有 v0.7.x 採用方升 v0.8.0 前須先跑一次 doctor 修補 vendor schema 不一致）：

```
對採用方專案內每個 vendor 端 slash command 檔：

  Claude Code  → <project>/.claude/commands/*.md
  Gemini CLI   → <project>/.gemini/commands/*.toml
  Cursor       → <project>/.cursor/rules/*.mdc
  其他         → 依該 vendor `<vendor>.md` 提供的位置規範

依對應 `roles/<role>/<vendor>.md` 內 schema 規範段（v0.7.4 加：
  roles/pm/gemini-cli.md §3.6 + roles/engineer/claude-code.md §4.1）逐項校驗：

1. 檔名 = 期望指令名（檔名 vs 指令名一致性）
2. 必填欄位齊（如 Gemini CLI toml 必含 root level prompt + description）
3. 禁用結構不出現（如 Gemini CLI toml 不可有 nested [command] table）
4. 內容滿足 init-template §2 八項最終狀態（七步驟全跑、§2 等效狀態達成）
```

| 失敗 | 狀態碼 | 處置 |
|---|---|---|
| vendor schema 違反（nested table / 缺必填 / 禁用欄位）| **E801**（v0.8.0 啟用）| 致命；依 `<vendor>.md` schema 規範修補（如 Gemini CLI toml 改扁平結構、移除 nested table）|
| vendor schema 規範未在 `<vendor>.md` 顯化 | **W802**（v0.8.0 啟用）| 警告：`<vendor>.md` 缺 schema 規範段；走 `ai-vendor-onboarding §3` 邀請 vendor 補完 |

#### E801 詳盡引導（v0.8.1 加；SSS S3 spec-as-data）

**合規規定**：
- 必須狀態：vendor 端 slash command 檔依對應 `roles/<role>/<vendor>.md` schema 規範段
- 對齊條款：
  - `roles/pm/gemini-cli.md §3.6`（toml 扁平結構強制、v0.7.4 加）
  - `roles/engineer/claude-code.md §4.1`（.md 純 markdown 規範、v0.7.4 加）

**修補方向 + 約束**：
- ✅ 必動：依 vendor schema 規範修補 slash command 檔（如 Gemini CLI toml 改扁平結構、移除 nested table）
- ✅ 補完前提：對應 `<vendor>.md` 已有 schema 規範段
- 🚫 不可動：vendor schema 規範本身（charter 既有條文）
- 🚫 不可代決：跨 vendor 設計（不可寫死 Claude Code hook / Gemini 沒對應機制等 vendor-specific 假設）
- **推薦路徑**：對照 `<vendor>.md` schema 段逐項對齊、跑 doctor 重驗 → PASS

**反例**：
- ❌ AI 寫 `.gemini/commands/charter-init.toml` 用 nested `[command]` table（v0.5.9 接入時 Gemini 自編 schema 違反、dogfood signal #16）
  - ✅ 正解：扁平結構、root level prompt + description（依 `roles/pm/gemini-cli.md §3.6`）
- ❌ AI 寫死 vendor-specific 工具（如 hook 注入身份戳寫進 charter 概念層）
  - ✅ 正解：走 `core/ai-vendor-onboarding §3` 邀請制 vendor 自實作

#### W802 詳盡引導（v0.8.1 加）

**合規規定**：
- 必須狀態：vendor schema 規範必在對應 `<vendor>.md` 顯化（不是 charter 概念層）
- 對齊條款：`core/ai-vendor-onboarding §3.1` 邀請制（charter 不代寫 vendor schema）

**修補方向 + 約束**：
- ✅ 必動：走 `core/ai-vendor-onboarding §3` 邀請制 step 2-4 補完 `<vendor>.md` schema 規範段
- 🚫 不可動：charter 概念層（不可在 `core/` 寫死 vendor schema）

**反例**：
- ❌ Maintainer 在 charter `core/init-template.md` 直接寫 Gemini CLI toml schema → 違反 ai-vendor-onboarding §3.1 邀請制
  - ✅ 正解：邀請 vendor 在 `roles/<role>/<vendor>.md` 自寫
- ❌ AI 看 W802 → 自己代寫 vendor schema 段給 charter（補丁）
  - ✅ 正解：W802 是給 maintainer 的提醒「該邀請 vendor 補完」、不是 AI 代寫信號

### 3.8.1 v0.7.4 → v0.8.0 漸進啟用路徑（已完成）

對齊 charter 北極星「**向下兼容嚴守**」紀律：

| 階段 | doctor 行為 | 對既有採用方影響 |
|---|---|---|
| **v0.7.4**（spec 層）| 規範寫進本 §3.8 + 各 `<vendor>.md` schema 段；doctor **不跑** vendor schema check | **零動作 migration**；既有採用方升版 doctor 不會跑出新 ERROR/WARN |
| **v0.7.5**（採用方體感優化期）| 仍 spec 層；YC_AIAgentCrew 升版實證觸發 dogfood signal #19/#20/#21 累積 | 同 v0.7.4 |
| **v0.8.0**（實作層、本 release 啟用）| doctor 啟用 §3.8 校驗、E801 / W802 報錯 | 升版前須**先跑一次** doctor + 修補 vendor schema 不一致；對應 `versioning-migration §3` 7 步流程 |

**v0.8.0 啟用條件**（已滿足）：
- 至少 2 個 vendor（Claude Code §4.1 / Gemini CLI §3.6）`<vendor>.md` schema 規範段已 v0.7.4 ship ✅
- `tools/post-upgrade-verify-spec.md`（v0.8.0 ship）軸 C C005 對齊本 §3.8 校驗、雙工具防禦 ✅
- 採用方升版指引：`core/versioning-migration §3.4` 跨多版本升級子段已 v0.7.5 ship + YC walkthrough 實證 ✅

→ v0.8.0 ship vendor schema 實作層、既有 v0.7.x 採用方升 v0.8.0 須跑 doctor 修補 vendor schema 不一致 — 屬可接受 BREAKING-LITE（v0.x 階段、純擴增校驗、不變更條款規範）。

### 3.9 axiom 紀律對齊（v0.8.0 加；dogfood signal #23 條款化）

對應 **dogfood signal #23** 第二次同類觀察（v0.7.0 公司接入第一次失敗：Gemini 寫 dbsdk.md schema 但檔案沒建 + v0.7.6 LIVE 公司專案接入第二次：Gemini 路徑 B 寫 axiom AI-DRAFTED + user 未升 USER-RATIFIED + init Phase 1-5b 跑通 + Phase 5b CHECK 7 PASS = surface PASS / structural fail）— v0.7.1 加路徑 B「不可在 AI-DRAFTED 啟動 init」紀律但執行載體缺位。

本段為 **doctor 端執行載體**（升版後 + 任意時點驗證）；`init-spec` Phase 5b CHECK 7 ext 為 **init 端執行載體**（fail-fast）；`post-upgrade-verify-spec.md` 軸 D 為 **升版專屬執行載體** — **三層雙重防禦**。

**校驗集**（v0.8.0 必跑）：

```
1. 對 profile.yaml `domain_axioms.primary` 指向的 axiom 檔：
   檔案物理存在（§3.5 領域公理檔存在已抓、本段不重抓物理存在）

2. 讀 axiom 檔 frontmatter：
   檢查 status 欄位值
     - status: USER-RATIFIED → PASS
     - status: AI-DRAFTED → ERROR (E606)
     - status: 其他值 / 缺 status → ERROR (E607)
   檢查 mutability_default 欄位（v0.7.1 scaffold）
     - 存在 → PASS
     - 缺 → WARN (W608)
```

| 失敗 | 狀態碼 | 處置 |
|---|---|---|
| axiom frontmatter `status: AI-DRAFTED`（未升 USER-RATIFIED） | **E606** | 致命；user 校 axiom 後改 frontmatter `status: AI-DRAFTED` → `USER-RATIFIED` + `created_by: ai-drafted` → `user-ratified-from-ai-draft` + 加校正紀錄行（依 `core/domain-axiom-slot §3.3` 路徑 B 紀律）|
| axiom frontmatter `status` 值非 USER-RATIFIED 也非 AI-DRAFTED | **E607** | 致命；違反 v0.7.1 雙路徑二態紀律；改回合法二態之一 |
| axiom frontmatter 缺 `mutability_default` 欄位 | **W608** | 警告；補上 `mutability_default: APPEND-ONLY`（v0.7.1 scaffold 預設值）|

**對應雙重防禦設計**：
- `tools/init-spec.md` Phase 5b CHECK 7 ext（v0.8.0 加）— init 階段 fail-fast、未升 USER-RATIFIED 不允許 init 跑通
- `tools/doctor-spec.md §3.9`（本段）— 升版後 + 任意時點驗證
- `tools/post-upgrade-verify-spec.md` 軸 D（v0.8.0 加）— 升版後 5 軸 verify 中的軸 D D001

三層同源紀律、三處執行載體 — 對齊 v0.7.3 北極星「**不讓 user 記**」精神（即使 user 跨 session / 下班再回、流程強制抓 axiom 升級狀態）。

#### E606 詳盡引導（v0.8.1 加；SSS S3 spec-as-data）

**合規規定**：
- 必須狀態：axiom 檔 frontmatter `status: USER-RATIFIED`
- 對齊條款：
  - `core/domain-axiom-slot §3.3` 路徑 B「不可在 AI-DRAFTED 啟動 init」紀律（v0.7.1 加）
  - `templates/agent-commons/domain-axioms-via-ai-draft-prompt.md.tpl` 第 5 步（v0.7.1 加）

**修補方向 + 約束**：
- ✅ 必動：user 校 axiom 內容後改 frontmatter `status: AI-DRAFTED` → `USER-RATIFIED`
- ✅ 補完前提：`created_by: ai-drafted` → `user-ratified-from-ai-draft` + 加校正紀錄行
- 🚫 不可動：axiom 內容本身的修訂權（path B「不可在 AI-DRAFTED 啟動 init」）
- 🚫 不可代決：升級到 `USER-RATIFIED` **必由 user 親操作**、AI 不可代

**反例**：
- ❌ AI 自我宣告「我已校過、status 改 USER-RATIFIED」（dogfood signal #23 第二次同類、v0.7.6 LIVE 公司專案接入第二次實證）
  - ✅ 正解：必由 user explicit 動作、AI 不可代
- ❌ AI 跑 init 時看到 `status: AI-DRAFTED` → 自動「為了讓 init 跑通」改 `USER-RATIFIED`
  - ✅ 正解：終止 init、回報 user「需先校 axiom 升 USER-RATIFIED」、AI 不可代

#### E607 詳盡引導（v0.8.1 加）

**合規規定**：
- 必須狀態：axiom frontmatter `status` 值合法二態（`USER-RATIFIED` 或 `AI-DRAFTED`）
- 對齊條款：`core/domain-axiom-slot §3.3` 路徑 B 雙路徑二態紀律（v0.7.1 加）

**修補方向 + 約束**：
- ✅ 必動：改回合法二態之一（依 `core/domain-axiom-slot §3.3` 路徑 B 紀律）
- 🚫 不可代決：哪一態屬必由 user 確認

**反例**：
- ❌ AI 自編 `status: PROVISIONAL` / `DRAFT` / 別的值
  - ✅ 正解：`USER-RATIFIED` 或 `AI-DRAFTED` 二擇一、不可創新

#### W608 詳盡引導（v0.8.1 加）

**合規規定**：
- 必須狀態：axiom frontmatter 含 `mutability_default` 欄位
- 對齊條款：`core/domain-axiom-slot §3.3` v0.7.1 frontmatter scaffold

**修補方向 + 約束**：
- ✅ 必動：補 `mutability_default: APPEND-ONLY`（v0.7.1 scaffold 預設值）
- 🚫 不可代決：mutability 級別（IMMUTABLE-by-AI / APPEND-ONLY / FULL-MUTABLE）必由 user 確認、AI 不可建議放寬

**反例**：
- ❌ AI 自編 `mutability_default: FULL-MUTABLE`（最寬鬆）→ AI 不該主動推「方便」級
  - ✅ 正解：v0.7.1 scaffold 預設 `APPEND-ONLY`、user 可改但 AI 不主動建議放寬

### 3.10 採用方文檔變更歷史 sync 校驗（v0.8.1 加；dogfood signal #24 條款化）

對應 **dogfood signal #24** 連續 ≥3 次同類違反（v0.7.4 / v0.7.5 / v0.8.0 三次 release 中 maintainer 漏執行 `core/maintainer-discipline §3.4.2` 文檔層 sync checklist 子項「變更歷史段（採用方文檔）」）— 已達 §3.4「升級該子項至 §3.1 工具層自動偵測」演化路徑觸發點。

**校驗集**（v0.8.1 加；非模式 B minimal 必驗、屬模式 A 全量檢查項）：

```
對採用方專案內 ADOPTION.md / TUTORIAL.md / QUICKSTART.md 三採用方文檔（檔名可採用方自定、依 mapping.yaml shared.adoption_doc / shared.tutorial / shared.quickstart 指向實際檔）：

  1. 讀檔末段「變更歷史」表（pattern：行內含「v<X.Y> | charter v<A.B.C>」格式）
  2. 讀 profile.yaml `charter_version` 值
  3. 比對：變更歷史最新 entry 對應的 charter v<A.B.C> 是否 == profile.yaml charter_version
     - 對應 → PASS
     - 不對應 → WARN (W901)
  4. 若採用方文檔不存在（mapping 未指向）：跳過、不報錯
```

| 失敗 | 狀態碼 | 處置 |
|---|---|---|
| 採用方文檔變更歷史最新 entry 不對齊 profile.yaml charter_version | **W901** | 警告；補齊變更歷史 entry（依 maintainer-discipline §3.4.2 紀律）或標記「升版過渡期」說明 |

#### W901 詳盡引導（v0.8.1 加；SSS S3 spec-as-data）

**合規規定**：
- 必須狀態：採用方文檔變更歷史最新 entry 對應的 charter version == profile.yaml charter_version
- 對齊條款：`core/maintainer-discipline §3.4.2` 文檔層 sync checklist（v0.7.2 加）

**修補方向 + 約束**：
- ✅ 必動：補齊缺漏的變更歷史 entry（如 ADOPTION.md §13 加 v1.X entry）
- ✅ 補完前提：依 `core/maintainer-discipline §3.4.2` 變更歷史 entry 格式（v<X.Y> | <date> | charter v<A.B.C> | <change-summary>）
- 🚫 不可動：既有 entry（保歷史紀錄完整、append-only）
- 🚫 不可代決：升版本身（AI 補變更歷史 entry ≠ 升版完成、charter_version 對齊與否是另一軸）

**反例**：
- ❌ AI 看到不對齊 → 自動把 charter_version 改到舊版本以「對齊」
  - ✅ 正解：補變更歷史 entry、不動 charter_version（charter_version 對齊由升版流程決定）
- ❌ AI 把 W901 解讀為「採用方升版未完成」並終止其他動作
  - ✅ 正解：W901 是 WARN 不是 ERROR、是「文檔層 sync 漏」提醒、不阻擋其他流程

**對應條款 / signal**：
- v0.7.2 ship 文檔層 sync checklist 為人為紀律 → v0.8.1 升工具層自動偵測
- dogfood signal #6「條款層 sync 與文檔層 sync 不對等」終局實作層
- `tools/post-upgrade-verify-spec.md` 軸 E（stale reference）擴含此項留 v0.8.x PATCH 後續（雙重防禦）

### 3.11 個體學習迴圈合規（v0.9.0 加；`core/individual-learning-loop §6` 對齊）

對應 **dogfood signal #34**（user 2026-04-30 LIVE 公司專案接入抓到「個體學習迴圈紀律缺失」、user 明示「框架必備」直接條款化）— charter v0.7.x 累積把 `core/violation-reflection §2`「LLM 不可矯正、價值在集體記憶」實作為集體記憶層（`state/failure_mode_log.md` + `institutional-memory/`），但**個體記憶層 + 跨 session 學習迴圈紀律缺失**：reflections/ 目錄無強制累積、F-mode 命中無雙寫對應、init 無 step 0 強制讀過去違反。

本段為 **doctor 端執行載體**（任意時點驗證個體學習迴圈是否落地）；`init-template §3.3.2 step 0` 為 **init 端執行載體**（fail-fast、不通則 step 1 禁止啟動）；`templates/agent-commons/reflection.md.tpl` 為 **個體層 entry 結構模板** — **三層雙重防禦**。

**校驗集**（v0.9.0 必跑、屬模式 A 全量檢查項；模式 B minimal 必驗集**含 W1101 + E1103**、不含 W1102（雙寫對應依賴 failure_mode_log 累積、self-instantiation 階段太早可能無 entry、可跳過））：

```
1. 對 <common-memory-root>/roles/<role>/_role.md 內 Status 為 ACTIVE 的角色：
   - <common-memory-root>/roles/<role>/reflections/ 目錄存在
   - 至少一個 reflection 檔（accumulating audit trail、新接入採用方首個 reflection 可為「無歷史」placeholder）
   缺 → W1101

2. 對 <common-memory-root>/state/failure_mode_log.md 內每個 F-mode 命中 entry：
   逐 entry 比對 <common-memory-root>/roles/<role>/reflections/ 下是否有對應檔
   匹配規則：檔名含 entry 對應 role + F-mode（個體層命名 <YYYY-MM-DD>_<f-mode>_<short>.md
     OR 舊格式 <task-id>-<role>-<f-mode>-x<count>.md 兩種並存）
   不對應 → W1102（雙寫紀律違反）

3. 對 <common-memory-root>/roles/<role>/reflections/ 下每個 reflection 檔：
   讀 frontmatter，必含五欄（date / role / vendor / status / violations）
   缺欄位或值為空 → E1103（致命）
```

| 失敗 | 狀態碼 | 處置 |
|---|---|---|
| reflections/ 目錄缺或空（ACTIVE 角色） | **W1101** | 警告：補建目錄 + 寫第一個 reflection（可為「首次接班、無歷史」placeholder 含合規 frontmatter） |
| failure_mode_log F-mode 命中 entry 無對應 reflection 個體層檔 | **W1102** | 警告：補寫 reflection 個體層 entry（依 `templates/agent-commons/reflection.md.tpl`）|
| reflection 檔 frontmatter 五欄不齊 | **E1103** | 致命：補完 frontmatter 必填欄位（date / role / vendor / status / violations）|

#### W1101 詳盡引導（v0.9.0 加；SSS S3 spec-as-data）

**合規規定**（charter ground truth）：
- 必須狀態：`<common-memory-root>/roles/<role>/reflections/` 目錄存在 + 至少一個 reflection 檔（ACTIVE 角色）
- 對齊條款：
  - `core/individual-learning-loop §2` 寫紀律（雙寫個體 + 集體）
  - `core/individual-learning-loop §3` 讀紀律（init step 0 強制讀）
  - `core/init-template §3.3.2 step 0`（v0.9.0 加；讀過去違反紀錄）

**修補方向 + 約束**：
- ✅ 必動：`mkdir -p <common-memory-root>/roles/<role>/reflections/` + 寫第一個 reflection（首次接班可為「首次接班、無歷史」placeholder、frontmatter 五欄齊）
- ✅ 補完前提：對應 role 的 `_role.md` Status 已 ACTIVE（PROVISIONAL 階段不要求 reflections/ 累積）
- 🚫 不可動：reflections/ 既有檔（永不刪除、依 `core/violation-reflection §5` append-only 紀律）
- 🚫 不可代決：reflection 內容質量（廢話也歸檔、依 `core/violation-reflection §2` 真價值是審計痕跡不是矯正）
- **推薦路徑**：依 `templates/agent-commons/reflection.md.tpl` 套用、frontmatter 五欄填齊、§1-§3 三段不可省

**反例**（charter 已駁回的 anti-pattern）：
- ❌ AI 看到 reflections/ 目錄缺 → 自行決定「ACTIVE 角色不需要 reflections/」（違反 individual-learning-loop §2 寫紀律）
  - ✅ 正解：v0.9.0 起 ACTIVE 角色必有 reflections/ 累積、不可省
- ❌ AI 看到 W1101 → 寫個空檔 placeholder 但 frontmatter 五欄不齊（順便撞 E1103）
  - ✅ 正解：placeholder 也須符合 frontmatter 五欄 schema、即使 violations: [] 也明示空陣列
- ❌ AI 把 W1101 解讀為「升版過渡期可豁免」自行跳過修補
  - ✅ 正解：W1101 是 WARN 不是阻擋、但補建是 v0.9.0 升版必動作（升版 walkthrough Step 3 對齊）
- ❌ AI 把 reflection 寫到 vendor 私有目錄（如 `.gemini/self_audit/` / `.claude/reflections/` / `.cursor/notes/` 等）
  - ✅ 正解：reflection 必須在 `<common_memory_root>/roles/<role>/reflections/`；vendor 目錄（`.gemini/` / `.claude/` / `.cursor/`）是橋接層、**不是** charter 共享記憶根（`core/common-memory-root §1`）。寫到 vendor 目錄 = W1101 偵測不到（doctor 只掃 common_memory_root 範圍）— 詳見 `roles/pm/gemini-cli.md §3.8`

#### W1102 詳盡引導（v0.9.0 加；雙寫對應軸）

**合規規定**：
- 必須狀態：`failure_mode_log.md` 每個 F-mode 命中 entry 在 `reflections/` 有對應檔
- 對齊條款：
  - `core/individual-learning-loop §2` 雙寫紀律（個體 + 集體）
  - `core/violation-reflection §3` 五段格式（既有集體層）
  - `templates/agent-commons/reflection.md.tpl`（v0.9.0 加；個體層）

**修補方向 + 約束**：
- ✅ 必動：對缺漏的 F-mode entry 補寫 reflection 個體層檔（依 `reflection.md.tpl`）
- ✅ 補完前提：failure_mode_log entry 完整（含 role / F-mode / 日期 — 缺則先修 entry 再補 reflection）
- 🚫 不可動：failure_mode_log 既有 entry（append-only、不可改既有歷史）
- 🚫 不可代決：補寫個體層 reflection ≠ 重寫集體層五段（兩者互補不互斥、依 reflection.md.tpl §3 雙寫紀律段）
- **推薦路徑**：逐個比對 failure_mode_log → reflections/ 缺項 → 依模板套用補寫、跑 doctor 重驗 → W1102 解除

**反例**：
- ❌ AI 看到 W1102 → 為對齊統計把 reflection 內容**抄自 failure_mode_log**（內容空虛）
  - ✅ 正解：個體層 reflection 是 AI 個體的學習迴圈起手 — §1 命中模式 + §2 學習要點 + §3 條款引用必含 AI 自視角的反思（即使廢話也歸檔、`violation-reflection §2`）
- ❌ AI 把舊事件 reflection 寫日期 = today（偽造時間軸）
  - ✅ 正解：補寫時 frontmatter date 寫**事件實際發生日**、檔名也用該日期前綴；「補登」事實另在 §1 註明（如「2026-04-30 補登 2026-04-15 漏寫」）
- ❌ AI 為了讓 W1102 解除把對應條款 §3 引用空表
  - ✅ 正解：§3 必含 charter 條款編號鏈（`core/<condition>.md §X` + `tools/<spec>.md §Y` + 對應 IM entry）、不可空

#### E1103 詳盡引導（v0.9.0 加）

**合規規定**：
- 必須狀態：reflection 檔 frontmatter 含五欄（date / role / vendor / status / violations）
- 對齊條款：
  - `templates/agent-commons/reflection.md.tpl` frontmatter schema
  - `core/structural-anti-fabrication.md`（frontmatter 缺欄即視同未交付、抽驗方有權直接退稿）

**修補方向 + 約束**：
- ✅ 必動：補完 frontmatter 五欄（date 用事件實際日期 / role 對應接班角色 / vendor 對應 AI 廠商 / status: 強化抽驗 / user 裁決待議 / 結案 三擇一 / violations 為 F-mode 編號陣列、空陣列也要明示 `[]`）
- 🚫 不可動：既有正文段落（§1-§3）— 補完 frontmatter ≠ 重寫
- 🚫 不可代決：status 升降（強化抽驗 → 結案 屬抽驗方判定、AI 不可代決）
- **推薦路徑**：對照 `reflection.md.tpl` frontmatter 區塊逐欄補完、跑 doctor 重驗 → E1103 解除

**反例**：
- ❌ AI 自編新欄位（如 `severity: high`）想表達「重要」但模板無此欄
  - ✅ 正解：依模板五欄、不可創新；嚴重度透過 violations F-mode + status 表達
- ❌ AI 把 violations 寫純文字描述（如 `violations: 假宣告就位`）
  - ✅ 正解：violations 是**陣列**、值是 F-mode 編號或條款 §引用（如 `[F1, role-separation §3.5]`）
- ❌ AI 看到 E1103 致命 → 為了讓 doctor PASS 直接刪該 reflection 檔
  - ✅ 正解：reflection 永不刪除（`violation-reflection §5` append-only）— 補完 frontmatter、不可刪檔；刪檔本身是**新一輪 F-mode 命中**（湮滅證據）、抽驗方有權升級至 user 裁決

**對應條款 / signal**：
- dogfood signal #34（user 2026-04-30 LIVE 直接條款化、明示「框架必備」）
- charter v0.5.7 working-stack-discipline 補完接班場景三軸 → v0.9.0 補完第 4 軸（個體 AI 跨任務 / 跨 session 學習迴圈）
- `tools/post-upgrade-verify-spec.md` 軸 C / 軸 E 擴含本段校驗留 v0.9.x PATCH 後續（雙重防禦）

### 3.12 平行獨語 Gap 偵測（v0.9.1 加）

> **設計動機**（dogfood signal #36）：dbSDK LIVE 觀察 — Kiro（工程師 AI）維護 `kiro-sync-point-01~10.md`、Gemini（PM AI）維護 `checkpoint_gemini.md`，兩者各自平行記錄、無共享 handoff 文件。doctor 既有校驗無法偵測「形同虛設目錄」與「平行獨語」狀態，無法引導修復。本段新增五個 Warning 碼補完此 Gap。

**Gap 分類表**（模式 C Step 3 判定依據）：

| 檔案模式 | Gap 性質 | charter 目標路徑 | 格式轉換需要 |
|---|---|---|---|
| `*-sync-point-*.md` / `checkpoint_<vendor>.md` | AI 個人工作日誌（分散） | `roles/<ai>/sessions/` | 否（直接搬移） |
| `S\d+-*.md`（sprint 任務） | 任務膠囊候選 | `capsules/` | 建議（依 `capsule.md.tpl`） |
| `S\d+-*-report.md`（sprint 報告） | 已封存任務記錄 | `capsules/`（archived） | 建議 |
| `*history*.md` / `*refactor*.md`（知識積累） | 機構記憶條目候選 | `institutional-memory/` | 建議（依 IM entry tpl） |
| `architecture.md` / `*-instructions.md` / `GEMINI.md`（根目錄） | 領域公理 / vendor 指引 | `protocols/` 或 vendor dir | 視內容決定 |
| **多個 AI 各自分散狀態檔** | 跨 AI 狀態（需合併） | `handoffs/HANDOFF_1.md` | 是（多來源合併） |
| `agent-commons/<dir>/`（空目錄） | 形同虛設 scaffold | 保留目錄 + 補初始檔 | 否（補充內容） |

#### W1201 平行獨語狀態 (Parallel Monologue)（v0.9.1 加）

**合規規定**：
- 必須狀態：跨 AI 協作的共享狀態以 `handoffs/HANDOFF_<N>.md`（單一真相來源）存在；不得多個 AI 各自維護分散狀態檔而無共享 handoff
- 對齊條款：
  - `core/working-stack-discipline.md`（handoff-chain 為跨 session 接班的執行載體）
  - `core/individual-learning-loop.md §3`（個體 session notes 路徑 `roles/<ai>/sessions/`、不替代共享 handoff）

**偵測邏輯**：
```
若 handoffs/ 目錄不存在 或 handoffs/ 內無任何 HANDOFF_*.md
且 專案根目錄 / docs/ / 任意子目錄含多個疑似 AI 狀態檔（各 AI 名稱各異）
→ 命中 W1201
```

**修補方向 + 約束**：
- ✅ 必動：進入模式 C Step 2-6，引導 user 將分散狀態合併建立 `handoffs/HANDOFF_1.md`
- 🚫 不可動：不自動合併（合併邏輯含取捨判斷、需 user 主導）
- 🚫 不可刪除分散檔：原始 AI 工作日誌有歷史價值，建議搬至 `roles/<ai>/sessions/`（保留）
- **推薦路徑**：模式 C 互動引導 → user 確認分散檔的「個人日誌」vs「共享狀態」性質 → 個人日誌歸 `sessions/`、跨 AI 共享部分合併建立首個 HANDOFF

**反例**：
- ❌ AI 把所有分散 checkpoint 直接 concat → HANDOFF_1.md（無取捨、雜訊滿載）
  - ✅ 正解：引導 user 提取「下一個 AI 需要知道的最小知識」合成 handoff（`working-stack-discipline.md §3` 格式）
- ❌ AI 刪除 `kiro-sync-point-01~10.md` 以「清理根目錄」
  - ✅ 正解：搬至 `roles/kiro/sessions/`（保留個體工作歷程）

**對應條款 / signal**：
- dogfood signal #36（dbSDK LIVE 2026-04-30、user 直接條款化）

---

#### W1202 handoffs/ 形同虛設（v0.9.1 加）

**合規規定**：
- 必須狀態：若 `handoffs/` 目錄存在，則至少含一個 `HANDOFF_1.md`（或對應編號）
- 對齊條款：`core/working-stack-discipline.md §3`（handoff 文件格式規範）

**偵測邏輯**：
```
若 handoffs/ 目錄存在 且 handoffs/ 內無任何 .md 檔
→ 命中 W1202
```

**修補方向 + 約束**：
- ✅ 必動：進入模式 C，引導建立 `handoffs/HANDOFF_1.md`（依 `working-stack-discipline.md §3` 模板）
- 🚫 不可代填：HANDOFF 內容必須反映**真實當前狀態**；AI 不可捏造「目前狀態：無」等空殼

**反例**：
- ❌ AI 建立內容全空的 `HANDOFF_1.md` 讓 W1202 消失
  - ✅ 正解：填入真實的接班者閱讀資訊（當前任務 / 待議事項 / 已知風險）

---

#### W1203 capsules/ 形同虛設（v0.9.1 加）

**合規規定**：
- 必須狀態：若 `capsules/` 目錄存在，則實際被使用（含至少一個 `.md` 任務膠囊，或 `README.md` 說明「目前無活躍任務」）
- 對齊條款：`core/working-stack-discipline.md`（任務膠囊為工作分解載體）

**偵測邏輯**：
```
若 capsules/ 目錄存在 且 capsules/ 內無任何 .md 檔
→ 命中 W1203
```

**修補方向 + 約束**：
- ✅ 選項 A：進入模式 C 將現有 sprint 任務文件（`S\d+-*.md`）轉換為膠囊格式
- ✅ 選項 B：建立 `capsules/README.md` 說明「尚無活躍任務膠囊」（合規、不強制有任務）
- 🚫 不可代填真實任務資訊

---

#### W1204 institutional-memory/ 形同虛設（v0.9.1 加）

**合規規定**：
- 必須狀態：若 `institutional-memory/` 目錄存在，則含至少一個知識積累條目，或 `README.md` 說明「目前無條目」
- 對齊條款：`core/working-stack-discipline.md`（機構記憶為跨 session 知識積累載體）

**偵測邏輯**：
```
若 institutional-memory/ 目錄存在 且 目錄內無任何 .md 檔
→ 命中 W1204
```

**修補方向 + 約束**：
- ✅ 選項 A：進入模式 C 將現有歷史 / 重構文件轉換或引用為 IM 條目
- ✅ 選項 B：建立說明性 README（不強制必須有知識積累，但目錄不可完全空洞）
- 🚫 不可代填：知識條目須反映真實學習積累

---

#### W1205 failure_mode_log 缺失（v0.9.1 加）

**合規規定**：
- 必須狀態：`state/failure_mode_log.md` 存在（即使無任何 entry，空檔也合規）
- 對齊條款：
  - `core/individual-learning-loop.md §3`（雙寫紀律：F-mode 命中 → 寫集體 failure_mode_log）
  - `core/violation-reflection.md §5`（append-only log）

**偵測邏輯**：
```
若 state/failure_mode_log.md 不存在
→ 命中 W1205
```

**修補方向 + 約束**：
- ✅ 必動：建立 `state/failure_mode_log.md`（空檔含 frontmatter header 即合規）
- ✅ 可由 AI 直接建立（無需 user 取捨、純 scaffold）
- 🚫 不可偽造過去 F-mode entry（初始化時新建空檔、不追溯填入）

**反例**：
- ❌ AI 為讓 W1205 消失、偽造過去的 F-mode entry（「補填」歷史）
  - ✅ 正解：空檔即合規；若確有過去事件需補填，走 `core/individual-learning-loop.md §3` 雙寫流程（補登事實在 §1 注明）

---

## 4. `health-report.md` 輸出格式

依 `structural-anti-fabrication.md` 強制：含實際 stdout 區塊，非純文字結論。

```markdown
# AgentCharter Health Report — <project-name>

> 產生時間：<UTC + 本地>
> Charter version：0.4.0
> Profile preset：standard
> 整體狀態：✅ 全綠 / ⚠️ 有 N 個警告 / ❌ 有 N 個錯誤

## 1. 結構完整性

​```bash
ls -la <common-memory-root>/_config/
​```

​```text
<實際輸出>
​```

✅ profile.yaml 存在
✅ mapping.yaml 存在
✅ schema 版本相容（0.4.0 ↔ 0.4.0）

## 2. 條款相依

| 條款 | 啟用 | 依賴狀態 |
|---|---|---|
| audit-rights | ✅ | OK |
| violation-reflection | ✅ | OK（依賴 audit-rights / failure-modes / structural-anti-fabrication 全綠）|

## 3. 路徑對映

​```bash
for p in $(yq '.shared | to_entries | .[].value' mapping.yaml); do ls -la "$p" 2>&1; done
​```

​```text
<實際輸出>
​```

✅ 所有 shared 路徑存在
⚠️ roles.engineer.reflections 路徑不存在（可能是計畫中目錄）

## 4. 角色 init slash command

​```bash
ls -la .claude/commands/*-init.md
grep -l "步驟 1〜5" .claude/commands/*-init.md
​```

✅ engineer-init.md 結構完整
✅ pm-init.md 結構完整

## 5. 領域公理

​```bash
ls -la <domain_axioms.primary>
grep -c "^##" <domain_axioms.primary>
​```

✅ IRON.md 存在，含 11 個 § 條款

## 6. 失敗模式狀態

抽驗 `<failure_mode_log>` 最近事件：

​```bash
tail -20 <failure_mode_log>
​```

INFO 當前無進行中事件。

## 7. 修復建議（若有失敗）

- W201：建立 management/roles/engineer/reflections/ 目錄
  ​```bash
  mkdir -p management/roles/engineer/reflections
  ​```
```

---

## 5. 退出碼

| Code | 含義 |
|---|---|
| 0 | 全綠 |
| 1 | 有 INFO 但無錯誤 |
| 2 | 有警告 |
| 3 | 有錯誤（必修）|
| 4 | 致命錯誤（無 `<common-memory-root>/` 或 domain_axioms 缺失）|

CI / pre-commit hook 可依退出碼 gate。

---

## 6. `--fix` 互動模式

對每個失敗項：

```
1. 顯示問題描述 + 建議修復指令
2. 詢問使用者：apply / skip / explain more
3. apply → 自動執行修復指令並重檢
4. skip → 標註於 health-report，繼續
5. explain → 顯示對應 condition 條文的相關段
```

對致命錯誤（E001/E002/E401）：直接中斷，無互動。

**§3.12 W120x 命中時的特殊行為**（v0.9.1 加）：
- W1201（平行獨語）/ W1202（handoffs/ 空）命中時，`--fix` 自動進入**模式 C 互動式 Gap 遷移**（§2.1 模式 C）
- 模式 C 流程六步驟（§2.1 模式 C 說明）全程互動式確認；AI 不自主執行任何搬移
- W1203 / W1204（capsules/ / institutional-memory/ 空）：輕量版模式 C — 僅提案建立說明性 README 或引導轉換現有文件，不強制進入完整六步驟
- W1205（failure_mode_log 缺失）：AI 可直接建立空檔（最低影響操作、詢問確認後執行）

---

## 7. 與其他條款的關係

| 條款 | 關係 |
|---|---|
| `core/charter-config.md` | doctor 是 schema 的執行驗證器 |
| `core/structural-anti-fabrication.md` | health-report 含 stdout 區塊 |
| `tools/init-spec.md` | init Phase 5 自動跑一次 doctor |
| `core/escalation-protocol.md` | 偵測強化抽驗模式狀態 |
| **`core/init-template.md §3.3.2 step 5`**（v0.5.10）| **self-instantiation 結尾強制呼叫點**（呼叫模式 B，本檔 §2.1）；不通則 self-instantiation 視為失敗 |
| **`core/failure-modes.md F6`**（v0.5.10）| 跳過模式 B 直接簽名 = F6（未驗證即宣告就緒、轉嫁驗證負擔）|
| **`core/individual-learning-loop.md`**（v0.9.1）| §3.12 W1205 failure_mode_log 缺失偵測 + §3.11 W1101/E1103 雙重防禦 |
| **`core/working-stack-discipline.md`**（v0.9.1）| §3.12 W1201-W1204 的合規對齊條款；handoff-chain 為跨 AI 協作單一真相來源 |
| **`roles/doctor/_spec.md`**（v0.9.1 加）| System Doctor 角色概念層定義（可選角色、自具象化執行 /charter-doctor）|

---

## 8. 實作節奏

| 版本 | 內容 | 狀態 |
|---|---|---|
| v0.4 | Spec only — 本文檔初版 | ✅ |
| v0.5.0 | 配置目錄合併（spec 對齊延遲到 v0.5.7） | ✅ |
| v0.5.1 | §3.4 自我具象化狀態檢查段加入 | ✅ |
| v0.5.7 | 曾落地為 python 工具 | ⛔ 後於 v0.5.9 移除 |
| v0.5.9 | 回歸純 spec — framework 不附實作工具 | ✅ |
| **v0.5.10** | **§2.1 呼叫模式拆分**（A 人工 / B self-instantiation 結尾強制驗證點）；§7 反向引用加 `init-template §3.3.2 step 5` + `failure-modes F6`。**觸發**：dogfood signal #4 於 YC_AIAgentCrew 接入（2026-04-28）實證；驗證從「使用者另一動作」內化到「self-instantiation 流程內必跑」 | ✅ |
| **v0.7.0** | **§3.7 加結構頂層完整性 + namespace vs 檔案路徑校驗**（E601/E602/E603/E604/E605）；§2.1 模式 B minimal 必驗集擴充含 §3.7。**觸發**：dogfood signal #4 第三次同類（公司專案接入失敗 2026-04-28）— `shared.*` namespace 被 Gemini 誤翻譯為檔案系統目錄，整個 agent-commons/ 結構錯位 + F6 漏啟用 + dbsdk.md 完全沒建。對應 charter-config.md mapping schema 段加註明的雙重防禦 | ✅ |
| **v0.7.4** | **§3.8 加 vendor 端 slash command schema 校驗**（spec 層、實作 defer v0.8+）+ §3.8.1 v0.7.4 → v0.8+ 漸進啟用路徑說明。**觸發**：dogfood signal #16 條款化（YC_AIAgentCrew 2026-04-28 Gemini CLI v0.39.1 載入 toml 失敗、charter v0.5.9 〜 v0.7.3 vendor schema 規範完全空白）。**嚴守向下兼容**：v0.7.4 doctor 不跑此 check、既有採用方升版零新 ERROR/WARN；實作待 v0.8+ 對齊 `core/adoption-lifecycle.md` 完整化後啟用 | ✅ |
| **v0.8.0** | **§3.8 vendor schema 從 spec 層升實作層**（E801/W802 列為強制）+ §3.8.1 漸進路徑表加 v0.8.0 已完成行 + **§3.9 加 axiom 紀律對齊**（E606/E607/W608 — axiom frontmatter status 二態紀律執行載體）+ §2.1 模式 B minimal 必驗集擴含 §3.9。**觸發**：(a) v0.7.4 spec 層累積至 v0.8.0 實作層啟用條件滿足（vendor schema 段已 ship + post-upgrade-verify 軸 C C005 對齊雙工具防禦）；(b) **dogfood signal #23 條款化**（v0.7.0 公司接入第一次失敗 + v0.7.6 LIVE 公司專案接入第二次同類觀察、user 直接授權跳過 ≥3 次累積門檻、同 v0.5.8 / v0.7.1 / v0.7.4 直接條款化 pattern）— init-spec Phase 5b CHECK 7 ext 為 init 端執行載體、本 §3.9 為 doctor 端執行載體、post-upgrade-verify 軸 D 為升版專屬執行載體、三層雙重防禦 | ✅ |
| **v0.8.1** | **SSS S3 起手實證 — doctor-spec 既有 error codes 全加四欄 spec-as-data 結構**（合規規定 / 修補方向 + 約束 / 反例）：§3.7 E601-E605（5 個 H4 子段）+ §3.8 E801/W802（2 個）+ §3.9 E606/E607/W608（3 個）+ **新加 §3.10 採用方文檔變更歷史 sync**（W901、dogfood signal #24 升工具層）+ §3.7 校驗集第 2 條措辭修（dogfood signal #19 雙重否定）。**觸發**：(a) 2026-04-30 multi-perspective 評估第十四循環 — external Engineer Round 3-4 提案被 4 sub-agent 反向校準後、SSS S3「引導式紀律」起手實證；(b) **dogfood signal #24 條款化**（v0.7.4/v0.7.5/v0.8.0 連續 ≥3 次同類違反、達 §3.4 演化路徑觸發點）；(c) **dogfood signal #19 順手修**（YC v0.8.0 升版 LIVE Gemini 把合規「shared/ 不存在」誤標 WARN）。**對齊**：v0.7.3 北極星「不讓 user 記」+ v0.7.4 雙軌節奏「頻繁小擴增 PATCH」+ feedback `structural-over-patch` 紀律（spec 結構升維、不是規範補丁）+ `core/violation-reflection §2`「LLM 個體不重要、集體記憶才重要」設計方向（spec 自帶反例段抹掉「LLM completionist 易踩」需求） | ✅ |
| **v0.9.0** | **新加 §3.11 個體學習迴圈合規**（W1101 reflections/ 累積 / W1102 雙寫對應 / E1103 frontmatter 五欄；全 3 個含四欄 spec-as-data 結構）+ §2.1 模式 B minimal 必驗集擴含 §3.11 W1101 + E1103（W1102 屬模式 A 全量）。**觸發**：**dogfood signal #34 條款化**（user 2026-04-30 LIVE 公司專案接入抓到「個體學習迴圈紀律缺失」、user 明示「框架必備」直接條款化、跳過 ≥3 次累積門檻、同 v0.5.8 / v0.7.1 / v0.7.4 user 直接條款化 pattern）— charter v0.7.x 把 `core/violation-reflection §2` 集體記憶實作完成、但個體層 + 跨 session 學習迴圈紀律缺失（reflections/ 無強制累積 / F-mode 命中無雙寫對應 / init 無 step 0 強制讀過去違反）。本 §3.11 為 doctor 端執行載體；`init-template §3.3.2 step 0` 為 init 端執行載體；`templates/agent-commons/reflection.md.tpl`（v0.9.0 加）為個體層 entry 結構模板 — 三層雙重防禦。**對齊**：(a) charter v0.5.7 working-stack-discipline 補完接班場景三軸 → v0.9.0 補完第 4 軸（個體 AI 跨任務 / 跨 session 學習迴圈）；(b) v0.7.3 北極星「不讓 user 記」對 AI 角度補完（既有對採用方角度 walkthrough + verify、v0.9.0 補對 AI 個體的學習迴圈強制讀寫）| ✅ |

| **v0.9.1** | **新加 §3.12 平行獨語 Gap 偵測**（W1201 平行獨語 / W1202 handoffs 空 / W1203 capsules 空 / W1204 institutional-memory 空 / W1205 failure_mode_log 缺；全含四欄 spec-as-data 結構）+ **§2.1 模式 C 互動式 Gap 遷移修復**（六步驟流程 + 執行約束 + Gap 分類表）+ **§6 W120x --fix 特殊行為**（W1201/W1202 → 完整模式 C；W1203/W1204 → 輕量版；W1205 → 直接建空檔）+ **§7 三個新關係引用**（individual-learning-loop / working-stack-discipline / roles/doctor）。**觸發**：**dogfood signal #36 條款化**（2026-04-30 LIVE — dbSDK 公司專案 Kiro + Gemini 平行獨語實例、user 直接識別「doctor 應有此能力」，與 `init-spec.md Phase 3.5` scaffold 預防 + `roles/doctor/_spec.md` 角色概念層同批 ship）。**北極星**：偵測 Gap → 辨識性質 → 互動式引導歸位 → 縮小 Gap 至零 | ✅ |

**實作模式**：採用方對 AI prompt「依本 spec 跑健康檢查」+ 順便自具象化 `/charter-doctor` slash command（依 `core/init-template.md §3.3` self-instantiation 精神）。

→ framework 維持「純規範」位階；工具實作由各 AI 自行管理（對齊「角色 ⊥ AI」+「framework 不代生成」原則）。
