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

`.claude/commands/engineer-init.md` 應實作 `init-template.md` 五步驟。CryptoBot 專案的 v1.0 範本可作為參考（見 `examples/cryptobot/`）。

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

- **2026-04-27 v1.0** — 初版，從 CryptoBot S70 事件後沉澱。對應教訓：F1 連環假宣告 5 次後觸發使用者裁決選項 B；工程師獨立抽驗權證實為協作必需品；憲章須在 session 開頭一次完整載入避免淡化。
