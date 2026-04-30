# Diagnose-Remediate Protocol（診斷—修補引導式紀律協議）

> **狀態**：v0.1（自 v0.9.0 引入）
> **位階**：core 通用條款。**設計層引導式紀律** — 不新加架構級概念、屬 v0.8.1 SSS S3 起手實證的架構級條款化。
> **依存**：`violation-reflection.md`（紀律執行底層）、`failure-modes.md`（F6 surface vs structural sub-pattern）、`structural-anti-fabrication.md`（真實 stdout 證據要求精神延伸）、`ai-vendor-onboarding.md`（vendor 邀請制基底）、`tools/doctor-spec.md` / `tools/init-spec.md` / `tools/post-upgrade-verify-spec.md`（執行載體）
> **保證強度**：結構強制（spec-as-data 四欄結構強制 + 真實 stdout 證據要求；vendor 邀請制 commit hook 結構強制升維）
> **檢測時點**：runtime（任意時點 spec 校驗）+ post-upgrade（升版後 verify）+ commit（vendor 端 hook）
> **since**：v0.9.0（v0.8.1 doctor §3.7-§3.9 起手實證）

---

## 0. 概念位階（spec-driven vs LLM 自律循環依賴解）

### 0.1 charter v0.7.x 設計矛盾

charter v0.7.x 累積「**spec-driven 紀律**」（doctor / init / verify 工具 spec 完整、條款體系 21 條），但所有工具實際執行**循環依賴 LLM 自律**（multi-perspective 結構師金礦指認、user LIVE 公司專案實證）：

| 環節 | 既有狀況 | 循環依賴 |
|---|---|---|
| `/charter-doctor` 跑校驗 | AI 自跑、ERROR code 自由解讀 | AI 可能 simulated 修補（dogfood signal #31）|
| `/charter-init` 流程 | AI 自跑七 Phase、自查 templates | AI 不查 templates 自編格式（dogfood signal #32）|
| `/charter-upgrade-verify` | AI 自跑五軸、自報結果 | AI 可能漏跑某軸但宣告「全綠」（F6 surface vs structural）|
| violation-reflection 補交 | 抽驗方退稿、宣告方主動補 | AI 不主動補交（dogfood signal #33）|
| commit hook 攔截 | 不存在 | 結構強制完全空白 |

→ 「**spec-driven 紀律 + AI 自跑工具**」表面看起來閉環、實際**仍依賴 AI 自律**、沒有結構強制升維。

### 0.2 v0.8.1 SSS S3 起手實證

charter v0.8.1 在 `tools/doctor-spec.md §3.7-§3.9` 起手實證 **spec-as-data 四欄擴展**（每個 ERROR code 加四欄結構：合規規定 / 修補方向 + 約束 / 反例 / 真實 stdout 證據要求）— 把 spec 從「**靜態文檔**」升維為「**機器可讀的引導式紀律資料**」。

v0.9.0 條款化此精神、升維到完整實作：

| 階段 | 範圍 | 強度 |
|---|---|---|
| v0.8.1（起手）| doctor §3.7-§3.9 ERROR code 四欄擴展 | 局部試點 |
| v0.8.2（連續）| 21 條 condition 加雙軸 blockquote、framing 第一段 | 設計層 framing |
| **v0.9.0（本條款）** | **propagate 全 spec（doctor 全項 + init / post-upgrade-verify / 任何新 spec）+ vendor 邀請制 commit hook + 真實 stdout 證據要求結構強制** | **結構強制升維** |

### 0.3 引導式紀律 vs 封鎖式 / freelance 三軸

對齊 charter 既有「**引導式紀律 > 封鎖式 / freelance**」精神（charter 三層精神：不代寫 / 給結構引導 / 留 AI 主動權）：

| 風格 | 表現 | charter 取捨 |
|---|---|---|
| 封鎖式（hard block）| spec 寫死、AI 完全照做、零自由度 | ❌ — 違反「角色 ⊥ AI」公理、不同 vendor 工具差異無法兼顧 |
| freelance（無 spec 引導）| AI 自由解讀、自由執行 | ❌ — 既有狀況、循環依賴 LLM 自律 |
| **引導式（spec-as-data + 四欄）** | **spec 顯化合規規定 + 修補方向 + 反例 + 證據要求、AI 仍主動執行但有結構引導** | ✅ — 本條款主軸 |

→ 本條款是 charter「引導式紀律」精神在**工具 spec 層**的具體落地。

### 0.4 與既有條款的位階分工

| 條款 | 主管面向 | 動作主體 |
|---|---|---|
| `structural-anti-fabrication.md` | 一般宣告（capsule / handoff / 完工交付）的結構強制證據欄位 | 宣告方 + 抽驗方 |
| `violation-reflection.md` | 違規事件後的反省紀錄結構 | 違規方 |
| **本條款** | **工具 spec 層**（doctor / init / verify）+ **commit hook 邀請制** + **任意時點 spec 校驗的引導式結構** | **vendor + maintainer + 工具執行端**（含 AI / commit hook / 任何抽驗載體）|

→ structural-anti-fabrication 是「**寫產出物時**」結構強制；本條款是「**寫工具 spec 時 + 跑工具時**」結構強制。

---

## 1. 條文

charter 對所有「**校驗類 spec**」（含 `tools/doctor-spec.md` / `tools/init-spec.md` / `tools/post-upgrade-verify-spec.md` 及 v0.9.0 後新增的任何校驗 spec）**必須**採用 **spec-as-data 四欄結構**（依 §2 規範）+ **真實 stdout 證據要求**（依 §2.4）。

且採用 charter 的 vendor（依 `ai-vendor-onboarding.md` 邀請制）**可選**實作 commit hook 邀請制加固（依 §4），charter 概念層不寫死實作、僅規範概念紀律。

違反 → maintainer 抽驗時退回（依 `maintainer-discipline.md §3.1` auditor 校驗精神延伸）；採用方層工具 spec 漏 spec-as-data 結構視同 v0.8.x 既有 spec drift（依 `maintainer-discipline §3.4.1` 條款層連動 sync）。

---

## 2. spec-as-data 結構（四欄 + 真實 stdout 證據）

### 2.1 四欄結構規範

每個 ERROR code / 校驗項在 spec 內必含**四欄**：

| 欄 | 內容 | 對應 |
|---|---|---|
| **欄 1：合規規定**（charter ground truth、寫死）| 必須狀態 / 禁止狀態 + 對齊條款引用 | charter 條款體系本體（不可被 AI 解讀為「視情況而定」）|
| **欄 2：修補方向 + 約束**（必動 / 不可動 / 不可代決 / 推薦路徑）| ✅ 必動 / 🚫 不可動 / 🚫 不可代決 / 推薦路徑 | 給 AI 修補時的結構引導（防 freelance）|
| **欄 3：反例段**（charter 已駁回的 anti-pattern + 對應正解）| ❌ AI 常見誤解 / ✅ 正解 | 顯化過去 dogfood signal 已封閉的 anti-pattern（防同類復發）|
| **欄 4：真實 stdout 證據要求**（每 PASS 必附 binary stdout、不能純文字）| 校驗工具 / 命令 / 期望 stdout 格式 | 結構強制證據欄位、對齊 structural-anti-fabrication 精神延伸 |

→ v0.8.1 doctor §3.7-§3.9 已起手實證（E601 / E602 / E603 / E604 詳盡引導段為 reference 樣本）。v0.9.0 propagate 全 spec。

### 2.2 為何四欄（與 charter 「引導式紀律」精神對齊）

| 替代方案 | 缺點 |
|---|---|
| 一欄（只寫 ERROR code 名）| 既有 v0.5-v0.7 模式 — AI 自由解讀、可 simulated 修補（signal #31）|
| 二欄（ERROR code + 修補建議）| 仍 freelance — 沒寫死「不可動」/「不可代決」、AI 越界決策 |
| 三欄（+ 反例）| 漏「真實 stdout 證據要求」— PASS 純文字宣告無從證偽（F6 surface vs structural）|
| **四欄（spec-as-data）** | charter 已駁回 anti-pattern + 結構引導 + 證據要求 + ground truth 四向對齊 |

→ 四欄是「**spec 從靜態文檔升維為機器可讀資料**」的最低結構。

### 2.3 各 spec 對齊路線

| spec | 既有狀況 | v0.9.0 對齊 |
|---|---|---|
| `tools/doctor-spec.md` §3.7-§3.9 | v0.8.1 起手、E601-E604 已四欄 | 全項 propagate（§3.10 W901 / §3.11 W1101-E1103 等所有 ERROR code 必四欄）|
| `tools/init-spec.md` Phase 1-7 + 5b | v0.7.0 加 Phase 5b 但 ERROR code 無四欄 | 每個 Phase 失敗點對齊四欄 |
| `tools/post-upgrade-verify-spec.md` 五軸 | v0.8.0 ship、軸 A-E 各 ERROR | 每軸 ERROR 對齊四欄（含 v0.9.0 補完模式 B/C 的新 ERROR）|
| 未來新 spec | — | 強制走四欄（不可回退）|

### 2.4 真實 stdout 證據要求（signal #31 加固）

對齊 `structural-anti-fabrication.md §1` 精神延伸到 verify 工具層：

| 校驗結果 | 證據要求 |
|---|---|
| **PASS** | 必附該校驗對應的 binary stdout（如 `ls -la <path>` / `git log --oneline -1` / 工具命令 + 真實輸出）|
| **FAIL** | 必附觸發 FAIL 的 stdout 證據 + 對應 ERROR code 四欄引導 |
| **SKIP** | 必附 skip 原因 + 對齊條款（如「essential preset 不啟用此校驗、依 profile.yaml 對應」）|

純文字 PASS / FAIL 宣告（無 stdout 證據）→ 視同 violation-reflection §1 假宣告、抽驗方有權直接退稿（依 `audit-rights.md §3` 抽驗 SOP）。

→ 對齊 dogfood signal #31（simulated slash command）— 此處結構強制「**沒 stdout 就視同未交付**」。

---

## 3. 弱保證項清單派生（從雙軸標籤派生）

### 3.1 概念

charter v0.8.2 為 21 條 condition 加雙軸 blockquote 三行（保證強度 / 檢測時點 / since）— 雙軸標籤本身可派生「**弱保證項清單**」：哪些條款是「單 actor 自律」（弱保證）、哪些是「結構強制」（強保證）。

弱保證項在實際運行時最容易循環依賴 LLM 自律 → 本條款 §2 / §4 優先針對弱保證項加固。

### 3.2 派生邏輯

| 雙軸標籤 | 派生分類 | v0.9.0 處置 |
|---|---|---|
| 「結構強制」單軸 | 強保證 — 不需額外加固 | 維持 |
| 「多 actor 互檢」單軸 | 中保證 — 抽驗方意願依賴 | 由 `audit-rights.md` 既有機制覆蓋 |
| 「單 actor 自律」單軸 | **弱保證 — 循環依賴 LLM 自律** | **本條款 §4 vendor 邀請制 commit hook 候選加固對象** |
| 混合（如「結構強制 + 單 actor 自律輔助」）| 中—強混合 | 維持、但弱保證子段為加固候選 |

### 3.3 派生方式（手寫 OR 由 lint binary 派生）

| 派生路徑 | 適用 | 強度 |
|---|---|---|
| 手寫派生（maintainer 整理）| v0.9.0 ship 階段（21 + 4 = 25 條全列）| 一次性、易維護 |
| lint binary 派生（如 grep `保證強度` 自動分類）| v0.9.x PATCH 落地 | 自動同步、跨 release 一致 |

→ v0.9.0 階段以手寫派生為主、lint binary 自動派生為 future enhancement（對齊 charter v0.5.9「不附 binary」原則 — 由 vendor 邀請制實作）。

---

## 4. vendor 邀請制 commit hook 加固（signal #33 結構強制升維）

### 4.1 動機（dogfood signal #33 對應）

dogfood signal #33（failure-mode 自報失效）：AI 命中 F-mode 後**不主動補交** violation-reflection、依賴抽驗方退稿觸發 — 但若抽驗方漏抽、F-mode 命中 entry 留在 `failure_mode_log.md` 但對應個體層 reflection 不存在。

→ 結構強制升維解：**commit 時若 commit message 標 F-mode 命中、`failure_mode_log` 必有對應 entry、`reflections/` 必有對應檔；否則拒絕 commit**。

### 4.2 charter 概念層（本條款 §1）vs vendor 層（各自實作）

對齊 `ai-vendor-onboarding.md §3` 邀請制四步驟：

| 層 | 角色 | 動作 |
|---|---|---|
| charter 概念層（本條款）| maintainer | 寫紀律：「**commit 時若 AI 標 F-mode 命中、failure_mode_log 必有對應 entry + reflections/ 必有對應檔、否則退稿**」 |
| vendor 層（claude-code.md / gemini-cli.md / cursor.md）| 各 vendor | 各自實作 commit hook（依自己 vendor 工具能力 — Claude Code 用 hooks / Gemini CLI 用對應機制 / Cursor 用 rules）|
| maintainer 簽收層 | maintainer | review vendor commit hook 實作是否對齊本條款紀律、簽收 |

→ charter **不寫死任一 vendor 實作**（對齊 v0.5.9「不附 binary」原則 + ai-vendor-onboarding §1 邀請制原則）。

### 4.3 邀請制 commit hook 紀律最低要求

vendor 實作的 commit hook 必須涵蓋：

| 校驗點 | 觸發條件 | 對應條款 |
|---|---|---|
| F-mode 命中對應 reflection 存在 | commit message / 文件異動 偵測到 F-mode entry | `individual-learning-loop §2` 雙寫紀律 |
| reflection frontmatter 完整 | 偵測到 reflection 新檔 | `individual-learning-loop §2.3` |
| 校驗結果有 stdout 證據 | commit 含 verify 報告但無 stdout | 本條款 §2.4 真實 stdout 證據要求 |
| 擴展空間 | vendor 自選 | vendor 主動權（對齊 `ai-vendor-onboarding §3 step 2`）|

→ vendor 實作的 hook 內容**可以更嚴**（vendor 主動權）、**不可以更鬆**（charter 概念層保底）。

### 4.4 vendor 拒絕實作的 fallback

對齊 `ai-vendor-onboarding §0.3`「邀請制原則」+ `versioning-migration §2.3`「不破壞既有採用方」精神：

| vendor 狀況 | fallback |
|---|---|
| vendor 實作 hook 對齊本條款 | ✅ 結構強制升維落地 |
| vendor 暫未實作 hook | ⚠️ 退化到既有 v0.8.x 紀律（依 `audit-rights` + `violation-reflection §1` 抽驗方意願執行）|
| vendor 明示 hook 能力盲區 | ⚠️ vendor.md 顯式聲明、由 maintainer 簽收 + 記錄為已知 fallback |

→ charter 不強制 vendor 必實作 hook（依邀請制原則、vendor 主動權）；但概念層紀律本身對所有 vendor 適用。

---

## 5. 與其他 core 條款的關係

| 條款 | 關係 |
|---|---|
| `violation-reflection.md` | §3 五段結構是本條款「真實 stdout 證據要求」的 prior art；本條款 §2.4 延伸到工具 spec 層、§4 commit hook 結構強制升維是 violation-reflection §1「抽驗方拒絕進入下個任務」精神的工具化 |
| `failure-modes.md` | F6 surface vs structural sub-pattern（v0.7.0 加）是本條款 §0.1 循環依賴的最直接對應；本條款 §2.4 真實 stdout 證據要求直接打擊 F6 surface-level 完成感 |
| `structural-anti-fabrication.md` | §1 條文（事實型宣告依賴文檔結構強制證據欄位）是本條款 §2.4 的 prior art；本條款延伸到工具 spec 層（不只「寫產出物」、也「寫 spec」）|
| `evidence-first.md` | §3.2 證據格式建議與本條款 §2.4 對齊；本條款結構強制升維到 spec 層級 |
| `audit-rights.md` | §3 抽驗 SOP 與本條款 §2.4 配合 — 純文字 PASS / FAIL 缺 stdout 視同未交付、抽驗方有權直接退稿 |
| `ai-vendor-onboarding.md` | §3 邀請制四步驟是本條款 §4 commit hook 加固的執行載體；vendor 主動實作 hook 對齊 `ai-vendor-onboarding §3 step 2` vendor 主動權精神 |
| `maintainer-discipline.md` | §3.1 工具層 spec-driven self-check 與本條款 §1 對齊；§3.4.1 條款層連動 sync 是本條款的執行紀律延伸 |
| `individual-learning-loop.md` | 本條款 §4 commit hook 校驗點之一是 individual-learning-loop §2 雙寫紀律；兩條款互為加固機制 |
| `versioning-migration.md` | 本條款 §4.4 vendor fallback 對齊 versioning-migration §2.3「不破壞既有採用方」精神 |
| `domain-axiom-slot.md` | 領域公理校驗（如資金 / 安全）四欄結構同樣強制；本條款不重定義、領域公理優先（依 domain-axiom-slot §2.1 衝突優先序）|

---

## 6. 對應 dogfood signal

| Signal | 日期 | 事件 | 對應本條款段 |
|---|---|---|---|
| **#27** | 2026-04-29 | spec-driven 循環依賴 reality check（multi-perspective 結構師金礦指認）| §0.1 循環依賴對應 + §1 條文 |
| **#30** | 2026-04-30 LIVE | LLM 砍 fork 內容（不對齊 charter ground truth）| §2.1 欄 1 合規規定（寫死 ground truth）+ §2.3 欄 3 反例段 |
| **#31** | 2026-04-30 LIVE | simulated slash command（非真實 stdout 而宣告 PASS）| §2.4 真實 stdout 證據要求 |
| **#32** | 2026-04-30 LIVE | LLM 不查 templates（不查 charter 既有資源）| §2.1 欄 2 修補方向（推薦路徑指向 charter 資源）+ `individual-learning-loop §3` step 0 互補 |
| **#33** | 2026-04-30 LIVE | failure-mode 自報失效（不主動補 reflection）| §4 vendor 邀請制 commit hook 加固 |

未來再撞到同類觀察時：

- 若 vendor commit hook 已實作 → 應被自動偵測
- 若仍漏 → 評估升級條款（如 §4 從邀請制升強制 + 加 maintainer 簽收門檻）

---

## 7. 變更歷史

### v0.1（自 v0.9.0 引入）

初版。對應 v0.8.1 SSS S3 起手實證（doctor §3.7-§3.9 四欄擴展）的架構級條款化、不新加架構級概念、屬「**設計層引導式紀律**」。

**設計學意義**：charter「**spec-driven 紀律 + AI 自跑工具**」表面閉環、實際循環依賴 LLM 自律 — 本條款把 spec 從「**靜態文檔**」升維為「**機器可讀的引導式紀律資料**」。配合 v0.9.0 同 release 的 ① individual-learning-loop（個體學習迴圈雙寫 + step 0 強制讀）+ ③ adoption-lifecycle（lifecycle 完整化）+ ④ condition-mutability（紀律本體），charter 完成「**紀律完整性 + AI 自我覺察升維**」轉折。

對應 dogfood signal #27 / #30 / #31 / #32 / #33 五個 signal 同 release 條款化、屬 charter dogfood-driven hardening 第十七循環核心收編。
