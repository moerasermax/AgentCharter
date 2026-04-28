# Role: <ROLE_NAME>

> **位階**：本檔在 `<common-memory-root>/roles/<role>/` 根目錄，標明此角色資料夾的當值身份。
> **依據**：`core/init-template.md` Role Init Mandate v0.5.0（§1.3 Sign-in 職責由本檔承載）。

---

## 角色資訊

- **Spec**：引用 AgentCharter `roles/<ROLE_NAME>/_spec.md`（職能定義）
- **AI 實作版**：引用 AgentCharter `roles/<ROLE_NAME>/<AI_VENDOR>.md`（具體執行細節）
- **Status**：`PROVISIONAL` / `ACTIVE`（v0.7.0 加；二態說明見下）
- **當前扮演 AI**（最近 session）：<AI 名稱 / 廠商>
- **當值期間**：<起始 session> ~ <最近 session>

### Status 二態（v0.7.0 加）

依 `core/multi-role-tracking.md §3.4.4` + `core/init-template.md §3.3.2 step 6`：

| 狀態 | 含義 | 觸發 |
|---|---|---|
| **`PROVISIONAL`** | 暫具象化 — slash command 已就緒、但角色身份**未經 user explicit 授權激活** | self-instantiation step 6 簽名後預設值；只能寫具象化痕跡（「各 AI 具象化位置」表 + 切換歷史「自我具象化完成」），**不寫 Sign-in Log** |
| **`ACTIVE`** | 已激活 — user explicit 授權某 AI 接該角色（如 user 打 `/<role>-init` + 明示「請以 <role> 身份接此專案」）| 升 ACTIVE 時才寫 Sign-in Log（角色入職紀錄）|

**禁止**：AI 自我發起把 Status 從 PROVISIONAL 升 ACTIVE（違反 multi-role-tracking §3.4.4 = F1）。

---

## 各 AI 的 Init Slash Command 具象化位置

依 `core/init-template.md §3` 多 AI 具象化規範，本角色的 init slash command 在各 AI 廠商的對應位置：

| AI | 具象化位置 | 是否實裝？ | 自我具象化日期 |
|---|---|---|---|
| Claude Code | `.claude/commands/<role>-init.md` | ✅ / ❌ | <YYYY-MM-DD> |
| Gemini CLI | `.gemini/commands/<role>-init.toml` | ✅ / ❌ | <YYYY-MM-DD> |
| Cursor | `.cursor/rules/<role>-init.mdc` | ✅ / ❌ | <YYYY-MM-DD> |
| 其他 / 無 slash 系統 | 通用 prompt 文件：`<common-memory-root>/roles/<role>/init-prompt.md` | ✅ / ❌ | <YYYY-MM-DD> |

→ AI 第一次扮演此角色時，**自我具象化**到自己廠商的位置（依 `core/init-template.md §3.3`）。框架不代生成。

### 自我具象化機制

當任何 AI 看到自己對應位置標為 ❌（未實裝）時，須執行：

1. 讀 AgentCharter `core/init-template.md §3.3` 規範
2. 讀本角色的 `_spec.md` + `<my-vendor>.md`（若存在）
3. 套用 `templates/role-init.md.tpl` 為骨架
4. 在自己 AI 系統的標準位置生成 slash command 檔
5. 把上表自己一行的「是否實裝？」改為 ✅，填上日期
6. 在切換歷史追加「自我具象化完成」紀錄

**禁止**：要求使用者手動寫該 AI 的 slash command（違反「角色 ⊥ AI」公理）。

---

## 切換歷史（依 init-template §1.3 Sign-in + cross-ai-handoff §6）

每次 init 觸發時必須在此表追加一行（不修改既有行）。本表同時服務兩個條款：
- 一般 init / 同 AI 接班 — `Self-instantiation?` 與 `能力差異要點` 欄填「-」即可
- 跨 AI 接班 — 五欄全填，依 `core/cross-ai-handoff.md §6` 強制

| 日期 | 扮演 AI | 觸發原因 | Self-instantiation? | 能力差異要點 |
|---|---|---|---|---|
| <YYYY-MM-DD HH:MM TZ> | <AI 廠商 + model 等級> | <初始化 / session 接班 / 角色切換 / 跨 AI 接班> | <是 / 否 / -> | <對前一行的差異一句話；無顯著差異須明示> |

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
