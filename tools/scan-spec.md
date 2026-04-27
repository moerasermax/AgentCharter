# /charter-scan — 智慧掃描器設計

> **狀態**：v0.5.7 對齊（spec only，無實作；v1.0 後做）
> **位階**：tools / 設計文檔。
> **掃描智慧度**：A3（LLM 內容判讀）
> **v0.5.7 對齊註記**：原 v0.4 spec 寫 `<common-memory-root>/_config/` 路徑（v0.5.0 已合併到 `agent-commons/_config/`）。本檔已同步對齊。實作優先序排在 `charter-init.py`（已落地）+ `charter-doctor.py`（已落地）+ `charter-upgrade.py`（v0.6+）之後。

---

## 1. 目標

讓既有專案接入 AgentCharter 時**不需要重組目錄**。透過掃描既有檔案系統，產出：

1. `scan-report.md` — 給人看的探測報告
2. `mapping-draft.yaml` — 給工具用的路徑對映草稿
3. 信心分數，標註哪些對映需要使用者確認

---

## 2. 輸入 / 輸出

### 輸入

- 專案根目錄路徑（預設：`$CLAUDE_PROJECT_DIR` 或當前 cwd）
- 可選：忽略清單（`<common-memory-root>/_config/scan-ignore`，類似 .gitignore）

### 輸出

| 檔案 | 用途 |
|---|---|
| `<project>/<common-memory-root>/_config/scan-report.md` | 人類可讀的探測結果 + 推論依據 |
| `<project>/<common-memory-root>/_config/mapping-draft.yaml` | 自動生成的 mapping.yaml 草稿 |

`/charter-scan` **不直接寫入** `mapping.yaml` — 草稿須使用者 review 後由 `/charter-init` 升級。

---

## 3. 掃描流程（A3 LLM 判讀）

### Phase 1：粗收集

```
1. 用 glob 收集所有 .md / .yaml / .json / .toml 檔
   - 排除：node_modules / .git / bin / obj / dist / build
   - 排除：scan-ignore 規則
2. 依路徑深度分桶（management/、docs/、tasks/、history/ 等）
3. 統計各目錄檔案數、最近修改時間、命名 pattern
```

### Phase 2：候選分桶

依目錄 / 檔名關鍵字做**粗篩**，產候選清單：

| 槽位 | 關鍵字 hint |
|---|---|
| `capsules` | `task` / `capsule` / `tickets` / `issues` |
| `handoffs` | `handoff` / `history` / `session` / `checkpoint` |
| `protocols` | `protocol` / `governance` / `rules` / `charter` / `policy` |
| `institutional_memory` | `memory` / `wiki` / `lessons` / `postmortem` |
| `nextwork` | `nextwork` / `backlog` / `todo` / `roadmap` |
| `domain_axioms` | `IRON` / `axiom` / `safety` / `invariant` / 任何全大寫檔名 |

### Phase 3：LLM 內容判讀（A3 核心）

對每個候選目錄：

```
1. 抽樣 3〜5 份檔案
2. 截取前 50 行 + 後 30 行（避開引用 / footnote 雜訊）
3. 構造 prompt 給 LLM：
   "以下是 <path> 內某 .md 的內容片段。判斷它最像下列哪個槽位：
    capsule | handoff | protocol | institutional_memory | nextwork | domain_axiom | other
    回答格式：
      slot: <slot-name>
      confidence: <0.0-1.0>
      reasoning: <一句話>
      keywords_matched: [...]
   片段：
   <content>"
4. 收集 N 份檔的判讀，多數決 + 平均信心分數
5. 信心 >= 0.7 → 寫進 mapping-draft.yaml
   信心 0.4-0.7 → 寫進 mapping-draft.yaml 但標註「需確認」
   信心 < 0.4 → 不寫入 mapping，列入 scan-report 「待釐清」段
```

### Phase 4：角色推論

掃描特定 hint 推論專案有哪些角色：

| 觀察 | 推論 |
|---|---|
| 出現 `engineer-init.md` / `engineer-notes/` | 啟用 `engineer` 角色 |
| 出現 `pm-*` / `PM_*` / `Operational_Manual` | 啟用 `pm` 角色 |
| 出現 `review-*` / `reviewer-` | 啟用 `reviewer` 角色 |
| 出現 `qa-*` / 測試報告專屬目錄 | 推論 `qa` 角色（未啟用，僅 hint）|

---

## 4. `scan-report.md` 結構

依 `structural-anti-fabrication.md` 強制：報告含 stdout 區塊、不寫純文字結論。

```markdown
# Scan Report — <project-name>

> 產生時間：<UTC + 本地>
> Charter version：0.4.x
> 掃描智慧度：A3 (LLM 判讀)

## 1. 探測摘要

| 槽位 | 對映路徑 | 信心 | 狀態 |
|---|---|---|---|
| capsules | management/capsules/ | 0.92 | ✅ 自動採用 |
| handoffs | management/history/HANDOFF_*.md | 0.88 | ✅ 自動採用 |
| protocols | management/protocols/ | 0.95 | ✅ 自動採用 |
| domain_axioms.primary | management/protocols/Dev_Protocol_IRON.md | 0.97 | ✅ 自動採用 |
| roles.engineer | (未發現顯著證據) | 0.30 | ⚠️ 待釐清 |

## 2. LLM 判讀原文（每槽位至少一份）

### capsules（信心 0.92）

​```text
抽樣檔：management/capsules/TASK_S70_DASHBOARD_PNL_CORRECTION.md
LLM 判讀：
  slot: capsule
  confidence: 0.95
  reasoning: 含「## 1. 動機」「## 5. 驗收計畫 (VCP)」結構，符合典型任務膠囊格式
  keywords_matched: [VCP, 驗收計畫, 動機, 修法範圍]
​```

（其餘槽位同格式）

## 3. 待釐清項目

- `roles.engineer.sessions` 未發現顯著對應目錄。建議：
  a) 若無，profile.yaml 設 violation-reflection 為 false
  b) 若有但命名不同，手動補 mapping
  c) 若採用 AgentCharter 推薦結構，新建 management/roles/engineer/

## 4. 下一步

執行 `/charter-init <preset>` 套用 mapping-draft.yaml。
```

---

## 5. `mapping-draft.yaml` 結構

直接是 `core/charter-config.md §3` 定義的 mapping schema，但每行加註信心分數註解：

```yaml
version: "0.4.0"

shared:
  capsules: management/capsules/        # confidence: 0.92
  handoffs: management/history/         # confidence: 0.88
  protocols: management/protocols/      # confidence: 0.95
  institutional_memory:
    - management/protocols/Institutional_Memory.md  # confidence: 0.91
  nextwork: management/history/NextWork.md          # confidence: 0.85

roles:
  # 注意：roles.engineer 信心 0.30，建議手動確認後再啟用
  # engineer:
  #   sessions: ???
  #   reflections: ???

domain_axioms:
  primary: management/protocols/Dev_Protocol_IRON.md  # confidence: 0.97
  alias: IRON
```

---

## 6. 邊界場景處理

| 場景 | 處置 |
|---|---|
| 完全空白專案（無任何 management/）| 全槽位信心 0.0；建議使用 `templates/management-layout.md` 從零建立 |
| 多個候選同槽位（兩個目錄都像 capsule）| 列出全部，標信心分數，待使用者選 |
| LLM 判讀互相矛盾（5 份抽樣 3 種結論）| 信心 < 0.4，列入待釐清 |
| 大型專案（> 1000 .md）| 抽樣分層（每 100 份取 5 份），不全跑 |
| 第二語言內容（中文 / 英文混雜）| LLM 已可處理；prompt 不指定語言 |

---

## 7. 工具實作節奏

| 版本 | 實作層級 | 狀態 |
|---|---|---|
| v0.4 | Spec only — 本文檔即交付物 | ✅ |
| v0.5.7 | 路徑對齊 v0.5.0 配置合併（spec 內容更新；無實作）| ✅ |
| v1.0+ | python 原型 + 整合 Anthropic / Gemini API 做 LLM 判讀 | ⏳ 留 v1.0 後（需 LLM judgment 工作量大）|

→ 當前外部採用方應走「**手動建 + python charter-init.py**」路徑，不依賴 scan。既有 protocols 的對映 → 跑完 init 後手動 `git mv` 進 `agent-commons/protocols/`（依 TUTORIAL §3.5）。

---

## 8. 與其他條款的關係

| 條款 | 關係 |
|---|---|
| `core/charter-config.md` | 掃描輸出對映 mapping.yaml schema |
| `core/structural-anti-fabrication.md` | scan-report 含 LLM 判讀原文（stdout 區塊）|
| `core/evidence-first.md` | 信心分數 + 原文引用提供證據鏈 |
| `templates/management-layout.md` | 推薦結構作為「從零建立」的對比基準 |
