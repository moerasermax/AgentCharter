---
date: <YYYY-MM-DD>
role: <role>
vendor: <vendor>
status: 強化抽驗
violations: [<必須引用 failure_mode_log.md 已登記的 F-mode ID，不可自編 — 如 F1, F3 / role-separation §3.5>]
---

# 違規反省：<TASK_ID>_<F-MODE>_<SHORT_DESC>

> **建立日期**：<YYYY-MM-DD>
> **角色**：<role>（<vendor>）
> **位階**：個體層學習迴圈 entry — 依 `core/individual-learning-loop §2` 雙寫紀律（個體層 ＝ 本檔；集體層 ＝ `state/failure_mode_log.md`）
> **依據**：<觸發來源 — F-mode 命中 / 抽驗退稿 / user 抓到 / self-instantiation step 0 抓出歷史漏寫補登>

> frontmatter 五欄必填，缺欄位 → doctor §3.11 E1103。
> status 三值擇一：`強化抽驗`（進行中）/ `user 裁決待議`（等 user 決定）/ `結案`（已解決）。

---

## 1. 命中模式（按 charter F-mode 分類）

> 逐個列 F-mode 命中事件、含 evidence + 對應條款引用。

### F-mode #N — `<F1 / F3 / role-separation §3.5 ...>`

- **觸發脈絡**：<具體任務 / 場景 — 引用 capsule / handoff 編號>
- **違規 stdout**（宣告方當時提交內容、原文）：

```text
<原文>
```

- **證偽 stdout**（抽驗方 / 後手 AI 用以證偽的指令 + 真實輸出）：

```bash
<指令>
```

```text
<真實 stdout>
```

- **對應條款**：`core/<condition>.md §X` — <一句話描述違反的紀律>

---

## 2. 學習要點（next-time 紀律）

> 每條鐵律一行：未來如何避免、引用 charter 條款。
>
> ⚠️ **接受**結構性內容（依 `core/violation-reflection §3` 接受清單）；
> **不接受**「我會更小心」「下次注意」等廢話。
>
> 廢話仍會歸檔當作違規模式證據（§2 真價值是審計痕跡、不是矯正）。

- **L1 — <鐵律一句話>**：<具體未來偵測 / 結構強制路徑> — 引用 `core/<condition>.md §X` / `tools/<spec>.md §Y`
- **L2 — <鐵律一句話>**：<同上>

---

## 3. 對應條款引用（完整鏈）

| 引用 | 連動處 |
|---|---|
| `core/<condition>.md §X` | <為何相關 — 違規對應的紀律本體> |
| `tools/<spec>.md §Y` | <如校驗載體、如執行載體> |
| `templates/<tpl>` | <若涉及範本層> |
| `state/failure_mode_log.md` 對應 entry | <集體層雙寫對應、依 individual-learning-loop §2> |
| `institutional-memory/<entry>.md` | <若已升 IM 五段格式、引用對應 §章節> |

---

## 模板使用指南

實例化此模板時替換以下變數：

| 變數 | 範例 |
|---|---|
| `<TASK_ID>` | `TASK_S70` / `TICKET_123` / `INC-2026-001` 等專案約定 |
| `<F-MODE>` | `F1` / `F3` / `F6` / `role-separation §3.5` 等 |
| `<SHORT_DESC>` | 短描述（snake_case，如 `mock_db_passed_prod_failed`）|
| `<role>` | `engineer` / `pm` / `reviewer` 等 |
| `<vendor>` | `claude-code` / `gemini-cli` / `cursor` 等 |

### 檔名規則

`<YYYY-MM-DD>_<f-mode>_<short>.md`（v0.9.0 加，個體層、依 `core/individual-learning-loop §2`）

或舊格式 `<event-id>.md`（如 `S70-pm-f1-x5.md`，依 `core/violation-reflection §5`）— 兩種並存，新採用方建議用 v0.9.0 格式（日期前綴方便 init step 0 撈最近 N 個）。

### 雙寫紀律（依 `core/individual-learning-loop §2`）

- **集體層必寫**：`<common-memory-root>/state/failure_mode_log.md`（既有、F-mode 累積統計）
- **個體層必寫**：`<common-memory-root>/roles/<role>/reflections/<filename>.md`（本檔）
- **不可只寫一邊**（doctor §3.11 W1102 抓「集體有 entry / 個體無對應檔」）

### 讀取紀律（依 `core/individual-learning-loop §3`）

每次 self-instantiation **step 0 必讀**自己 reflections/ 最近 5 個 + failure_mode_log + IM。
不通則 step 1 禁止啟動（依 `core/init-template §3.3.2 step 0`）。

### Placeholder 變體（violations: [] 時使用）

首次 init 無違規歷史、或新 session 合規佔位用。僅需 frontmatter 五欄合規，段落 §1-§3 可省略（Interface 聲明 → 結構合規；Implementation 為空 → 尚無違規歷史可填）。

最小合規 placeholder：

````markdown
---
date: <YYYY-MM-DD>
role: <role>
vendor: <vendor>
status: 結案
violations: []
---

# 違規反省 placeholder — <role> 初始化合規佔位

> **建立日期**：<YYYY-MM-DD>
> **角色**：<role>（<vendor>）
> **依據**：self-instantiation — 首次 init，無違規歷史
````

### 為什麼此模板獨立於 `violation-reflection.md` §3 五段格式

- `violation-reflection §3` 五段 = **每事件級**集體記憶結構（vendor-agnostic、跨 session 集體價值）
- 本模板 = **個體 + 跨 session 學習迴圈** entry — 補完 charter v0.5.7 working-stack 三軸接班場景的**第 4 軸**（個體 AI 跨任務 / 跨 session 學習）

兩者**互補不互斥**：F-mode 命中時既寫集體層（依 §3 五段）也寫個體層（依本模板 §1-§3）— 雙寫對應，缺一即 doctor §3.11 W1102。

### 不可省略的紀律

- §1 至少一個 F-mode 命中段（缺即無此 entry 存在意義）
  ↳ **例外**：`violations: []` placeholder 變體可省略 §1-§3（見上方 Placeholder 變體說明）
- §2 至少一條鐵律（未來偵測路徑必含）
- §3 對應條款引用（charter 條款編號完整、不可空表）
- frontmatter 五欄齊（doctor §3.11 E1103 致命）

省略段落 = 違反 `core/structural-anti-fabrication.md`，抽驗方有權直接退稿並要求重寫。
