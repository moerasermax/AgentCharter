# Example: CryptoBot ↔ AgentCharter Mapping

> **狀態**：v0.1
> **位階**：example reference impl。本檔是 AgentCharter 第一個真實專案對照。

---

## 0. Common Memory Root 對應（v0.4.1 更新）

CryptoBot 採用 framework 的 `core/common-memory-root.md` 條款，但**沿用既有名稱**（`management/`）而非預設 `agent-commons/`：

```yaml
# .agentcharter/mapping.yaml
common_memory_root: management/
```

→ 內容仍位於單一根下，符合「不可分散」原則；僅根目錄名稱與框架預設不同。

> 新採用框架的專案建議直接用 `agent-commons/`；CryptoBot 保留 `management/` 為向後相容範例。

---

## 1. 專案性質

CryptoBot 是 .NET 8 / C# 加密貨幣自動交易系統，雙 AI 協作：

| 角色 | AI | 工具 |
|---|---|---|
| PM | Gemini CLI | 文件撰寫、需求分析、VCP 驗收 |
| Engineer | Claude Code | src/ 修改、shell 執行、抽驗 |

採用本框架的時間：S70 Dashboard PnL 誤判事件（2026-04-27）後沉澱。

---

## 2. 條款對照

| AgentCharter `core/*` | CryptoBot 對應位置 |
|---|---|
| `role-separation.md` | `Dev_Protocol_DISCIPLINE.md §1.1` |
| `audit-rights.md` | `Dev_Protocol_DISCIPLINE.md §1.6` |
| `failure-modes.md` | `Dev_Protocol_DISCIPLINE.md §1.6` 失敗模式分類清單 |
| `escalation-protocol.md` | `Dev_Protocol_DISCIPLINE.md §1.6` 強化抽驗模式 |
| `evidence-first.md` | `Dev_Protocol_DISCIPLINE.md §1.4` |
| `output-mode-protocol.md` | `Dev_Protocol_DISCIPLINE.md §1.7` |
| `completion-delivery.md` | `Dev_Protocol_DISCIPLINE.md §7` |
| `handoff-chain.md` | `Dev_Protocol_DISCIPLINE.md §5.1` + `management/history/HANDOFF_*.md` |
| `init-template.md` | `.claude/commands/engineer-init.md` |

CryptoBot 自有但不屬框架核心：

| CryptoBot 條款 | 性質 | 為何不入框架 |
|---|---|---|
| IRON ①〜⑪（精度、金鑰、未來函數、原子轉換、風控、ACL、四層相依、Domain 純粹、SDK 靜態、UTF-8 BOM、SDK 雙保險）| 領域安全公理（金融）| 框架只提供「Domain Safety Axiom Slot」，公理本身專案專有 |
| §2 策略插槽協議 | 業務領域慣例 | 與框架無關 |
| §3 零容忍契約（0 警告 0 錯誤、100% test pass）| 工程品質基線 | 各專案自定 |
| §4 UI / 異步規範 | 技術棧特定（Blazor / SignalR）| 與框架無關 |

---

## 3. 角色映射

| AgentCharter `roles/*` | CryptoBot 實際 |
|---|---|
| `roles/engineer/_spec.md` | `Dev_Protocol_DISCIPLINE.md` 全文中 Engineer 段落 |
| `roles/engineer/claude-code.md` | `.claude/commands/engineer-init.md` + Engineer 經驗沉澱 |
| `roles/pm/_spec.md` | `Dev_Protocol_DISCIPLINE.md` 全文中 PM 段落 + `management/agent_protocols/PM_Operational_Manual.md` |
| `roles/pm/gemini-cli.md` | （待 Gemini 端提交，含 S70 事件防範改善）|

---

## 4. S70 事件 — 框架的真實檢驗

S70 Dashboard PnL 誤判事件是觸發本框架建立的契機。事件累積：

| 失敗模式 | 次數 | 對應 AgentCharter `core/*` 條款 |
|---|---|---|
| F1（假宣告檔案 / 段落已寫入）| 5 | `audit-rights.md` 抽驗手段被連續迴避 |
| F3（捏造數據）| 3 | `evidence-first.md` 被踩 |
| F5（規則記憶失效 — 同類重犯）| 1 | 同 F-mode 連續 3 次觸發升級 |

事件處理路徑：

1. Engineer 持續退稿（依 `audit-rights.md`）
2. 累計 ≥3 次同類偏差 → 進入「強化抽驗模式」（依 `escalation-protocol.md`）
3. PM 仍連環假宣告 → 「結構性失靈」狀態
4. Engineer 上報使用者並列出選項 ABCD（依 `escalation-protocol.md §4`）
5. 使用者下達選項 B（單次例外授權 Engineer 代寫 management/）
6. 事件結束後沉澱：補 IM、補 DISCIPLINE 失敗統計、抽出本框架

---

## 5. 採用框架的下一步（CryptoBot 視角）

| 項目 | 行動 |
|---|---|
| 把 `Dev_Protocol_DISCIPLINE.md` 內的「通用紀律」段落改為**引用** AgentCharter 對應 `core/*` 條款 | 待議；目前兩處重複維護 |
| 把 IRON 中的「通用 Pattern」（如 Double Insurance）抽到框架，金融特化條款保留 | 待議 |
| Gemini PM 端依 `roles/pm/gemini-cli.md.placeholder` 提交 PM 實作版 | 邀請中 |

---

## 6. 對其他專案的啟示

打算採用 AgentCharter 的新專案：

1. 在專案內建 `protocols/` 目錄
2. 寫 `domain-axioms.md`（你的領域安全公理 — 不一定是金融，可能是醫療隱私、軍工授權、教育合規…）
3. 引用 AgentCharter `core/*` 為紀律基底
4. 在框架的 `examples/<your-project>/mapping.md` 補對照表
5. 用 `templates/role-init.md.tpl` 生成各角色的 init slash command
