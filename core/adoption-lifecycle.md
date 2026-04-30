# Adoption Lifecycle（採用生命週期）

> **狀態**：v0.1（自 v0.9.0 引入）
> **位階**：core 通用條款。**lifecycle 完整化** — 不新加架構級概念、屬「升版場景補完」+「棄用 / 重新採用條款化」+「vendor 升級 path 三路徑明示化」。
> **依存**：`versioning-migration.md`（升版主軸 + 跨多版本升級 + 重新採用場景指引）、`ai-vendor-onboarding.md`（vendor 升級 path 三路徑載體）、`handoff-chain.md`（lifecycle 階段轉換的紀律基底）、`cross-ai-handoff.md`（vendor 升級對應跨 AI 接班）、`tools/uninstall-spec.md`（v0.9.0 ship、棄用階段執行載體）
> **保證強度**：多 actor 互檢（lifecycle 階段轉換由 user 授權閘 + maintainer 抽驗共同把關；棄用階段三次確認結構強制）
> **檢測時點**：init + post-upgrade + uninstall（lifecycle 階段轉換時點）
> **since**：v0.9.0

---

## 0. 概念位階（5 階段 lifecycle 定義）

### 0.1 charter v0.7.x 升版場景累積

charter v0.7.5 → v0.8.2 累積 **5 個升版 walkthrough**（對齊 `examples/upgrades/` 目錄）：

| Walkthrough | 場景 | 對應 lifecycle 階段 |
|---|---|---|
| `QUICKSTART.md`（既有）| 全新接入 | 階段 1 全新接入 |
| `examples/upgrades/yc-v0.5.9-to-v0.7.4.md` | 跨多 MINOR 升版 | 階段 2 升版（跨多版本子場景）|
| `examples/upgrades/v0.7.5-to-v0.8.0.md` | 含 BREAKING-LITE | 階段 2 升版（BREAKING-LITE 子場景）|
| `examples/upgrades/v0.8.0-to-v0.8.1.md` | 純擴增 + 新校驗 | 階段 2 升版（純擴增子場景）|
| `examples/upgrades/v0.8.1-to-v0.8.2.md` | 純文檔擴增 | 階段 2 升版（PATCH 子場景）|

→ 升版場景 5 個 walkthrough 收齊、但**棄用 / 重新採用場景無條款**、且**vendor 升級 path 三路徑無條款化**。

### 0.2 5 階段 lifecycle 定義

charter v0.9.0 把採用生命週期條款化為 **5 階段**：

| 階段 | 名稱 | 既有狀況 | v0.9.0 補完 |
|---|---|---|---|
| 1 | **全新接入** | `QUICKSTART.md` 已 ship | 維持、本條款 §2.1 引用 |
| 2 | **升版** | 4 個升版 walkthrough（v0.7.5-v0.8.2）已 ship | 維持、本條款 §2.2 + §4 對齊既有 |
| 3 | **棄用** | ❌ 完全空白 | **本條款 §2.3 + §3 + tools/uninstall-spec.md** |
| 4 | **重新採用** | `versioning-migration §3.4.5` 既有指引（停用一段時間後重新採用）| **本條款 §2.4 + §3 完整化** |
| 5 | **vendor 升級 path** | ❌ 三路徑無條款化 | **本條款 §3 vendor 升級 path 三路徑（A/B/C）** |

### 0.3 對應 SSS S2 設計素材

對應 user LIVE 提案 2026-04-29（STATUS §A v0.8.0 「**SSS S2** v0.8.0/v0.9.0 lifecycle 設計素材含 `/charter-uninstall` + vendor 升級 path 三路徑 + 互學深化 + 框架價值第 4 條候選」）— 本條款 v0.9.0 ship 收編此素材。

### 0.4 「保留最後的溫柔」精神

對齊 charter v0.7.3 北極星「**培養魚塭、不討魚**」+ user 2026-04-29 LIVE 提的「**棄用是有尊嚴的離別、不是 lock-in**」精神：

| 設計取捨 | charter 態度 |
|---|---|
| 強迫採用方留下（lock-in）| ❌ — 違反「培養魚塭、不討魚」精神 |
| 採用方棄用時資產蒸發 | ❌ — 違反「結構承諾穩定」（versioning-migration §2.3）|
| **採用方棄用時 export adoption archive + 三段式確認** | ✅ — 「保留最後的溫柔」、有尊嚴的離別 |

→ 本條款 §2.3 棄用階段紀律對齊此精神。

### 0.5 與 versioning-migration 的位階分工

| 條款 | 主管面向 | 範圍 |
|---|---|---|
| `versioning-migration.md` | 升版主軸（SemVer + 結構穩定承諾 + 遷移流程 + 雙軌版本）| **升版維度（階段 2 為主）+ 階段 4 重新採用 §3.4.5** |
| **本條款** | **5 階段 lifecycle 完整化**（含棄用 + 重新採用 + vendor 升級 path 三路徑）| **lifecycle 維度（階段 1-5）**、與 versioning-migration 互補（不重定義升版 SemVer）|

→ versioning-migration 解決「升版怎麼跑」、本條款解決「**lifecycle 怎麼走完一輪**」。

---

## 1. 條文

採用 AgentCharter 的專案在生命週期內**必經 5 階段**之一（全新接入 / 升版 / 棄用 / 重新採用 / vendor 升級 path），各階段紀律依本條款 §2 規範執行。

階段轉換時點 → 須走對應 walkthrough（既有 5 個 + v0.9.0 新加 v0.8.2-to-v0.9.0）/ tools spec（init-spec / post-upgrade-verify-spec / uninstall-spec）/ 邀請制流程（vendor 升級 path）。

違反 → 該階段視同未完成、後續階段不得啟動（如棄用階段三次確認漏掉、不得進 Phase 2 archive 寫入）。

---

## 2. 各階段紀律

### 2.1 階段 1：全新接入

**執行載體**：`QUICKSTART.md`（既有）+ `tools/init-spec.md` 七 Phase + `tools/scan-spec.md`（A3 LLM 判讀既有專案結構）。

**核心紀律**：
- 走完整 init-spec Phase 1-7 + 5b
- charter_version 寫入 `agent-commons/_config/profile.yaml`
- 角色 self-instantiation（依 `init-template §3.3.2` 八步驟、含 v0.9.0 加的 step 0 讀過去違反紀錄）
- Phase 5b 採用方半邊「自抽自驗」結構性盲區封閉（依 `tools/init-spec.md` v0.7.0 加）

**完成條件**：
- doctor 全綠（依 `tools/doctor-spec.md` 模式 A 五軸）
- `_role.md` 各 AI 具象化位置表 ✅（依 `init-template §3.3.2 step 6` PROVISIONAL → user explicit 授權升 ACTIVE）

→ 此階段對應 `examples/upgrades/` 沒有檔（QUICKSTART 即為 walkthrough）。

### 2.2 階段 2：升版

**執行載體**：5 個既有 walkthrough（含 v0.9.0 ship 的 v0.8.2-to-v0.9.0）+ `tools/post-upgrade-verify-spec.md` 五軸 + `versioning-migration §3.1` 標準 7 步流程。

**核心紀律**：
- 升版前 commit 當前狀態（dirty tree 拒絕升版、依 `versioning-migration §4.2`）
- 跑 doctor pre-check（看 v0.9.0 新校驗如 W1101/W1102 是否觸發、依 `individual-learning-loop §6`）
- 走對應 walkthrough（找最接近的既有升版場景）
- 升版後跑 `/charter-upgrade-verify` 五軸全綠（依 `tools/post-upgrade-verify-spec.md`）
- 升版事件寫進 HANDOFF（依 `handoff-chain §2` 第 3 項「協議版本迭代軌跡」）
- 跨多版本升版場景依 `versioning-migration §3.4` 7 步流程擴充版

**完成條件**：
- post-upgrade-verify 五軸全綠（0 ERROR / 0 WARN）
- `charter_version` commit 升版

→ 對應 `examples/upgrades/` 5 個既有 walkthrough（v0.7.5-to-v0.8.0 / yc-v0.5.9-to-v0.7.4 / v0.8.0-to-v0.8.1 / v0.8.1-to-v0.8.2 + v0.9.0 ship 的 v0.8.2-to-v0.9.0）。

### 2.3 階段 3：棄用

**執行載體**：`tools/uninstall-spec.md`（v0.9.0 ship、Agent B 範圍）/ `/charter-uninstall` slash command（vendor 自具象化、依 `init-template §3.3.2` 同精神）。

**核心紀律**（對應 SSS S2.1 設計素材）：

| Phase | 動作 | 結構強制 |
|---|---|---|
| Phase 1 | **三次確認**（Q1 確定棄用？/ Q2 已備份 agent-commons/？/ Q3 確認執行不可逆操作？）| 三次確認結構強制、缺一視為未確認、不可進 Phase 2 |
| Phase 2 | **export adoption archive**（寫入 `<project>/charter-archive/CHARTER_ADOPTION_REPORT_<date>.md`）| 內容必含：接入摘要 / capsules 統計 / HANDOFF 鏈時間線 / IM entries / protocols snapshot / failure_mode_log 統計 / dogfood signal 觸發紀錄 / 結語 |
| Phase 3 | **level 選擇**（預設 Soft）— Soft / Full / Nuclear | 各 level 對應不同清除範圍、Full / Nuclear 各加額外確認 |
| Phase 4 | **charter clone 處理**（檢查 `~/.agentcharter` 有無其他 active 專案在用、詢問 user 是否刪）| user explicit 授權後才動 |
| Phase 5 | **結束 + 輸出 archive 報告位置** | 給 user 留下「重新採用時可從此 archive 恢復」的具體路徑 |

**核心精神**：「**保留最後的溫柔**」— 對齊 charter v0.7.3 北極星「培養魚塭、不討魚」、棄用是有尊嚴的離別不是 lock-in。

**完成條件**：
- 三次確認全過
- archive 報告寫入完整
- level 選擇對應的清除範圍執行完成
- charter clone 處置 user explicit 授權

### 2.4 階段 4：重新採用

**執行載體**：對齊 `versioning-migration §3.4.5`「停用一段時間後重新採用」既有指引 + 本條款 §2.4 補完 archive 恢復路徑。

**核心紀律**（依 `versioning-migration §3.4.5` 5 步流程）：
1. 讀 `agent-commons/_config/profile.yaml.charter_version`（若 archive 有保留）/ 或讀 `charter-archive/CHARTER_ADOPTION_REPORT_<date>.md` 確認停在哪版
2. 讀 charter `CHANGELOG.md` 從停的版本到當前最新
3. 對照 `examples/upgrades/<closest-case>.md` 找最接近的升版實證
4. 跑 doctor dry-run 抓本專案的具體 migration 點
5. 走 `versioning-migration §3.1` 7 步流程（跨多版本擴充版見 §3.4.3）

**從 archive 恢復路徑**（v0.9.0 新加紀律）：
- 若上一輪走完 §2.3 棄用階段 Nuclear level（agent-commons/ 全砍）
  → archive 報告含 protocols snapshot + IM entries 摘要 → user 對照 archive 重建頂層 protocols/ + 走 §2.1 全新接入流程
- 若上一輪走完 Soft level（保留 _config）
  → 直接走 §2.2 升版階段（從 archive 中的 charter_version 升到當前）

**核心精神**：對齊 charter v0.7.3 北極星「**回鍋開發者無痛**」 — user 停了一年回來、結構承諾仍 hold（依 `versioning-migration §2.3 agent-commons 結構穩定性承諾`）+ archive 報告為輔助記憶。

**完成條件**：
- 對應升版 / 全新接入流程的完成條件達標
- 重新採用事件寫進新 HANDOFF（含「**從 archive 恢復**」標註）

### 2.5 階段 5：vendor 升級 path（三路徑 A/B/C）

**執行載體**：依 `ai-vendor-onboarding §3` 邀請制基底 + 本條款 §3 三路徑明示化。

**觸發條件**：vendor schema / 工具能力 / vendor.md 內容隨 vendor 廠商更新（如 Gemini CLI v0.39.1 載入 toml 失敗、對應 dogfood signal #16 / v0.7.4 條款化）→ 需要 path A/B/C 之一 reactive 處置。

**詳細紀律**：見 §3 vendor 升級 path 三路徑。

---

## 3. vendor 升級 path 三路徑（A/B/C）

對應 SSS S2 設計素材 + SSS S1 user 授權閘精神（依 dogfood signal #21 LIVE prototype 累積）。

### 3.1 三路徑定義

| 路徑 | 動作主體 | 場景 | charter 對齊 |
|---|---|---|---|
| **A：維持現狀** | 採用方（無動作）| vendor schema 變動但採用方 vendor 工具仍可用、不主動升級 | `versioning-migration §2.3` 結構承諾穩定 — 不強迫 |
| **B：開 issue 給 charter** | 採用方 | vendor schema 變動且採用方判斷需 charter maintainer 處置（如 schema 規範本身需更新）| 走 charter GitHub issue 機制、`maintainer-discipline §3.4` 文檔層 sync 啟動 |
| **C：AI 自驅修復對齊新 vendor schema** | 採用方專案內 AI（依 user explicit 授權）| vendor schema 變動且採用方 AI 可自驅對齊（屬 SSS S1 子集 — AI 自治協作 + user 授權閘）| `ai-vendor-onboarding §3 step 2` vendor 主動權精神延伸 |

### 3.2 路徑選擇紀律（user 授權閘）

對齊 SSS S1「**user 授權閘**」精神 — vendor 升級 path 三路徑選擇權**屬 user**：

| 場景 | 預設路徑 | user 授權方式 |
|---|---|---|
| vendor schema 微調、採用方未受影響 | 路徑 A 維持現狀 | 隱式（user 不主動觸發升級即視為選 A）|
| vendor schema 規範性變動 | 路徑 B 開 issue 給 charter | user explicit 開 issue（如 GitHub issue / 對話 framing）|
| vendor schema 變動 + 採用方 AI 已具備自驅修復能力 | 路徑 C AI 自驅 | **user explicit 授權**（依 `multi-role-tracking §3.4` 身份穩定承諾「上岸需 user explicit 授權」精神延伸）|

→ 採用方 AI 不可自選路徑 C 自驅（會違反 SSS S1 user 授權閘 + multi-role-tracking 自我激活禁令）。

### 3.3 路徑 C 詳細紀律（AI 自驅修復）

當 user explicit 授權路徑 C，採用方 AI 執行紀律：

| 步驟 | 動作 | 條款依據 |
|---|---|---|
| 1 | 讀新 vendor schema（依 `ai-vendor-onboarding §3 step 2` vendor 自評能力精神）| ai-vendor-onboarding §3 |
| 2 | 對照採用方 vendor.md 既有實作、列出 diff | `maintainer-discipline §2.2` 引用範圍對齊 |
| 3 | 修補 vendor.md 對齊新 schema、保留既有能力盲區聲明 | `ai-vendor-onboarding §3 step 2` vendor 主動權 |
| 4 | 跑 doctor + post-upgrade-verify 全綠 | `tools/doctor-spec.md` + `tools/post-upgrade-verify-spec.md` |
| 5 | commit + 寫進 HANDOFF（含「路徑 C 自驅修復」標註）| `handoff-chain §2` 第 3 項協議版本迭代軌跡 |

→ 路徑 C 完成後、若 maintainer review 認為修補對所有採用方有價值 → 提 PR 給 charter（升維到路徑 B）。

### 3.4 SSS S1「user 授權閘」prototype 累積

對應 dogfood signal #21（user LIVE prototype 累積、依 STATUS §A v0.8.0 「user 不自抽驗、AI 跑 verify、user 看報告即授權」）— vendor 升級 path 三路徑是 SSS S1 一個具體子集。

→ 本條款 §3.2 的「user 授權閘」紀律是 SSS S1 在 vendor 升級維度的條款化落地。未來 SSS S1 累積成熟 → 可能升維為架構級概念（v0.x.y 後續 release）。

---

## 4. 與既有 walkthrough 對齊（5 個既有 → lifecycle 階段映射）

### 4.1 既有 walkthrough → 階段映射

| Walkthrough | 路徑 | 對應階段 | 子場景 |
|---|---|---|---|
| `QUICKSTART.md` | 根目錄 | 階段 1 全新接入 | 主場景 |
| `examples/upgrades/yc-v0.5.9-to-v0.7.4.md` | examples/ | 階段 2 升版 | 跨多 MINOR 子場景 |
| `examples/upgrades/v0.7.5-to-v0.8.0.md` | examples/ | 階段 2 升版 | BREAKING-LITE 子場景 |
| `examples/upgrades/v0.8.0-to-v0.8.1.md` | examples/ | 階段 2 升版 | 純擴增 + 新校驗 子場景 |
| `examples/upgrades/v0.8.1-to-v0.8.2.md` | examples/ | 階段 2 升版 | 純文檔擴增 子場景 |
| `examples/upgrades/v0.8.2-to-v0.9.0.md`（v0.9.0 ship、Agent C 範圍）| examples/ | 階段 2 升版 | MINOR 含新加 condition + 新範本 + 新 preset 子場景 |

### 4.2 v0.9.0 後 walkthrough 補完優先序

依 charter「**頻繁小擴增**」雙軌節奏（`versioning-migration` 隱性、v0.7.4 條款化）：

| 場景 | walkthrough 補完優先 |
|---|---|
| 階段 3 棄用走查 | tools/uninstall-spec.md 已含 5 Phase（v0.9.0 Agent B ship）、未來可補 `examples/uninstall/<scenario>.md` |
| 階段 4 重新採用走查 | `versioning-migration §3.4.5` 既有 5 步流程、未來可補 `examples/re-adoption/<scenario>.md` |
| 階段 5 vendor 升級 path 走查 | 本條款 §3 既有規範、未來可補 `examples/vendor-upgrade/<vendor>.md`（依 `ai-vendor-onboarding §3 step 4` maintainer 簽收 + 邀請制節奏）|

→ v0.9.0 ship 不強制全寫、依 dogfood-driven hardening 節奏累積觀察後補（避免一次寫太多 walkthrough 過早抽象）。

---

## 5. 與其他 core 條款的關係

| 條款 | 關係 |
|---|---|
| `versioning-migration.md` | 本條款 §2.2 升版階段紀律完全建立在 versioning-migration §3.1 標準 7 步流程 + §3.4 跨多版本升級之上、不重定義；§2.4 重新採用階段對齊 versioning-migration §3.4.5 既有指引、本條款補完 archive 恢復路徑 |
| `ai-vendor-onboarding.md` | §3 邀請制四步驟是本條款 §3 vendor 升級 path 三路徑的執行載體；路徑 C 對齊 ai-vendor-onboarding §3 step 2 vendor 主動權精神延伸 |
| `handoff-chain.md` | 各階段轉換時點寫進 HANDOFF（本條款 §2.2 / §2.4 / §3.3 步驟 5 都對齊 handoff-chain §2 必含項）|
| `cross-ai-handoff.md` | vendor 升級 path 場景若涉及廠商換手 → 同時走 cross-ai-handoff §3 / §4 退出方 + 接班方紀律 |
| `init-template.md` | 階段 1 全新接入 + 階段 4 重新採用「從 archive 恢復」路徑、AI self-instantiation 走 init-template §3.3.2 八步驟（含 v0.9.0 加 step 0）|
| `multi-role-tracking.md` | 階段 5 vendor 升級 path 路徑 C 對齊 multi-role-tracking §3.4 身份穩定承諾「上岸需 user explicit 授權」精神延伸（採用方 AI 不可自選路徑 C）|
| `role-conflict-resolution.md` | §5.4 角色切換決策權屬 user 對齊本條款 §3.2 user 授權閘精神（決策權屬 user）|
| `domain-axiom-slot.md` | 領域公理（資金 / 安全 / 合規）跨階段保留 — 即使階段 3 棄用 Nuclear level 仍須 archive 保留 protocols/ snapshot（依 §2.3 Phase 2 archive 內容）|
| `maintainer-discipline.md` | §3.4 文檔層 sync 對齊本條款各階段轉換的文檔層紀律（含 v0.9.0 ship 的 v0.8.2-to-v0.9.0 walkthrough 連動）|
| `individual-learning-loop.md` | 階段轉換時點（如棄用階段 archive / 重新採用階段恢復）對應 individual-learning-loop §3 跨 session 學習迴圈精神延伸（lifecycle 維度的學習迴圈）|
| `diagnose-remediate-protocol.md` | 各階段執行載體（init-spec / post-upgrade-verify-spec / uninstall-spec）依 diagnose-remediate-protocol §2 spec-as-data 四欄結構強制升維 |

---

## 6. 對應 /charter-uninstall 工具引用

階段 3 棄用的執行載體：`tools/uninstall-spec.md`（v0.9.0 ship、Agent B 範圍）。

vendor 端 slash command（vendor 自具象化、依 `ai-vendor-onboarding §3` 邀請制 + `init-template §3.3.2` self-instantiation 精神）：

| Vendor | slash command 位置 |
|---|---|
| Claude Code | `.claude/commands/charter-uninstall.md` |
| Gemini CLI | `.gemini/commands/charter-uninstall.toml`（或對應 Gemini 慣例）|
| Cursor | `.cursor/rules/charter-uninstall.mdc` |
| 無 slash 系統 | 走純 prompt（user 手動貼）|

→ 對齊 `init-template §3.3.2` 既有 self-instantiation 紀律，charter 不代生成、vendor 自具象化。

---

## 7. 對應 dogfood signal

| Signal | 日期 | 事件 | 對應本條款段 |
|---|---|---|---|
| **#16** | 2026-04-30 | YC_AIAgentCrew 升版時 Gemini CLI v0.39.1 載入 toml 失敗（v0.7.4 vendor schema 條款化）| §2.5 階段 5 vendor 升級 path + §3 三路徑 |
| **#21**（SSS S1 prototype）| 多次 LIVE | user 授權閘精神累積（user 不自抽驗、AI 跑 verify、user 看報告即授權）| §3.2 路徑選擇紀律（user 授權閘）+ §3.4 SSS S1 prototype 累積 |
| **#22**（SSS S2 設計素材）| 2026-04-29 LIVE | user LIVE 提案 lifecycle 設計含 `/charter-uninstall` + vendor 升級 path 三路徑 + 互學深化 + 框架價值第 4 條候選 | §0.3 對應 SSS S2 設計素材 + §2.3 / §3 全段 |

未來再撞到同類觀察時：

- 若各階段 walkthrough 已補完 → 採用方依 `examples/<phase>/<scenario>.md` 直接 reference
- 若仍漏 → 加 dogfood signal 累積到 NEXT.md，evaluate 是否升級條款（如棄用階段強制 archive 校驗、或 vendor 升級 path 路徑 D 候選）

---

## 8. 變更歷史

### v0.1（自 v0.9.0 引入）

初版。對應 SSS S2 設計素材（user LIVE 提案 2026-04-29、含 `/charter-uninstall` + vendor 升級 path 三路徑 + 互學深化）的條款化、不新加架構級概念、屬「**升版場景補完 + 棄用 / 重新採用條款化 + vendor 升級 path 三路徑明示化**」。

**設計學意義**：charter v0.7.x 升版場景累積 5 個 walkthrough、但 lifecycle 不完整（棄用 / 重新採用 / vendor 升級三路徑無條款）— 本條款條款化 5 階段 lifecycle、配合 `tools/uninstall-spec.md`（v0.9.0 Agent B ship）落地階段 3 棄用執行載體。對齊 charter v0.7.3 北極星「**培養魚塭、不討魚**」+「**回鍋開發者無痛**」雙精神。

配合 v0.9.0 同 release 的 ① individual-learning-loop（個體學習迴圈）+ ② diagnose-remediate-protocol（紀律執行循環依賴解）+ ④ condition-mutability（紀律本體），charter 完成「**紀律完整性 + AI 自我覺察升維**」轉折。
