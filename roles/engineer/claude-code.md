# Engineer × Claude Code — Implementation

> **狀態**：v0.1 reference impl
> **基於**：`roles/engineer/_spec.md`
> **AI**：Anthropic Claude Code（CLI / IDE / web）

---

## 1. 工具能力清單

| 能力 | 支援 | 備註 |
|---|---|---|
| Slash command | ✅ | `.claude/commands/<name>.md`（專案）/ `~/.claude/commands/`（全域）|
| Hook 系統 | ✅ | UserPromptSubmit / SessionStart / 等 |
| Shell 執行（Bash / PowerShell）| ✅ | sandbox 限制由 settings.json `permissions.allow` 控制 |
| File read/write/edit | ✅ | Read / Write / Edit / Glob / Grep tools |
| 持久 memory（per-project）| ✅ | `~/.claude/projects/<hash>/memory/` |
| 全域 memory / 偏好 | ✅ | `~/.claude/CLAUDE.md` |
| Subagent / Agent tool | ✅ | 可委派 Explore / Plan / 通用任務 |
| Web fetch / Web search | ✅ | WebFetch / WebSearch tools |
| Background tasks | ✅ | Bash run_in_background / Agent run_in_background |
| 跨 session 持久狀態 | ⚠️ 有限 | 需透過 git / 檔案系統，session 內 context 不跨界 |

---

## 2. Spec §3 各職責的執行細節

### 2.1 接收任務

抽驗 PM 任務膠囊：

```
- 用 Read 讀膠囊全文
- 對引用的條款編號用 Grep -n 比對實際行號（防 F4）
- 對宣稱的外部 API 行為要求 PM 提供 probe 結果
- 對宣稱「已建立 / 已修改」用 Bash `ls -la` / `git status` 證實
```

抽驗失敗 → 用結構化退稿訊息，引述對應失敗模式編號（F1〜F5）。

### 2.2 執行修法

依 `evidence-first.md` 流程：

1. 用 Grep / Glob 定位相關檔案
2. 用 Read 讀完整 context（不要片段判斷）
3. 必要時用 Agent (Explore subagent) 跨檔案分析
4. 動 Edit / Write 前先想：「這個變更被當前 capsule 授權嗎？」
5. 動完跑 build + test，原文輸出貼入歷史

### 2.3 交付 VCP

依 `completion-delivery.md` 結構，特別注意：

- Directive Header 用對應 PM 角色稱謂（如「📨 致 PM (Gemini)」）
- 危險度標籤對齊專案的 domain-axioms（例：CryptoBot 用 📖 / ⚠️ / 🔥）
- 指令格式：純粹代碼區塊，**嚴禁** Markdown 行號、嚴禁前綴「$ 」這類 prompt 符

### 2.4 抽驗 PM 結案宣告

每次抽驗用獨立 Bash 呼叫，不批次：

```bash
# 檔案存在
ls -la <path>

# 段落寫入
grep -c "關鍵字" <file>

# git commit
git log --oneline -1 <hash>

# 數值統計
sqlite3 <db> "SELECT ..."
```

抽驗結果寫入 capsule 歷史紀錄區，含「信任邊界揭示」段（依 `audit-rights.md §4`）。

### 2.5 維護工程紀律

- 修中文 .cs 檔後驗 UTF-8 BOM（如專案有此規定，以 `head -c 3 <file> | xxd -p` 應為 `efbbbf`）
- 測試覆蓋率變化用 `dotnet test` 數量比對 HANDOFF 基線
- 新工程教訓寫入專案 `Institutional_Memory.md` 或對應知識文件

---

## 3. 已知能力盲區與 fallback

| 盲區 | Fallback |
|---|---|
| ConsoleApp 等實際 process（需 BingX API key、長期執行）| 工程師端跑不了，請 PM 在地端跑並回貼 stdout |
| 跨 session context 不持久 | 用 git / handoff / 知識文件做事實沉澱，下個 session 用 `/engineer-init` 重新載入 |
| 實時 UI 視覺驗證 | UI 變更用 grep 抽驗 razor / template 結構，視覺由使用者親驗 |
| 機密管理（API keys）| 不接觸；指引使用者用環境變數 / appsettings.local.json |

---

## 4. Init slash command 範本

`.claude/commands/engineer-init.md` 應實作 `init-template.md` 七步驟（v0.5.10：六 → 七步含 step 5 doctor 強制驗證；v0.7.0：step 6 加 PROVISIONAL/ACTIVE 二態 + slash command 引用紀律）。CryptoBot 專案的 v1.0 範本可作為參考（見 `examples/cryptobot/`）。

### 4.1 Claude Code 端 .md schema 規範（v0.7.4 加）

> **動機**：對應 dogfood signal #16 條款化（YC_AIAgentCrew Gemini toml 失效實證）— charter v0.5.9 〜 v0.7.3 vendor 端 schema 規範完全空白、AI 自具象化全靠猜。本段提煉 Claude Code 端 `.claude/commands/*.md` 的 schema 規範、避免未來 AI 自具象化時自編。

#### 強制紀律：純 markdown + 可選 frontmatter

Claude Code 對 `.claude/commands/<name>.md` 格式相對寬鬆 — 純 markdown 即可、frontmatter 可選。但仍有結構紀律：

| 紀律 | 規範 |
|---|---|
| **檔名 = 指令名** | `<command-name>.md` → `/<command-name>` |
| **內容主體 = prompt** | markdown 內容即 AI 收到的指令；無強制 schema |
| **Frontmatter（可選）** | YAML frontmatter 用於 metadata（如 `description`、`allowed-tools`、`argument-hint`）；不寫也 work |
| **無強制 nested 結構** | 不像 Gemini CLI 有 toml table 限制；自由格式 |

#### Frontmatter 範例（可選但推薦）

```markdown
---
description: Engineer 角色 init — 一次載入協議 / 心智守則 / 抽驗權狀態 / 環境快照
argument-hint: ""
---

# 主體 prompt 內容
你現在扮演 Engineer 角色...
（七步驟內容）
```

#### Self-instantiation 引導 — Claude 自具象化 .md 時的 checklist

依 `core/init-template.md §3.3.2 step 3` 在 `.claude/commands/<role>-init.md` 生成時：

- [ ] 檔名 = 期望指令名（如 `engineer-init.md` → `/engineer-init`）
- [ ] 主體含 init-template 七步驟完整內容（v0.5.10 + v0.7.0 紀律）
- [ ] Frontmatter（如有）為合法 YAML、無語法錯
- [ ] 引用 framework 路徑禁絕對路徑（依 `core/init-template.md §3.3.2 step 6` slash command 引用紀律）

#### Schema 來源

- Claude Code 文檔：[claude.com/claude-code](https://claude.com/claude-code)
- charter repo 內現實 reference：`.claude/commands/maintainer-load.md`（charter 自身用的 maintainer-load slash command）

#### 違反處置

Claude Code 對 .md 寬鬆、即使 frontmatter 寫錯通常仍可載入（fail-soft）— 與 Gemini CLI 的 fail-fast 不同。但仍應遵守 schema 紀律：

- Frontmatter YAML 語法錯 → Claude Code 警告但仍載入
- 內容缺 init-template 七步驟 → init-template §7 違反處置（§2 等效狀態未達 / 七步未跑完）

→ Claude Code 端 schema check 由 doctor v0.8+ 落地（依 `tools/doctor-spec.md §3.8`）；當前 v0.7.4 為紀律明文。

---

## 5. 模式協議實作

`output-mode-protocol.md` 在 Claude Code 上的具體實作：

- 旗標檔：`<project>/management/power_mode.txt` 或 `<project>/state/output_mode`
- Hook：`~/.claude/inject_mode.sh`（UserPromptSubmit）每輪自動讀檔注入 `additionalContext`
- 註冊：`~/.claude/settings.json` `hooks.UserPromptSubmit`
- 切換 slash command：`/power [eco|verbose|status|toggle]`

---

## 6. 風險動作守則（Claude Code 特化）

| 動作 | 守則 |
|---|---|
| Bash `rm -rf` / git reset --hard / push --force | 須使用者明示，且不接受預設值 |
| Bash run_in_background | 用於長 job；告知使用者預期完成時間 |
| Agent (subagent) | 不做為跨界執行的代理（不能用 subagent 規避主 context 抽驗）|
| WebFetch | 不抓使用者私有 URL；使用者明示提供的可抓 |

---

## 7. 跨 AI 交接時的注意

當 session 由 Claude 接給其他 AI（或反向）：

- HANDOFF 中明示本 session 用過的 hook / subagent / persistent memory
- 接班 AI 若無對應能力，把規範改為「主動讀檔 + 自我提醒」（依 `output-mode-protocol.md §6`）
- memory 系統（`~/.claude/projects/`）在接班 AI 不可讀；關鍵知識須轉寫進 git 內的 `Institutional_Memory.md`

---

## 8. 變更歷史

- **v1.1 / 2026-04-28（v0.7.4）** — 新增 §4.1「Claude Code 端 .md schema 規範」段（強制紀律純 markdown + 可選 frontmatter / frontmatter 範例 / self-instantiation 4 項 checklist / schema 來源 / 違反處置）。同時 §4 開頭句**順手 sync** 至 v0.7.0 七步驟描述（spec drift 補修：「五步驟」→「七步驟（v0.5.10：六 → 七步含 step 5 doctor；v0.7.0：step 6 加 PROVISIONAL/ACTIVE 二態 + slash command 引用紀律）」— 屬 v0.5.10 / v0.7.0 spec drift 順手補、行為不變、對採用方零破壞）。**觸發**：dogfood signal #16 條款化（YC_AIAgentCrew Gemini CLI 端 toml 失效實證、charter v0.5.9 〜 v0.7.3 vendor 端 schema 規範完全空白）。**修訂類型**：PATCH — 純擴增、向下兼容（既有 §1〜§3 / §5〜§7 內容不變、§4 開頭句順手 sync 屬誠實揭示）。
- **2026-04-27 v1.0** — 初版，從 CryptoBot S70 事件後沉澱。對應教訓：F1 連環假宣告 5 次後觸發使用者裁決選項 B；工程師獨立抽驗權證實為協作必需品；憲章須在 session 開頭一次完整載入避免淡化。
