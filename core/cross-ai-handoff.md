# Cross-AI Handoff（跨 AI 接班規範）

> **狀態**：v0.1（本檔自 v0.5.2 引入，補完 v0.5.1 self-instantiation 之後的「退出方—轉移—接班方」全鏈）
> **位階**：core 通用條款。
> **依存**：`handoff-chain.md`（基底）、`init-template.md`（接班方入口）、`role-separation.md`（角色身份）、`escalation-protocol.md`（強化抽驗狀態）、`audit-rights.md`（抽驗權繼承）

---

## 0. 與相關條款的位階分工

跨 AI 場景由三條互補條款共同管轄：

| 條款 | 主管面向 | 動作主體 |
|---|---|---|
| `handoff-chain.md` | Session 維度的工作交接（不分 AI）| 退出方主筆 HANDOFF、接班方抽驗 |
| `init-template.md §3.3` | 新 AI 進入角色時的**自我具象化** | 接班方（若無對應 slash command 即自建）|
| **本條款** | 廠商維度的**狀態轉移** + 接班方**能力差異**處置 | 退出方移交 + 接班方接收 |

→ 換言之：HANDOFF 解決「做了什麼」，self-instantiation 解決「我以什麼身份進入」，**本條款解決「上一手的狀態怎麼正確流到下一手」**。

---

## 1. 條文

當任一角色由不同 AI 廠商接班，**退出方必須完成轉移交付**、**接班方必須完成接收校準**，否則視為跨 AI 接班未完成；前一段協議狀態（強化抽驗、未結案膠囊、隱性決策）皆不得自動失效。

---

## 2. 觸發判定

| 場景 | 等級 | 本條款是否生效 |
|---|---|---|
| AI 廠商不一致（Claude → Gemini / Cursor → Claude）| **強跨 AI** | ✅ 全條款生效 |
| 同廠商但 model 等級顯著變動（Opus → Haiku、SDK 主版號跳動）| **弱跨 AI** | ✅ §3 / §4 / §5 生效；§6 切換歷史可簡記 |
| 同廠商同 model 但工具配置變動（失去某 MCP / hook 失靈）| 環境變更 | ❌ 非跨 AI；屬 `handoff-chain.md §5` 工具能力範疇 |
| 同 AI 同 session 切換角色（1 AI 多角色）| 非跨 AI | ❌ 走 `multi-role-tracking`（待寫）|

判定權：**接班方**第一輪（init 守門時）判定；爭議時由使用者裁決。

---

## 3. 退出方（舊 AI）轉移職責

### 3.1 標準 HANDOFF 增量

跨 AI 的 HANDOFF 在 `handoff-chain.md §2` 必含 7 項之外，額外必含：

| 項目 | 說明 |
|---|---|
| **能力快照**（Capability Snapshot）| 依 §5 標準格式 |
| **強化抽驗狀態**（若有）| 對方角色當前是否處於強化抽驗模式、累積偏差次數、解除進度 |
| **私有筆記轉移宣告** | `roles/<role>/private/` 內若有對接班方關鍵的資訊，須**轉到** `sessions/` 或 `drafts/`；若無則明示「無」 |
| **隱性決策清單** | 已內化執行但未寫入文件的判斷（如「我認為 X 寫法不適用此專案」），點名待接班方確認 |
| **未結案膠囊清單** | capsule ID + 當前 state + 退出方建議下一步 |

### 3.2 禁令

| 禁令 | 動機 |
|---|---|
| ❌ 把私有筆記留在 `private/` 直接離開 | `private/` 不入 git、跨 AI 不可見；資訊蒸發 = 集體記憶斷鏈 |
| ❌ 把未結案膠囊默認交給接班方關 | 退出方仍對自己工作期內的結案宣告負責；不可甩鍋 |
| ❌ 把強化抽驗狀態以「我覺得對方修好了」自行解除 | 解除須走 `escalation-protocol.md §5` 流程，跨 AI 接班不是解除事件 |

---

## 4. 接班方（新 AI）接收職責

### 4.1 五步接收流程

```
1. 跑自己廠商的 init（依 init-template.md）
   → 若無對應 slash command，先走 §3.3 self-instantiation

2. 讀完整 HANDOFF（含 §3.1 跨 AI 增量五項）

3. 能力差異盤點：
   - 對退出方「能力快照」逐項自評：我是否具備、若無 fallback 為何
   - 任一項缺且無 fallback → 中斷接收、回報使用者裁決

4. 狀態繼承：
   - 強化抽驗模式：若退出方註明對方在此模式，本 session 對其結案宣告強制要求附 stdout
   - 未結案膠囊：寫入自己的 NextWork 第一優先
   - 隱性決策清單：逐項確認或明示推翻並補寫文件

5. 簽名（依 §6 切換歷史標準格式）
```

### 4.2 禁令

| 禁令 | 動機 |
|---|---|
| ❌ 跳過退出方留下的能力快照 | 不知道前任能做什麼，無法判斷自己的差異與 fallback 需求 |
| ❌ 自行降級強化抽驗模式 | 解除權不跨 AI 繼承（依 §7）|
| ❌ 把退出方的私有筆記當作不存在 | 若 `private/` 內有資訊但退出方未轉移，應主動回退、要求補交 |

---

## 5. 能力快照（Capability Snapshot）標準格式

退出方在 HANDOFF 內附以下表格：

```markdown
## 能力快照（依 cross-ai-handoff.md §5）

### 工具能力
| 能力 | 退出方狀態 | 接班方須評估 |
|---|---|---|
| Hook 系統 | ✅ 有用過（settings.json 有 X）| 接班方對應系統？|
| MCP server: <name> | ✅ 連上、用過 N 次 | 接班方是否有同 MCP？|
| Shell: bash on Win11 | ✅ 全程使用 | 接班方環境一致？|
| Slash commands 自建 | ✅ <list> 已具象化在 .<vendor>/commands/ | 接班方需自我具象化自己的 |

### Stateful 副作用
- <列出本機暫存檔、process 持留、外部 API 已寫入但未確認的記錄>

### 隱性能力假設
- <列出本 session 默認可用但未驗證的能力，如「假設 git rebase -i 不需要」>

### 接班方若缺對應能力的 fallback 路徑建議
- <對每個能力差異點，退出方提一條 fallback>
```

**最低要求**：四個區塊都不可省，「無」也須明示「無」。

---

## 6. `_role.md` 切換歷史標準格式

每次跨 AI 接班完成後，接班方須在 `<common-memory-root>/roles/<role>/_role.md` 的「切換歷史」追加一行：

```markdown
| 日期 | AI 廠商 | 觸發原因 | Self-instantiation? | 能力差異要點 |
|---|---|---|---|---|
| 2026-04-27 | Claude (Opus 4.7) | Gemini 額度耗盡 | 否（既有 .claude/commands/pm-init.md）| 無顯著差異 |
| 2026-05-03 | Gemini CLI | 使用者指定試用 | **是**（首次具象化 .gemini/commands/pm-init.toml）| 缺 Bash hook，改用 Gemini shell tool |
```

| 欄位 | 必填？ | 說明 |
|---|---|---|
| 日期 | ✅ | 接班完成日（YYYY-MM-DD）|
| AI 廠商 | ✅ | 含 model 等級（如 Claude Opus 4.7）|
| 觸發原因 | ✅ | 簡述（額度 / 使用者指定 / 工具能力需求 / 等）|
| Self-instantiation? | ✅ | 是 / 否（接 init-template §3.3）|
| 能力差異要點 | ✅ | 對前一行的差異一句話；無差異須寫「無顯著差異」 |

---

## 7. 強化抽驗狀態的跨 AI 傳遞

`escalation-protocol.md §5` 規定強化抽驗模式不會自動解除。**跨 AI 接班是更嚴格的場景**：

| 規則 | 細節 |
|---|---|
| 不跨 AI 繼承解除權 | 連續無偏差的計數**不繼承前一 AI 的累積**；接班方須重新累計 ≥ N 次連綠才得解除 |
| 雙重標註 | 退出方在 HANDOFF + `_role.md` 雙處標註當前強化抽驗狀態 |
| 接班方守門時讀取 | init §1.4 守門步驟必讀 `state/failure_modes.log` 與 HANDOFF，發現對方在強化抽驗即進入該模式 |
| 解除須明示 | 接班方解除時，須在 HANDOFF + `_role.md` 寫明「解除依據：本 AI 任內連續 N 次無偏差」|

**動機**：跨 AI 接班自帶能力差異風險，前一 AI 累積的「無偏差信用」可能在新環境失效，重新累計是防偽的最低保險。

---

## 8. 對應的失敗模式

當本條款被違反，依 `failure-modes.md` 對應如下（不另立新 F-mode）：

| 違反方式 | 失敗模式 |
|---|---|
| 接班方跳過自己的 init 即進入工作 | F1（假宣告就位）|
| 退出方 HANDOFF 缺能力快照 | F3（捏造數據類）+ 結構性不交付（依 `structural-anti-fabrication.md`）|
| 退出方私有筆記未轉移即離開 | F4（編號 / 檔案位置偏差類）|
| 強化抽驗狀態未傳遞 / 接班方擅自解除 | F5（規則記憶失效）|
| `_role.md` 切換歷史未更新 | F1（簽到偽造，等同 init-template §1.3 違反）|

---

## 9. 與其他 core 條款的關係

| 條款 | 關係 |
|---|---|
| `handoff-chain.md` | 本條款是其 §5 的展開；§5 改為指向本檔，避免雙處維護 |
| `init-template.md` | 接班方走 init（含 §3.3 self-instantiation）為本條款 §4.1 第 1 步 |
| `role-separation.md` | 跨 AI 不改變角色身份，只換載體；本條款保護「角色 ⊥ AI」公理 |
| `audit-rights.md` | 接班方繼承前任的抽驗權；不可主張「我剛接手所以這次不抽」 |
| `escalation-protocol.md` | 強化抽驗狀態傳遞依本條款 §7；解除流程不變 |
| `common-memory-root.md` | `_role.md` 切換歷史是跨 AI 集體記憶的物理 anchor |
| `violation-reflection.md` | 退出方留下的反省紀錄不刪、不繼承責任，但接班方須讀過 |

---

## 10. 變更歷史

- **v0.1（自 v0.5.2 引入）** — 初版。從 `handoff-chain.md §5` 拆出獨立條款；補完「舊 AI 退出 + 狀態傳遞 + 強化抽驗繼承」這半，與 v0.5.1 self-instantiation 構成「退出—轉移—接班」全鏈。
