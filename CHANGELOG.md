# Changelog

依 [Keep a Changelog](https://keepachangelog.com/) 與 [SemVer](https://semver.org/) 風格。

---

## [Unreleased]

（待議事項）

---

## [0.5.6] — 2026-04-27

### Added — Versioning & Migration 條款（高優先候選 #2 — 完成最後一條）

新建 `core/versioning-migration.md`，補完條款集對「自身版本演化」的紀律。**至此 5 候選全部完成**（v0.5.2〜v0.5.6）。

#### 為何需要

- `profile.yaml` 已有 `version` + `charter_version` 兩欄，但無「升級時怎麼遷」
- `tools/init-spec.md §6` 提到 `/charter-init --update` 但只 5 步驟，缺判斷依據
- `tools/doctor-spec.md §3.1` 引用「profile schema 版本相容」但無「相容」定義

#### 條款內容（10 段）
- §0 為何需要本條款
- §1 條文（charter_version 必填 + 升級走流程 + 框架提供 migration guide）
- §2 SemVer 對 AgentCharter 的具體含義（PATCH / MINOR / MAJOR / 架構級四類）+ §2.1 BREAKING 判定條件 + §2.2 PATCH 判定條件
- §3 已採用專案的遷移流程（標準 7 步流程 + 工具支援 + 跨 MAJOR 跳升禁令）
- §4 破壞性升級的告警（框架側 + 採用方側責任）
- §5 回退路徑（升級失敗回退 / 升級後局部關閉 / 整版降回最後手段）
- §6 `version` 與 `charter_version` 雙軌（獨立演化 + 相容性檢查）
- §7 多 AI 環境的版本一致性
- §8 違反處置（接 F1 / F4 / F5）
- §9 與其他 core 條款的關係
- §10 變更歷史 + v1.0 完整化規劃

### Modified

- `core/charter-config.md` — `enabled` 加 `versioning-migration`；條款相依表加（依賴 `charter-config` + `handoff-chain` + `init-template`）
- `core/handoff-chain.md §7` — 加反向引用，標明升級事件須寫進 §2 第 3 項
- `core/init-template.md §8` — 加反向引用，標明 §1.4 守門須驗證 charter version 一致性
- `tools/profiles/{minimal,standard,strict}.yaml` — 全部啟用（minimal 也啟用，因任何專案都會遇到 charter 升版）；三者 `charter_version` 升至 0.5.6
- `README.md` core 條款表加一行

### 動機

當前其他 5 條候選（cross-ai-handoff / role-conflict-resolution / multi-role-tracking / domain-axiom-slot 加上歷史的 common-memory-root 與 charter-config）已穩定，可開始做版本化規範。原本 NEXT.md 標明「等其他穩定後再做」，避免條款本身變動時頻繁修改 versioning 規範。

關鍵設計決策：
- **架構級類別 BREAKING-LITE**（§2）— v0.4.1 / v0.5.0 這類「技術上 minor 但實質影響大」的歷史變動需要中間級別；標 minor 但 CHANGELOG 顯著標明
- **跨 MAJOR 禁止跳升**（§3.3）— 跳過中間 migration 等於放棄狀態一致性保證
- **整版降回不是常態**（§5.3）— 先嘗試局部關閉條款 / 調參數，最後才整版降
- **多 AI 同 session 禁不同 charter version**（§7）— 會破壞 cross-AI 兼容性
- **v0.x → v1.0 之間的版本提升均不視為 BREAKING**（§10）— v0.x 階段條款仍在演化；v1.0 之後嚴格遵循 SemVer

### 里程碑

5 候選核心條款覆蓋率盤點**完成**：

```
v0.5.2 — Cross-AI Handoff
v0.5.3 — Role Conflict Resolution
v0.5.4 — Multi-Role Tracking
v0.5.5 — Domain Axiom Slot
v0.5.6 — Versioning & Migration ← 本版
```

下一階段焦點：roles/pm/gemini-cli.md（待 Gemini 端代理）+ v0.5+ Reference Impl（把 scan/init/doctor spec 變可跑工具）。

---

## [0.5.5] — 2026-04-27

### Added — Domain Axiom Slot 條款（高優先候選 #1）

新建 `core/domain-axiom-slot.md`，把原本只在 `templates/agent-commons/domain-axioms.md.tpl` 的撰寫紀律提煉至 core 層，並補完位階理論依據與違反處置嚴重度分級。

#### 位階定位
- **Template** = 採用方專案複製貼上的實作骨架
- **本條款** = 框架對該槽位本身的規範（位置 / 強制要求 / 違反處置 / 與 core 關係）

沒有 core 條款，工具（`/charter-doctor`）無法判斷「本專案的領域公理是否合規」，AI 跨 AI 接班時無共同基準確認領域公理是否到位。

#### 條款內容（8 段）
- §0 為何需要本條款（與 template 的差別）
- §1 條文（位置必填 + 內容須符合最低要求 + 違反觸發 doctor 報錯）
- §2 槽位位階（**領域公理 > core 條款**衝突優先序，及與 role-conflict-resolution §2「領域 vs 通用衝突」的對應）
- §3 撰寫紀律最低要求：強制（位置存在、後果段必含、可驗證、有編號）/ 建議（分梯、修訂只增不刪、IM 引用、已落實段）
- §4 與 charter-config / common-memory-root / template 的關係
- §5 多領域公理的處理（v0.5+ secondary 陣列候選 schema）
- §6 違反處置 — /charter-doctor 嚴重度分級（ERROR / WARN / INFO）
- §7 與其他 core 條款關係
- §8 變更歷史

### Modified

- `core/charter-config.md` — `enabled` 加 `domain-axiom-slot`；條款相依表加（依賴 `charter-config` + `common-memory-root` + `evidence-first`）
- `core/evidence-first.md §5` — 加反向引用，標明領域公理「可驗證」要求與本原則同源
- `core/role-conflict-resolution.md`：
  - §2「領域 vs 通用衝突」改為引用 `domain-axiom-slot §2.1`（取代原本指向 template 的引用）
  - §7 加反向引用
- `templates/agent-commons/domain-axioms.md.tpl §與 AgentCharter 的關係` — 加指向 core 條款，標明撰寫紀律最低要求由 core §3 規範
- `tools/profiles/{minimal,standard,strict}.yaml`：**全部啟用**（`minimal` 也啟用，因領域公理檔即使在 minimal 場景仍須合規 — minimal 條款啟用：6/14 → 7/15）；三者 `charter_version` 升至 0.5.5
- `README.md` core 條款表加一行

### 動機

條款覆蓋率盤點時發現：`templates/agent-commons/domain-axioms.md.tpl` 已有實作骨架與撰寫紀律建議，但 core 層空白導致：

1. `/charter-doctor` 工具無依據判斷專案領域公理是否合規
2. 跨 AI 接班時無共同基準確認領域公理到位（init-template §1.2 校準步驟引用「讀領域公理」但無「該讀什麼」的規範）
3. 「領域 vs 通用衝突」的優先序只散見於 template 與 role-conflict-resolution，缺中央定義

關鍵設計決策：
- **領域公理 > core 條款**（§2.1）— 通用紀律服從領域底線；違反領域公理 → 直接後果（資金 / 安全 / 合規），通用條款不該越界決定領域風險容忍度
- **強制 vs 建議分級**（§3）— 違反強制 = ERROR，違反建議 = WARN；避免一刀切讓採用方覺得負擔過重
- **violation 處置由 /charter-doctor 落實**（§6）— 而非由 AI 即時退稿；領域公理偏差不是「失敗事件」（單一事件 F1〜F5），而是專案級配置問題
- **minimal preset 也啟用本條款**（區別於其他 v0.5 新條款）— 即使探索型專案，「有領域公理且合規」是採用 AgentCharter 的最低標籤；無公理 = 採用 evidence-first 預設一般紀律但仍須在 mapping 標明

---

## [0.5.4] — 2026-04-27

### Added — Multi-Role Tracking 條款（高優先候選 #5）

新建 `core/multi-role-tracking.md`，把原本 `templates/management-layout.md §3.1` 的「不建議動態切換角色」**建議**升格為 core **強制規範**，並補完三項防呆機制（離岸/上岸宣告、身份戳、自抽自驗禁令）。

#### 為何需要

`role-separation.md` 的對稱分離原則動機是「兩端互為事實檢核器」。1 AI 兼任 ≥ 2 角色時物理上只有一個推論主體，互鎖機制有兩種失效路徑：

1. **隱式戴帽子** — AI 不走 init 即從 Engineer 心智切到 PM 心智；外部看不出切換時間點
2. **自抽自驗** — AI 用 Reviewer 身份抽驗自己 Engineer 身份的產出；同一推論偏見無外部修正

兩條失效路徑都會把多角色協作降級為「單方獨佔閉環」。

#### 條款內容（9 段）
- §0 適用範圍（同 AI ≥ 2 角色）+ 與 cross-ai-handoff 區隔
- §1 條文（切換必走 init / 必標身份戳 / 禁自抽自驗）
- §2 設計動機（兩種失效路徑分析）
- §3 強制規範三項：
  - §3.1 切換協議（離岸宣告 + 跑 init + 上岸宣告，三段不同訊息 / 不同時間戳）
  - §3.2 結案宣告身份戳（frontmatter 三欄：身份戳 / 切換情境 / 前一身份）
  - §3.3 自抽自驗禁令（同 session 禁、跨 session 警示、戴帽抽他人允許；例外走 escalation §4-B）
- §4 切換歷史紀錄（_role.md 多角色情境的特殊條目辨識 + 兼任宣告欄位）
- §5 防呆 + 反濫用（連續違反觸發強化抽驗）
- §6 對應失敗模式（接 F1 / F4 / F5）
- §7 與其他 core 條款關係
- §8 與 management-layout §3.1 的關係（升格與簡化指向）
- §9 變更歷史

### Modified

- `core/charter-config.md` — `enabled` 加 `multi-role-tracking`；條款相依表加（依賴 `role-separation` + `audit-rights` + `init-template` + `failure-modes`）
- `core/role-separation.md`：
  - §3 加 §3.4「1 AI 兼任 ≥ 2 角色」段，指向本條款
  - §5 加反向引用
- `templates/management-layout.md §3.1`：
  - 升格為強制規範指向本條款
  - 「不建議動態切換」→「強制規範：切換必走完整 init + 身份戳 + 禁自抽自驗」
- `tools/profiles/{minimal,standard,strict}.yaml` — standard / strict 啟用；minimal 預設 `false`（單 AI 單角色）；三者 `charter_version` 升至 0.5.4
- `README.md` core 條款表加一行

### 動機

`management-layout.md §3.1` 早期形式（v0.4.1）只是 template 建議「不建議動態切換」，無強制力與防呆。實證需求：CryptoBot 場景中 Claude 偶爾被使用者要求戴 PM 帽抽驗自己工作 — 結果即「同一偏見的形式抽驗」，無實際外部修正力。

關鍵設計決策：
- **三段對稱宣告**（離岸 + init + 上岸）— 物理上拉開時間，給推論一個「下班—上班」的儀式間隔
- **自抽自驗有梯度**（同 session 禁、跨 session 警示、戴帽抽他人允許）— 不一刀切，但同 session 是物理上的同一推論狀態，最危險
- **例外授權走 escalation §4-B**（單次例外、不形成慣例、留審計）— 與既有條款銜接而非另立通道
- **連續違反觸發強化抽驗**（§5.1 反濫用）— 防止「不同身份」被當成逃避抽驗的捷徑
- **升格 management-layout §3.1**（template 建議 → core 強制）— 避免雙處維護

---

## [0.5.3] — 2026-04-27

### Added — Role Conflict Resolution 條款（高優先候選 #4）

新建 `core/role-conflict-resolution.md`，補完 `escalation-protocol` 之外的「**決策分歧**」軸。失敗事件處理（單向、有對錯）與決策分歧處理（雙向、無對錯）至此正交完整。

#### 與 escalation-protocol 的嚴格區隔（§0）
- `escalation-protocol` — 失敗事件累積（F1〜F5），單向，宣告方有偏差須補強
- **`role-conflict-resolution`** — 決策分歧（範圍 / 技術選型 / 紀律解讀 / 優先序 / 領域 vs 通用），雙向，兩角色對等 escalate
- 誤分類後果：把分歧誤判為失敗事件 → 抽驗方單方退稿、累積進入強化抽驗 → 對方無辜進入升級狀態 → 協作信任崩解

#### 條款內容（8 段）
- §0 與 escalation-protocol 的區隔（先講清楚）
- §1 條文（禁止單方逕行 + 三級裁決階梯）
- §2 衝突類型分類（5 類：範圍 / 技術選型 / 紀律解讀 / 優先序 / 領域 vs 通用）
- §3 三級裁決階梯：L0 對話（N ≤ 2 回合）→ L1 條款仲裁（明示對錯 / 轉 escalation / 升 L2）→ L2 使用者裁決（標準上報格式 + ABCD 選項）
- §4 紀錄要求（capsule decision log / conflict-record / IM 判例三層）
- §5 防呆（Pending 狀態紀律 + 時效性例外 + 反濫用）
- §6 對應失敗模式（接 F1〜F5）
- §7 與其他 core 條款關係
- §8 變更歷史

### Modified

- `core/charter-config.md` — `enabled` 加 `role-conflict-resolution`；條款相依表加（依賴 `role-separation` + `escalation-protocol` + `evidence-first` + `audit-rights`）
- `core/escalation-protocol.md §6` — 加反向引用，明示與本條款的嚴格區隔
- `core/role-separation.md §5` — 加反向引用，標明衝突 pending 期間單方逕行 = 越界，依本條 §3.1 退稿
- `tools/profiles/{minimal,standard,strict}.yaml` — standard / strict 啟用；minimal 預設 `false`（單 AI 無此情境）；三者 `charter_version` 升至 0.5.3
- `README.md` core 條款表加一行

### 動機

CryptoBot 過往案例（PM 想擴 scope vs Engineer 守 capsule 邊界）暴露了 escalation-protocol 的覆蓋盲區：兩角色無人錯，但需裁決路徑。原協議只能把分歧硬塞進 escalation 處理，導致無辜方累積進入強化抽驗。

獨立條款後關鍵設計：

```
失敗事件（單向、有對錯） → escalation-protocol
決策分歧（雙向、無對錯） → role-conflict-resolution
邊界爭議 → 預設為分歧，由 L1 仲裁判定是否升級為失敗事件
```

關鍵設計決策：
- **三級階梯避免直跳使用者**（L0 對話 → L1 條款仲裁 → L2 使用者）— 使用者只在條款未明示時介入
- **L0 限 N ≤ 2 回合**（防無限拖延）
- **領域公理優先於 core 條款**（衝突時依 domain-axioms.md.tpl「衝突時以本文件為準」）
- **Pending 紀律連動 role-separation §3.1**（衝突期間越界 = 退稿）
- **時效性例外有四道閘**（避免熱修被濫用為跳過協議的捷徑）
- **L2 級必入 IM 為判例**（給未來相似衝突一鍵套用）

---

## [0.5.2] — 2026-04-27

### Added — Cross-AI Handoff 條款（高優先候選 #3）

新建 `core/cross-ai-handoff.md`，補完 v0.5.1 self-instantiation 之後的「**退出方—轉移—接班方**」全鏈。原 `handoff-chain.md §5`（簡略 3 點）拆出獨立條款，避免 session 維度與廠商維度混雜。

#### 位階分工
- `handoff-chain.md` — Session 維度的工作交接（不分 AI）
- `init-template.md §3.3` — 新 AI 進入時的**自我具象化**（接班方入口）
- **`cross-ai-handoff.md`** — 廠商維度的**狀態轉移** + 接班方**能力差異**處置

#### 條款內容（10 段）
- §0 與相關條款的位階分工
- §1 條文（退出方須轉移、接班方須接收，缺則跨 AI 接班未完成）
- §2 觸發判定（強跨 AI / 弱跨 AI / 環境變更 / 1 AI 多角色）
- §3 退出方轉移職責（HANDOFF 增量 5 項：能力快照、強化抽驗狀態、私有筆記轉移宣告、隱性決策清單、未結案膠囊清單）
- §4 接班方接收職責（5 步流程 + 禁令）
- §5 能力快照（Capability Snapshot）標準格式（工具能力 / Stateful 副作用 / 隱性能力假設 / fallback 路徑）
- §6 `_role.md` 切換歷史標準格式（5 欄）
- §7 強化抽驗狀態的跨 AI 傳遞（**不繼承解除權**，須重新累計）
- §8 對應失敗模式（接 F1〜F5，不另立新 F-mode）
- §9 與其他 core 條款的關係
- §10 變更歷史

### Modified

- `core/handoff-chain.md §5` 簡化為指向 `cross-ai-handoff.md`，避免雙處維護
- `core/charter-config.md` schema：`enabled` 清單加 `cross-ai-handoff`；條款相依表加一行（依賴 `handoff-chain` + `init-template` + `escalation-protocol` + `audit-rights`）
- `core/init-template.md §8` 加一行：`cross-ai-handoff` 為跨 AI 轉移流程的接收端入口
- `templates/agent-commons/_role.md.tpl` 切換歷史擴為 5 欄（加 `Self-instantiation?` + `能力差異要點`），同時服務 init-template §1.3 與 cross-ai-handoff §6
- `tools/profiles/{minimal,standard,strict}.yaml`：standard / strict 啟用 `cross-ai-handoff: true`；minimal 預設 `false`（單 AI 不需）；三者 `charter_version` 升至 0.5.2
- `README.md` core 條款表加 `cross-ai-handoff` 一行；`init-template` 描述同步更新為 v0.5.0 升格後內容

### 動機

v0.5.1 self-instantiation 解決了「**新 AI 進入**」（接班方自己讀 charter 自我具象化），但「**舊 AI 退出 + 狀態傳遞**」這半空白 — 私有筆記蒸發、強化抽驗狀態斷鏈、能力差異無顯式處置。

跨 AI 是架構級維度（自帶能力差異風險），不該與 session 維度的 handoff 混為一談。獨立條款後位階清晰：

```
session 維度 = handoff-chain
廠商維度 = cross-ai-handoff
進入儀式 = init-template (§3.3 self-instantiation)
```

關鍵設計決策：**強化抽驗解除權不跨 AI 繼承**（§7）— 前任累積的「無偏差信用」可能在新環境失效，重新累計是防偽底線。

---

## [0.5.1] — 2026-04-27

### Changed — AI Self-Instantiation 機制

把「init slash command 怎麼來」從「框架代生成」改為「**AI 自我具象化**」。對應「角色 ⊥ AI」公理 — 不同 AI 對 slash command 系統有自己最佳實踐，框架不該越界決定。

- `core/init-template.md` 加 §3.3 AI 自我具象化規範：觸發條件 / 6 步驟流程 / 為何這樣設計 / 跨 AI 接班鏈 / 違反處置
- `templates/agent-commons/_role.md.tpl`：各 AI 具象化位置表加「自我具象化日期」欄位 + 加段「自我具象化機制」說明 + 明示「禁止要求使用者手動寫」
- `tools/init-spec.md` Phase 4 改寫：**不自動生成任何 AI 的 slash command**，只建立 `_role.md` 與資料夾結構；新增 Phase 4.5 通知使用者下一步「跟 AI 說『請接此角色』，AI 會自我具象化」
- `tools/doctor-spec.md` §3.4 改為「自我具象化狀態檢查」：偵測哪些 AI 已具象化、是否與 `_role.md` 紀錄一致

### 動機

使用者觀察「Gemini 不認識 /pm-init」時提出洞察：與其讓框架代每個 AI 生成 slash command（不可能完美兼顧各 AI 系統差異），不如讓 AI 自己讀規範、自己具象化。

這對應「創世者 / 造物主」概念：框架是設計藍圖，AI 是自我建造的造物。框架定義「PM 該做什麼」（職責規範），AI 自己用最熟悉自己系統的方式實作出來。

新流程：使用者 → 跟 Gemini 說「你來當 PM」→ Gemini 讀 charter → 自己寫 `.gemini/commands/pm-init.toml` → 簽名 `_role.md` → 通知使用者「我建好了，可以打 /pm-init」。

### Changed — Init Mandate 升格 + 配置目錄合併（架構級重構）

#### A. `core/init-template.md` 升格為 Role Init Mandate（職責規範）

從 v0.4 的「五步驟骨架」升格為**四大職責 + 必達狀態 + 多 AI 具象化規範**：

- §0 概念位階：Init = 使用者分身 / 造物主 / 守門人
- §1 四大職責：Summon（召喚）/ Calibrate（校準）/ Sign-in（簽名）/ Gatekeep（守門）
- §2 必達最終狀態（八項，跨 AI 等效）
- §3 各 AI 具象化規範（Claude Code / Gemini CLI / Cursor / 通用 prompt）
- §4 跨 AI 兼容性要求 + 統一就緒回報格式
- §5 替換性保證（無隱性綁定）
- §6 五步驟骨架（保留 v0.4 內容為實作步驟）
- §7 違反處置（跳過 init = F1）
- §8 與其他 core 條款關係

#### B. 配置目錄合併（架構級）

原 `.agentcharter/` 配置目錄合併進 `<common-memory-root>/_config/`：

- 達成「**單一採用識別目錄**」設計
- `agent-commons/` 內部含完整配置 + 內容（清晰分層）
- 工具尋找優先序：先 `agent-commons/_config/`，沒有則掃專案根找符合 `<dir>/_config/profile.yaml` 的目錄

### Modified

- `core/charter-config.md` schema 升 v0.5.0：配置位置變更 + 工具尋找優先序段
- `core/common-memory-root.md` §3 必含子槽位加 `_config/`；§8 命名規則加 `_config/` 條目
- `templates/agent-commons/_role.md.tpl` 大改：加多 AI init 位置表、切換歷史審計欄位、統一就緒回報格式
- `examples/cryptobot/mapping.md` §0：對齊 v0.5.0 配置位置（CryptoBot 沿用 `management/`，配置在 `management/_config/`）

### 動機

使用者提兩個議題：

1. **`.agentcharter/` 應併進 `agent-commons/`**：兩個 dot-folder 違反「單一採用識別」原則。合併後看到 `agent-commons/` ＝ 整套框架就位。
2. **`.claude/commands/<role>-init.md` 不該只限 Claude**：Init 是「造物主級」職責，相當於使用者分身。框架應先定義抽象職責，讓各 AI 廠商自行具象化到自己的 slash command 系統，達成可替代化。

兩件事都涉及架構級概念（採用識別 / 角色召喚），故 minor version 升 0.5.0。

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
