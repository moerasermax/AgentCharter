# AgentCharter — Next Work

> **更新時間**：2026-04-28（v0.7.5 release 收尾 — 跨多版本升級指引 + YC walkthrough 後）
> **依循**：v1.0 公開化條件（GOVERNANCE §6）+ **v0.7.3 北極星紀律**（README §設計哲學）+ **v0.7.4 雙軌節奏**（頻繁小擴增 PATCH + 大方向新加條款用 MINOR）+ **v0.7.5「0 ERROR + 0 WARN 才算還清技術債」紀律**（user 強調的深度 sweep 標準）

---

## 🚀 SSS 級 — 架構級議程（v1.0 前必處理）

> 本段為**跨多 release / 架構級議題**、優先序**高於** 🔴 高優先（單 release 議題）。每次 release 修訂須對照本段方向不偏離。SSS 級不走「累積 ≥ 3 次同類觀察」條款化門檻 — 由 maintainer 視 use case 演化決定 ship 節奏；可能跨 v0.8 → v1.0 多 release 漸進落地。

### S1. AI 自治協作 + user 授權閘模式（user 角色 redefinition）

**user 提案原話（2026-04-29）**：「**讓 AI 們互相自己工作、我從監督決策的角色變成讓他們自動升級的概念、但是要我授權後才可以**」

**三軸拆解**：

| 軸 | 內容 | 現有條款 gap |
|---|---|---|
| **A. AI 互相自己工作** | AI-to-AI direct collaboration、不每步 user-in-the-loop | `cross-ai-handoff` 是換手非並行；`role-separation` 沒規範 autonomous 模式下的 role-to-role 直接交互 |
| **B. user 角色：監督決策 → 授權閘** | user 從持續監督變 consent-gate；AI 提案、user 通過 / 否決 | **完全新概念** — 可能新加 `core/user-authorization-gate.md` + 改 `audit-rights` 在 autonomous mode 下的執行模式 |
| **C. AI 自動升級** | AI 自驅 charter migration / 自身能力進化 / 自抓 signal 自提條款修訂；user 授權閘通過才生效 | 改 `versioning-migration` (auto-migration with gate)、`maintainer-discipline` (誰發起條款修訂的擴張)、可能新概念「AI-as-maintainer-candidate」|

**戰略意義**：
- v0.7.3 北極星「**charter 引導採用方、不讓 user 記**」從**文件層引導**擴展到**運作層引導**
- 採用方放大化路徑：user 也可從「持續監督多 AI」→「授權閘」、降低採用門檻、放大 framework 影響力
- 對齊「**培養魚塭、不討魚**」精神 — 建立 AI 自治紀律本身就是長期生態養成

**起手方向**（待下次 session 深化）：
1. **概念 framing 文件先寫**（不寫條款、不寫 spec）— 三軸再拆細 / 「AI 自治模式」邊界 / 與既有條款相容性盤點 / 與 v0.8.0 議程 `adoption-lifecycle` + `condition-mutability` 兩條既有 v0.8.0 議題的整合關係
2. **謹守向下兼容**：autonomous mode 必為 opt-in、既有 supervisor mode 永久 default
3. **dogfood signal 累積**：採用方（YC / 公司專案 / CryptoBot）1-2 個月後問「你想讓 AI 自治到什麼程度」累積真實 use case 觸發條款化
4. **不限單一 release ship**：可能跨 v0.8 → v1.0 多 release 漸進落地

**潛在影響範圍**（初步盤點、深化時擴）：
- **條款層**：可能新加 1-3 條（user-authorization-gate / autonomous-collaboration / ai-self-driven-evolution）
- **架構級概念**：新加第 13 / 14 / 15 個（視議題拆解深度）
- **spec 層**：init-spec / doctor-spec 全部可能有 autonomous-mode 對應段
- **role 層**：可能新 role（autonomous-coordinator？supervisor-on-gate？）
- **preset 層**：autonomous mode 開關 / 可能新 preset

**對既有 SSS 級候選的對齊**：
- S2「v0.8.0/v0.9.0 lifecycle 設計素材」→ 見下（user LIVE 設計直覺保留、待 v0.9.0 fresh head 設計 lifecycle.md / mutability.md 時拿來用）
- S3「charter as diagnose + remediate protocol（引導式紀律、非封鎖式 freelance）」→ 見下（v0.8.0 ship 後 user LIVE 抓到 Gemini 三輪編造 + 第四輪認錯閉環、實證 SSS S3 設計提議的需求性 + 引導式 framing 的優越性）

#### LIVE prototype 觀察（2026-04-30 多 sub-agent 評估）

> **位階**：SSS S1 LIVE prototype 實證紀錄 — 完整紀錄在 `examples/external-evaluations/clispike-multi-perspective-eval-2026-04-30.md`。**user LIVE 明示「僅限本 session」、不條款化此 multi-agent prototype 模式**；本子段純為 SSS S1 設計素材保留、非條款化。
> **對應 dogfood-driven hardening 第十四循環（新類型）**：maintainer 派多視角 sub-agent 反向校準自身判斷 — 對齊 v0.6.0 auditor「自抽自驗封閉」精神延伸到 maintainer 對自身判斷的校準軸。

**觸發場景**：
- CliSpike Engineer Claude 出 Round 3+4 修正提案（binary 化 / hook 寫進概念層 / npm install -g 等）
- maintainer 第一輪綜合給「洞見採、載體駁」初步判斷
- user LIVE 提議「特地找 3 個一樣的你、扮 4 個角色、不同角度評估、你綜合」、強調「**我需要的是對不是快、慢工出細活**」
- 4 sub-agent（框架結構師 / 核心理念守護者 / 軟體工程師 / 採用方）並行獨立、不互看彼此產出、不看 maintainer 第一輪判斷（避免污染）
- maintainer 綜合 → 補出 4 個第一輪沒到的深度（雙軸矩陣 / 方向性誤讀 / token 估算挑錯 / Phase 5b 解循環依賴）

**對 SSS S1 設計的啟示**：

| SSS S1 三軸 | prototype 對應 | 設計啟示 |
|---|---|---|
| **A. AI 互相自己工作** | 4 sub-agent 各擔一角、獨立作業、不互看 | 設計時注意「**獨立性 vs 一致性**」張力 — 完全獨立可能輸出衝突、需要綜合者協調機制 |
| **B. user 角色：監督決策 → 授權閘** | user 派 sub-agent 後不干預內容、只在 maintainer 綜合後決定要不要 ship | **user 授權閘形態 LIVE 實證**：user 不需看每個 sub-agent 全文、只看綜合判斷 → 授權 ship 三件事 |
| **C. AI 自動升級** | 不對應（本次只是評估、未涉及條款修訂）| 待後續 prototype 累積 |

**設計挑戰浮現**：
- **「不條款化此模式」紀律的微妙張力**：本次 LIVE 證明 multi-agent 評估可行、但 SSS S1 條款化機制設計仍需 fresh-head；若未來 SSS S1 條款化時包含此模式、本次 prototype 是參考素材、不是強制範本
- **多視角綜合 → 升維洞見**：4 sub-agent 各自獨立到深層洞見（雙軸矩陣 / 方向性誤讀 / 採用方層 vs 維護者層分離 / essential preset），單一 AI 第一輪沒到 — 這暗示 SSS S1 條款化時「**多 actor 評估**」可能比「**單 AI 深思**」更高效
- **maintainer 自我抽驗的新軸**：v0.6.0 auditor 是 charter 自身被抽驗、Phase 5b validator 是採用方接入被抽驗、本次是 **maintainer 對自身判斷的多視角校準** — 三條軸正交、是否值得在 SSS S1 條款化階段顯化為架構級概念第 13 個？待累積觀察

**衍生新議程候選**：
- v0.8.x PATCH 雙軸矩陣 framing（結構師金礦、見下方 ⚪ 待對話段「新議程候選 — 雙軸矩陣 framing」）

### S2. v0.8.0/v0.9.0 lifecycle 設計素材（LIVE capture 2026-04-29）

> **位階**：本段為 user LIVE 設計 fresh-head 素材保留（即使疲勞模式直覺仍清晰）— 對應 v0.9.0 議程 `core/adoption-lifecycle.md` + `core/condition-mutability.md` 兩條大條款。**不在本段直接條款化**、保留待 v0.9.0 fresh head 設計時直接拿來用。

#### S2.1 `/charter-uninstall` 工具設計（user 提案 + maintainer enrichment）

**核心精神（user framing）**：「**盡到最後的溫柔**」— 對齊「培養魚塭、不討魚」精神、棄用是有尊嚴的離別不是 lock-in。

**流程設計**：

```
[Phase 1] 三次確認
  Q1: 確定要棄用 charter？
  Q2: 已備份 agent-commons/ 重要資產？
  Q3: 確認執行不可逆操作？
[Phase 2] 保留最後的溫柔 — export adoption archive
  寫入 <project>/charter-archive/CHARTER_ADOPTION_REPORT_<date>.md：
  - 接入摘要（charter_version / preset / 採用日期 / 棄用日期 / 採用時長）
  - capsules/ 統計（總 N、closed M、failed K）
  - HANDOFF 鏈時間線
  - institutional-memory/ 全部 entries
  - protocols/<axiom>.md snapshot
  - state/violations + failure_modes.log 統計（F1〜F6 各觸發次數）
  - dogfood signal 觸發紀錄
  - 結語「感謝採用 AgentCharter v<X>、你的紀律遺產保留於本檔」
[Phase 3] level 選擇（預設 Soft）
  Soft：移除 vendor slash command、agent-commons/_role.md 加 status: ARCHIVED + uninstalled_at
  Full：Soft + 砍 _config（保留 protocols/）+ 加 1 次確認
  Nuclear：Full + 砍整個 agent-commons/（archive 先寫完）+ 加 2 次確認
[Phase 4] charter clone 處理
  檢查 ~/.agentcharter 有無其他 active 專案在用
  詢問 user 是否刪 ~/.agentcharter
[Phase 5] 結束 + 輸出 archive 報告位置
```

**紀律重點**：
- LLM 不得自代回答三次確認（對應 dogfood signal #5 LLM 繞路同源）
- archive 報告先寫完才動刪除（structural-anti-fabrication 精神）
- agent-commons/ 預設不刪（A3 公理 — user 對自己工作軌跡 ownership 永久）
- `~/.agentcharter` 刪除前必查 multi-project 影響

**對應條款定位**：新檔 `tools/uninstall-spec.md` + `core/adoption-lifecycle.md` 「棄用」階段引用

#### S2.2 vendor 升級 path 三路徑設計（user 提案）

**user 核心原則**：「**有始終有備案、不死在那邊**」

**機制**：vendor-specific init slash command（`/pm-init` / `/engineer-init`）內含 vendor 版本一致性 check —— 比對 `current vendor version` vs `last_known_vendor_version`（後者記在 `agent-commons/roles/<role>/_role.md` frontmatter）：

- **一致** → 直跳 init 流程
- **不一致** → 三路徑供 user 選：

| 路徑 | 內容 | 對應紀律 |
|---|---|---|
| **A. 維持現狀** | 採用方繼續用既有 toml/md | 純等待、向下兼容精神 |
| **B. 開 issue** | 採用方開 issue 給 charter maintainer | charter 走 `ai-vendor-onboarding §3` 邀請制 v2 重新校正 vendor spec |
| **C. AI 自驅修復** | vendor AI 重新具象化 init slash command 對齊新 vendor schema | **SSS S1「AI 自治協作 + user 授權閘」子集**、user explicit 授權閘後執行 |

**對應落地檔**：
- `core/init-template §3.3.2` 加 step 8 vendor 版本一致性 check（或擴 step 5 schema validation）
- `roles/<role>/<vendor>.md` frontmatter 加 `vendor_supports: ">=X.Y.Z,<X+1.0.0"`
- `agent-commons/roles/<role>/_role.md` frontmatter 加 `last_known_vendor_version`（init 時記）

#### S2.3 新 vendor 接入「互學深化」設計（user 提案）

**user 核心原則**：「**1+1>2 / 青出於藍勝於藍 = 框架價值**」

**機制擴張**：
- `ai-vendor-onboarding §3 step 2`（vendor 寫實作層）**強制紀律**：必須先讀既有所有同角色 vendor spec、做 cross-vendor pattern extraction
- 新 vendor spec 模板加 `§N. 與既有 vendor 對照學習` — 顯化吸收什麼 / 創新什麼
- `§3 step 4`（既有 vendor 校正 regression）擴為「**vendor 互學深化**」— 新 vendor 接入後、既有 vendor 回頭吸收新 vendor 的創新（雙向 pollination）

#### S2.4 README §設計哲學第 4 條候選（v0.7.3 北極星擴）

**user 今天 reframing**：

> **4. 跨 vendor 知識聚合 + 互為養分 + 收斂 best-of-breed**
>
> charter 不只是「讓多 AI 協作」、而是「**讓多 AI 學彼此、超越彼此**」。每次新 vendor 接入 = 新 cross-pollination 機會；charter spec 收斂 best-of-breed 紀律 = 跨廠商演化機制本身就是 framework 價值。

這呼應 A1「角色 ⊥ AI」公理的 reverse — 不只「角色不綁 AI」、是「**同一角色在不同 AI 身上演化、互為養分**」。

**Ship 時機**：v0.9.0 lifecycle.md ship 時、一併進 README §設計哲學段

### S3. charter as diagnose + remediate protocol（引導式紀律、v0.8.x PATCH 漸進落地候選）

**user 提案原話（2026-04-29 LIVE）**：「**doctor 診斷然後給出符合現在版本的範疇... 透過我們的框架定義好目前最合規的方式、並且找出不合規的點、並且給予針對性建議**」+「**不要封鎖它的限制而是引導式的帶他做**」+「**把必不可缺的都列為檢查項目、如果有缺或不合規、再透過我們事先定義好的規定、讓 AI 去發想**」

**核心設計**：charter 從「**規範框架**」進化到「**diagnose + remediate 標準作業協議**」、但採「**引導式紀律**」非「**封鎖式 freelance 抑制**」。

**現況（v0.8.0）vs 提議（SSS S3）對比**：

| 維度 | v0.8.0 現況 | SSS S3 提議（引導式） |
|---|---|---|
| charter spec 角色 | detect 規範 + 抽象「處置」描述 | detect + **修補方向 + 約束 + 反例**（引導式紀律） |
| AI 角色 | 看 ERROR 自行想 prompt（易 freelance）| 在 charter 框架內**發想具體執行方式**、寫 prompt 給 user 確認 |
| user 角色 | trust AI 修補建議 | trust charter ground truth、AI 在約束內 context-aware 優化 |
| LLM 行為紀律 | 容易 freelance / 編造 anti-pattern | 既有 ground truth + 既能 vendor-specific 優化（青出於藍） |

**對齊既有條款脈絡**（不是新概念、是既有「不代寫」精神往 fix layer 擴張）：

| 既有條款 / signal | 對應 |
|---|---|
| v0.6.0 `core/ai-vendor-onboarding.md` 邀請制四步驟 | charter 對 vendor「不代寫、給概念層引導」精神同源、本 SSS S3 = 對「fix layer」的延伸 |
| v0.7.3 北極星「charter 引導採用方、不讓 user 記」 | 深化：+「**引導 AI 在紀律內發想、不讓 user trust AI 判斷**」 |
| v0.7.4 雙軌節奏「PATCH 頻繁小擴增」 | 落地：每個 error code 加四欄（v0.8.x PATCH 漸進） |
| dogfood signal #5「LLM 繞路」治本路徑 | 給 AI「該做 / 不該做 / 反例」明確 → AI 不需要繞路 |
| dogfood signal #20「LLM vocal 推 anti-pattern + 編造論述」 | 直接治本：spec 自帶 anti-pattern 反例 → AI 看反例就知道不能那樣做 |
| dogfood signal #21「採用方動 schema 必須給 AI prompt」 | 延伸：fix 動作也要有 prompt、且 prompt 由 AI 在 charter 框架內發想（非 user 自寫、非 charter 寫死）|
| dogfood signal #22「v0.x 結構修正 >> 規範補丁」 | 落地：「處置」描述（規範補丁）→ 五欄結構（結構修正） |
| 框架價值第 4 條候選（1+1>2 / 青出於藍）| AI 在引導下發想、可能比 charter 預設更好（vendor-specific / project-specific 優化）|

**spec 結構設計**（每個 error code 五欄）：

```markdown
### E<code>：<簡述>

**校驗集**：[既有 schema 校驗 — 不變]
**失敗描述**：[既有 — 不變]

**合規規定**（v0.8.x PATCH 加、charter ground truth 寫死）：
- 必須狀態：<目標終態>
- 對齊條款：<引用具體 § 條款>

**修補方向 + 約束**（v0.8.x PATCH 加、引導 AI 在框架內發想）：
- ✅ 目標：<最終狀態描述>
- ✅ 必動：<必須改的欄位 / 動作>
- 🚫 不可動：<框架禁碰的東西>
- 🚫 不可代決：<必須 user explicit 提供、AI 不得自代>
- 推薦路徑：<charter 認可的修補方向、允許 AI 在約束內變體>

**反例**（charter 已駁回的 anti-pattern、防 AI 重蹈覆轍）：
- ❌ <具體 anti-pattern + 對應正解>
- ❌ <另一個 anti-pattern + 對應正解>
```

**LIVE 實證閉環**（2026-04-29 user LIVE 抓到的 SSS S3 需求性）：

| 階段 | charter 角色 | AI 行為 | LLM 紀律密度 |
|---|---|---|---|
| 第一輪 doctor | 給 error code + 抽象處置描述 | freelance 編造（移除 F6 + 在地化 vendor specs）= 兩個 anti-pattern | 不足 |
| user 給挑戰 prompt | 三份 spec 原文 quote | 仍 double-down + 加碼編造 created_by 路徑 B | spec 紀律密度仍不足以單向 enforce |
| user 加 ground truth + **「不要 freelance」明示 + 該動 / 不該動 / 反例** | spec 原文 + 強化引導結構 | **回歸實證立場、執行 charter 規範** ← **這就是引導式紀律的目標終態** | 紀律密度足夠 |

→ **2026-04-29 user + maintainer 手動 simulate 了未來 v0.8.x SSS S3 條款化後 spec 自帶的引導結構**、實證設計提議的需求性 + 引導式 framing 比封鎖式更好。

**ship 路徑（v0.8.x PATCH 漸進）**：

- **v0.8.1 PATCH**（短期可 ship、~1-2 hr fresh head）：doctor-spec 既有 error codes（E601-E605 + E606-E608 + E801/W802）全加四欄結構（合規規定 + 修補方向約束 + 反例）
- **v0.8.2 PATCH**：post-upgrade-verify-spec 5 軸 error codes 全加四欄
- **v0.8.3 PATCH**：擴 init-spec Phase 5b CHECK 1-10 對應四欄
- **v0.9.0 MINOR（架構級）**：新加 `core/diagnose-remediate-protocol.md` 條款（架構級概念第 13 個正式條款化）+ 對應 SSS S1 落地（自治模式安全閥）

**對 SSS S1「AI 自治協作 + user 授權閘」前置基礎建設**：本 SSS S3 是 SSS S1 的前置 — 沒這層、AI 自治 = AI freelance（危險）；有這層、AI 自治 = AI 在 charter 框架內發想 + user 授權閘確認。**SSS S3 ship 完才有條件啟動 SSS S1 真正設計**。

**架構級概念候選編號**：第 13 個（lifecycle.md / condition-mutability.md 留 v0.9.0 lifecycle 議程、屬第 14 / 15 個）。

**SSS S3 不走「累積 ≥ 3 次」門檻**：本 LIVE 實證自身（signal #20 第 1〜4 次同 session 完整閉環）= 設計提議充分、跨多 release 漸進落地由 maintainer 視 use case 演化決定節奏。

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

### 5. `/charter-upgrade-verify` — 升版後標準驗證流程 ✅ **v0.8.0 完成**（2026-04-29 ship）

**Ship 內容**：`tools/post-upgrade-verify-spec.md` 新檔（5 軸 spec：A clone / B schema / C structure / D axiom / E stale ref + 模式 A 完整健康檢查）。模式 B 升版 diff / C pre-commit sync 留 v0.9+ 議程。

**最終命名**：`/charter-upgrade-verify`（user 2026-04-29 確認、選 「強調升版場景」候選）

**Ship 路徑**：v0.8.0 slim release（lifecycle.md / condition-mutability.md 兩條大條款 fresh-head risk 高、留 v0.9.0）

**累積跳門檻紀錄**：1 次（user 直接提議、2026-04-29 LIVE 條款化、同 v0.5.8 / v0.7.1 / v0.7.4 user 直接條款化 pattern）

**詳細歷史 entry 看下面**（保留供查、不刪）：

---

**user 提案原話**：「**升版後需要一個檢核機制、看目前的文件狀態、`~/.agentcharter`、目前 agent-commons 哪些標準的格式不合規等**」 — 升版完**之後**的 standard post-migration verification protocol。

**位階定位**：
- spec layer（tools/）— 不是 condition
- 與 `tools/doctor-spec.md`（通用 schema validation）並列、定位**升版專屬**
- 對應 `core/versioning-migration §3` 第 7 步「跑 doctor」的擴充強化（升版後完整度驗證）

**和既有的區別**：

| | doctor-spec | versioning-migration §3 | **新 post-upgrade verify** |
|---|---|---|---|
| 場景 | 任何時候 | 升版**過程** | 升版**完之後** |
| 範圍 | 通用 schema | 升版步驟流程 | 升版完整度 + stale reference + 跨多版累積遺漏 |

**檢查範圍盤點（5 軸）**：

| 軸 | 檢查內容 |
|---|---|
| **A. charter clone 對齊** | `~/.agentcharter` git log 是否含 user profile.yaml 宣稱的 `charter_version` 對應 commit / tag |
| **B. 本專案 schema 對齊** | profile.yaml 啟用條款數對齊當前 charter spec + enable_modes 含 F6（v0.7.0 起必啟） |
| **C. agent-commons/ 結構合規** | v0.7.0 namespace（shared/ 不存在）+ v0.7.4 vendor toml 扁平結構 + `_role.md` PROVISIONAL/ACTIVE 二態 |
| **D. axiom 紀律對齊** | frontmatter `status: USER-RATIFIED`（v0.7.1 + 待 signal #23 ship 後加 status check） |
| **E. stale reference 檢查** | 文件 / vendor toml / template 內 `charter_version` / spec section / step 編號是否對齊當前 |

**工具命名候選**：`/charter-version-status` (user 暫名) / `/charter-upgrade-verify` / `/charter-postmigration` / `/charter-sync-check`

**位階建議**：新檔 `tools/post-upgrade-verify-spec.md`（與 doctor-spec 並列）+ AI 自具象化為 slash command（依 init-template §3.3）+ 三 preset 不需新欄位

**Ship 路徑選項**：
- **選項 1：v0.7.6 BOOTSTRAP 批次** — scope 變大（QUICKSTART swap + signal #23 + BOOTSTRAP.md + 本工具）、但同源北極星精神
- **選項 2：v0.7.7 獨立 PATCH** — scope 乾淨、可優先於 v0.7.7 既有「prompt 簡化」或合併
- **選項 3：v0.8.0 「lifecycle 完整化」** — 整合進 `core/adoption-lifecycle.md` 升版階段

**對齊 SSS S1**：本工具自動化驗證是 **SSS S1「AI 自治協作 + user 授權閘」的子集** — 自動驗證後 AI 自提升版完整度報告 → user 授權閘批准 release lifecycle 推進。可作 S1 起手方向之一

**累積觸發**：1 次（user 直接提議、跳過 ≥3 次累積門檻、同 v0.5.8 / v0.7.1 user 直接條款化 pattern）

**user 待決**：(a) Ship 路徑（選項 1 / 2 / 3 / 其他組合）+ (b) 工具最終命名

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

> **處理紀律**（user 2026-04-29 強調）：本段每個議題處理完後**必須**：
> 1. 劃線標 ✅ vN.M 完成 + 簡述條款化位置（如「✅ v0.7.6 完成：core/X.md §Y 加段」）
> 2. 若部分完成：明示「**部分完成**：X 已條款化 / Y 留 v0.8.0」
> 3. 不可只在腦中知道做完了、必須回頭來標
> → 對齊 `working-stack-discipline §1` DRAFT 紀律 + `maintainer-discipline §3.4.3` 內部追蹤層 sync

- **新議程候選 — v0.8.x PATCH 雙軸矩陣 framing（multi-perspective 評估第十四循環、結構師金礦）**（2026-04-30 LIVE capture）：對應 `examples/external-evaluations/clispike-multi-perspective-eval-2026-04-30.md` 結構師金礦 — 顯化 charter 條款的雙軸正交分類：
  - **物理依據軸**：結構強制 / 多 actor 互檢 / 單 actor 自律
  - **檢測時點軸**：init / runtime / post-upgrade / handoff
  - **目標**：每條 charter 條款補 (物理依據, 檢測時點) 雙標籤、顯化「**弱保證項 = 單 actor 自律格**」（真正需要加固的條款）— 加固路徑優先「升級到多 actor 互檢」、不走 binary（保 vendor-agnostic）
  - **對齊條款 / 北極星**：
    - `core/violation-reflection §2`「LLM 不可矯正」自覺的延伸（讓採用方知道哪些保證靠誰守）
    - 北極星「解決重複溝通」（user 不必每次跟 AI 確認「這條靠誰守」）
    - feedback `structural-over-patch` 紀律（**結構修正、不是規範補丁**）
  - **ship 路徑**（v0.8.x PATCH 漸進）：
    - **v0.8.x PATCH 1**：README §設計哲學第 5 條加雙軸矩陣 framing 段 + 對應 SSS S3 spec-as-data 五欄結構 cross-reference
    - **v0.8.x PATCH 2**：21 條 core 條款逐條補雙軸標籤（frontmatter 或 §1 加 `<!-- enforcement: structural | external-arbitration | llm-self -->` + `<!-- detection-time: init | runtime | post-upgrade | handoff -->`）
    - **v0.8.x PATCH 3**：「依賴 LLM 紀律的條款清單」公開（自動由雙軸標籤派生 = 單 actor 自律格清單、放 README §設計哲學）
  - **scope 估算**：21 條條款逐條補雙軸標籤 ~ 中等工作量（每條 5-10 分鐘 × 21 條 = 2-3 hr fresh head）
  - **獨立性**：可獨立於 SSS S3 ship（不衝突、互補）— SSS S3 是 spec 設計層、本議程是 condition 設計層
  - **判斷**：multi-perspective 評估第十四循環直接 capture、**不走「累積 ≥ 3 次」門檻**（對齊 v0.7.4 / v0.5.8 / v0.7.1 / v0.7.4 user 直接條款化 pattern）；user 同意 ship 路徑後、列 v0.8.x PATCH 議程
  - **配套檔案**：
    - `examples/external-evaluations/clispike-multi-perspective-eval-2026-04-30.md` §3.2 結構師金礦（雙軸矩陣完整推導）
    - 本檔 SSS S1「LIVE prototype 觀察（2026-04-30 多 sub-agent 評估）」子段（觸發脈絡）

- **v0.7.6 BOOTSTRAP.md 入口檔議程備註 — 必含「升版快速執行版」段**（v0.7.5 對話揭露 / 2026-04-29 user 直接抓到）：v0.7.5 ship 的 `examples/upgrades/yc-aiagentcrew-v0.5.9-to-v0.7.4.md` walkthrough §3 7 步流程對採用方仍偏重（含大量 reference + 條款引用 + 設計學意義段）；對話內 maintainer 即興整理的「**5 步精簡實戰執行版**」（Step 0 前置 / Step 1 toml / Step 2 profile / Step 3 doctor / Step 4 axiom / Step 5 commit + 預估時間 + 驗證點）對採用方體感更佳、但**沒沉澱回文件**。對應 v0.7.3 北極星「**charter 引導採用方、不讓 user 記**」精神不夠到位 → v0.7.6 BOOTSTRAP.md 設計時必含「**升版快速執行版**」結構（採用方端入口、對應 walkthrough §3 但精簡 actionable）；既有 walkthrough §3 保留為「**標準學術版**」、可加 §3a「**快速執行版**」對照 cross-reference。**對應 NEXT 區段 v0.7.x 後續議程的 v0.7.6 BOOTSTRAP**

  - **第二輪 user 抓到的同源設計盲區（2026-04-29 升版實戰）**：v0.7.5 walkthrough §3 Step 4「應用 migration」段（4.1 profile.yaml 修補 / 4.2 toml 修補 / 4.3 axiom frontmatter）— **4.1 + 4.3 是「給 user 的 yaml/markdown diff 範例」、不是「給 AI 的 prompt」**（vs 4.2 toml 修補是「給 AI 的 prompt」格式）。user 反問「這邊要自己手改(?，不能用指令嗎 這樣似乎不是無痛」抓到此設計矛盾。**v0.7.6 BOOTSTRAP 設計必修紀律**：所有採用方需要動 schema / 修檔的動作（profile.yaml 改 / mapping.yaml 改 / axiom 加 frontmatter / commit message 模板等）— **必須有對應「給 AI 的 prompt」模板**（user 貼一次 AI 自動完成）；不可只給「user 視角的 diff 範例」（要求 user 親自編輯）。對齊「**user 最少做 1 個動作**」北極星精神 — user 動作 = 貼 prompt、AI 動作 = 修檔。
  - **同源 dogfood signal**：charter 過去半天 ship 的 v0.7.0〜v0.7.5 多個 release 文件（QUICKSTART / ADOPTION / TUTORIAL / walkthrough）很多段落都犯這個「maintainer 視角寫法」毛病 — 顯化條款細節 vs 顯化採用方執行路徑 兩者落差。v0.7.6 BOOTSTRAP 順帶 sweep 整個採用方文檔層、把「執行類段落」全部對齊「給 AI 的 prompt」格式。**累積觀察**：本次 user 反問是第 1 次直接抓到這類同源 pattern；累積觀察、視 BOOTSTRAP 設計範圍評估是否擴大 sweep 範圍

- ~~**新 dogfood signal #19 候選 — doctor §3.7 E602 雙重否定措辭引發 LLM 誤判**~~ ✅ **v0.8.1 完成**（2026-04-30）：`tools/doctor-spec.md §3.7` 校驗集第 2 條改為「期望狀態（合規）vs 違規狀態」對照表 + 紀律提醒（不要把「找不到」誤判為 WARN/ERROR）+ §3.7 E602 詳盡引導反例段加此 anti-pattern 對照。原候選紀錄保留（2026-04-29 YC 升版實證）：YC 升版 Step 3 跑 doctor、Gemini 讀 `tools/doctor-spec.md §3.7` 「`<common_memory_root>/shared/` 目錄存在 → E602 ERROR」措辭、把 YC 實際「shared/ 不存在」（合規狀態）誤判為「⚠️ WARN (Non-Critical) — 未偵測到 management/shared/ 目錄」。實際應該全綠通過。**根因**：spec 用「shared/ 應不存在」雙重否定描述 anti-pattern、Gemini 防禦性編程把「找不到」也標 WARN。**累積**：1 次（YC 升版實證）。**判斷**：屬 v0.7.6 BOOTSTRAP 順手修補的同類議題（doctor spec 對 LLM 友善的措辭明確化）；v0.7.6 議程 順帶 sweep doctor §3.7 + §3.8 對「禁存在 / 應存在」表述加正反例對照；當前先觀察、不條款化

- **新 dogfood signal #21 候選 — charter 對「framework 全域 vs agent-commons 專案私有」雙層架構解釋不夠**（2026-04-29 user 升版完問「.agentcharter 在 user home 會影響其他專案嗎」直接抓到）：charter 文件（README / QUICKSTART / ADOPTION / TUTORIAL）多處提到 `~/.agentcharter/` 路徑、但**沒有清楚架構圖**（雙層 framework + agent-commons）讓 user 一眼看懂兩層隔離設計。user 第一次接觸時會困惑「會不會影響其他專案」。**對齊條款**：`core/common-memory-root.md` + `core/versioning-migration §6` + `core/charter-config.md §2` 都有相關說明、但分散；新 user 找不到全景。**判斷**：屬 v0.7.6 BOOTSTRAP 必修方向 — BOOTSTRAP.md 第一段應有 ASCII 架構圖 + 三個關鍵保證表（framework 升級 ≠ 自動升專案 / framework 比專案新 OK / 專案資產完全獨立）。**累積**：1 次（YC 升版完問）；屬一見即明痛點、可不必累積到 3 次直接條款化（BOOTSTRAP 設計順手做）

- **新 dogfood signal #28 候選 — progressive adoption / 採用門檻 framing 缺**（2026-04-30 CliSpike Engineer Claude 外部評估觸發）：Engineer 報「過重 if 你只想要 AI 別瞎掰、抓 3-5 條核心落地就 80% 收益」 + 「適配場景 vs 反適配」二分。**根因**：charter 採用方分層採用紀律沒明示、三個 preset (minimal/standard/strict) 是「設定嚴格度」軸、不是「採用深度」軸。**候選方向**：v0.9.0 essential preset（3-5 條 core、targets 探索期 / 單人 / 快迭代）+ 採用 lifecycle「初始 footprint 超低、漸進深化」設計。詳見 `examples/external-evaluations/clispike-engineer-claude-2026-04-30.md`

- **新 dogfood signal #27 候選 — spec-driven 與 LLM 自律 循環依賴 reality check**（2026-04-30 CliSpike Engineer Claude 外部評估觸發）：Engineer 報「框架自己的前提就是『LLM 不可矯正』循環依賴」 — spec-driven 工具鏈 + AI 自具象化 = 紀律執行最終仍依賴 LLM 自律、但 charter 自身條款（violation-reflection §2「反省不能矯正 LLM」）已承認 LLM 不可矯正。**直接對應 SSS S3 引導式紀律設計的需求性** — SSS S3 v0.8.x PATCH ship 後此循環解開。詳見 `examples/external-evaluations/clispike-engineer-claude-2026-04-30.md`

- **新 dogfood signal #26 候選 — init token cost / ROI 系統評估缺位**（2026-04-30 CliSpike Engineer Claude 外部評估觸發）：Engineer 報「每次 init 約 25k+ tokens 讀協議；單人 / 小專案 ROI 會吃緊」。**根因**：charter 至今沒系統評估過 init token cost vs ROI、minimal preset 雖 9/19 仍偏重。**候選方向**：v0.9.0 essential preset（3-5 條 core、< 5k init token、與 #28 同源族群）。詳見 `examples/external-evaluations/clispike-engineer-claude-2026-04-30.md`

- **新 dogfood signal #25 候選 — walkthrough 設計層未涵蓋 v0.7.1 frontmatter scaffold ship 前接入採用方**（2026-04-29 user LIVE 抓到）：v0.7.5 → v0.8.0 walkthrough §0 表只有 A/B/C 三類採用方分類、但 user IRON.md case 屬第 4 類 D（路徑 A user 主筆 + axiom 完全缺 frontmatter、v0.7.1 frontmatter scaffold ship 前接入採用方）。**現況走 manual override**（user 用我給的修補 prompt 跑通）；walkthrough 文件需補 §0 第 4 類 D + 新加 Step 3.D「路徑 A axiom 補 frontmatter scaffold」（簡化版、無校正紀錄行、created_by: user）。**累積**：1 次（YC 升版 LIVE 實證）。**判斷**：累積觀察、暫不條款化、待 v0.8.x PATCH 順手補

- ~~**新 dogfood signal #24 候選 — ADOPTION/TUTORIAL 變更歷史段 sync 缺漏連續違反**~~ ✅ **v0.8.1 完成**（2026-04-30）：`tools/doctor-spec.md §3.10` 新加採用方文檔變更歷史 sync 校驗（W901）— `core/maintainer-discipline §3.4` 演化路徑「升級到工具層自動偵測」終局實作。原候選紀錄保留（2026-04-29 user post-v0.8.0 ship 抓到）：v0.8.0 ship commit 後 user 立即問「**文件有更新嗎、有記得補更新的文件讓採用方可以照著步驟更新了嗎**」→ maintainer 檢查發現 (a) ADOPTION.md §13 變更歷史最新 entry 為 v1.5 (charter v0.7.3)、缺 v0.7.4 + v0.7.5 + v0.8.0 entries；(b) TUTORIAL.md 變更歷史最新 entry 為 v1.3 (charter v0.7.0)、缺 v0.7.1 + v0.7.2 + v0.7.3 + v0.7.4 + v0.7.5 + v0.8.0 entries。**已 v0.8.0 commit 後修補**（add follow-up commit、不動 v0.8.0 tag、本 commit 純文檔補完不影響 release）。**根因**：v0.7.2 ship `core/maintainer-discipline §3.4.2` 文檔層 sync checklist 子項「變更歷史段（採用方文檔）」、但 maintainer 在 v0.7.4 / v0.7.5 / v0.8.0 三次連續 release 中漏執行此 checklist 子項 = **連續 ≥ 3 次同類違反同一子項**、對應 §3.4 違反處置「升級該子項至 §3.1 工具層自動偵測」。**已達 dogfood-driven hardening 第十二循環觸發點**。**處置候選**（v0.8.x PATCH 議程 / v0.9.0 一併）：
  - (a) `tools/doctor-spec.md` 新加 §3.10「採用方文檔變更歷史 sync」校驗 — 比對 ADOPTION/TUTORIAL 變更歷史最新 entry 對應 charter version vs profile.yaml `charter_version`、不一致 → WARN
  - (b) `tools/post-upgrade-verify-spec.md` 軸 E（stale reference 檢查）擴含「採用方文檔變更歷史 entry 對齊當前 charter_version」校驗（E3 stale reference 自動延伸）
  - (c) `core/maintainer-discipline §3.4.2` 加紅色強調「變更歷史段（採用方文檔）— 連續 3 次違反、已升級為硬性 release blocker」+ 視為 release commit pre-flight 必查項
  - (d) **dogfood signal #6「條款層 sync 與文檔層 sync 不對等」第 N 次同類同源**：v0.7.2 條款化 §3.4 checklist 為對應修補、本次實證 checklist 仍依賴 maintainer 主動執行、**人為紀律不夠、需工具層硬性偵測** — 對應 §3.4「v0.8+ 升級到工具層 doctor 自動偵測」演化路徑該執行
  - **判斷**：累積已 ≥ 3 次違反、夠條款化、列 v0.8.x PATCH 優先順位
  - **設計學意義**：dogfood signal #20/#22 同源「LLM/maintainer 紀律補丁不夠、需結構修正 / 工具層硬性 enforce」 — checklist 是規範補丁、doctor 校驗是結構修正

- ~~**新 dogfood signal #23 候選 — Phase 5b CHECK 7 axiom 校驗範圍 gap（surface-level vs structural-level F6 sub-pattern 第二次同類）**~~ ✅ **v0.8.0 完成**（user LIVE 直接授權跳累積門檻、跨 init/doctor/post-upgrade-verify 三層雙重防禦：`tools/init-spec.md` Phase 5b CHECK 7 ext + `tools/doctor-spec.md §3.9` E606/E607/W608 + `tools/post-upgrade-verify-spec.md` 軸 D D001 全 ship）（2026-04-29 公司專案第二次接入 LIVE 實證、user 直接授權「下一次升版順便修」）：v0.7.0 公司接入第一次失敗（Gemini 寫 dbsdk.md schema 但檔案沒建）= 第一次同類；本次公司專案第二次接入（Gemini 路徑 B 寫 axiom AI-DRAFTED + user 未升 USER-RATIFIED）→ init Phase 1-5b 跑通 + Phase 5b CHECK 7 PASS = 第二次同類。**根因三層**：(a) `tools/init-spec.md Phase 5b CHECK 7` 只驗「檔案物理存在」、**沒驗 frontmatter `status` 值**；(b) `core/domain-axiom-slot §3.3` 路徑 B 紀律「不可在 AI-DRAFTED 啟動 init」**執行載體缺位**；(c) `templates/agent-commons/domain-axioms-via-ai-draft-prompt.md.tpl` 第 5 步寫了、但 QUICKSTART Step 3 init prompt 沒交叉引用、AI 跑 init 不主動驗 axiom status。**累積**：2 次（v0.7.0 一次 + v0.7.6 LIVE 二次）。**queued v0.7.6 BOOTSTRAP 批次候選 / 或 v0.7.7 獨立 PATCH**（user 2026-04-29 LIVE 授權「順便修」、不打斷當前 LIVE 接入；當前 LIVE 走 Option B 就地補救手動升 status）：
  - (a) `tools/init-spec.md Phase 5b CHECK 7` 擴含「frontmatter `status` == `USER-RATIFIED`」校驗（不通則 fail）
  - (b) `QUICKSTART.md Step 3` init prompt 加紀律提示「跑 init 前自驗 axiom frontmatter `status` 是否 USER-RATIFIED、AI-DRAFTED 即終止退稿」
  - (c) `core/domain-axiom-slot §3.3` 反向引用 init-spec Phase 5b CHECK 7（雙向引用對齊）
  - (d) `tools/doctor-spec.md §3.7` 加 axiom frontmatter status 校驗（與 Phase 5b CHECK 7 互補）

  **設計學意義**：F6 sub-pattern「surface vs structural」精神在 Phase 5b 自身內部的反向實證 — Phase 5b 設計是用來補 doctor 半邊「自抽自驗」、自身也可以有結構性盲區（surface PASS / structural fail）。對應 v0.7.3 北極星「**charter 引導採用方、不讓 user 記**」紀律 — 目前要 user 自己記「升 status」是反向

- **新 dogfood signal #22 候選 — v0.x 階段紀律補丁應預設重評為結構修正**（2026-04-29 user LIVE 公司接入駁回 v0.7.2 取捨）：v0.7.2 對 dogfood signal #10「QUICKSTART Step 2-3 順序與 Phase 5b 衝突」採 cross-reference 方案（保留編號 + 加警告）、留 v0.8+ 線性化；user 公司接入 LIVE 跑 Step 2 看到「前置條件 Step 3」直接反問「為啥不對調」 → cross-reference 警告 LIVE 失效訊號 #1。v0.7.6 prep 直接 swap、移除全部 cross-reference 警告。**結構性反思**：v0.x 階段「紀律補丁類修訂」（cross-reference / 警告 / 提醒）對採用方體感是反作用 — **多記東西** ⊥ v0.7.3 北極星「charter 引導採用方、不讓 user 記」。應預設「**結構修正**」（直接 swap / 重排 / 命名修正）而非「**規範補丁**」（加警告 / 加 footnote / 加紀律提醒）。**累積**：1 次（QUICKSTART #10 v0.7.2 → v0.7.6 升級實證）。**判斷**：累積 ≥ 2 次同類後條款化進 `core/maintainer-discipline §X` —「v0.x 階段條款修訂優先序：結構修正 >> 規範補丁」+ 反例段引 v0.7.2 cross-reference 為何 LIVE 失效；當前先觀察、不條款化

- **新 dogfood signal #20 候選 — LLM 主動推薦 anti-pattern + 編造論述**（2026-04-29 YC 升版實證、**比 #19 嚴重**）：承 #19、Gemini 不只把 E602 標 WARN、**還主動建議 user 執行「結構遷移」**：mkdir management/shared/ + mv 所有資產進去 + 改 mapping.yaml layout.shared.<key>: shared/<key>/。**這正好是 v0.7.0 公司接入失敗的 dogfood signal #4 同源 anti-pattern**（Gemini 把 schema namespace `shared.*` 翻譯為檔案系統目錄）。Gemini 還編造論述：「對齊 v0.7.5 標準命名空間結構」 — **charter 沒這個結構**、v0.7.5 標準就是頂層扁平。**根因比 #19 深**：(a) v0.7.0 採「不重命名 namespace + 雙重防禦」決策（charter-config §3 註明 + doctor §3.7 校驗）對「**LLM silent 寫錯**」夠用、但對「**LLM vocal 主動推 anti-pattern + 編造論述**」不夠 — Gemini 不只是被動踩坑、還會說服 user 跟著踩。(b) doctor §3.7 措辭問題（#19）讓 Gemini 防禦性編程進入「主動建議修補」模式。**累積**：1 次（YC 升版實證）。**判斷**：v0.7.6 BOOTSTRAP 順手沒解；可能需要 v0.8.0 重新評估 v0.7.0「不重命名 namespace」決策 — 之前 user 選雙重防禦、本實證揭露雙重防禦對「LLM vocal misrecommendation」不夠、累積到 ≥3 次同類後評估是否在 v0.8.0 把 mapping schema `shared.*` namespace 重命名為不像路徑的字（如 `commons.*` / `xroles.*`）。**v0.7.0 決策回看**：「不重命名」決策仍對 — 重命名是 BREAKING-LITE 對既有採用方破壞大；但 v0.8.0 可考慮 alias（`shared.*` 仍 work、新採用方用 `commons.*`）漸進遷移路徑

- ~~**dogfood signal #6 — 「條款層 sync 與文檔層 sync 不對等」**~~ ✅ **v0.7.2 完成**（達 ≥3 次同類門檻、條款化）：v0.6.1 auditor 第一次實戰（漏 numeric/version）+ v0.6.1 後 session（templates 範圍兜底含糊）+ **v0.7.1 後 user 直覺抓到 structural-anti-fabrication §5 反向引用漏**（v0.7.0 + v0.7.1 加段全部漏）= 三次同類觀察。v0.7.2 條款化為 `core/maintainer-discipline §3.4` 文檔層 sync checklist 三子段（條款層連動 + 文檔層連動 + 內部追蹤層）+ 違反處置 + v0.8+ 升級到工具層 doctor 自動偵測的演化路徑
- **新 dogfood signal #9 候選**（v0.7.0 auditor 抽驗時發現） — 「**release 收尾步驟（STATUS/NEXT 更新）放到 commit 之後 = 容易在 release 當下漏掉 signal 紀錄**」。本次 v0.7.0 auditor 抽驗第一次跑時就抓到 W001（STATUS / NEXT 缺 signal #7/#8 紀錄、雖然 P6 task 排程內），對應「signal 紀錄 vs 條款修訂的時間差」結構性問題。**判斷**：累積 ≥3 次同類再評估，候選方向：(a) `maintainer-discipline §2.2` 引用範圍表加「STATUS / NEXT signal sync」項；(b) release commit 前 checklist 加「STATUS §D + NEXT.md ⚪ 是否已對齊本 release 修訂的 signal」；(c) 把 P6 標準化到 release 流程的 P3 之後（即修完條款立刻寫 STATUS/NEXT、再走 auditor）
- ~~**dogfood signal #10 — QUICKSTART Step 2-3 順序與 v0.7.0 Phase 5b 衝突**~~ ✅ **v0.7.2 cross-reference → v0.8.0 直接 swap ship**（v0.7.6 prep 併入 v0.8.0、議程順位 shift）：v0.7.2 加紀律警告（檔頂執行順序 + Step 2 前置條件 + Step 3 順序提醒）為過渡方案；**v0.8.0 ship 直接 swap**（QUICKSTART Step 2 (axiom) ↔ Step 3 (init) + 移除全部 cross-reference 警告 + 修 path B item 4 pre-existing drift Step 4 → Step 3 + sweep README / domain-axiom-slot / maintainer-discipline §3.4.2 / templates 路徑 B prompt 共 5 檔同步）。**觸發於**：2026-04-29 user LIVE 公司專案接入時直接駁回 v0.7.2 取捨「為啥不對調」 → 累積 1 次 LIVE 失效訊號 + signal #22 候選同源「v0.x 結構修正 >> 規範補丁」原則。**設計學意義**：對齊 v0.7.3 北極星「**charter 引導採用方、不讓 user 記**」+ v0.7.4 雙軌節奏「PATCH 頻繁小擴增」

- **新 dogfood signal #13 候選 — user 對 charter 自身演化行使「他抽」屬性**（v0.7.2 觸發、抽驗時發現）：v0.7.1 release 後、user 連續兩次 IDE 開 `core/structural-anti-fabrication.md` 抓到 maintainer + auditor 漏的 §5 反向引用同步 → 觸發 v0.7.2 條款化 signal #6 + signal #10。**設計學意義**：v0.7.0 加的 Phase 5b 採用方半邊「他抽」屬性 → user 學會 → user 反過來他抽 charter 自己。**判斷**：累積 use case 後評估是否在 `roles/validator/_spec.md` 加 §3.7「對 charter 自身演化行使他抽」段（採用方視角的 charter dogfood 貢獻路徑明示）；當前先觀察、不條款化

- **新 dogfood signal #17 候選 — 條款互引時 maintainer 留占位符 §X / §3.X 未替換為實際章節編號**（v0.7.4 auditor 抓到）：v0.7.4 ship 時 5 處 `§X` / `§3.X` 占位（gemini-cli §3.6 + §7 v1.2 entry / claude-code §4.1）— 應為實際章節（§3.8 / §4.1）；對應 F4 編號偏差。**累積**：v0.7.3 完整文檔層 sweep 抓的 10 ERROR 多數同類「主體內容沒對齊條款最新狀態」+ v0.7.4 又踩 1 次 = 第二次同類觀察。**判斷**：累積 ≥3 次同類後可條款化「**maintainer 寫條款互引時禁占位、必填實際章節**」（如新加 `maintainer-discipline §3.4.4` 子項）；當前先觀察、不條款化

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

### v0.8.1 release（2026-04-30）— SSS S3 起手實證 + dogfood signal #24 升工具層 + #19 順手修

✅ **dogfood-driven hardening 第十四循環**（multi-perspective sub-agent 反向校準新類型）：
- `examples/external-evaluations/clispike-multi-perspective-eval-2026-04-30.md` 新檔（4 sub-agent 原文 verbatim + maintainer 綜合判斷 + 五軸分類 + 守住禁區）— commit `afcd330`
- 4 sub-agent 補強 maintainer 第一輪沒到的深度：結構師雙軸正交矩陣（物理依據 ⊥ 檢測時點）+ 理念守護者「LLM 不可矯正」方向性誤讀指認 + 工程師 token 25k→8k 估算挑錯 + 採用方 essential preset 才是真槓桿

✅ **dogfood-driven hardening 第十五循環**（signal #24 升工具層 + #19 順手修 + SSS S3 起手 三 signal 同 LIVE session 條款化）：

✅ **新增**：
- `tools/doctor-spec.md §3.7-§3.9` 既有 error codes 全加四欄 spec-as-data 結構（合規規定 / 修補方向 + 約束 / 反例）— SSS S3「引導式紀律」起手實證、共 10 個 H4 子段（E601-E605 + E801/W802 + E606/E607/W608）
- `tools/doctor-spec.md §3.10` 新加採用方文檔變更歷史 sync 校驗（W901）— signal #24 升工具層條款化、`core/maintainer-discipline §3.4` 演化路徑「升級到工具層自動偵測」終局實作

✅ **修正**：
- `tools/doctor-spec.md §3.7` 校驗集第 2 條雙重否定措辭修（signal #19 YC v0.8.0 升版 LIVE 實證 Gemini 把合規「shared/ 不存在」誤標 WARN）

✅ **連動更新**：三 preset yaml `0.8.0` → `0.8.1` + ADOPTION/TUTORIAL/maintainer-load 升版號 + ADOPTION §13 v1.9 + TUTORIAL 變更歷史 v1.9 + CHANGELOG v0.8.1 段 + STATUS Version 軌跡 v0.8.1 row + STATUS frontmatter「當前版本」+ Git tags

✅ **議程位階重整**：v0.8.x SSS S3 漸進落地起手、v0.8.2 propagate 到 post-upgrade-verify-spec + 雙軸矩陣 framing 第一段（README §設計哲學第 5 條）、v0.8.3 propagate 到 init-spec + 21 條條款補雙軸標籤

✅ **嚴守向下兼容**：純擴增 spec 層 + 文檔層、採用方升版只改 `charter_version` 一行；W901 為新增 WARN、可選修補

### v0.8.0 release（2026-04-29）— 升版 + 接入防呆強化（slim 版）

✅ **dogfood-driven hardening 第十一循環 — 三條同 session 條款化（不依賴 release 等待）**：

✅ **新增**：
- `tools/post-upgrade-verify-spec.md` 新檔（5 軸 spec + 模式 A 完整健康檢查；user LIVE 提議 `/charter-upgrade-verify`）
- `tools/doctor-spec.md §3.9` 加 axiom 紀律對齊段（E606/E607/W608、dogfood signal #23 條款化）

✅ **啟用 / 擴**：
- `tools/doctor-spec.md §3.8` vendor schema 從 spec 層升實作層（v0.7.4 累積條件滿足、E801/W802 強制）
- `tools/init-spec.md` Phase 5b CHECK 7 ext（axiom frontmatter status 校驗 — init 端 fail-fast 載體）

✅ **結構修正**：
- `QUICKSTART.md` Step 2 ↔ Step 3 swap（v0.7.6 prep 併入；signal #10 從 cross-reference 升結構修正、signal #22 候選紀錄 v0.x 紀律補丁應預設重評為結構修正）

✅ **連動更新**：三 preset yaml `0.7.5` → `0.8.0` + ADOPTION/TUTORIAL/maintainer-load 升版號 + core/domain-axiom-slot §3.3 對應載體加 v0.8.0 三層雙重防禦反向引用 + maintainer-discipline §3.4.2 checklist 範例更新 + CHANGELOG v0.8.0 段

✅ **議程位階重整**：原 v0.8.0 議程 lifecycle.md + condition-mutability.md 兩條大條款（架構級新概念）fresh-head risk 高、留 v0.9.0；v0.7.x 留下議程（BOOTSTRAP / prompt 簡化 / BREAKING-LITE checklist）shift 到 v0.8.x PATCH

✅ **SSS 級 capture（無 ship、跨 release 演化）**：
- S1：AI 自治協作 + user 授權閘模式（user 角色 redefinition）
- S2：v0.8.0/v0.9.0 lifecycle 設計素材（`/charter-uninstall` 流程 + vendor 升級 path 三路徑 A/B/C + 新 vendor 互學深化 + README §設計哲學第 4 條候選「跨 vendor 知識聚合 + 互為養分 + 收斂 best-of-breed」）

✅ **採用方影響**：升版基本動作 = 改 charter_version 一行；既有 vendor toml/md 若 schema 不合規 / axiom AI-DRAFTED → 跑 doctor 抓新 ERROR、屬可接受 BREAKING-LITE（v0.x 階段、校驗強化非條款新增）；新採用方按新 QUICKSTART step order

### v0.7.5 release（2026-04-28）— 跨多版本升級指引 + 第一個回鍋開發者無痛實證 walkthrough

✅ **dogfood-driven hardening 第十循環 — 北極星「回鍋開發者無痛」第一個實證 ship**：對應 v0.7.3 顯化的 README §設計哲學從「規範密度導向」轉向「服務體感導向」的具體兌現。user 在 v0.7.4 ship 後直接要求「**文件上記得補充如何更新、以 YC_AIAgentCrew 為例該如何從 v0.5.9 → v0.7.4**」觸發

✅ **新增（純擴增、向下兼容）**：
- 新檔 `examples/upgrades/yc-aiagentcrew-v0.5.9-to-v0.7.4.md`（charter 第一個跨版本升版實證 walkthrough）— 6 段（升版前狀態 / 跨 8 release 演化軸 / 7 步升版流程 / 升版後 self-check / 設計學意義 / 變更歷史）
- `core/versioning-migration §3.4` 跨多版本升級子段 — 5 子段（適用範圍 / 允許性 / 流程擴充 / 實證 walkthrough 表 / 「停用一段時間後重新採用」場景具體指引）

✅ **連動更新**：三 preset yaml `0.7.4` → `"0.7.5"` + ADOPTION/TUTORIAL/maintainer-load 升版號 + ADOPTION line 149/336 charter_version 範例值同步 + maintainer-load.md 加 v0.7.5 議程說明

✅ **嚴守向下兼容**：純擴增 / 既有採用方升 v0.7.4 → v0.7.5 零動作 migration（只改 profile.yaml `charter_version`）

✅ **user「0 ERROR + 0 WARN」深度 sweep 紀律**：v0.7.5 ship 前跑深度 5 面向 sweep（跨檔引用 / 跨 release 邏輯一致性 / numeric 同步 / 北極星三題對齊 / dogfood signal 累積盤點）— 修補所有 ERROR/WARN 直到 0/0 才 commit

### v0.7.4 release（2026-04-28）— vendor 端 slash command schema 規範條款化（dogfood signal #16）

✅ **dogfood-driven hardening 第九循環 — vendor schema 規範條款化**：YC_AIAgentCrew（v0.5.9 接入）2026-04-28 user 重啟 Gemini CLI v0.39.1 時、3 個自具象化 toml 全部被 vendor 端 schema validator 抓出格式錯（nested table）跳過載入 → 觸發條款化

✅ **新增條款 / 段（純擴增、向下兼容）**：
- `roles/pm/gemini-cli.md §3.6` Gemini CLI 端 toml schema 規範（強制扁平結構 + 正確 vs 錯誤對照範例 + 5 項 self-instantiation checklist + schema 來源 + 跨 AI 對應表）
- `roles/engineer/claude-code.md §4.1` Claude Code 端 .md schema 規範（純 markdown + 可選 frontmatter + 4 項 self-instantiation checklist + 違反處置）
- `tools/doctor-spec.md §3.8` vendor 端 slash command schema 校驗（spec 層、實作 defer v0.8+；E801/W802 不在 v0.7.4 啟用）+ §3.8.1 v0.7.4 → v0.8+ 漸進啟用路徑說明

✅ **嚴守向下兼容**：純擴增 / 既有採用方升 v0.7.3 → v0.7.4 零動作 migration（只改 profile.yaml `charter_version`）/ doctor 不跑新 check / 對 YC_AIAgentCrew toml 失效有立即 reference

✅ **節奏修正**：user 提「為什麼 0.7.3 → 0.8 我不太理解」 → maintainer 反省 v0.8.0 大 release 違反「頻繁小擴增、每個 release 純向下兼容」精神（規範密度導向殘留）→ charter 改走「**頻繁小擴增 PATCH** + **大方向新加條款用 MINOR**」雙軌節奏

✅ **連動更新**：三 preset yaml `0.7.3` → `"0.7.4"` + ADOPTION/TUTORIAL/maintainer-load 升版號

### v0.7.3 release（2026-04-28）— 完整文檔層 sync sweep + 設計哲學北極星顯化 + v0.7.0 BREAKING-LITE 追溯

✅ **dogfood-driven hardening 第八循環 — 設計哲學北極星顯化**：v0.7.2 release 後 user 提兩個關鍵 framing →（1）「**框架價值來自服務 / 解決重複溝通 / 由淺入深 / charter 引導採納方**」+（2）「**培養魚塭、不討魚 — 真正開發不應侷限眼前舒服、而是放眼未來舒適**」+ 「**有衝突就代表沒有向下兼容**」 → 觸發 charter 從「規範密度導向」轉向「服務體感導向」

✅ **README 加設計哲學（北極星）段**：兩無痛定義（回鍋開發者 / 小白）+ 三服務原則（解決重複溝通 / charter 引導採用方 / 培養魚塭）+ 對未來修訂的紀律（每次修訂對照三題：對回鍋開發者體驗加減分？對小白接入門檻降低升高？解決新的重複溝通還是新增採用方要記的東西？）。**所有未來條款 / spec / templates 修訂須對照此北極星檢驗**

✅ **完整文檔層 sync sweep**（auditor 抓 10 ERROR + 3 WARN 全修）：
- ADOPTION.md 7 處（charter_version + F1〜F6 + init-template step 6 + 雙路徑 + 7 步驟 + self-check + §13 補 v1.4/v1.5）
- TUTORIAL.md 4 處（§3 cross-reference + §5.2 7 步驟 + §8.3 F1〜F6 + §11.1 doctor E601〜E605）
- README.md 3 處（F1〜F6 + init-template step 6 + 角色目錄 v0.7.0 升級）
- core/charter-config.md §5 條款相依表加 init-template → multi-role-tracking + audit-rights

✅ **v0.7.0 BREAKING-LITE 追溯說明**：v0.7.0 release notes 標題 mislabel 為 MINOR、實際含兩個既有採用方 migration 點（F6 強制必啟 + mapping shared/ 中介層 migration）→ 應為 BREAKING-LITE。本 release CHANGELOG 加追溯校正、git history 不改、留 reference。**這個 mislabel 本身對齊 v0.7.0 加的 F6 sub-pattern「surface vs structural」精神在 release labelling 的諷刺實證**

✅ **連動更新**：三 preset yaml `0.7.2` → `"0.7.3"` + ADOPTION/TUTORIAL/maintainer-load 升版號 + CHANGELOG v0.7.3 段

✅ **新加 dogfood signal #15 候選**：「`versioning-migration` 對 v0.x 階段 BREAKING-LITE 判定不嚴謹」— 留 v0.8.0 條款化（加 BREAKING-LITE 判定 checklist）

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
