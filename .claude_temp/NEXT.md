# AgentCharter — Next Work

> **更新時間**：2026-04-28（v0.7.2 release 收尾 — dogfood signal #6 三次同類條款化 + signal #10 條款化 + structural-anti-fabrication §5 補反向引用後）
> **依循**：v1.0 公開化條件（GOVERNANCE §6）

---

## 🔴 高優先（影響 v1.0）

### 1. 核心條款覆蓋率盤點 ✅ **全部完成**

5 候選全部完成（v0.5.2〜v0.5.6）：

- [x] ~~Cross-AI handoff 細則~~ — **v0.5.2 完成**（獨立 core/cross-ai-handoff.md）
- [x] ~~Conflict resolution between roles~~ — **v0.5.3 完成**（獨立 core/role-conflict-resolution.md）
- [x] ~~Multi-role tracking 條款化~~ — **v0.5.4 完成**（獨立 core/multi-role-tracking.md，management-layout §3.1 升格）
- [x] ~~Domain Axiom Slot 撰寫規範~~ — **v0.5.5 完成**（獨立 core/domain-axiom-slot.md，從 template 提煉撰寫紀律到 core 層）
- [x] ~~Versioning / Migration 規範~~ — **v0.5.6 完成**（獨立 core/versioning-migration.md，SemVer 對 charter 的具體含義 + 升級流程）

下一階段焦點轉向 §2 / §3（PM gemini-cli 提交、Reference Impl）。

### 2. `roles/pm/gemini-cli.md` 提交 ✅ **完成**

由 Gemini CLI PM 親自提交（Round 1 實證 + Round 2 三層結構重整 + Claude 校正補回 5 處 regression）。詳見「已完成」段。

### 3. v0.5+ Reference Impl — **版更工具優先**

**狀態**：v0.5.7 後啟動。**修正前一輪「工具中心偏見」**（2026-04-27）。

**核心定位**：工具不是必要組件（framework 本體已完備），但**升版流程是反覆痛點，手動易錯**。所以工具的核心目的是支援 `versioning-migration §3` 的升版流程，不是初次接入。

**Phase 順序**（依痛點優先）：

**v0.5.9 重大轉向**：framework 不附 python / npm 等實作工具（移除 charter-init.py + charter-doctor.py）。所有工具動作由 AI 依對應 spec 自具象化（對齊 v0.5.1 「不代生成」+ A1「角色 ⊥ AI」原則）。

| Phase | 工具 | 用途 | 狀態 |
|---|---|---|---|
| ~~1~~ | ~~charter-doctor.py~~ | ~~升版 dry-run + 健康檢查~~ | ⛔ **v0.5.9 移除**（純 spec-driven）|
| ~~3~~ | ~~charter-init.py~~ | ~~初次接入~~ | ⛔ **v0.5.9 移除** |
| ~~3.5~~ | ~~charter-doctor.py --self-check~~ | ~~self-check 候選~~ | ⛔ **v0.5.9 改為 AI 自具象化**（依 maintainer-discipline §3.1 修訂）|
| ~~2~~ | ~~charter-upgrade.py~~ | ~~執行升版~~ | ⛔ 不做（升版由 AI 依 versioning-migration §3 流程跑）|
| ~~4~~ | ~~charter-scan.py~~ | ~~既有專案智慧掃描~~ | ⛔ 不做（採用方手動 + AI prompt 即可）|

→ Reference Impl 整段廢止。對應實作模式：採用方對 AI 下 prompt「依 ~/.agentcharter/tools/<X>-spec.md 跑 X」，AI 完成動作 + 順便具象化 slash command 給未來重用（依 init-template §3.3 self-instantiation）。

framework 永久維持「**純規範**」位階。

**技術選型**：python + PyYAML + stdlib（避免 npm/brew 多通道發布；單一 cross-platform）

**Drop**：原本列的選項 B（Claude Code slash command）— 違反「框架不代生成」精神，跨 AI 不通用，不採。

### 4. 第二個非 CryptoBot 真實 example ✅ **2026-04-28 完成**

**狀態**：YC_AIAgentCrew 接入完成 — 第二個非 CryptoBot 採用案例。雙 AI 雙角色 self-instantiation 全部跑通（PM Gemini ✅、Engineer Claude ✅、charter-init 兩 vendor ✅），doctor 全綠 + 1 個合理 W201（lazy create）。同步驗證 v0.5.9 純規範框架（無 python 工具仍可跑通）+ dogfood signal #4「具象化 ⊥ 驗證結構性脫鉤」預測完全成立。詳見 STATUS §已對外實證。
**A3 公理實證**：「專案 ⊥ 框架」公理由真實非金融專案實證 — YC_AIAgentCrew 不是 CryptoBot 系列，charter 條款抽象層次經得起跨領域考驗。

---

## 🟡 中優先

### 5. LICENSE 決定

**狀態**：v1.0 公開化前需決定
**候選**：MIT / Apache 2.0 / 其他

### 6. CryptoBot 改為引用框架

**狀態**：待議
**動作**：CryptoBot 的 DISCIPLINE / IRON 改為 *引用* AgentCharter `core/*`，避免兩處重複維護
**風險**：大規模重組，建議 v1.0 後做

### 7. IRON Pattern 抽到框架

**狀態**：評估中
**範圍**：CryptoBot IRON 中的「Double Insurance」「ACL」等 Pattern 是否屬通用層（不限金融）

### 8. ShopStack / Codex walkthrough 寫成實檔

**狀態**：本 session 模擬已完成口頭討論，可選擇性寫入 examples
**動作**：寫 `examples/_walkthrough/shopstack-onboarding.md` + `examples/_walkthrough/codex-onboarding.md`
**理由**：給未來新採用者具體可循的範例

---

## 🟢 低優先（v1.0 後）

### 9. B2 子條款層級配置

**狀態**：v0.5+ 候選
**動作**：profile.yaml 加 `sections.<§>` 開關支援

### 10. AgentCharter 自身 dogfooding

**狀態**：v1.0 後啟動
**階段**：
- 階段 1：管理工作流（DRAFT / HANDOFF / NextWork）
- 階段 2：採用 .agentcharter/profile.yaml 與 mapping.yaml
- 階段 3：多角色協作

當前狀態：**先用 .claude_temp/ 替代**，等 v1.0 後升格。

### 11. 跨 AI CLI 工具

**狀態**：v0.6+ 候選
**動作**：類似 npm 之於 npm packages，做一個 CLI 讓任何 AI 透過標準介面接入

---

## ⚪ 待對話的議題

- ~~**dogfood signal #6 — 「條款層 sync 與文檔層 sync 不對等」**~~ ✅ **v0.7.2 完成**（達 ≥3 次同類門檻、條款化）：v0.6.1 auditor 第一次實戰（漏 numeric/version）+ v0.6.1 後 session（templates 範圍兜底含糊）+ **v0.7.1 後 user 直覺抓到 structural-anti-fabrication §5 反向引用漏**（v0.7.0 + v0.7.1 加段全部漏）= 三次同類觀察。v0.7.2 條款化為 `core/maintainer-discipline §3.4` 文檔層 sync checklist 三子段（條款層連動 + 文檔層連動 + 內部追蹤層）+ 違反處置 + v0.8+ 升級到工具層 doctor 自動偵測的演化路徑
- **新 dogfood signal #9 候選**（v0.7.0 auditor 抽驗時發現） — 「**release 收尾步驟（STATUS/NEXT 更新）放到 commit 之後 = 容易在 release 當下漏掉 signal 紀錄**」。本次 v0.7.0 auditor 抽驗第一次跑時就抓到 W001（STATUS / NEXT 缺 signal #7/#8 紀錄、雖然 P6 task 排程內），對應「signal 紀錄 vs 條款修訂的時間差」結構性問題。**判斷**：累積 ≥3 次同類再評估，候選方向：(a) `maintainer-discipline §2.2` 引用範圍表加「STATUS / NEXT signal sync」項；(b) release commit 前 checklist 加「STATUS §D + NEXT.md ⚪ 是否已對齊本 release 修訂的 signal」；(c) 把 P6 標準化到 release 流程的 P3 之後（即修完條款立刻寫 STATUS/NEXT、再走 auditor）
- ~~**dogfood signal #10 — QUICKSTART Step 2-3 順序與 v0.7.0 Phase 5b 衝突**~~ ✅ **v0.7.2 完成**（cross-reference 方案 — 條款化但保留編號）：QUICKSTART 檔頂「5 步流程」段加紀律警告（**實際執行順序：Step 1 → Step 3 → Step 2 → Step 4 → Step 5**）+ Step 2 加「前置條件 Step 3 必先完成」+ Step 3 加「先於 Step 2」執行順序提醒。**留 v0.8+** 整理為線性編號（消除「編號 vs 執行順序」的不一致）

- **新 dogfood signal #13 候選 — user 對 charter 自身演化行使「他抽」屬性**（v0.7.2 觸發、抽驗時發現）：v0.7.1 release 後、user 連續兩次 IDE 開 `core/structural-anti-fabrication.md` 抓到 maintainer + auditor 漏的 §5 反向引用同步 → 觸發 v0.7.2 條款化 signal #6 + signal #10。**設計學意義**：v0.7.0 加的 Phase 5b 採用方半邊「他抽」屬性 → user 學會 → user 反過來他抽 charter 自己。**判斷**：累積 use case 後評估是否在 `roles/validator/_spec.md` 加 §3.7「對 charter 自身演化行使他抽」段（採用方視角的 charter dogfood 貢獻路徑明示）；當前先觀察、不條款化

- **新 dogfood signal #14 候選 — spec ↔ core 條款雙向引用對稱性**（v0.7.2 auditor 抽驗時發現）：v0.7.2 補了 `structural-anti-fabrication §5` 對 `init-spec Phase 5b` / `domain-axiom-slot §3.3` / `failure-modes F6` 的引用，但對端**沒回引 structural-anti-fabrication**（spec 沒「§ 與其他 core 條款的關係」表結構、core 條款有引用但格式不一致）。**判斷**：accumulating 觀察、屬「**spec 設計層**」議題；候選方向：(a) `tools/*-spec.md` 加 「§ 對應 core 條款的反向引用」格式段；(b) `core/*.md` 內提到 `tools/*-spec.md` 時 spec 端強制有對應反向 entry。**累積 ≥3 次同類後條款化**（當前累積 1 次）
- **dogfood signal #11 候選 — condition mutability 三層分類**（v0.7.1 user 直接提議、frontmatter scaffold 已 ship、紀律本體留 v0.8.0）：user 公司接入痛點對話直接提議「IMMUTABLE-by-AI / APPEND-ONLY / FULL-MUTABLE 三層」+「3-strike 刪除」+「user-initiated consolidation」。v0.7.1 ship 了 frontmatter scaffold（structural 預備）；**v0.8.0 待做**：(a) 新加 `core/condition-mutability.md` 條款（或擴 `domain-axiom-slot §4`）規範三層 mutability + 3-strike 刪除協議 + user-initiated consolidation 紀律 + AI 對 condition 的修訂權限分層；(b) `tools/doctor-spec.md §3.7` 加 mutability frontmatter 校驗。**判斷**：等公司接入 1-2 週、user 累積 1-2 次「想刪 / 想改 / 想統整」痛點 → 條款化
- ~~**dogfood signal #12 候選 — 雙路徑（user 主筆 vs AI 代產）**~~ ✅ **v0.7.1 完成**：`core/domain-axiom-slot §3.3` 加雙路徑明文 + `templates/agent-commons/domain-axioms-via-ai-draft-prompt.md.tpl` 新檔（路徑 B prompt）+ QUICKSTART Step 3 雙路徑說明 + frontmatter `Status: AI-DRAFTED`/`USER-RATIFIED` 二態紀律。**user 公司接入痛點對話直接提議 → 30 分鐘內 ship 條款化** — 對應 user 對話原話「成長中、想法碰撞」
- AgentCharter 自身採用 framework 的邊界（dogfooding 何時、如何啟動）
- 條款命名規範統一（kebab-case vs snake_case 一致性）
- 多語系策略（當前繁中 + 英文小標題並陳）
- ~~AI 自我具象化的「能力評估盲區」（Codex walkthrough 浮現）— 是否該補一個 `core/ai-vendor-onboarding.md` 條款規範新 AI 加入時的能力評估流程~~ ✅ **v0.6.0 完成**
- **多 AI 具象化拓撲分類**（OrderRecon walkthrough 浮現，2026-04-27）— 當前 `init-template §3` 預設「1 AI × N command」拓撲；GPT 走「N Custom GPT × 1 instructions」拓撲，可能影響 `multi-role-tracking` 與 `cross-ai-handoff` 部分定義。**判斷：等第一拓撲 reference impl 跑通後再評估**
- ~~framework 維護者的紀律對齊（dogfood signal #1）~~ ✅ **v0.5.8 條款化**
- ~~framework spec 之間沒同步機制（dogfood signal #2）~~ ✅ **v0.5.8 條款化**
- ~~user 全域 skill 路徑硬編碼（dogfood signal #3）~~ ✅ **v0.6.0 maintainer-discipline §1 部分覆蓋 + v0.7.0 升級到具體 spec**：`core/init-template.md §3.3.2` slash command 引用紀律段 + `tools/init-spec.md Phase 4.x` 對應段（推薦 $AGENTCHARTER_HOME / ~/.agentcharter / agent-commons/ 三層優先序、禁絕對路徑）
- **`/maintainer-selfcheck` skill 落地**（2026-04-27 對話浮現，B+C 路徑）— **v0.6.0 部分完成**：概念層 `roles/auditor/_spec.md` 已誕生（v0.6.0）。**仍待做**：(a) auditor vendor 層 `claude-code.md` / `gemini-cli.md` 走 `ai-vendor-onboarding.md §3` 邀請制 step 2-4；(b) `.claude/commands/maintainer-selfcheck.md` 落地（依 auditor concept layer + sub-agent 跑反向引用 sweep）。spec DRAFT：`.claude_temp/MAINTAINER-SELFCHECK-DRAFT.md`。**判斷**：v0.6.1 + v0.7.0 路徑 C 手動 spawn 已驗證機制可重現、不急升 skill；等 user 邀請特定 vendor 寫 auditor vendor 層後再評估
- ~~**角色擴展走「邀請制」原則 + `auditor` 角色誕生**~~ ✅ **v0.6.0 完成**
- ~~**self-instantiation 結尾自帶 doctor schema 驗證**~~ ✅ **v0.5.10 完成**
- ~~**`init-template §6` / `role-init.md.tpl` 步驟 3 HANDOFF 排序 wording 修訂**~~ ✅ **v0.5.10 完成**
- ~~**「LLM 找路徑繞過角色約束」紀律 gap 條款修訂**~~ ✅ **v0.6.0 完成 + v0.7.0 擴 init 階段**：v0.6.0 四層 gap 封閉（role-separation §3.5 / multi-role-tracking §3.4 / role-conflict-resolution §5.4 / pm/gemini-cli.md §3.5）；v0.7.0 補 multi-role-tracking §3.4.4 init 階段自激活（公司接入第二次完整實證觸發）+ init-template §3.3.2 step 6 PROVISIONAL/ACTIVE 二態
- ~~**`validator` 角色誕生 + PM 漸進 deprecate 抽驗職責**~~ ✅ **v0.6.0 概念層完成 + v0.7.0 擴 init 階段抽驗**：v0.6.0 概念層誕生；v0.7.0 加 §3.6 採用方接入流程 init 結果抽驗（職能擴張）。**仍待做**：vendor 層走 `ai-vendor-onboarding §3` 邀請制（YC 計畫先邀請 Gemini）
- ~~**「採用方接入流程缺 init-validator 角色」結構性盲區（dogfood signal #7 候選）**~~ ✅ **v0.7.0 完成**：`tools/init-spec.md Phase 5b` + `roles/validator/_spec.md §3.6` 雙構成載體；雙半邊對稱（maintainer 半邊 auditor / 採用方半邊 validator on init）
- ~~**「surface-level 完成感 vs structural-level 完整性」結構性脫鉤（dogfood signal #8 候選）**~~ ✅ **v0.7.0 完成**：`core/failure-modes.md F6` sub-pattern + `tools/doctor-spec.md §3.7` 結構頂層 + namespace 校驗 + E605 強制檢查 enable_modes 含 F6（諷刺循環攔截）

---

## 已完成（本 session 累積，從待議移除）

### v0.7.2 release（2026-04-28）— dogfood signal #6 三次同類條款化 + signal #10 條款化 + structural-anti-fabrication 補反向引用

✅ **dogfood-driven hardening 第七循環 — Phase 5b 採用方他抽精神反向作用於 charter 自身演化**：user 連續兩次 IDE 開 `core/structural-anti-fabrication.md` + 問「你有更新文件嗎」 → maintainer 重新檢視 → 發現 v0.7.0 + v0.7.1 加段全部漏 §5 反向引用 → signal #6 達 3 次同類門檻 → 條款化

✅ **新增條款 / 段**：
- `core/maintainer-discipline §3.4` 文檔層 sync checklist 三子段（3.4.1 條款層連動 / 3.4.2 文檔層連動採用方視角 / 3.4.3 內部追蹤層）+ 違反處置表
- `core/structural-anti-fabrication §5` 補三行反向引用（F6 sub-pattern / Phase 5b 物理存在 / 路徑 B 推斷依據紀律）
- `QUICKSTART.md` 流程順序紀律 cross-reference 方案（實際執行 1→3→2→4→5）

✅ **連動更新**：三 preset yaml `0.7.1` → `"0.7.2"` + ADOPTION/TUTORIAL/maintainer-load 升版號 + CHANGELOG v0.7.2 段

✅ **設計學意義（最完整迴路展現）**：condition 設計（Phase 5b）→ user 學會這個設計 → user 以這個設計反過來他抽 charter 自己 → 抓到 maintainer 漏 → 條款化補上 → charter 跟 user 在對話過程互相塑造對方

### v0.7.1 release（2026-04-28）— 領域公理雙路徑 + condition mutability frontmatter scaffold

✅ **dogfood-driven hardening 第六循環 — user 直接 framing 最快 ship 案例**（30 分鐘內 ship）：
- signal #12 候選 → 完整條款化（`domain-axiom-slot §3.3` 雙路徑明文 + 新檔 `domain-axioms-via-ai-draft-prompt.md.tpl` 路徑 B prompt + `_role.md.tpl` frontmatter Status 二態 + QUICKSTART Step 3 雙路徑）
- signal #11 候選 → frontmatter scaffold 預備（紀律本體留 v0.8.0）

✅ **連動更新**：三 preset yaml `charter_version: "0.7.0"` → `"0.7.1"` + ADOPTION/TUTORIAL/maintainer-load 升版號 + CHANGELOG v0.7.1 段

✅ **設計層意義**：顯化「**user 對 AI 在採用方專案內的協作維度**」（與 `ai-vendor-onboarding` 規範的 framework 對 vendor 維度正交）— charter 設計軸新顯化第一個

### v0.7.0 release（2026-04-28）— 公司專案接入失敗大批次條款修訂

✅ **大批次 5 個 dogfood signal 一次處理**（dogfood-driven hardening 第五循環）：
- signal #3 結構性實證（slash command 路徑硬編碼）→ `core/init-template.md §3.3.2` slash command 引用紀律段 + `tools/init-spec.md Phase 4.x`
- signal #4 第三次同類（mapping schema namespace 誤翻譯）→ `core/charter-config.md §3` namespace 註明（雙重防禦文檔半邊）+ `tools/doctor-spec.md §3.7` E601〜E605 校驗（雙重防禦校驗半邊）+ 三 preset enable_modes 加 F6
- signal #5 第二次完整實證（init 階段 PM 自激活）→ `core/multi-role-tracking.md §3.4.4 + §3.4.5` + `core/init-template.md §3.3.2 step 6` Status PROVISIONAL/ACTIVE 二態 + `templates/agent-commons/_role.md.tpl` Status 二態說明
- signal #7 候選新增（採用方接入流程缺 init-validator）→ `tools/init-spec.md Phase 5b` + `roles/validator/_spec.md §3.6`（雙半邊對稱：maintainer 半邊 auditor / 採用方半邊 validator on init）
- signal #8 候選新增（surface-level 完成感 vs structural-level 完整性）→ `core/failure-modes.md F6` sub-pattern + 抽驗判別法 4 項 + 諷刺循環攔截

✅ **架構級概念第 12 個誕生**：「採用方接入流程『自抽自驗』結構性盲區封閉 / Phase 5b 對稱機制」— 對應 v0.6.0 加 auditor 封閉 maintainer 半邊的對稱版

✅ **連動更新**：
- 三 preset yaml charter_version 0.6.1 → 0.7.0 + enable_modes 全部含 F6
- ADOPTION.md / TUTORIAL.md / QUICKSTART.md / CHANGELOG.md / .claude/commands/maintainer-load.md
- v0.6.1 後 4 處未 commit 異動併入（templates/role-invocation-prompt.md.tpl 新檔 + QUICKSTART Step 4 重構）

✅ **auditor 抽驗通過**：fresh-context sub-agent 跑 cross-reference + spec sync audit；ERROR 0 / WARN 3 / INFO 2；W001+W003 在 P6 收尾、W002 已修補；發現新 signal #9 候選

✅ **未 commit / 未 push**：等 user 明示授權後走 P5 標準 release 流程



- ✅ Common Memory Root 條款（v0.4.1）
- ✅ agent-commons templates 完整 6 份（v0.4.2）
- ✅ Init Mandate 升格（v0.5.0）
- ✅ 配置目錄合併（v0.5.0）
- ✅ AI Self-Instantiation 機制（v0.5.1）
- ✅ Cross-AI Handoff 條款（v0.5.2）— 獨立 core 條款，補完 v0.5.1 之後「退出—轉移—接班」全鏈；連動 handoff-chain §5 簡化、charter-config 啟用清單、init-template §8 引用、_role.md.tpl 切換歷史擴 5 欄、三 profile yaml、README、CHANGELOG
- ✅ Role Conflict Resolution 條款（v0.5.3）— 獨立 core 條款，補完「決策分歧」軸（雙向、無對錯）；與 escalation-protocol 嚴格區隔；三級階梯 L0/L1/L2；連動 escalation §6 / role-separation §5 反向引用、charter-config 啟用清單與相依表、三 profile yaml、README、CHANGELOG
- ✅ Multi-Role Tracking 條款（v0.5.4）— 獨立 core 條款，補完 1 AI 多角色防呆（離岸/上岸宣告 + 身份戳 + 自抽自驗禁令）；template `management-layout §3.1` 升格為強制規範；連動 role-separation §3.4 加段 + §5 反向引用、charter-config 啟用清單與相依表、三 profile yaml、README、CHANGELOG
- ✅ Domain Axiom Slot 條款（v0.5.5）— 獨立 core 條款，把 template 的撰寫紀律提煉至 core 層；定義「領域公理 > core 條款」衝突優先序為架構級條文；/charter-doctor 違反處置嚴重度分級；連動 evidence-first §5 / role-conflict-resolution §2 §7 反向引用、template `domain-axioms.md.tpl` 加指向、charter-config 啟用清單與相依表、三 profile yaml（minimal 也啟用）、README、CHANGELOG
- ✅ Versioning & Migration 條款（v0.5.6）— 獨立 core 條款，定義 SemVer 對 charter 的具體含義（PATCH/MINOR/MAJOR/架構級）、BREAKING 判定條件、已採用專案 7 步遷移流程、回退路徑、雙軌版號獨立演化、多 AI 版本一致性禁令；連動 handoff-chain §7 / init-template §8 反向引用、charter-config 啟用清單與相依表、三 profile yaml（minimal 也啟用）、README、CHANGELOG。**5 候選盤點完成**
- ✅ Working Stack Discipline 條款（v0.5.7）— 獨立 core 條款，從 CryptoBot `~/.claude/commands/checkpoints.md` + `PM_Operational_Manual §1.3` 抽象化；補完「session 內物理中斷再續」結構性盲區（三種接班場景正交完整）；DRAFT 暫存堆疊 + save 六步驟（含 git commit 強制綁定）+ session 重啟接班協議；連動 charter-config 啟用清單 + 相依表 + mapping.yaml schema 擴 `shared.draft_context` / `shared.archive`、handoff-chain §7 / cross-ai-handoff §9 / init-template §1.4 §8 反向引用、三 profile yaml（minimal 也啟用 — 對單 AI 場景仍有 context 重啟接班價值）、README、ADOPTION（D 組 3→4 + 場景對照表加 2 條）、CHANGELOG
- ✅ Maintainer Discipline 條款（v0.5.8）— 獨立 core 條款，**位階特殊**（對採用方無關、framework 維護者強制）；對應 v0.5.7 期間累積的兩次 dogfood signal（#1 framework 設計者違反 working-stack-discipline §1 + #2 framework spec 不同步），使用者授權跳過 ≥3 次累積直接條款化；三層執行機制（charter-doctor self-check 候選 / CONTRIBUTING PR checklist / commit message sync 軌跡）；連動 charter-config enabled 加 + 相依表加（位階特殊註明）、三 profile yaml 全部預設 `false`（採用方無關）、README、ADOPTION（19 → 20 條）、CHANGELOG
- ✅ `/maintainer-load` slash command（2026-04-27）— charter repo 級維護者接班便利化工具（`.claude/commands/maintainer-load.md`）。一句指令完成「讀 .claude_temp/STATUS+NEXT+ONBOARDING → 八項就緒回報」全流程。對應 maintainer-discipline §1 跨 session 接班需求；不適用採用方（採用方走 init-template §3.3 self-instantiation）。連動 .gitignore 修正：`.claude/*` ignored、但 `.claude/commands/` 入 git；STATUS §跨 session 接班指引加「一句話接班」段
- ✅ v0.5.9 重大轉向（2026-04-27）— **回歸純規範框架**：移除 tools/charter-init.py + tools/charter-doctor.py（使用者反饋「不乾淨我認為有汙染」）。framework 永久維持「純規範」位階；所有工具動作由 AI 依 spec 自具象化（對齊 v0.5.1「不代生成」+ A1「角色 ⊥ AI」原則）。同時新增 versioning-migration §2.3 「**agent-commons 結構穩定性承諾**」：採用方第一次 init 後得到的 agent-commons/ 結構是穩定承諾，v1.0 後永久不破壞既有採用方。連動 init-spec/doctor-spec/maintainer-discipline §3.1 / versioning-migration §3.1-3.2 / QUICKSTART/TUTORIAL/README/ADOPTION/CHANGELOG 全部對齊純 spec-driven 模式
- ✅ tools/charter-doctor.py MVP（v0.5.7 + bug fix）— 升版 dry-run + 健康檢查 Phase 1 工具落地；Python + PyYAML，~390 行；對應 versioning-migration §3.1 第 3 步；含 §3.3 跨 MAJOR 邏輯 fix（必須先升 X.0.0 走 migration）+ BREAKING 偵測 trade-off 文檔化
- ✅ roles/pm/gemini-cli.md vendor spec（2026-04-27）— 由 Gemini CLI PM 親自提交。Round 1 實證內容（11 條工具能力 / 5 條 PM 職責 / 3 條盲區 / S70 根因分析 / 模式協議 / 跨 AI 交接）+ Round 2 重整為三層結構（概念層 / Gemini 實作 / 跨 AI 對應，對應 A1「角色 ⊥ AI」公理 — vendor spec 作為跨 AI PM 範本）+ Claude 校正補回 5 處 regression（§1 兩處橋接校正、§2 補回 3.5 維護管理文件、§4 補回 (d) 對 charter 條款反饋、§6 補回 cross-ai-handoff §5 四區塊能力快照）；連動更新 `roles/pm/_spec.md §7` 對應 AI 表（Gemini 從 placeholder → ✅ v1.0）
- ✅ **v0.5.10 release（2026-04-28）— 大工程批次第一階段（暖身 + spec-sync 修補）**：
  - **MINOR**：self-instantiation 結尾自帶 doctor schema 驗證強制點 — `core/init-template.md §3.3.2` 六步驟 → 七步驟（新增 step 5 schema 驗證、原 step 5/6 renumber）+ `core/failure-modes.md` 加 F6「未驗證即宣告就緒（轉嫁驗證負擔）」+ `tools/doctor-spec.md §2.1` 拆分呼叫模式 A/B + QUICKSTART Step 4-5 對齊。觸發：dogfood signal #4 於 YC_AIAgentCrew 接入實證
  - **PATCH**：HANDOFF 排序 wording 修訂 — `templates/role-init.md.tpl` + `templates/agent-commons/handoff.md.tpl` shell command 加 `grep -E 'HANDOFF_[0-9]+\.md$'` 過濾。觸發：YC_AIAgentCrew Engineer self-instantiation step 3 觀察
  - **PATCH**：spec-sync 修補（v0.5.8/v0.5.9 release 漏）— 三 preset yaml `charter_version` `0.5.8` → `0.5.10`（直接跳 v0.5.9）+ QUICKSTART/ADOPTION/TUTORIAL「19 個 .md」→「20 個 .md」+ QUICKSTART 前置移除「Python 3.8+ / PyYAML」（v0.5.9 純規範化遺漏）。觸發：BASELINE §3 抓到
  - **併入**：v0.5.9 後 [Unreleased] QUICKSTART 多 AI 提醒白話化 patch（705488a）
  - **dogfood-driven hardening 首次循環實證**：dogfood signal #4 累積 ≥1 次同類觀察 → 條款修訂門檻達標 → 自身改進 self-instantiation 七步驟。對應使用者提的「dogfood 內測優化也是持續健壯一環」精神首次落地（待評估是否寫進 v0.6.0 架構級概念第 12 條）
  - **Git tag**：`v0.5.10` @ `6dd3eda`；前置 baseline 已打 `v0.5.9` @ `a24c15c` + `pre-v0.6.0-batch` @ `2225659`

- ✅ **v0.6.0 release（2026-04-28）— 大工程批次第二階段（架構擴張 + LLM 行為紀律 gap）**：
  - **Added 條款**：`core/ai-vendor-onboarding.md` 邀請制條款 — 將 v0.5 隱性的 Gemini PM 接入歷程（Round 1 實證 + Round 2 三層重整 + Claude 校正）顯性化為「邀請制四步驟」。核心：禁 charter 預先寫死 vendor 層、由真實接觸累積差異。對應架構級概念第 10 個（角色擴展邀請制 / vendor 不代寫原則）
  - **Added 角色（maintainer-only）**：`roles/auditor/_spec.md` 概念層誕生 — 對應 `maintainer-discipline §3.1` 在 v0.5.9 後留下的執行載體 gap（spec-driven self-check 從「規範」變為「規範 + 執行角色」）。透過 fresh-context sub-agent / 不同 session / 邀請其他 vendor 達成「他抽」屬性
  - **Added 角色（採用方）**：`roles/validator/_spec.md` 概念層誕生 — YC_AIAgentCrew 觸發。實現「PM 派 → Engineer 執行 → Validator 抽驗」三角合規。漸進 deprecation：v0.x 並存 / v1.0+ 接管 PM 抽驗。連動 `roles/pm/_spec.md §3.3 / §3.4` 加 ⚠️ DEPRECATING 標記
  - **Added 紀律（dogfood signal #5 條款化）**：四層 gap 全部封閉 — `role-separation §3.5` 繞路禁令（PM 不得透過 sub-agent / 代理 / 提示 user / partial 自我合理化等繞路手段間接改 src/）+ `multi-role-tracking §3.4` 身份穩定承諾（上岸需 user explicit 授權、AI 自我發起切換 = F1）+ `role-conflict-resolution §5.4` 角色切換決策權屬 user + `roles/pm/gemini-cli.md §3.5` sub-agent 跨界禁令補段（對齊 Claude Engineer §6 既有原則）。對應架構級概念第 11 個（角色身份穩定性 / 繞路禁令）
  - **Changed**：`core/maintainer-discipline.md §3.1` 改為「由 auditor 角色執行」（v0.5.9 後留下的執行載體明確化）；`core/charter-config.md §3 enabled` + §5 相依表加 ai-vendor-onboarding entry
  - **連動範圍**（依 maintainer-discipline §2.2）：condition 數 20 → 21 / 角色 2 → 4 / 架構級概念 9 → 11；三 preset enabled 加 ai-vendor-onboarding（minimal false / standard true / strict true）+ charter_version 0.5.10 → 0.6.0；ADOPTION §3 標題 18 → 20 條（採用方視角）+ D 組 4 → 5 條 + 新增 F 組 maintainer-only；QUICKSTART/ADOPTION/TUTORIAL 條款數 20 → 21；STATUS 全段更新 + 演化軸表加 v0.6.0 entry + §B 架構級概念擴 9 → 11；CHANGELOG v0.6.0 段
  - **dogfood-driven hardening 第二、三循環實證**：第二循環 = signal #5 條款化封閉 LLM 繞路 gap；第三循環 = Gemini PM 接入歷程的隱性 pattern 顯性化為邀請制條款
  - **Git tag**：`v0.6.0` @ `9493814`

- ✅ **`templates/role-invocation-prompt.md.tpl` 新增 + QUICKSTART Step 4 重構（2026-04-28 session 內小演進）**：對應使用者 framing「charter 演示通用骨架、不蒐集 prompt 庫、採用方依骨架自填」（對齊 v0.6.0 邀請制 + A3「專案 ⊥ 框架」公理）。新檔含 6 個 placeholder + 6 個 ⭐ 結構區塊（對齊 init-template §3.3.2 七步驟）+ 採用方擴展貢獻路徑指向 ai-vendor-onboarding §3。QUICKSTART Step 4 從 inline 兩段 prompt 重構為「§4.1 通用骨架（指向新 .tpl）+ §4.2 已實證填充範例（保留 Engineer×Claude / PM×Gemini 兩段，加『其他組合自填』收斂尾）」。**auditor 第二次實戰**：手動 spawn fresh-context sub-agent 跑 cross-reference + spec-sync sweep（路徑 C，未升 `/maintainer-selfcheck` skill）— 抓 1 ERROR（doctor-spec 模式 A → 模式 B 引用錯）+ 3 WARN（ai-vendor-onboarding §3 步驟對應錯 / cursor 範例值未實裝 / spec-sync 軌跡漏）。3 個直接修（E1 / W1 / W3）、W2 留軌跡（記入 ⚪ 段 #6 entry 第二次同類觀察）。**未涉及**：CHANGELOG / charter_version 升 / git tag — 待公司接入跑過骨架實證後再評估是否升 PATCH

- ✅ **v0.6.1 release（2026-04-28）— auditor 第一次實戰後的 stable 版本（公司 production 接入用）**：
  - **動機**：v0.6.0 後使用者準備接入公司 production 專案、要求「最穩定」。為確保 v0.6.0 對 production ready，maintainer 用 v0.6.0 新誕生的 auditor 角色（`roles/auditor/_spec.md`）spawn fresh-context sub-agent 跑首次實戰 cross-reference + spec sync audit。
  - **Audit 結果**：5 項通過（綠燈：條款引用一致 / preset 對齊 / 三段新紀律內部一致 / ai-vendor-onboarding vs init-template 互補 / `_spec.md §7` 對應表）+ 3 項 ERROR + 4 項 WARN
  - **修 3 項 ERROR**：(1) `ADOPTION.md` 多處 v0.5.x 殘留 + 條款數內部矛盾（line 5 / 47 / 145 / 314 + §5 preset 表母數 16 → 19 + §13 變更歷史）/ (2) `TUTORIAL.md` Python runtime 殘留（v0.5.9 純規範化漏）+ 對應版本 v0.5.8 → v0.6.1 + preset 計數 17 → 19 + 變更歷史 / (3) `README.md` 角色目錄拆「採用方角色」vs「Maintainer-only 角色」分區（解決採用方誤以為要啟用 auditor 的風險）
  - **修 2 項 WARN**：(1) `.claude/commands/maintainer-load.md:68` 當前狀態 v0.5.8 → v0.6.1 + 加 auditor 執行載體說明 / (2) `core/charter-config.md §4` schema 範例 charter_version 0.3.0 → 0.6.1 加註「範例值」
  - **同步**：三 preset yaml `charter_version` 0.6.0 → 0.6.1
  - **不修 2 項 WARN**：CHANGELOG / ADOPTION 「採用方視角」語意游移（已部分對齊，殘餘留 v0.7+）+ `audit-rights.md` 沒同步引用 validator deprecation path（屬設計層，留 v1.0 PM `_spec.md` 真正移除 §3.3 / §3.4 時一併處理）
  - **新 dogfood signal #6 候選**：「條款層 sync 與文檔層 sync 不對等」（已記入 ⚪ 待對話），auditor 抽驗本身揭露的結構性盲區
  - **dogfood-driven hardening 第四循環**：第一循環 v0.5.10 (signal #4) / 第二循環 v0.6.0 (signal #5) / 第三循環 v0.6.0 (邀請制 pattern) / **第四循環 v0.6.1 (auditor 角色第一次實戰)** — auditor 抓到 maintainer 自己漏的東西，封閉「自抽自驗」結構性盲區
  - **採用方影響**：完全向後相容、純文檔修補；既有採用方升版只需改 profile.yaml `charter_version: "0.6.0"` → `"0.6.1"`
  - **Git tag**：`v0.6.1`（release commit 待打）

---

## 處置原則

| 觸發 | 動作 |
|---|---|
| 使用者明示開新議題 | 切該議題，動完更新本檔 |
| 工程師發現新候選條款 | 加入 §1 候選清單 |
| commit 後 | 同步更新 STATUS.md `Version 軌跡` 段 |
| 跨 session 接班 | Claude 第一輪先讀本檔 + STATUS.md，對齊脈絡後再回應 |
| 完成議題 | 從本檔移除，加入「已完成」段，避免下次又議 |
