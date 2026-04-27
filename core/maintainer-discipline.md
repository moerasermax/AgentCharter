# Maintainer Discipline（框架維護者紀律）

> **狀態**：v0.1（自 v0.5.8 引入）
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

### 3.1 工具層：`charter-doctor.py --self-check`（**v0.6+ 候選**）

擴充 `charter-doctor.py` 加 `--self-check` 旗標，對 charter repo 自身做一致性檢查：

| 檢查項 | 偵測方式 |
|---|---|
| 條款引用一致性 | 解析 `core/*.md` 內 `core/<filename>.md` 引用，verify 該檔存在 |
| spec 與 core 條款路徑對齊 | 解析 `tools/*-spec.md` 內 `<common-memory-root>/_config/` 引用是否還有殘留 `.agentcharter/` 舊路徑 |
| profile yaml 啟用清單對齊 core 條款檔 | `tools/profiles/*.yaml.enabled` 的 keys 須等於 `core/*.md` 檔名（去 .md）|
| `_spec.md §7` 對應 AI 表 vs `<vendor>.md` 檔案 | `roles/<role>/_spec.md` 表中標 ✅ 的 vendor，對應 `<vendor>.md` 須實際存在 |
| CHANGELOG 條款修訂 vs 條款檔變更 | git log 找 core 條款的最新修改 commit，對照 CHANGELOG entry |

當前狀態：⏳ **未實作**。優先序見 NEXT.md §3 工具 phase 候選。

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

未來再撞到同類觀察時：

- 若工具層（self-check）已實作 → 應被自動偵測
- 若仍漏 → 加 #3 #4 ... 累積到 NEXT.md，evaluate 是否升級條款（如把 §3.1 self-check 從「候選」變成「required」+ 條款 §1 加強制力）

---

## 8. 變更歷史

- **v0.1（自 v0.5.8 引入）** — 初版。對應 v0.5.7 期間累積的兩次 dogfood signal（framework 維護者違反自己條款）。**特殊位階**：對採用方無關（三 preset 預設 `false`），對 framework 維護者強制（自我約束 + 工具輔助）。
