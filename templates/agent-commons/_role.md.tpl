# Role: <ROLE_NAME>

> **位階**：本檔在 `<common-memory-root>/roles/<role>/` 根目錄，標明此角色資料夾的當值身份。
> **依據**：`core/init-template.md` Role Init Mandate v0.5.0（§1.3 Sign-in 職責由本檔承載）。

---

## 角色資訊

- **Spec**：引用 AgentCharter `roles/<ROLE_NAME>/_spec.md`（職能定義）
- **AI 實作版**：引用 AgentCharter `roles/<ROLE_NAME>/<AI_VENDOR>.md`（具體執行細節）
- **當前扮演 AI**（最近 session）：<AI 名稱 / 廠商>
- **當值期間**：<起始 session> ~ <最近 session>

---

## 各 AI 的 Init Slash Command 具象化位置

依 `core/init-template.md §3` 多 AI 具象化規範，本角色的 init slash command 在各 AI 廠商的對應位置：

| AI | 具象化位置 | 是否實裝？ |
|---|---|---|
| Claude Code | `.claude/commands/<role>-init.md` | ✅ / ❌ |
| Gemini CLI | `.gemini/commands/<role>-init.toml` | ✅ / ❌ |
| Cursor | `.cursor/rules/<role>-init.mdc` | ✅ / ❌ |
| 其他 / 無 slash 系統 | 通用 prompt 文件：`<common-memory-root>/roles/<role>/init-prompt.md` | ✅ / ❌ |

→ 任一 AI 接班時跑自己廠商的 init slash command；不存在則手動貼通用 prompt。

---

## 切換歷史（依 init-template §1.3 Sign-in）

每次 init 觸發時必須在此表追加一行（不修改既有行）。

| 日期 | 扮演 AI | 觸發原因 | 就緒回報 hash（可選）|
|---|---|---|---|
| <YYYY-MM-DD HH:MM TZ> | <AI 名稱> | <初始化 / session 接班 / 角色切換 / 跨 AI 接班> | <hash> |

---

## 當值規範

接班 AI 進入此資料夾時的**第一動作**（依 `core/init-template.md §1` 四大職責）：

1. **召喚（Summon）**：讀本檔 + AI 廠商實作版確認身份
2. **校準（Calibrate）**：跑 `/<role-name>-init` slash command（對應自己 AI 廠商的位置）
3. **簽名（Sign-in）**：在切換歷史表追加一行
4. **守門（Gatekeep）**：確認所有就位狀態（依 §2 完成狀態），未達標即中止 init

**禁止**：未跑 init 即進入工作（視同 F1 假宣告，依 `core/failure-modes.md`）。

---

## 統一就緒回報格式

跑完 init 後，輸出以下單一格式（任何 AI 一致）：

```
✅ <role>-init 完成
- 領域公理：<axiom-name> v<X>
- 通用條款：AgentCharter v<X> 已載入（依 profile）
- 模式：<eco|verbose>
- 最近 HANDOFF：HANDOFF_<N>.md
- 抽驗模式：<正常 | 強化中（理由：...）>
- 我是：<AI 廠商> 扮演 <role>
- git 狀態：<簡列>
- 待辦：<NextWork 抽 1-2 條>

<role> 值機完成，待派任務。
```

---

## 模板使用指南

實例化此模板時替換以下變數：

| 變數 | 範例 |
|---|---|
| `<ROLE_NAME>` | engineer / pm / reviewer / qa |
| `<AI_VENDOR>` | claude-code / gemini-cli / cursor |
| `<common-memory-root>` | agent-commons / management（依 mapping.yaml）|

### 切換歷史紀錄紀律

- 每次 init **必須**追加一行（依 init-template §1.3 強制）
- **不修改**既有行；舊紀錄為審計痕跡
- 跨 AI 接班時須明確標明前後 AI 廠商

### 替換性保證（依 init-template §5）

- 任何 AI 退出 → 新 AI 接手 → 跑新 AI 的 init slash command → 達等效狀態
- 切換歷史表是替換的審計 trail
- 不可有「只有 X AI 能扮演此角色」的隱性綁定
