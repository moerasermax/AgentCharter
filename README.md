# AgentCharter

> **多 AI 協作的角色協議框架** — 把「PM」「Engineer」「Reviewer」這些職能抽象出來，讓任何 AI（Claude / Gemini / Cursor / 你下個用的 LLM）都可以在任意專案上各司其職並互相抽驗。

---

## 為什麼存在

當你的工作流不只一個 AI（例如 Gemini 當 PM、Claude 當 Engineer），你會撞到三個問題：

1. **角色綁死特定 AI**：「我們的 PM 規則」其實只有 Gemini 跑得對
2. **協議綁死特定專案**：搬到新專案要重新發明所有紀律
3. **AI 能力差異無顯式描述**：Claude 有 hook、Gemini 沒 hook，協議在後者上會失效

AgentCharter 把這三軸正交化：

```
Charter (this repo)         ← 跨 AI、跨專案、跨角色的最大公約數
   │
   ├── core/                ← 通用條款（職責、抽驗、失敗模式、交付契約…）
   ├── roles/<role>/        ← 各角色職能定義 + 各 AI 的實作版
   ├── examples/<project>/  ← 真實專案的對照表（IRON ↔ Charter）
   └── templates/           ← 生成 /<role>-init 等的模板
```

---

## 三條設計公理

| 公理 | 含義 |
|---|---|
| **A1. 角色 ⊥ AI** | 「PM」是抽象職能，可由任何 AI 扮演；切換扮演者不該改變協議 |
| **A2. AI ⊥ 角色** | 同一個 AI 可在不同專案扮演不同角色；身份無黏著 |
| **A3. 專案 ⊥ 框架** | 框架不知道「金融 / 醫療 / SaaS」差異；領域特定條款（如 IRON 風控）放專案內，框架只提供「**領域安全公理槽位**」（Domain Safety Axiom Slots）|

---

## 核心通用條款（`core/`）

| 檔案 | 一句話描述 |
|---|---|
| `role-separation.md` | 角色互鎖原則 — 寫程式碼權與結案宣告權對稱分離 |
| `audit-rights.md` | 抽驗權 — 結案宣告默認待抽驗，工程師抽驗權不得放棄 |
| `failure-modes.md` | F1〜Fn 失敗模式分類（假宣告、捏造數據、規則記憶失效…）|
| `escalation-protocol.md` | 連續失敗 → 強化抽驗 → 結構性失靈 → 使用者裁決 |
| `evidence-first.md` | 隱性 Bug 嚴禁盲猜；參數嚴禁假設值 |
| `structural-anti-fabrication.md` | 事實宣告必含 stdout 區塊；不靠 AI 自我誠實，靠文檔結構強制 |
| `output-mode-protocol.md` | eco / verbose 雙段式輸出 + 自動升級條件 |
| `completion-delivery.md` | 工程師完工須附「PM 驗收測試計畫」（Directive Header / 雙保險 / 危險度標籤 / 期望錨點 / 失敗解讀表）|
| `handoff-chain.md` | Session 交接鏈與必含項目 |
| `init-template.md` | 任何 `/<role>-init` slash command 該有的最小骨架 |

---

## 角色目錄（`roles/`）

每個角色含：
- `_spec.md` — 該角色「做什麼 / 不做什麼 / 與其他角色的邊界」
- `<ai-vendor>.md` — 該 AI 在扮演此角色時的執行細節（如 Claude 用 hook，Gemini 用主動讀檔）

當前提供：
- `roles/engineer/claude-code.md` — Claude Code 工程師實作（v0.1 reference impl）
- `roles/pm/gemini-cli.md.placeholder` — 邀請 Gemini 提交 PM 經驗

---

## 對任意專案的接入流程

新專案要採用 AgentCharter：

1. 在專案內建 `protocols/` 或 `governance/` 目錄
2. 寫 `domain-axioms.md` — 你的領域安全公理（金融專案的 IRON、醫療專案的 HIPAA 對應…）
3. 引用 AgentCharter 的 `core/*` 為「通用層」
4. 在 `examples/<your-project>/mapping.md` 補一份對照表
5. 用 `templates/role-init.md.tpl` 生成 `/<role>-init` slash command

---

## 起源（v0.1）

本框架由 **CryptoBot 專案**的 S70 Dashboard PnL 誤判事件後沉澱啟動 — 該事件中 PM 連續 ≥7 次假宣告觸發強化抽驗 → 結構性失靈 → 使用者裁決。事件結束後，使用者要求把工程師（Claude）的協作守則抽象成跨 AI 框架。

詳見 `examples/cryptobot/mapping.md`。

---

## 治理 / 貢獻 / 變更

- `GOVERNANCE.md` — 誰可 merge、衝突如何處理、版本權威
- `CONTRIBUTING.md` — 如何提交新角色 / 新失敗模式 / 新 AI 實作版
- `CHANGELOG.md` — 版本紀錄

---

## License

私有專案；公開化決定保留至 v1.0。
