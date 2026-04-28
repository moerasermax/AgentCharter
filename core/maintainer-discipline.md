# Maintainer Discipline（框架維護者紀律）

> **狀態**：v0.2（自 v0.7.2 加 §3.4 文檔層 sync checklist；v0.1 自 v0.5.8 引入）
> **位階**：core 通用條款，但**位階特殊** — 對 framework 維護者生效，對採用方無關（採用方修自己的 charter copy 不適用本條款）
> **依存**：`working-stack-discipline.md`（DRAFT 紀律也適用維護者）、`versioning-migration.md`（升版同步 spec 時機）、`structural-anti-fabrication.md`（commit message 須含證據）、`audit-rights.md`（PR review 是 maintainer 的 audit 機制）

---

## 0. 概念定位（為何引入）

### 0.1 兩次實證觸發本條款

charter v0.5.7 期間累積兩次「framework 維護者違反自己條款」觀察：

| # | 日期 | 事件 | 違反條款 |
|---|---|---|---|
| 1 | 2026-04-27 | Claude 在 onboarding 討論說「dogfood signal 記在腦中」| 違反 `working-stack-discipline §1`（DRAFT 須是檔案而非對話累積）|
| 2 | 2026-04-27 | v0.5.0 / v0.5.1 修條款時未同步 `tools/{init,scan,doctor}-spec.md`，導致 user 在第二專案踩坑 | 隱性違反「條款修訂須對齊全 charter」（**之前無此條款**）|

兩次同源：「**framework 維護者沒走自己定義的紀律**」。

### 0.2 對應的 framework 設計矛盾

charter 對**採用方**有完整條款 + 工具強制（doctor / audit-rights / escalation 等）。但對**維護者本身**：

- 沒有 audit AI 抽驗 maintainer commit
- 沒有 hook 強制 spec sync
- v0.x 階段「dogfooding 取捨」（STATUS §D）讓 framework 自己**不採用 charter**，避免遞迴卡死

→ 結果：framework 維護者寫了條款 ≠ 自動遵守條款。本條款是這個矛盾的明示解。

### 0.3 本條款的位階特殊

不同於其他 core 條款（規範採用方 + 維護者）：

| 條款 | 對採用方 | 對維護者 |
|---|---|---|
| `working-stack-discipline` 等 16 條 | ✅ 強制 | ✅ 適用（精神，無外部強制） |
| **本條款（`maintainer-discipline`）** | ❌ 不適用 | ✅ **強制**（自我約束 + 工具輔助） |

採用方修自己的 charter copy 時不必啟用本條款；本條款的 enabled 在三個 preset 預設都是 `false`。

---

## 1. 條文

framework 維護者**修改 charter repo 內** `core/` / `templates/` / `tools/*-spec.md` / `roles/<role>/_spec.md` 任一檔時，須執行「**spec sync check**」 — 檢查所有引用該檔的位置是否需同步更新。違反 → 下次撞到的採用方會踩坑（如 dogfood signal #2 實證）。

且 framework 維護者本身須遵守 `working-stack-discipline §1`「DRAFT 須是檔案而非對話累積」（dogfood signal #1 對應）。

---

## 2. 範圍

### 2.1 「修改」的定義

| 動作 | 算 |
|---|---|
| 條款內容修訂（增 / 改 / 刪段落）| ✅ |
| schema 變更（如 `charter-config §3` mapping 加欄）| ✅ |
| 條款重命名 | ✅ |
| 修字 / 補例 / CHANGELOG 修訂 | ❌（PATCH-level，不觸發 sync check）|

### 2.2 「引用」的範圍

修 `core/<X>.md` 時須檢查的引用點：

| 引用類型 | 位置 |
|---|---|
| 其他 core 條款的 §「與其他 core 條款的關係」表 | `core/*.md` |
| `tools/{init,scan,doctor}-spec.md` 引用 | `tools/*.md` |
| `templates/agent-commons/*.tpl` 引用 | `templates/agent-commons/*.tpl` |
| `templates/management-layout.md` | （若有引用 X）|
| `examples/<project>/mapping.md` | `examples/*` |
| `roles/<role>/_spec.md` + `<vendor>.md` | `roles/*` |
| 採用方文件 | `README.md` / `QUICKSTART.md` / `TUTORIAL.md` / `ADOPTION.md` |
| 配置範本 | `tools/profiles/{minimal,standard,strict}.yaml` |
| 變更歷史 | `CHANGELOG.md` |
| 內部追蹤 | `.claude_temp/STATUS.md` / `NEXT.md` |

修 `templates/<X>.tpl` 時：對應的 core 條款（如 `_role.md.tpl` 對應 `init-template.md`）+ 引用該 template 的 `tools/init-spec.md`

修 `tools/<X>-spec.md` 時：對應的 python 工具（`charter-{init,doctor,scan}.py`）行為一致性

---

## 3. 三層執行機制

對應條款條文的**強制力**（自我約束 + 工具輔助，無外部強制）：

### 3.1 工具層：spec-driven self-check（**由 auditor 角色執行**）

> **v0.6.0 演化**：原「由 AI 自具象化執行」（無明確角色載體）改為「**由 auditor 角色執行**」 — 對應 `roles/auditor/_spec.md`（v0.6.0 新增、maintainer-only 位階）。auditor 透過 fresh-context sub-agent / 不同 session / 邀請其他 vendor 達成「他抽」屬性（避免自抽自驗）。

依 `core/init-template.md §3.3` self-instantiation 精神 + `core/ai-vendor-onboarding.md §3` 邀請制流程，charter 維護者可請已具象化 auditor 角色的 AI 跑以下檢查項，或 prompt 自具象化 `/charter-self-check` slash command：

```
請依以下檢查項對 charter repo 自身做一致性檢查，並順便具象化為
/charter-self-check slash command 給未來重用。

檢查項：
| 檢查項 | 偵測方式 |
|---|---|
| 條款引用一致性 | 解析 core/*.md 內 core/<filename>.md 引用，verify 該檔存在 |
| spec 與 core 條款路徑對齊 | 解析 tools/*-spec.md 內路徑引用是否殘留 .agentcharter/ 舊路徑 |
| profile yaml 啟用清單對齊 core 條款檔 | tools/profiles/*.yaml.enabled 的 keys 須等於 core/*.md 檔名（去 .md）|
| _spec.md §7 對應 AI 表 vs <vendor>.md 檔案 | roles/<role>/_spec.md 表中標 ✅ 的 vendor，對應檔案須存在 |
| CHANGELOG 條款修訂 vs 條款檔變更 | git log 找 core 條款最新修改 commit，對照 CHANGELOG entry |

完成後輸出 stdout 報告，並把流程具象化為 .claude/commands/charter-self-check.md。
```

當前狀態：⏳ **未自具象化**（charter repo 可隨時跑此 prompt 建出來）。本條款 §3.1 是「**規範**」，具體執行由維護者按需求觸發。

對齊 v0.5.9 「framework 不附實作工具」原則 — 所有工具動作由 AI 自具象化，charter repo 不維護 python / npm 等實作通道。

### 3.2 流程層：CONTRIBUTING.md 補 PR checklist

PR template 加：

```markdown
## Maintainer Spec Sync Check

修改了哪類檔案？對應同步檢查：

- [ ] 改了 `core/<X>.md` → 檢查所有引用該條款的檔（依 maintainer-discipline §2.2）
- [ ] 改了 `tools/<X>-spec.md` → 檢查對應 python 工具行為一致性
- [ ] 改了 `templates/<X>.tpl` → 檢查 init-spec / 採用方文件範例
- [ ] 改了 `tools/profiles/*.yaml` → 檢查三 profile 一致性 + charter_version
- [ ] 修改條款 → CHANGELOG 對應版本 entry 寫好
- [ ] 修了 schema → STATUS / NEXT 同步
```

當前狀態：⏳ **CONTRIBUTING.md 補強未做**。優先序見 NEXT.md §中優先。

### 3.3 commit 層：commit message 含 sync 軌跡

依 `structural-anti-fabrication.md` 精神，maintainer commit 須在 message 顯式列出同步修改的檔案範圍：

```
feat(core): <X> 條款修訂

## 同步修改範圍（依 maintainer-discipline §2.2）

- core/<X>.md：主修改
- core/<Y>.md §關係：加反向引用
- tools/init-spec.md：路徑對齊
- tools/profiles/*.yaml：enabled 加
- README / ADOPTION / CHANGELOG：同步
```

當前狀態：✅ **已自然執行**（v0.5.x 系列 commit 已養成此習慣）。本條款只是顯性化此習慣。

### 3.4 文檔層 sync checklist（v0.7.2 加，dogfood signal #6 三次同類條款化）

> **動機**：v0.6.1 / v0.7.0 / v0.7.1 連續三次踩同類坑 — 條款層改完整、文檔層改部分（漏 numeric / version / 反向引用 / 兜底範圍）。本段把「文檔層 sync」**從 §2.2 引用範圍表的子項顯化為獨立 checklist**，避免 maintainer 在 release 流程下意識跳過。

修條款 / spec / template 後，依序自驗以下 checklist（**附 git log + grep 證據**）：

#### 3.4.1 條款層連動 sync

- [ ] **`§ 與其他 core 條款的關係` 表雙向引用**：本次新增段（如 v0.7.0 Phase 5b、v0.7.1 §3.3 路徑 B）— 是否在所有同源條款（如 structural-anti-fabrication / failure-modes 等）的 §關係表加反向引用？grep 驗證
- [ ] **變更歷史對齊**：所有動到的 condition / spec / role 是否都有 `§變更歷史` 加新版本 entry（patch 級也要寫）？
- [ ] **schema 跨檔一致**：欄位名（如 frontmatter `status` / `mutability_default`）在 condition / template / prompt 範本三處用詞是否完全一致？

#### 3.4.2 文檔層連動 sync（採用方視角）

- [ ] **`charter_version` 跨檔同步**：`tools/profiles/*.yaml` 三檔 + `ADOPTION.md` line 5 + `TUTORIAL.md` line 6 + `.claude/commands/maintainer-load.md` 「當前狀態」段 — 全部更新到本 release 版號？
- [ ] **條款數同步**：若新增 / 刪除條款 — `README.md` 條款目錄 + `ADOPTION.md §3` + `QUICKSTART.md` 「條款數速查」段 + `TUTORIAL.md §3.3` preset 表母數 — 全部對齊？
- [ ] **流程圖 / step 順序對齊**：若改 phase / step（如 v0.7.0 加 Phase 5b、v0.7.2 重排 QUICKSTART Step 2-3）— `init-spec` / `doctor-spec` / `QUICKSTART` / `TUTORIAL` 流程圖是否更新？
- [ ] **變更歷史段（採用方文檔）**：`ADOPTION.md §13` / `TUTORIAL.md` 變更歷史 — 是否加本 release 對應 entry（含採用方升版注意事項）？

#### 3.4.3 內部追蹤層 sync（maintainer 視角）

- [ ] **CHANGELOG.md** 本 release 段：含 Triggered by / Added / Changed / Triggered（dogfood signal）/ 採用方影響 / 第 N 循環說明
- [ ] **`.claude_temp/STATUS.md` Version 軌跡**加新 entry + 演化軸表加 + 架構級概念加（如有）+ §D 跨議題盲點段加新 dogfood signal entry
- [ ] **`.claude_temp/NEXT.md` ⚪ 待對話段**：本 release 已條款化的 signal **從待議移除**（劃線 + ✅ vN.M 完成）+ 已完成段加新 entry + 新候選 signal 加待議

**違反處置**：

| 違反 | 處置 |
|---|---|
| 修條款後漏文檔層 sync 任一項 | 累積為 dogfood signal #6 觀察；user / 採用方撞到時補 fix commit + commit message 標明「補 maintainer-discipline §3.4」|
| 連續 ≥ 3 次同類違反同一子項 | 評估升級該子項至 §3.1 工具層自動偵測（如 doctor §3.7 加 schema 一致性 check）|
| 文檔層 sync 漏導致採用方接入失敗 | 視同 F6 sub-pattern「surface vs structural」— 我（maintainer）以為「條款 ship 了」（surface）= 採用方體驗（structural）— 補 fix commit 並反省 |

**對應 §3.1 工具層的演化路徑**：

未來（v0.8+）若 §3.4 累積觀察成熟，可考慮把部分 checklist 子項上移到 §3.1 工具層由 auditor 自動偵測（如 charter_version 跨檔一致性 / 反向引用對稱性等）。當前 v0.7.2 階段為「人工 checklist + auditor 抽驗」雙保險。

---

## 4. 違反處置（自我抽驗）

framework 自身的 commit 沒有外部 audit AI，違反處置依以下機制：

| 違反方式 | 處置 |
|---|---|
| 修條款沒同步 spec / template / 引用 | **發現時**（採用方撞到 / self-check 抓出 / 後續 commit review）→ 補 fix commit + commit message 標明「補 maintainer-discipline §X」+ 記為 dogfood signal |
| DRAFT 累積在對話內（違反 working-stack-discipline §1）| 發現時補做紀錄 + 記為 signal（dogfood signal #1 即此處置範例）|
| 連續 ≥ 3 次同類違反 | 觸發本條款條款化加嚴 / 機制升級（如 self-check 從候選變成 required） |

→ 沒有「強化抽驗模式」對應（無外部 audit 主體）；維護者自我約束為主。

---

## 5. 與 dogfooding 取捨的關係

### 5.1 v0.x 階段：charter 自己不採用 charter

對應 STATUS §D「dogfooding 取捨」：v0.x 條款仍在演化，硬上會卡死遞迴。charter 自己用 `.claude_temp/` 替代 `agent-commons/`。

但**本條款的精神（紀律對齊）**仍生效：

- working-stack-discipline §1 對 maintainer 仍適用 → maintainer 須用 `.claude_temp/` 檔案累積，不靠對話
- spec sync check 對 maintainer 適用（不需要 framework 採用即可執行）

### 5.2 v1.0 後：可能升級為 charter 完整自採用

當 v1.0 條款穩定後，charter 可考慮自己採用完整 framework（建 `agent-commons/` 走完整流程）。屆時本條款的執行機制（§3.1〜§3.3）可能整合進 charter 自身的 doctor / audit 流程。

NEXT.md §10「AgentCharter 自身 dogfooding」對應此議題。

---

## 6. 與其他 core 條款的關係

| 條款 | 關係 |
|---|---|
| `working-stack-discipline` | §1「DRAFT 須是檔案」對 maintainer 也適用；本條款 §1 條文明示 |
| `versioning-migration` | maintainer 升 charter_version 時須走 §3.1 7 步流程；spec sync check 是該流程的延伸 |
| `structural-anti-fabrication` | maintainer commit message 含同步軌跡（§3.3）為精神延伸 |
| `audit-rights` | PR review 是 maintainer 的 audit 機制（無外部 audit AI 時的替代）|
| `failure-modes` | 維護者違反觸發 F4（紀錄偏差）/ F5（規則記憶失效）— 但無外部抽驗主體，靠自我審查 |
| `escalation-protocol` | **不適用**（無外部 audit）— maintainer 違反走 §4 自我抽驗，不走升級協議 |
| `charter-config` | 本條款在三 profile yaml 預設 `false`（採用方無關）|

---

## 7. 對應 dogfood signal（記為條款化依據）

本條款引入時對應已知 signals：

| Signal | 日期 | 事件 | 對應本條款段 |
|---|---|---|---|
| #1 | 2026-04-27 | Claude 違反 working-stack-discipline §1（DRAFT 對話累積）| §1 條文後段 + §4 違反處置 |
| #2 | 2026-04-27 | v0.5.0/v0.5.1 修條款時未同步 tools/*-spec.md | §1 條文前段 + §2.2 引用範圍 + §3 三層機制 |
| #3 | 2026-04-27 | user 全域 skill `~/.claude/commands/checkpoints.md` 路徑硬編碼 `management/`，不對齊 charter mapping.yaml 抽象 | §1 條文（工具應對齊 charter 抽象）；具體工具修法在 NEXT.md 追蹤 |
| **#6 第一次** | 2026-04-28（v0.6.1）| auditor 第一次實戰抓到 v0.6.0 release 文檔層漏 numeric / version | §3.4 文檔層 sync checklist（v0.7.2 條款化）|
| **#6 第二次** | 2026-04-28（v0.6.1 後 session）| auditor 第二次實戰抓到 templates 範圍兜底含糊 | §3.4 文檔層 sync checklist（v0.7.2 條款化）|
| **#6 第三次** | 2026-04-28（v0.7.1 後）| **user 直覺連續兩次 IDE 開 `core/structural-anti-fabrication.md` 抓到 maintainer + auditor 漏的 §5 反向引用同步**（v0.7.0 + v0.7.1 加段全漏）| §3.4 文檔層 sync checklist（v0.7.2 條款化、達 ≥3 次同類門檻）|

未來再撞到同類觀察時：

- 若工具層（self-check）已實作 → 應被自動偵測
- 若仍漏 → 加 #3 #4 ... 累積到 NEXT.md，evaluate 是否升級條款（如把 §3.1 self-check 從「候選」變成「required」+ 條款 §1 加強制力）

---

## 8. 變更歷史

### v0.2（自 v0.7.2 起）

**動作**：§3 三層執行機制加 **§3.4「文檔層 sync checklist」**子項 — 拆 3 個子段（3.4.1 條款層連動 / 3.4.2 文檔層連動採用方視角 / 3.4.3 內部追蹤層）+ 違反處置表 + 對應 §3.1 工具層的演化路徑說明。§7 dogfood signal 表加 #6 三次同類條目（含 user 直覺第三次抓到的事件）。

**觸發**：dogfood signal #6 「條款層 sync 與文檔層 sync 不對等」第三次同類觀察 — 2026-04-28 v0.7.1 release 後、user 連續兩次 IDE 開 `core/structural-anti-fabrication.md` 抓到 maintainer + auditor 都漏的 §5 反向引用同步（v0.7.0 + v0.7.1 加段全部沒同步）。累積三次達 §4 違反處置「連續 ≥ 3 次同類違反 → 觸發本條款條款化加嚴」門檻。

**user 直覺實證**：本條款 §3.4 條款化的觸發來自 user **以採用方身份對 charter 行使「他抽」屬性** — 對應 v0.7.0 加 Phase 5b「採用方半邊他抽」的精神在 charter 自身演化的現場實證。charter 設計剛好被 user 直覺驗證、形成完整迴路。

**修訂類型**：MINOR（位階特殊：對採用方無關、僅 framework 維護者強制）— 加新段落、不破壞既有 §3.1〜§3.3 三層機制。連動條款不變（採用方 enabled 仍預設 `false`、相依鏈不變）。

### v0.1（自 v0.5.8 引入）

初版。對應 v0.5.7 期間累積的兩次 dogfood signal（framework 維護者違反自己條款）。**特殊位階**：對採用方無關（三 preset 預設 `false`），對 framework 維護者強制（自我約束 + 工具輔助）。
