# PM × Antigravity CLI — Implementation

> **狀態**：v1.1（v0.11.0 候選；v1.0 path A AI-DRAFTED-FROM-GEMINI-V1.8 同日上午 + v1.1 LIVE 第二輪校正同日下午 — dbSDK PM AI 親讀 SKILL.md 實檔回報：Skill 子目錄結構 `~/.gemini/skills/<name>/SKILL.md` + frontmatter `name:` 欄位必填）
> **基於**：`roles/pm/_spec.md`
> **AI（vendor tool）**：Google Antigravity CLI（binary `agy`、自 2026-05-19 取代 Gemini CLI）
> **AI（underlying model）**：可選 — Gemini 3 / Claude Sonnet 4.6 / Claude Opus 4.6 / GPT-OSS 120B（Antigravity 為 multi-model vendor、模型由 `~/.config/antigravity/config.toml` 或 `/model` slash command 切換）
> **vendor_status**：DRAFT-AI-DRAFTED-FROM-GEMINI-V1.8（path A、含同日 LIVE 第二輪校正升 path A LIVE-CALIBRATED；等真實 Antigravity PM AI 完整接入後升 SIGNED）
> **vendor_supports**：Antigravity CLI `agy` v1.0+（Antigravity 2.0 agent platform、I/O 2026 發布）
> **沉澱來源**：`roles/pm/gemini-cli.md` v1.8 平移 + Gemini CLI 棄用 LIVE 事件 dogfood signal #60 觸發（2026-05-22）+ dbSDK PM AI 跨 vendor 報告 LIVE 校正（`.claude_temp/DBSDK-CROSS-VENDOR-SLASH-COMMAND-REPORT-2026-05-22.md`）
> **since**：v0.11.0

本檔以「概念層 / Antigravity 實作 / 跨 AI 對應」三層結構撰寫，目的不只給 Antigravity 用，更作為**未來扮演 PM 的任何 AI 的參考範本**（對應 charter A1 公理「角色 ⊥ AI」）。

**vendor tool ⊥ underlying model 的兩軸分解**（v1.0 加、對應 dogfood signal #60 結構性觀察）：

- **vendor tool 層**（本檔規範）：Antigravity CLI 自身的工具系統 — Skills / Hooks / Subagents / Plugins / MCP / `agy` binary
- **underlying model 層**（不本檔規範）：實際執行 PM 行為的 LLM 模型（Gemini 3 / Claude / GPT-OSS）— 透過 `/model` 切換

charter A1「角色 ⊥ AI」在 Antigravity 場景拆兩軸：role ⊥ vendor tool ⊥ underlying model。本檔規範 role × vendor tool 那一層；underlying model 的選擇由採用方依任務性質決定（如 Claude Sonnet for thinking-heavy reasoning、Gemini 3 for high-throughput）。

---

## §1 工具能力清單（Vendor Spec — Antigravity CLI v1.0）

| 能力概念（跨 AI）| Antigravity CLI 實作 | 跨 AI 對應 |
|---|---|---|
| 指令容器（角色 init 流程）| **`~/.gemini/skills/<name>/SKILL.md`**（**子目錄結構**、全域 only、無 workspace 級、Markdown 格式、與 Gemini CLI 共用 `~/.gemini/` 根、LIVE 第二輪校正 2026-05-22）| Gemini CLI（legacy）→ `.gemini/commands/<name>.toml`；Claude → `.claude/commands/*.md`；Cursor → `.cursor/rules/*.mdc`；無指令 AI → `<common-memory-root>/roles/<role>/init-prompt.md` 純 prompt fallback |
| Hook 系統（事件攔截 / 注入）| Plugin lifecycle hooks（JSON-defined、事件：`before tool call` / `after file edit` / `on session start`）| Gemini CLI → 弱、依賴 `GEMINI.md` / `AGENTS.md` 注入；Claude → `UserPromptSubmit` hook；Cursor → `.cursorrules` 全域注入 |
| Shell 執行（驗收工具）| `run_shell_command`（PS / Bash、繼承自 Gemini CLI 工具集）| Claude → `Bash` tool；Cursor → 終端機整合；無 shell AI → 要求使用者貼上 stdout |
| 檔案精確編輯 | `replace`（含 `allow_multiple`、繼承自 Gemini CLI 工具集）| Claude → `Edit`（str_replace 模式）；Cursor → `Apply` 介面；其他 → 全檔覆寫 `write_file` |
| Persistent memory（per-project）| `save_memory(scope="project")`（繼承自 Gemini CLI）+ context file `GEMINI.md` / `AGENTS.md`（自動載入）| Claude → `~/.claude/projects/<hash>/memory/`；其他 → 用 git-tracked Institutional_Memory.md |
| Persistent memory（global）| `save_memory(scope="global")` + `~/.gemini/GEMINI.md` 全域 context | Claude → `~/.claude/CLAUDE.md` + 全域 `settings.json`；其他 → 使用者定義的系統提示 |
| Subagent 委派 | `/agent <name> "..."` slash command（Antigravity 把 sub-agents 升為 first-class concept、含 async multi-agent orchestration）| Gemini CLI → `invoke_agent(agent_name=...)`；Claude → `Agent` tool（含 Explore / Plan / general-purpose）；Cursor → Composer（多模型）|
| Web fetch / search | `web_fetch`、`google_web_search`（繼承自 Gemini CLI 工具集）| Claude → `WebFetch` / `WebSearch`；Cursor → `@Web`；其他 → 使用者提供瀏覽結果 |
| Background tasks | Antigravity 原生 async multi-agent orchestration（terminal 不鎖、可背景跑長任務）| Claude → `Bash run_in_background` + `Agent run_in_background`；其他 → 透過使用者中繼監控 |
| 跨 session 持久狀態 | 物理檔案（`<common-memory-root>/handoffs/`）| 跨 AI 通用：依 `working-stack-discipline.md` 規範之 MD 存檔 |
| 視覺 / 多模態驗收 | `read_file` 支援 PNG / JPG（繼承自 Gemini CLI 工具集）| Claude → `Read` 支援 PNG / JPG / PDF；Cursor → 圖片預覽；其他 → 使用者描述 UI 現象 |
| 結構化任務追蹤 | 透過 Skills 機制可定義 task tracking skill（非內建工具、需自具象化）| Claude → `TaskCreate` / `TaskUpdate` / `TaskList` / `TaskGet`；Gemini CLI → 無；其他 → 同 |
| User interactive prompt | 對話自然語言詢問、無 structured prompt 原生工具 | Claude → `AskUserQuestion`；Gemini CLI → 同；其他 → 同 |
| MCP server 整合 | `mcp_config.json`（路徑未 LIVE 校正、暫推測 `~/.gemini/` 子目錄、遠端 server 用 `serverUrl`）| Gemini CLI → 內嵌 `~/.gemini/settings.json`、遠端用 `url`（**注意 url → serverUrl 是 breaking rename**）；Claude → `.mcp.json`；其他 → 各 vendor 各別 |
| Underlying model 切換（multi-model） | `/model <name>` slash command 即時切（如 `/model claude-sonnet-4-6`）+ `~/.config/antigravity/config.toml` pin 預設 | **Antigravity 獨有** — Gemini CLI 鎖 Gemini family；Claude Code 鎖 Claude；Cursor 多模型但 UX 不同 |

---

## §2 PM 職責執行細節

對應 `roles/pm/_spec.md §3`，每個職責三層結構（核心概念 / Antigravity 實作 / 跨 AI 對應）。

### 3.1 任務契約化（Task Contracting）

**核心概念**（跨 AI 通用）：將需求轉化為具約束力的物理契約檔（capsule），定義 `DEFINITION_OF_DONE` 與 `FAILURE_MODES`，防止執行期需求漂移。涉及外部 API / 效能 / 規模時禁假設值（依 `evidence-first.md`）。

**Antigravity CLI 實作**：
- 工具：`write_file`
- 產出：`<common-memory-root>/capsules/TASK_<ID>_<DESC>.md`（依 `templates/agent-commons/capsule.md.tpl`）
- 強制要求：在 capsule 注入 `EVIDENCE_LEVEL` 標籤

**跨 AI 對應**：
- Claude / Cursor → 同樣採 `Write` 產出 capsule
- 無 file system AI → 透過對話輸出完整格式，由使用者存檔

### 3.2 派發任務（Delegation）

**核心概念**：向執行端 AI（Engineer）傳遞具備行為約束的指令。

**Antigravity CLI 實作**：
- 工具：`/agent <engineer-agent-name> "..."` slash command（subagent first-class）— 對齊 §3.5 sub-agent 跨界禁令
- 流程：在 prompt 中強制要求 `---CODE_ONLY---` 與 `---NO_LINE_NUMBERS---`
- **Multi-model 場景**：可在派發前 `/model claude-sonnet-4-6` 切到適合 Engineer 任務的模型、再 `/agent` 委派

**跨 AI 對應**：
- Gemini CLI（legacy）→ `invoke_agent(agent_name="generalist")`（注意：generalist 預設啟用會自動繞 PM 卡控、依 §3.5.5）
- Claude → 呼叫 `Agent` tool

### 3.3 接收交付並親跑驗收（Verification）

**核心概念**：禁止僅憑文字描述驗收。PM 必須執行實證腳本並擷取原始 stdout。

**Antigravity CLI 實作**：
- 工具：`run_shell_command` + `read_file`
- 流程：執行 `dotnet test` / `python verify_S70.py`，將輸出導向 `diagnostics/run.out` 後分析

**跨 AI 對應**：
- Gemini CLI（legacy）→ 同（同工具集）
- Claude → `Bash` 跑驗收 + `Read` 讀輸出

### 3.4 結案宣告（Closure）

**核心概念**：對任何「已完成 / 已關閉」型宣告默認待抽驗。

**Antigravity CLI 實作**：
- 工具：`replace` + `~/.gemini/skills/pm-verify/SKILL.md`（觸發自檢 skill）

**跨 AI 對應**：
- Gemini CLI（legacy）→ `.gemini/commands/pm-verify.toml`
- Claude → `Edit` + `/<role>-init`

### 3.5 維護管理文件（Documentation）

**核心概念**：HANDOFF / NextWork / IM / 升級協議文件維護。

**Antigravity CLI 實作**：
- 工具：`write_file` + `save_memory(scope="project")` + `replace`
- Antigravity 特別擅長透過 multi-agent async orchestration 從長 context 中總結隱性知識作為 IM 補寫

---

## §3 已知能力盲區與 fallback

| 盲區概念 | 觸發機制 | Antigravity 特徵 | Fallback |
|---|---|---|---|
| 紀律疲勞 | Context 視窗權重遞減 | 視 underlying model 而定（Claude Sonnet ~100k+ / Gemini 3 ~30k） | 定期 re-sync、`/agent <self>` 重跑 init skill |
| 幻覺式驗收 | 邏輯複雜度超上限 | 視 underlying model；generalist agent 易受影響 | 強制產出獨立驗證腳本 |
| 權限邊界模糊 | 角色分工僅語意標籤 | 不自覺改 src/ | `self_audit` 檢核 |
| **繞路執行傾向** | LLM completionist 找路徑繞過 | Antigravity sub-agent first-class、async orchestration 多 agent 自動分包繞路潛在更易 | 對齊 `role-separation §3.5` + `multi-role-tracking §3.4`；Plugin lifecycle hooks 強制機制 |
| **dual-mode context cross-mode forgetting** | 設計 mode 切執行 mode | Antigravity `/model` 切換場景特別易踩 | self-check 機制 |
| **vendor tool ⊥ underlying model 雙軸混淆**（v1.0 新加、signal #60）| 報告 bug / 描述能力時不分軸 | Antigravity 獨有（multi-model vendor）| self-check：明示「Antigravity vendor 層」vs「underlying model 層」分離 |

---

## §3.5 sub-agent / 代理跨界禁令

> Antigravity 把 sub-agents 升為 first-class concept、async multi-agent orchestration 預設啟用 — **繞路潛在風險比 Gemini CLI legacy 高**。

### Antigravity PM 禁止的繞路執行手段

| 手段 | 違反 |
|---|---|
| 自我宣告切換為 Engineer 角色 | `multi-role-tracking §3.4` + `role-separation §3.5` |
| 派 `/agent <name>` sub-agent 執行 `src/` 修法 | `role-separation §3.5` 繞路禁令 |
| **觸發 async multi-agent orchestration 自動分包 `src/` 修法到背景 sub-agent** | Antigravity 獨有風險、async 完成後 PM 可能不知道有違反 |
| 提示 user「請你貼這段 code」變相代寫 | 把 user 當代理規避紀律 = F1 |
| Partial 執行自我合理化 | 紀律邊界由條款定義、不由 violator 自我詮釋 |

### Antigravity-specific fallback

Antigravity CLI 有 **Plugin lifecycle hooks**（JSON-defined、`before tool call` / `after file edit` / `on session start`）— 比 Gemini CLI legacy 強的 pre-execution 攔截能力。

- **Plugin hook 攔截**（首選）：在 `~/.gemini/antigravity-cli/plugins/<plugin>/hooks/before-tool-call.json` 註冊 hook、攔截 PM 對 `src/` 路徑的寫入動作
- **self_audit 檢核**（fallback）：對任何即將執行的動作、先過「是否動 `src/` ?」檢查
- **心智守則**：上岸需 user explicit 授權

### §3.5.5 Antigravity 預設 sub-agent 行為處置 — PM init 必提醒（signal #55 family 延伸）

> **動機**：對應 Gemini CLI v0.10.5 條款化「generalist 自動分包繞 PM 卡控」的 Antigravity 平移。Antigravity 繼承 + 升級為 async multi-agent orchestration first-class — 預設行為可能同源或更積極。本段先列紀律框架、實際 disable 指令名待 LIVE 校正。

**紀律：PM init 開始時必對採用方提醒**

```
「Antigravity CLI 繼承自 Gemini CLI 的 sub-agent 系統可能預設啟用自動分包行為、可能繞過 PM 卡控紀律。建議現在執行對應的 disable 指令（**官方指令名待確認**、可能為 `/agents disable generalist` 繼承自 Gemini CLI 或新指令）：

/agents disable generalist   # legacy 對應
# 或
/plugin disable <auto-orchestration-plugin>   # Antigravity 新機制候選

請先跑 `agy --help` 或查 `antigravity.google/docs` 確認對應指令。已執行請告知。」
```

**`pm-init.md` 自具象化要求**：PM 自具象化 `~/.gemini/skills/pm-init/SKILL.md` 時 body 必含上述提醒。

---

## §3.6 Antigravity CLI Skills schema 規範（LIVE 第二輪校正 2026-05-22）

> **🔥 LIVE 第二輪校正（2026-05-22、dbSDK PM AI 親讀 SKILL.md 實檔回報）**：
> - **舊 `/pm-init` 等 `.gemini/commands/*.toml` 指令在 Antigravity 直接不可用** — `agy plugin import gemini` 不會自動讓舊 toml 指令 work、**必須手動建立 Skills**
> - **Skills 實際路徑：`~/.gemini/skills/<name>/SKILL.md`**（**子目錄結構**、每個 skill 是個目錄、內含 `SKILL.md`）
> - **frontmatter `name:` 欄位必填**（vs Gemini CLI legacy flat TOML 禁 `name`、Antigravity 規範要求）

### 強制紀律：Skills Markdown 格式

| 紀律 | 規範 |
|---|---|
| **檔案格式** | Markdown（`.md`、含 YAML frontmatter）|
| **檔案位置** | **`~/.gemini/skills/<name>/SKILL.md`**（子目錄結構、全域 only、無 workspace 級、LIVE 第二輪校正）|
| **檔名 = 指令名** | 目錄名 `<skill-name>` → `/<skill-name>`、目錄內 `SKILL.md` 為固定檔名 |
| **必填 frontmatter** | `name: <skill-name>`（對應目錄名）+ `description: "..."` |
| **可選 frontmatter** | `tools` / `subagent` / `argument-hint` 等 |
| **prompt body** | Markdown 純文字 |

### 範例：PM init skill

```markdown
# 路徑：~/.gemini/skills/pm-init/SKILL.md
---
name: pm-init
description: PM 初始化（AgentCharter charter v0.11.0+）
---

你現在扮演 PM 角色。

依 ~/.agentcharter/core/init-template.md §3.3.2 八步驟自我具象化：

Step 0: 讀過去違反紀錄
Step 0.5: charter version 比對
Step 1: 自我介紹 + Antigravity 預設 sub-agent 提醒（依 §3.5.5）
Step 2: 讀 _spec.md 概念層
...
```

### 從 Gemini CLI legacy 遷移：手動轉換

**🔥 重要**：原 path A 預估 `agy plugin import gemini` 會自動把 `.gemini/commands/*.toml` 轉成可用 Skill — **LIVE 實測 false**。實際必須**手動轉換**：

| 原 Gemini CLI | 改 Antigravity Skill |
|---|---|
| `.gemini/commands/pm-init.toml` | `~/.gemini/skills/pm-init/SKILL.md` |
| `.gemini/commands/checkpoints.toml` | `~/.gemini/skills/checkpoints/SKILL.md` |
| `.gemini/commands/charter-init.toml` | `~/.gemini/skills/charter-init/SKILL.md` |

轉換規則：

```toml
# Gemini CLI legacy：.gemini/commands/pm-init.toml
description = "PM 初始化"

prompt = """
你現在扮演 PM...
"""
```

↓ 手動轉換 ↓

```markdown
# Antigravity：~/.gemini/skills/pm-init/SKILL.md
---
name: pm-init
description: PM 初始化
---

你現在扮演 PM...
```

### Self-instantiation 引導 — 自具象化 checklist

依 `core/init-template.md §3.3.2 step 3` 在 `~/.gemini/skills/<role>-init/SKILL.md` 生成時：

- [ ] **建立子目錄** `~/.gemini/skills/<skill-name>/`（如 `pm-init/`）
- [ ] **檔名為 `SKILL.md`**（固定檔名）
- [ ] frontmatter 用 YAML 三 dash 包裹
- [ ] **frontmatter `name:` 欄位必填**
- [ ] **frontmatter `description:` 欄位必填**
- [ ] body 為 Markdown 純文字 prompt
- [ ] 全域路徑：`~/.gemini/skills/<skill-name>/SKILL.md`

### 跨 AI 對應（schema）

| AI | command 容器格式 | schema 規範位置 |
|---|---|---|
| Gemini CLI（legacy）| `.gemini/commands/<name>.toml`（扁平 TOML）| `roles/pm/gemini-cli.md §3.6` |
| **Antigravity CLI** | `~/.gemini/skills/<name>/SKILL.md`（子目錄 + YAML frontmatter `name:` 必填）| **本段 §3.6（v1.1 LIVE 第二輪校正）**|
| Claude Code | `.claude/commands/<name>.md` | `roles/engineer/claude-code.md §4.1` |

---

## §3.7 PM Init 後置：`/checkpoints` 介紹與落實

> 觸發時機：PM init step 8 後置 / user 主動問 / user 貼 install prompt。對應 `core/ai-vendor-onboarding §3.5` charter common 紀律的 Antigravity 落地。

### 設計架構

| 層 | 檔案 | 職責 |
|---|---|---|
| **橋接層**（Skill）| `~/.gemini/skills/checkpoints/SKILL.md` | 接收使用者指令 → 呼叫邏輯層 |
| **邏輯層**（Handler）| `tools/vendor/commons/checkpoints_handler.sh` | 路徑解析、HANDOFF 生成、git commit |

### 採用方同意後：AI 執行步驟

#### Step 1：確認 `~/.gemini/checkpoints_handler.sh` 存在且最新版

```
run_shell_command("test -f ~/.gemini/checkpoints_handler.sh && echo EXISTS || echo MISSING")
```

若 MISSING → 從 charter canonical 自動安裝（`cp ~/.agentcharter/tools/vendor/commons/checkpoints_handler.sh ~/.gemini/`）

#### Step 2：建立 `~/.gemini/skills/checkpoints/SKILL.md`（子目錄 + 固定檔名）

```markdown
---
name: checkpoints
description: AgentCharter 跨 session 存檔機制 — 用法：/checkpoints [save|load|status|config]
---

執行 AgentCharter /checkpoints 存檔機制。依使用者輸入動作執行：

## save 流程
1. run_shell_command("bash ~/.gemini/checkpoints_handler.sh save")
2. read_file(DRAFT_PATH)
3. 依 ~/.agentcharter/templates/agent-commons/handoff.md.tpl 格式生成 HANDOFF_<N>.md
4. write_file + run_shell_command("bash ~/.gemini/checkpoints_handler.sh commit_save <N>")
5. 回報 + 詢問交班

## load / status / config 流程
（依 Gemini CLI §3.7 格式平移）
```

#### Step 3：驗收

```
run_shell_command("bash ~/.gemini/checkpoints_handler.sh status")
```

### 跨 AI 對應

| AI | 等效機制 |
|---|---|
| Claude Code | `~/.claude/commands/checkpoints.md` |
| Gemini CLI（legacy）| `.gemini/commands/checkpoints.toml` |
| **Antigravity CLI** | `~/.gemini/skills/checkpoints/SKILL.md`（子目錄、全域 only）|

---

## §3.8 Violation Reflection 執行

> 對齊 `core/individual-learning-loop §2` 雙寫紀律。

### 正確路徑（強制）

| 層 | ✅ 正確路徑 | ❌ 錯誤路徑 |
|---|---|---|
| 個體層 reflection | `<common_memory_root>/roles/pm/reflections/<YYYY-MM-DD>_<f-mode>_<short>.md` | `~/.gemini/skills/<skill>/`、任何 vendor 私有目錄 |
| 集體層 log | `<common_memory_root>/state/failure_mode_log.md` | 任何 vendor 私有目錄 |

**根本原則**：`~/.gemini/skills/` 是 Antigravity vendor 橋接層目錄、**不是** charter `common_memory_root`。寫到 vendor 私有目錄 = 跨 AI 不可見 = 違反 `core/common-memory-root §1`。

### Antigravity 執行步驟（F-mode 命中後）

```
1. write_file(
     path="<common_memory_root>/roles/pm/reflections/<YYYY-MM-DD>_<f-mode>_<short>.md",
     content=<依 ~/.agentcharter/templates/agent-commons/reflection.md.tpl 填寫>
   )

2. replace(
     path="<common_memory_root>/state/failure_mode_log.md",
     ...  # 追加 F-mode entry
   )

3. 雙寫完成後 stdout 明確回報。
```

### 跨 AI 對應

| AI | 橋接層（❌ 不寫 reflection 的地方）| charter 共享記憶根（✅ 寫 reflection 的地方）|
|---|---|---|
| Antigravity CLI | `~/.gemini/skills/<skill>/SKILL.md` | `<common_memory_root>/roles/pm/reflections/` |
| Gemini CLI（legacy）| `.gemini/` | 同上 |
| Claude Code | `.claude/` | 同上 |

---

## §4 歷史事件沉澱

### (a) 平移自 Gemini CLI v1.8 §4：S70 PnL 誤判事件 ⭐

本檔繼承 `roles/pm/gemini-cli.md §4` S70 PnL 誤判事件根因分析（vendor 中立、Antigravity 同樣適用）：

1. **認知偏差**：所有 LLM 都可能因 Engineer 信心語氣偏差
2. **缺乏結構化證據**：Context 過長 + 紀律未強制 = 任何 AI 都會失靈
3. **無 hook 的紀律鬆散**（vendor-specific）：Antigravity 有 Plugin lifecycle hooks 比 Gemini CLI legacy 強

### (b) vendor 失效時運事件（dogfood signal #60 LIVE）

**LIVE 揭示**：2026-05-22 charter 接收日 —

- 2026-05-19 Google I/O 2026 宣布 Antigravity CLI 取代 Gemini CLI、2026-06-18 對 Pro/Ultra/free 斷線
- charter v0.10.6（2026-05-21 ship）剛 ship Claude PM v1.0 + Gemini PM v1.8 best-of-breed 收斂、**ship 不到 24 小時 vendor 棄用消息抵達**

**結構性 takeaway**：

| 觀察 | 設計學意義 |
|---|---|
| **A1「角色 ⊥ AI」公理的時運實證** | 即使 Gemini 消失、PM 角色不死（Claude PM 接班 / Antigravity vendor 接入）。**path B dogfood 收編 pattern 回頭看不是「best-of-breed 收斂」、是「vendor 換手保險」** |
| **vendor 中立架構反向實證** | v0.10.0 commit-hook git-native + v0.9.4 handler 移至 `tools/vendor/commons/` survive vendor death。**dogfood signal #41「vendor lock-in 反思」終局實證** |
| **`ai-vendor-onboarding §3` 邀請制 LIVE 第二次應用契機** | Antigravity 繼承 Skills/Hooks/Subagents/Extensions → PM 角色概念可平移、charter 有 prior art 做參考 |
| **vendor tool ⊥ underlying model 雙軸分解** | Antigravity 是 multi-model vendor → charter A1 公理擴 A1.1「vendor tool ⊥ underlying model」二層分解 |

---

## §5 模式協議實作（Output Mode）

**Antigravity CLI 實作**：
- **首選**：Antigravity Plugin lifecycle hook（`on session start`）讀取模式檔 + 注入 system context
- **Fallback**（hook 未配置時）：採「指令前綴 + 手動審核」（同 Gemini CLI legacy）

---

## §6 跨 AI 交接建議

### 工具能力快照

- **主要環境**：Windows / Linux / macOS（Antigravity 跨平台、binary `agy`）
- **已用過工具集**：繼承自 Gemini CLI + Antigravity 新增（`/agent` first-class / async orchestration / Plugin hooks / `/model`）
- **Underlying model 選擇**：Claude Sonnet 4.6 / Claude Opus 4.6 / Gemini 3 / GPT-OSS 120B

### Stateful 副作用

- 使用者家目錄 `~/.gemini/skills/<skill>/SKILL.md` 全域 skills 子目錄（LIVE 第二輪校正）
- `save_memory` 寫入跨 AI 不可見、須轉寫進 git 內 IM
- **如有走 `/model` 切換**：接班 AI 須讀取最後使用的 underlying model 紀錄

---

## §7 Vendor 接入回顧（path A AI-DRAFTED 自述）

> 本檔由 maintainer 從 `roles/pm/gemini-cli.md` v1.8 path A 平移 + 同日 LIVE 第二輪校正（2026-05-22 dbSDK PM AI 親讀 SKILL.md 實檔回報）。

### (a) Path A AI-DRAFTED 範圍說明 + LIVE 校正紀錄

| 段 | 預估內容 | LIVE 校正狀態 |
|---|---|---|
| §1 row「指令容器」| ❌ 預估 `.agents/skills/` workspace + `~/.gemini/antigravity-cli/skills/` global | ✅ **LIVE 校正**：實際 **`~/.gemini/skills/<name>/SKILL.md`**（子目錄結構、全域 only、無 workspace 級）|
| §3.6 Skills schema | ❌ 預估 `agy plugin import gemini` 自動轉換 | ✅ **LIVE 校正**：實際**舊 toml 指令在 Antigravity 直接不可用**、必須**手動建立 Skills `.md` 檔到 `~/.gemini/skills/<name>/SKILL.md`** |
| §3.6 frontmatter | ❌ 預估禁 `name:` 對齊 Gemini flat TOML | ✅ **LIVE 校正**：`name:` 欄位**必填**（vs Gemini CLI legacy 禁 name）|
| §3.5.5 `/agents disable generalist` 指令名 | path A 預估 | ⏳ 待校正 — 採用方跑 `agy --help` 確認 |
| §1 MCP server 整合 路徑 | path A 預估 | ⏳ 待校正 |
| §5 Plugin lifecycle hook | path A 預估 | ⏳ 待校正 |

**校正紀律**：採用方走完邀請制 step 2-4、累積 ≥ 80% segment LIVE 校正後升 SIGNED-vX.Y。

### (b) 結構性 takeaway

1. **path A AI-DRAFTED 的紀律自覺**：本檔由 maintainer 從 Gemini CLI v1.8 path A 平移、**不假裝知道 Antigravity 細節**
2. **vendor tool ⊥ underlying model 雙軸自覺**：Antigravity 是 multi-model vendor、報告 bug 時明示分軸
3. **vendor 預設行為層紀律**：sub-agent first-class + async orchestration 預設啟用、PM init 開始時必對採用方提醒（§3.5.5）
4. **集體記憶優先個體記憶**：永遠優先寫 `<common_memory_root>/roles/pm/reflections/`（§3.8）

---

## §8 變更歷史

### v1.1 / 2026-05-22（v0.11.0 候選 / LIVE 第二輪校正）

**動作**：dbSDK PM AI 2026-05-22 提交跨 vendor 報告（`.claude_temp/DBSDK-CROSS-VENDOR-SLASH-COMMAND-REPORT-2026-05-22.md`）親讀 SKILL.md 實檔回報、修正 v1.0 path A 預估的 Skills 路徑 + frontmatter schema：

- §1 row「指令容器」第二格 → `~/.gemini/skills/<name>/SKILL.md`（**子目錄結構** + SKILL.md 固定檔名）
- §3.6 frontmatter「`name:` 從可選改為必填」
- §3.6 範例 + 從 Gemini CLI 轉換對應規則 + Self-instantiation checklist 全對齊新 Skill 子目錄路徑
- §3.7 Step 2 `/checkpoints` skill 路徑 + 範例 frontmatter 加 `name: checkpoints`
- §3.8 反例路徑表 + §6 stateful 副作用段同步
- §7(a) path A 範圍說明加 LIVE 校正狀態欄

**觸發**：dbSDK PM AI 報告 + dogfood signal #60 LIVE 觸發（Gemini CLI 棄用 + path A LIVE-CALIBRATED v2 升維）

**修訂類型**：MINOR — 新 vendor spec 接入（依 `core/versioning-migration §2.2` MINOR 規範）

### v1.0 / 2026-05-22（v0.11.0 候選 / path A AI-DRAFTED-FROM-GEMINI-V1.8）

**動作**：新增本檔 — Antigravity CLI vendor spec path A AI-DRAFTED-FROM-GEMINI-V1.8（從 `roles/pm/gemini-cli.md` v1.8 平移、八段結構對稱、Antigravity-specific 改動）

**觸發**：dogfood signal #60 LIVE — Gemini CLI 棄用事件觸發 charter v0.11.0 Antigravity vendor path A AI-DRAFTED 接入。對齊 v0.7.3 北極星「**培養魚塘、不討魚**」精神 + `core/ai-vendor-onboarding §3 step 2` 邀請制 path A 規範。

**修訂類型**：MINOR — 新 vendor spec 接入

**連動範圍**（同 v0.11.0 release）：
- `roles/pm/_spec.md §7` 對應 AI 表 update（加 Antigravity CLI row、Gemini CLI 標 LEGACY_AUTO_IMPORTED）
- `roles/pm/gemini-cli.md` frontmatter + §9 LEGACY 警告段（同 release ship）
- `examples/upgrades/v0.10.6-to-v0.11.0-antigravity-migration.md` 新檔（採用方 walkthrough）
- `UPGRADE.md` 加新 row + v0.11.0 重大事件提示段
- `tools/profiles/*.yaml` 4 個 charter_version 0.10.6 → 0.11.0
- `CHANGELOG.md` v0.11.0 段
- `.claude_temp/NEXT.md` 登記 dogfood signal #60 條款化候選
- 採用方文檔（ADOPTION / TUTORIAL / README / QUICKSTART）變更歷史
