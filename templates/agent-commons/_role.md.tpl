# Role: <ROLE_NAME>

> **位階**：本檔在 `<common-memory-root>/roles/<role>/` 根目錄，標明此角色資料夾的當值身份。

---

## 角色資訊

- **Spec**：引用 AgentCharter `roles/<ROLE_NAME>/_spec.md`
- **AI 實作版**：引用 AgentCharter `roles/<ROLE_NAME>/<AI_VENDOR>.md`（具體執行細節）
- **當前扮演 AI**（最近 session）：<AI 名稱 / 廠商>
- **Init slash command**：`/<role-name>-init`（位於 `.claude/commands/<role>-init.md`）

## 切換歷史

| 日期 | 扮演 AI | 觸發原因 |
|---|---|---|
| <YYYY-MM-DD> | <AI 名稱> | <初始化 / session 接班 / 角色切換> |

---

## 當值規範

接班 AI 進入此資料夾時的**第一動作**：

1. 讀本檔確認角色身份
2. 跑 `/<role-name>-init`（依 `core/init-template.md` 五步驟）
3. 依 `_spec.md` + `<AI_VENDOR>.md` 執行職責

**禁止**：未跑 init 即進入工作。

---

## 模板使用指南

實例化此模板時替換以下變數：

| 變數 | 範例 |
|---|---|
| `<ROLE_NAME>` | engineer / pm / reviewer / qa |
| `<AI_VENDOR>` | claude-code / gemini-cli / cursor |
| `<common-memory-root>` | agent-commons / management（依 mapping.yaml）|
