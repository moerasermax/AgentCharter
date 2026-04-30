# Domain Axiom Slot（領域安全公理槽位規範）

> **狀態**：v0.1（自 v0.5.5 引入）
> **位階**：core 通用條款。**框架對「領域公理」這個槽位本身的規範** — 不規範內容，但規範它如何被定義、放在哪、與 core 紀律的優先序。
> **依存**：`charter-config.md`（schema 入口）、`common-memory-root.md`（位置）、`evidence-first.md`（內容紀律）、`role-conflict-resolution.md`（衝突優先序）
> **保證強度**：多 actor 互檢 + 結構強制（路徑 B 紀律「不可在 AI-DRAFTED 啟動 init」由 v0.8.0 三層雙重防禦升結構強制）
> **檢測時點**：init + post-upgrade
> **since**：v0.5.5（v0.7.1 雙路徑 / v0.8.0 三層雙重防禦）

---

## 0. 為何需要本條款（與 template 的差別）

`templates/agent-commons/domain-axioms.md.tpl` 已含**實作模板**（給專案複製貼上）。但兩者位階不同：

| 載體 | 用途 | 對象 |
|---|---|---|
| `templates/agent-commons/domain-axioms.md.tpl` | 實作模板（變數 + 範例 + 撰寫紀律建議）| 採用方專案複製到自己 `protocols/` |
| **本條款** | **框架對該槽位的規範**（位階 / 強制要求 / 違反處置 / 與 core 關係）| 框架自身、`/charter-doctor` 工具、跨 AI 一致性檢查 |

→ 沒有 core 條款，工具無法判斷「本專案的領域公理是否合規」、AI 跨 AI 接班時無共同基準確認領域公理是否到位。

---

## 1. 條文

採用 AgentCharter 的專案**應提供領域安全公理檔**，位置由 `mapping.yaml.domain_axioms.primary` 指定，內容符合本條款規範的最低要求。違反 → `/charter-doctor` 依 §6 嚴重度報錯。

---

## 2. 槽位的位階（與 core 的優先序）

### 2.1 衝突優先序

當領域公理與 core 條款發生衝突時，**領域公理優先**。

| 場景 | 解 |
|---|---|
| 領域公理規定「禁用 float / double 處理金額」，core 無此要求 | 採領域公理 |
| 領域公理「資料庫 schema 修改須三重授權」，core `escalation-protocol §4-B` 允許單次例外 | 採領域公理（更嚴格）|
| Core `output-mode-protocol` 預設 verbose，領域公理規定「外部回覆強制 eco」 | 採領域公理 |
| 領域公理空白 / 無對應規定 | 採 core |

**動機**：
- Core 是**通用紀律**，框架不知道領域差異（A3 公理「專案 ⊥ 框架」）
- 領域公理是**血鐵律**（資金 / 安全 / 合規），違反 → 直接後果（資金損失 / 安全事故 / 合規違反）
- 通用紀律服從領域底線，避免框架越界決定領域風險容忍度

### 2.2 與 `role-conflict-resolution §2` 的對應

`role-conflict-resolution.md §2` 已將「領域 vs 通用衝突」列為衝突類型之一，並標明「領域公理優先」。本條款 §2.1 是其底層理論依據。

---

## 3. 撰寫紀律（最低要求）

下列要求由 `templates/agent-commons/domain-axioms.md.tpl` 的「撰寫紀律」段提煉至 core 層，分**強制**與**建議**：

### 3.1 強制（違反 → /charter-doctor ERROR）

| 紀律 | 動機 |
|---|---|
| **位置存在** | `mapping.yaml.domain_axioms.primary` 指向的檔案實體必存在；缺檔即視為未啟用領域公理 |
| **每條鐵律必含「後果」段** | 違反時的具體損害（資金 / 安全 / 合規），禁模糊「會出錯」「可能有問題」|
| **條款內容可被驗證** | 「禁用 float / double 處理金額」可 grep；「應該寫得好」不可驗。不可驗的條款無法成為紀律 |
| **每條鐵律有獨立編號** | 便於跨檔引用（如 IM、IRON 引用具體條款 ID）|

### 3.2 建議（違反 → /charter-doctor WARN）

| 紀律 | 動機 |
|---|---|
| **分梯結構** | 「血鐵律 vs 架構鐵律」或專案約定的等級分類。便於違反時判斷嚴重度 |
| **修訂只增不刪 + 刪除須三重授權** | 防止熱頭上刪除已驗證的紀律。三重授權（連續確認 3 次）是最低門檻 |
| **每條鐵律引用 IM / event 章節** | 紀律來自實證事件而非空想；引用是審計痕跡 |
| **「已落實」段標明完成事件 ID** | 給未來 AI 看到「此鐵律已內化進工具 / hook」，避免重複實作 |

### 3.3 初次領域公理生成路徑（v0.7.1 加，雙路徑明文）

> **動機**：dogfood signal #12 候選 — user 直接提議「初次要請 AI 代產還是要自己手寫變成一種選擇」（公司接入痛點對話 2026-04-28）。charter `tools/scan-spec.md`（v0.4 起）早就有「AI 讀 codebase 推斷」設計精神，但**領域公理層**沒明示雙路徑 — 導致 user 第一次接入時誤以為「必須 user 主筆從零寫」、心理門檻高。本段顯化雙路徑紀律。

採用方初次寫領域公理檔（`mapping.yaml.domain_axioms.primary` 指向）有兩條合法路徑：

| 路徑 | 動作 | 適用 | 預設 frontmatter |
|---|---|---|---|
| **A. user 主筆**（既有預設） | user 親自寫每條鐵律 | user 對領域底線有明確心智模型；典型場景 | `status: USER-RATIFIED` + `created_by: user` |
| **B. AI 讀 codebase 代產草稿 + user 校** | user 邀請 AI 讀既有 codebase、推斷隱含工程紀律、寫 draft；user 親自校正並升 Status | user 想低門檻起手 / 既有 codebase 已有隱含紀律可被推斷 / AI 有 codebase context 比通用 stub 準 | `status: AI-DRAFTED` + `created_by: ai-drafted` |

**路徑 B 紀律**（對齊 v0.7.0 PROVISIONAL/ACTIVE 二態 + multi-role-tracking §3.4.4）：

| 紀律 | 細節 |
|---|---|
| **AI 不可自升 Status** | AI 寫的 draft `Status: AI-DRAFTED`；升 `USER-RATIFIED` 必須 user **親自**改 frontmatter；違反 = F1（假宣告就位）|
| **每條附推斷依據** | AI 寫的鐵律每條須附「我從哪推斷的」（檔案路徑 + 行號 / grep 結果 / commit hash）— 給 user 校正時知道推斷依據 |
| **不可編造** | AI 只顯化「codebase 真實存在的紀律」；找不到 = 少寫幾條、不要湊數；對應 `failure-modes F3` 防呆 |
| **校正前不啟動 init** | user 校過 axiom 檔（升 RATIFIED）才繼續 charter-init Phase 1-5b；對應 v0.7.0 Phase 5b 物理存在校驗的精神延伸；**v0.8.0 加執行載體**（dogfood signal #23 條款化）：`tools/init-spec.md` Phase 5b CHECK 7 ext + `tools/doctor-spec.md §3.9` E606 + `tools/post-upgrade-verify-spec.md` 軸 D D001 三層雙重防禦 |

**對應載體**：

| 載體 | 內容 |
|---|---|
| `templates/agent-commons/domain-axioms.md.tpl` | 含 frontmatter scaffold（status / mutability_default / created_by / created_at）|
| `templates/agent-commons/domain-axioms-via-ai-draft-prompt.md.tpl` | 路徑 B 觸發 prompt 範本（v0.7.1 新加）|
| `QUICKSTART.md Step 2` | 雙路徑說明 + 路徑 B prompt 連結 |
| `tools/init-spec.md` Phase 5b CHECK 7 | v0.8.0 加 axiom frontmatter status 校驗（init 端 fail-fast、AI-DRAFTED → FAIL）|
| `tools/doctor-spec.md §3.9` | v0.8.0 加 axiom 紀律對齊（任意時點驗證載體、E606/E607/W608） |
| `tools/post-upgrade-verify-spec.md` 軸 D | v0.8.0 加 axiom status 校驗（升版專屬載體、D001/D003/D004） |

**與 `ai-vendor-onboarding.md` 的區別**：

| 條款 | 規範對象 |
|---|---|
| `ai-vendor-onboarding.md`（v0.6.0）| **framework 對 vendor**：charter 不代寫 vendor 層 |
| 本 §3.3（v0.7.1）| **user 對 AI**：採用方專案內、user 邀請 AI 讀自己 codebase 寫領域公理 draft |

兩者**正交**：A3 公理「專案 ⊥ 框架」雙向 — framework 不知領域差異 / 但 framework **不該管 user 跟 AI 在採用方專案內怎麼協作**。

---

## 4. 與其他配置的關係

### 4.1 與 `charter-config.md` 的關係

| `charter-config` 角色 | 細節 |
|---|---|
| `mapping.yaml.domain_axioms.primary` | **位置指標**（必填，charter-config §3）|
| `mapping.yaml.domain_axioms.alias` | 短名稱（如 IRON、HIPAA），便於文件引用 |
| `profile.yaml` 不含領域公理開關 | 領域公理一律啟用；可選的是 core 條款，不是領域公理本身 |

### 4.2 與 `common-memory-root.md` 的關係

領域公理檔典型放在 `<common-memory-root>/protocols/<axiom>.md`。例如：
- CryptoBot：`management/protocols/Dev_Protocol_IRON.md`
- 假想醫療專案：`agent-commons/protocols/HIPAA.md`

`common-memory-root §3` 必含子槽位包含 `protocols/`，本條款是其上的內容規範。

### 4.3 與 `templates/agent-commons/domain-axioms.md.tpl` 的關係

| 載體 | 維護方向 |
|---|---|
| 本條款（core/domain-axiom-slot.md）| 規範**最低要求** + 位階 + 違反處置 |
| Template（templates/agent-commons/domain-axioms.md.tpl）| 提供**實作骨架**（變數、範例、撰寫指引） |

兩處須一致：本條款修改最低要求時，template 須同步調整撰寫指引；template 新增建議撰寫紀律時，若該紀律普世適用，可考慮升格至本條款 §3。

---

## 5. 多領域公理的處理

少數專案有多份領域公理檔（如金融專案同時有 IRON 風控 + 合規 KYC 兩份），處置：

| 情境 | 處置 |
|---|---|
| 多份公理彼此正交（覆蓋不同面向）| `mapping.yaml.domain_axioms.primary` 指向**主檔**；其他列在 `secondary:` 陣列（v0.5+ 候選 schema 擴充）|
| 多份公理彼此衝突 | 視為條款內部問題，須由專案先合併或定優先序，不可丟給 AI 解 |
| 多份公理為同一公理的不同版本 | 只有最新版生效；舊版移到 `archive/` 但不刪（依 §3.2 修訂只增不刪）|

`secondary:` 陣列為 v0.5+ schema 候選，本條款 v0.1 暫不展開實作細節，僅定義概念槽位。

---

## 6. 違反處置（/charter-doctor 檢查）

| 違反類型 | 嚴重度 | 處置 |
|---|---|---|
| `mapping.yaml.domain_axioms.primary` 缺欄位 | ERROR | charter-config §3 已規定為必填；缺即拒絕推進 |
| `primary` 指向的檔案不存在 | ERROR | 違反 §3.1 位置存在 |
| 公理檔內容空白 / 純佔位符 | ERROR | 視為未提供領域公理；採用方須補實質內容 |
| 某條鐵律缺「後果」段 | ERROR | 違反 §3.1 |
| 某條鐵律不可驗證（純抽象描述）| WARN（連續違反升 ERROR）| 違反 §3.1 |
| 缺分梯結構 | WARN | 違反 §3.2 建議 |
| 缺 IM / event 引用 | INFO | 違反 §3.2 建議 |
| 修訂中含刪除但無三重授權紀錄 | ERROR | 違反 §3.2 |

`/charter-doctor` 啟動時逐項檢查，依嚴重度回報。

---

## 7. 與其他 core 條款的關係

| 條款 | 關係 |
|---|---|
| `charter-config.md` | 位置 schema 入口；本條款規範該位置指向的內容 |
| `common-memory-root.md` | 公理檔位置在 `protocols/`；本條款是其內容規範 |
| `evidence-first.md` | §3.1「條款內容可被驗證」與 evidence-first 同源 |
| `role-conflict-resolution.md` | §2.1 衝突優先序「領域 > 通用」是其 §2「領域 vs 通用衝突」的理論依據 |
| `init-template.md §1.2 校準` | init 守門步驟必讀領域公理；本條款規範「該讀什麼」|
| `failure-modes.md` | 公理檔缺漏 / 內容違反紀律 → F4（紀錄偏差）|

---

## 8. 變更歷史

### v0.2（自 v0.7.1 起）

**動作**：新增 §3.3「初次領域公理生成路徑（雙路徑明文）」段 — 顯化路徑 A（user 主筆）vs 路徑 B（AI 讀 codebase 代產草稿 + user 校）；附 `AI-DRAFTED` / `USER-RATIFIED` Status 二態紀律 + 路徑 B 必含「推斷依據」紀律 + 不可自升 Status 紀律。

**觸發**：dogfood signal #12 候選 — user 公司接入痛點對話 2026-04-28 直接提議「初次要請 AI 代產還是要自己手寫變成一種選擇」。同對話 user 第一個提議「condition mutability 三層」(IMMUTABLE-by-AI / APPEND-ONLY / FULL-MUTABLE + 3-strike 刪除) 觸發 dogfood signal #11，本 v0.7.1 同步 ship frontmatter scaffold 預備（紀律本體留 v0.8.0 完整條款化）。

**修訂類型**：PATCH — 顯化既有設計（charter `scan-spec` v0.4 起就有「AI 讀 codebase 推斷」精神 / 本檔 §3.2 「修訂只增不刪 + 三重授權」原本就有）；不破壞既有採用方（既有 user 主筆專案 frontmatter 可後補）。

**連動範圍**（依 `maintainer-discipline §2.2`）：
- `templates/agent-commons/domain-axioms.md.tpl`（v0.7.1 加 frontmatter scaffold + per-clause mutability HTML 註解 + 撰寫指南雙路徑段）
- `templates/agent-commons/domain-axioms-via-ai-draft-prompt.md.tpl`（v0.7.1 新檔 — 路徑 B 觸發 prompt 範本）
- `QUICKSTART.md Step 2`（v0.7.1 加雙路徑說明 / v0.7.6 swap 後從 Step 3 移到 Step 2）

### v0.1（自 v0.5.5 引入）

初版。把 `templates/agent-commons/domain-axioms.md.tpl` 的撰寫紀律提煉至 core 層，並補完 §2 衝突優先序的理論依據、§6 /charter-doctor 違反處置嚴重度分級。
