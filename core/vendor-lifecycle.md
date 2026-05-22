# Vendor Lifecycle（Vendor 預設行為 / 失效 / 換手紀律）

> **狀態**：v0.1（自 v0.12.0 引入）
> **位階**：core 通用條款 + **架構級概念第 14 個誕生**「Vendor Lifecycle 紀律」— 收編 dogfood signal #5 / #41 / #55 / #58 / #59 / #60 family、把 v0.6.0 起累積的「vendor onboarding / 預設行為 / 失效 / 換手 / best-of-breed 收斂」議題系統化
> **依存**：`ai-vendor-onboarding.md`（邀請制基礎）、`cross-ai-handoff.md`（換手協議）、`versioning-migration.md`（版本演化）、`role-separation.md`（角色互鎖前提）
> **保證強度**：多 actor 互檢（vendor 預設行為層 binary hook 攔截 + maintainer 簽收 + doctor 偵測）
> **檢測時點**：init + runtime + post-upgrade
> **since**：v0.12.0

---

## 0. 概念定位（為何引入）

### 0.1 dogfood signal family 累積

charter v0.6.0 〜 v0.12.0 期間累積以下同源 dogfood signal：

| Signal | 日期 | 場景 | family 軸 |
|---|---|---|---|
| **#5** | 2026-04-28 | YC_AIAgentCrew Gemini PM 兩變體繞路（自切 Engineer / 派 generalist sub-agent）| LLM 主動繞路 |
| **#41** | 2026-05-04 | 公司專案 Kiro 找不到 `kiro.md` → fallback 讀 `claude-code.md` → 誤認身份 | vendor fallback 誤讀 |
| **#55** | 2026-05-07 | CryptoBot 反向接入後 user LIVE 發現 Gemini CLI 預設 `generalist` agent 自動分包繞 PM 卡控 | vendor 預設行為層 |
| **#58** | 2026-05-20 | Claude vendor skill abstraction 紀律對齊不完整（v0.9.3 Gemini handler mapping.yaml 抽象化升維未 propagate Claude 端）| 跨 vendor 紀律 propagate 漏 |
| **#59** | 2026-05-21 | path B dogfood 收編 LIVE — `ai-vendor-onboarding §3 step 3` 原設計「first-mover baseline」假設失效、第二個 vendor 優於第一個時失效 | vendor best-of-breed 收斂 |
| **#60** | 2026-05-22 | Gemini CLI 棄用事件（Google I/O 2026 宣布 Antigravity CLI 取代、2026-06-18 對 Pro/Ultra/free 斷線） | vendor 失效 / 換手 |

→ 六個 signal 同源「**charter 紀律 vs vendor 端實際行為 / 生命週期**」軸、v0.6.0 〜 v0.11.x 累積但條款層散在多個既有條款（ai-vendor-onboarding / cross-ai-handoff / role-separation §3.5 / multi-role-tracking §3.4 / 各 vendor spec §3.5.5）。本條款**收編為單一架構級概念**。

### 0.2 對應 framework 設計成熟

charter v0.6.0 邀請制條款（`ai-vendor-onboarding`）解的是「**新 vendor 接入既有角色 / 新角色誕生**」靜態 onboarding。但 vendor 生命週期動態議題未收編：

| 議題 | charter v0.6.0〜v0.11.x 處置 | v0.12.0 收編位置 |
|---|---|---|
| Vendor 預設行為層（signal #5 / #55）違背 charter 卡控 | 散在 `roles/<role>/<vendor>.md §3.5 / §3.5.5` vendor spec 提醒層 | **本條款 §2 vendor 預設行為紀律** |
| Vendor fallback 誤讀（signal #41） | `init-template §3.3.2` step 1/4 防呆 | **本條款 §3 vendor 識別紀律** |
| Vendor 失效 / 棄用（signal #60） | `roles/<role>/<vendor>.md` vendor_status: LEGACY_AUTO_IMPORTED + walkthrough | **本條款 §4 vendor 失效 / 換手紀律** |
| Vendor 之間 best-of-breed 收斂（signal #59）| user explicit 授權 maintainer 代修 path B | **本條款 §5 跨 vendor 收斂紀律** |
| 跨 vendor 紀律 propagate（signal #58）| ad-hoc maintainer sweep | **本條款 §6 跨 vendor 紀律 propagate** |

→ 本條款不取代既有條款、而是**整合 vendor lifecycle 軸的橫切議題**。

---

## 1. 條文

採用 AgentCharter 的 framework + vendor + 採用方關係中：

1. **MUST** 區別 vendor tool 層（如 Gemini CLI / Antigravity CLI binary）⊥ underlying model 層（如 Gemini 3 / Claude Sonnet）— charter A1 公理 vendor 雙軸分解
2. Vendor 預設行為違背 charter 卡控時、**MUST** 在對應 `roles/<role>/<vendor>.md` 標明 + PM init / Engineer init 必對採用方提醒（依 §2）
3. Vendor 失效 / 棄用時、**MUST** 標 `vendor_status: LEGACY_AUTO_IMPORTED`、保留 spec 內容、提供採用方遷移 walkthrough（依 §4）
4. 跨 vendor best-of-breed 收斂時、**MAY** 走 maintainer 代修 path B（user explicit 授權）、但 **MUST** 不破壞既有 vendor spec 的 LIVE 反例自報歷史（依 §5）
5. Charter 紀律演化（如 handler / hook / common-memory-root 變更）**MUST** 同 release propagate 到所有 vendor spec（依 §6）

違反條文 → vendor lifecycle 議題 ad-hoc 處置、紀律一致性破裂、採用方體驗碎片化。

---

## 2. Vendor 預設行為紀律（#5 / #55 family）

### 2.1 偵測場景

| 場景 | 範例 |
|---|---|
| vendor 預設啟用某 agent / plugin / hook 繞 charter 卡控 | Gemini CLI 預設 `generalist` agent 自動分包（signal #55）|
| vendor 預設 prompt / system instruction 與 charter 紀律衝突 | （未來觀察）|
| vendor 預設工具行為（如 commit / push 預設 force）破壞 charter audit trail | （未來觀察）|

### 2.2 處置紀律

1. **PM / Engineer init 必提醒採用方**：在 `roles/<role>/<vendor>.md §3.5.5` 加段、PM init step 1 自我介紹之前必對採用方主動發 reminder（提示對應 disable 指令）
2. **採用方拒絕 disable**：PM 後續每次任務派發前 self_audit 額外項
3. **新 vendor 接入時 maintainer 簽收檢查項**：依 `ai-vendor-onboarding §3 step 4` 簽收前必查「vendor 預設行為清單 vs charter 紀律衝突」

---

## 3. Vendor 識別紀律（#41 family）

### 3.1 場景

vendor AI 接入時找不到自己對應的 `<vendor>.md` → fallback 讀別的 vendor spec → 誤認身份（如 Kiro 讀 claude-code.md 輸出「Claude Code 角色模擬」）

### 3.2 處置紀律

對齊 `core/init-template §3.3.2` step 1 + step 4 防呆（v0.9.10 ship）：

- step 1：若 `<my-vendor>.md` 不存在 → **只讀 `_spec.md` 概念層**、不可 fallback 讀別 vendor spec
- step 4：「若有」= 若存在自己 vendor 的 `.md`、其他 vendor 執行細節不可代入

---

## 4. Vendor 失效 / 換手紀律（#60 family）

### 4.1 場景

vendor 廠商宣布棄用 / 停止維護 / 從 OSS 轉閉源、charter 採用方需遷移到替代 vendor（如 Gemini CLI → Antigravity CLI、2026-06-18）

### 4.2 處置紀律

1. **`vendor_status` 標明**：既有 `roles/<role>/<vendor>.md` frontmatter 加 `vendor_status: LEGACY_AUTO_IMPORTED`（或對應狀態）+ 顯化 tier-specific 影響
2. **不刪 spec 內容**：保留歷史 audit trail（對齊 v0.7.3「不刪 = 培養魚塘」精神 + `violation-reflection §2`「集體記憶才重要」）
3. **新 vendor 接入 path A AI-DRAFTED 平移**：maintainer 從既有 vendor spec path A 平移、標明預估範圍、待真實 vendor AI LIVE 校正升 SIGNED
4. **採用方完整 walkthrough**：`examples/upgrades/v<X>-to-v<Y>-<old-vendor>-to-<new-vendor>-migration.md` 提供 tier 自我判斷 + 10 step 流程 + 6 常見問題

### 4.3 LIVE 校正升 SIGNED 紀律

對應 `ai-vendor-onboarding §3 step 2` 邀請制 path A：

| Status | 含義 |
|---|---|
| DRAFT-AI-DRAFTED-FROM-<source> | maintainer 從既有 vendor spec path A 平移、未經真實 vendor AI 校正 |
| DRAFT-AI-DRAFTED-LIVE-CALIBRATED | 採用方 LIVE 實證部分段（≥ 30%）已校正 |
| SIGNED-v<X.Y> | 真實 vendor AI 完整接入 LIVE 校正 ≥ 80%、maintainer step 4 簽收 |

---

## 5. 跨 vendor best-of-breed 收斂紀律（#59 family）

### 5.1 場景

新 vendor 接入後（依 ai-vendor-onboarding §3 邀請制）、其 vendor spec 某些段優於既有 vendor — 既有 vendor 應反向 regression 收斂 best practice

### 5.2 處置紀律

1. **path B dogfood 收編 pattern**：採用方先具象化 vendor command → maintainer 從產出萃取 vendor spec → step 4 簽收（path B、對應 v0.5.1 self-instantiation 原則反向延伸）
2. **maintainer 代修反向 regression（user explicit 授權）**：違反 v0.6.0 邀請制 letter「charter 不代寫 vendor 層」但對齊 best-of-breed spirit、需 user LIVE 授權
3. **既有 vendor spec LIVE 反例自報歷史不可破壞**：收斂只能加、不能刪既有 §7 Vendor 接入回顧紀律（對齊 `core/violation-reflection §5` append-only log 精神）

---

## 6. 跨 vendor 紀律 propagate 紀律（#58 family）

### 6.1 場景

charter 條款 / handler / hook / schema 變更時（如 v0.9.3 checkpoints_handler.sh mapping.yaml 抽象化升維）、未同步 propagate 到所有 vendor spec、造成跨 vendor 紀律不對齊

### 6.2 處置紀律

對齊 `core/maintainer-discipline §3.4` 文檔層 sync checklist 延伸：

- 修改 `core/<X>.md` 或 `tools/<Y>-spec.md` 時、**MUST** 檢查所有 `roles/<role>/<vendor>.md` 是否需同步 propagate
- 修改 `tools/vendor/commons/<handler>.sh` 時、**MUST** 檢查既有所有 vendor spec 的對應段（如 §3.7 checkpoints handler 引用）是否需 sync
- 跨 vendor 紀律 propagate 漏失 → 由 dogfood signal LIVE 累積 → 條款化（如本 #58 → v0.12.0 收編）

---

## 7. 與其他 core 條款的關係

| 條款 | 關係 |
|---|---|
| `ai-vendor-onboarding.md` | §3 邀請制是本條款 §4 path A AI-DRAFTED 平移的紀律基礎 |
| `cross-ai-handoff.md` | §3.3 directive header 是本條款 §4 vendor 換手的具體執行載體 |
| `versioning-migration.md` | §2 SemVer + §2.3.5 BREAKING-MEDIUM 是本條款 §4 vendor 失效升版的依據 |
| `role-separation.md` | §3.5 繞路禁令是本條款 §2 vendor 預設行為違規的處置條款 |
| `multi-role-tracking.md` | §3.4 身份穩定承諾是本條款 §3 vendor 識別紀律的條款基礎 |
| `maintainer-discipline.md` | §3.4 文檔層 sync 是本條款 §6 跨 vendor 紀律 propagate 的紀律基礎 |
| `init-template.md` | §3.3 self-instantiation 是本條款 §2 PM / Engineer init 必提醒採用方的執行入口 |
| `violation-reflection.md` | §2「集體記憶才重要」+ §5 append-only log 是本條款 §4 不刪 spec + §5 不破壞反例自報歷史的設計原則 |

---

## 8. 對應 dogfood signal 收編

| Signal | 條款化位置 |
|---|---|
| #5（LLM 主動繞路、v0.6.0）| 既有 `role-separation §3.5` + `multi-role-tracking §3.4`、本條款 §2 整合進 vendor 預設行為紀律 |
| #41（vendor fallback 誤讀、v0.9.10）| 既有 `init-template §3.3.2` step 1 + step 4 防呆、本條款 §3 整合 |
| #55（generalist 自動分包、v0.10.5）| 既有 `roles/pm/gemini-cli.md §3.5.5`、本條款 §2 整合 |
| #58（跨 vendor 紀律 propagate 漏、v0.11.0+）| **本條款 §6 新加** |
| #59（first-mover baseline 假設失效、v0.10.6 LIVE）| **本條款 §5 新加** |
| #60（Gemini CLI 棄用、v0.11.0 LIVE）| **本條款 §4 新加**、`roles/pm/gemini-cli.md` v1.9 LEGACY_AUTO_IMPORTED + `roles/pm/antigravity-cli.md` v1.1 path A 是其執行載體 |

→ 六個 signal 同 v0.12.0 release 一次收編為架構級概念第 14 個。

---

## 9. 變更歷史

### v0.1（自 v0.12.0 引入）

**動作**：新增本條款 — 將 v0.6.0〜v0.11.x 累積的 6 個 dogfood signal（#5 / #41 / #55 / #58 / #59 / #60）vendor lifecycle 軸的橫切議題收編為單一架構級概念。

**觸發**：
- 2026-05-22 dogfood signal #60 LIVE（Gemini CLI 棄用）+ user explicit 授權 ship v0.12.0 3 in 1
- 同 release 收編議題已累積 ≥ 6 個同源 signal、架構級概念升維時機成熟

**修訂類型**：MINOR（新增條款 — 對既有採用方無破壞、整合既有散在多條款的紀律為單一架構級概念）；條款數 25 → 26（或 27 含 init-spec-schema）；架構級概念 13 → 14。

**連動範圍**（同 v0.12.0 release、依 `maintainer-discipline §2.2 / §3.4`）：
- `core/init-spec-schema.md`（v0.12.0 同 release 加、Canonical Init Spec Layer、本條款 §6 跨 vendor 紀律 propagate 的具體執行載體）
- `roles/pm/antigravity-cli.md` v1.1（本條款 §4 vendor 失效 / 換手紀律 LIVE 第一次完整實證）
- `roles/pm/gemini-cli.md` v1.9 LEGACY_AUTO_IMPORTED（本條款 §4 對既有 vendor 處置 LIVE 實證）
- `tools/doctor-spec §3.13` W1301 / E1302（本條款 §6 偵測載體）
- `tools/doctor-spec §3.14` W1401（本條款 §4 agents-commons rename migration 偵測）
- `tools/vendor/commons/migrate-to-agents-commons.sh`（本條款 §4 migration script 執行載體）
- `core/charter-config §5` 條款相依表加 vendor-lifecycle entry
- `tools/profiles/{essential,minimal,standard,strict}.yaml` enabled 加 vendor-lifecycle + charter_version 升 `0.12.0`
- `README.md` / `ADOPTION.md` / `TUTORIAL.md` 條款數 25 → 27
- `CHANGELOG.md` v0.12.0 段
