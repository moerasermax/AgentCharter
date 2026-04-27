# Changelog

依 [Keep a Changelog](https://keepachangelog.com/) 與 [SemVer](https://semver.org/) 風格。

---

## [Unreleased]

（待議事項）
- 邀請 Gemini CLI 端提交 `roles/pm/gemini-cli.md`
- CryptoBot 改為 *引用* 框架而非重複維護
- 評估 IRON Pattern（Double Insurance、ACL）抽到框架的可行性
- v0.2 評估把 `structural-anti-fabrication.md` 從「強化抽驗模式必強制」升為「全模式預設強制」

---

## [0.1.1] — 2026-04-27

### Added

- `core/structural-anti-fabrication.md` — 結構性反捏造條款。把驗證從「AI 自我誠實」搬到「文檔結構強制」：事實型宣告必須含 stdout 區塊，缺即視同未交付。

### Modified

- `README.md` core 條款列表加入新條目
- `core/audit-rights.md` / `evidence-first.md` / `escalation-protocol.md` / `completion-delivery.md` / `failure-modes.md` 補交叉引用至新條款

### 動機

S70 事件診斷後使用者提出「AI 多一個自我 hook 檢驗是不是好事」討論。結論：自我 hook 仍受限於「遞迴信任陷阱」與「形式主義」。更有效的設計是把「驗證」從 AI 行為層搬到文檔結構層 — 沒有 stdout 區塊就連送都送不出，AI 想假宣告無處可放。


---

## [0.1.0] — 2026-04-27

### Added — 初版骨架

#### Core 通用條款（9 份）

- `core/role-separation.md` — 角色互鎖原則
- `core/audit-rights.md` — 抽驗權通用模型
- `core/failure-modes.md` — F1〜F5 失敗模式分類
- `core/escalation-protocol.md` — 強化抽驗 / 結構性失靈 / 使用者裁決
- `core/evidence-first.md` — 實證先行原則
- `core/output-mode-protocol.md` — eco / verbose 模式協議
- `core/completion-delivery.md` — 完工交付契約（VCP / Directive Header / 雙保險 / 危險度標籤）
- `core/handoff-chain.md` — Session 交接鏈
- `core/init-template.md` — 角色 init 五步驟骨架

#### Roles（4 份）

- `roles/engineer/_spec.md` — Engineer 職能定義
- `roles/engineer/claude-code.md` — Claude Code 工程師 reference impl（v0.1）
- `roles/pm/_spec.md` — PM 職能定義
- `roles/pm/gemini-cli.md.placeholder` — 邀請 Gemini 提交

#### Examples（1 份）

- `examples/cryptobot/mapping.md` — CryptoBot ↔ AgentCharter 對照（首個 reference impl）

#### Templates（1 份）

- `templates/role-init.md.tpl` — 任意角色 init slash command 模板

#### Meta（4 份）

- `README.md`
- `GOVERNANCE.md`
- `CONTRIBUTING.md`
- `CHANGELOG.md`（本檔）

### 起源事件

本框架由 CryptoBot 專案 S70 Dashboard PnL 誤判事件後沉澱啟動。事件累積：

- F1（假宣告）×5
- F3（捏造數據）×3
- F5（規則記憶失效）×1
- 觸發強化抽驗 → 結構性失靈 → 使用者裁決選項 B

詳見 `examples/cryptobot/mapping.md §4`。
