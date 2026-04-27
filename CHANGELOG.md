# Changelog

依 [Keep a Changelog](https://keepachangelog.com/) 與 [SemVer](https://semver.org/) 風格。

---

## [Unreleased]

（待議事項）

---

## [0.4.2] — 2026-04-27

### Added — agent-commons 完整 templates + 命名規則

- `templates/agent-commons/capsule.md.tpl` — 任務膠囊範本（依 CryptoBot 真實格式 1:1 萃取，含動機 / 根因 / 修法範圍 / 修法方案 / VCP / 權責 / 連動更新 / 歷史紀錄區）
- `templates/agent-commons/handoff.md.tpl` — HANDOFF 範本（里程碑摘要 / 核心事件 / src 變更清單 / 測試指標 / 膠囊清單 / Protocols 軌跡 / IM 引述 / 紀律事件 / 待 commit 清單）
- `templates/agent-commons/institutional-memory-entry.md.tpl` — IM 章節範本（強制五段格式：症狀 → 根因 → 診斷 → 修法 → 預防）
- `templates/agent-commons/nextwork.md.tpl` — NextWork 範本（執行中 / 待處理 / 已驗證 / 即將開始衝刺）
- `templates/agent-commons/domain-axioms.md.tpl` — 領域公理範本（血鐵律 / 架構鐵律分梯，每條含「後果」段，僅限增加 / 刪除三重授權）
- `templates/agent-commons/_role.md.tpl` — 角色識別檔範本

### Changed

- `core/common-memory-root.md` 加 §8 命名規則（檔名規則 / 路徑明確性 / templates 對應）

### 動機

使用者要求 agent-commons/ 內容**完全按照 CryptoBot 模式**。CryptoBot 的 `management/` + `ai_ops/capsules/` 經 S60〜S70 多事件實戰驗證為有效模式，從中萃取 6 份 templates 為框架預設。新採用框架的專案直接套 templates 即可。

每份 template 含「模板使用指南」段說明變數替換、撰寫紀律、與框架其他條款的對應。

### Added — 架構級約定（Common Memory Root）

- `core/common-memory-root.md` — **架構級約定**：多 AI 共享資產必須位於單一根目錄（預設 `agent-commons/`）。採用識別（看到 `agent-commons/` ＝ 此專案採用 AgentCharter）。允許名稱覆寫但禁止分散。

### Changed

- `core/charter-config.md` — mapping.yaml schema 升 v0.4.1：加 `common_memory_root` 必填欄位；`shared.*` / `roles.*` / `domain_axioms.primary` / `state.*` 路徑改為相對於 common_memory_root；相依表加上「所有條款依賴 common-memory-root」
- `templates/management-layout.md` — 預設根目錄從 `management/` 改為 `agent-commons/`；首段引用 common-memory-root.md 強調架構約束
- `examples/cryptobot/mapping.md` — 加 §0：CryptoBot 沿用 `management/` 為向後相容覆寫範例
- `README.md` — 加 A4 公理「架構級約定」+ core 條款列表

### 動機

使用者提兩件事：(1) 框架熱插拔（v0.4 已支援）；(2) AI 間運作流程基於 management 為共同記憶路徑。第二點原本只在 templates 提到，未條款化 → 補為 core 條款，升為架構級約束。

預設名稱 `agent-commons/` 取自「agent + commons（共同地）」概念，唯一性高、與 `.agentcharter/` 配置目錄不衝突；既有專案（如 CryptoBot）可透過 mapping.yaml 覆寫沿用既有名稱。
- 邀請 Gemini CLI 端提交 `roles/pm/gemini-cli.md`
- CryptoBot 改為 *引用* 框架而非重複維護
- 評估 IRON Pattern（Double Insurance、ACL）抽到框架的可行性
- **B2 子條款層級配置**（profile.yaml `sections.<§>` 開關）— v0.5+ 候選
- **`/charter-{scan,init,doctor}` reference impl**（v0.4 為 spec only，實際工具留 v0.5+）

---

## [0.4.0] — 2026-04-27

### Added — 工具化接入（Spec only）

- `core/charter-config.md` — mapping.yaml + profile.yaml schema 定義；含相依表、解析優先序、違反處置
- `tools/scan-spec.md` — `/charter-scan` 智慧掃描器設計（A3 LLM 內容判讀）
- `tools/init-spec.md` — `/charter-init <preset>` 接入流程設計（5 phase + 失敗回滾）
- `tools/doctor-spec.md` — `/charter-doctor` 健康檢查設計（含 status code 表）
- `tools/profiles/minimal.yaml` — 探索型 / 單人 + 1 AI（6 條款啟用，寬鬆參數）
- `tools/profiles/standard.yaml` — 一般雙 AI 協作（11 條款全啟用，中等參數）
- `tools/profiles/strict.yaml` — 嚴格合規（11 條款全啟用 + 嚴格上限參數，禁信任邊界揭示）

### Modified

- `README.md` — 加 charter-config 條款列表 + 雙路徑接入流程（自動 vs 手動）

### 設計取捨

- **配置粒度**：v0.4 採 B1（條款層級）+ B3 少量參數；B2 子條款層級留 v0.5+
- **掃描智慧度**：A3 LLM 內容判讀（用 LLM 自己讀檔判斷槽位）
- **實作節奏**：v0.4 純 Spec，無實作程式碼；reference impl 留 v0.5+
- **Spec → Impl 分離**：先把契約釘下，工具實作分階段。所有 spec 文檔含跨版本實作節奏表。

### 動機

S70 事件後使用者提兩個議題（智慧掃描、可插拔優化）。整合命題：讓 AgentCharter 從「規範文件集」進化為「**可被工具讀取與執行的協議**」。透過 mapping.yaml + profile.yaml 雙配置檔，既有專案不需重組目錄即可接入；條款可逐項啟用 / 停用，適配不同嚴格度需求。

---

## [0.3.0] — 2026-04-27

### Added — 防線層 L2 + 結構建議

- `core/violation-reflection.md` — 違規反省條款。承認 LLM 個體不可矯正，反省價值在「未來 AI / 集體記憶」而非矯正當前 AI；結構受 structural-anti-fabrication 強制，廢話本身亦為違規模式證據。
- `templates/management-layout.md` — 推薦的 `management/` 結構範例。依角色分私有區（不依 AI 廠商）；含多重身份場景處置與 git 漸進遷移指引。

### Modified

- `README.md` core 條款列表 + 加入新條目
- `core/audit-rights.md` / `failure-modes.md` 補交叉引用至 violation-reflection

### 動機

S70 事件後使用者複盤「自我反省 vs LLM 個體不可矯正」議題。結論：
1. AI 個體不可矯正是事實，反省不能改變當前 AI 行為
2. 但反省的真實價值在於審計痕跡 + 集體記憶 + 機器可掃描的違規統計
3. 結構強制（v0.2 已加）+ 違規反省（v0.3）+ 升級協議（既有）構成多層防線
4. 同時釐清「角色 vs AI 廠商」分軸 — 私有區依角色分，不依廠商分，支援 1 AI 多角色場景

---

## [0.2.0] — 2026-04-27

### Changed — 強度升級

- `core/structural-anti-fabrication.md` 從「強化抽驗模式必強制」**升為「全模式預設強制」**：所有結案宣告無論模式皆須附 stdout 區塊，缺失即直接退稿不進入內容判讀
- 新增 §7.1 Token 影響說明：短期 +1〜3%，長期顯著減少（避免假宣告事件爆炸性消耗）
- 新增 §7.2 與 eco 模式的相容說明（stdout 屬事實型內容，不在 eco 可砍項）

### 動機

S70 事件後使用者複盤討論：自我 hook 受限於遞迴信任陷阱與形式主義，把驗證搬到結構層才有效。0.1.1 引入後評估 token 影響為「短增長減」，故直接升級為全模式強制，無 v0.2 觀察期。

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
