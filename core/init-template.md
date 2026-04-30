# Role Init Mandate（角色初始化職責規範）

> **狀態**：v0.5.0 — 升格為職責規範（v0.4 僅為「五步驟骨架」）
> **位階**：core 通用條款。**抽象規範 + 具象化指引**雙層。
> **保證強度**：結構強制（核心 step 5 doctor schema 驗證；step 7 self-instantiation 自驅屬單 actor 自律輔助）
> **檢測時點**：init
> **since**：v0.5.0（v0.5.10 加 step 5 / v0.7.0 加 step 6 PROVISIONAL/ACTIVE）

---

## 0. 概念位階 — Init 是什麼

Role Init 是接班 AI 進入角色身份的**召喚與校準機制**，相當於：

| 比喻 | 含義 |
|---|---|
| **使用者分身** | 接班 AI 透過 init 對齊使用者意圖；無 init = 無分身 |
| **造物主** | init 「召喚」AI 進入角色，並「校準」其認知 |
| **守門人** | init 拒絕未對齊的 AI 進入工作（缺協議、缺路徑、缺權限）|

**核心地位**：Init 是多 AI 協作的**入口契約**。任何角色被任何 AI 扮演，都必須通過此契約。

→ 因此 Init 不是「Claude Code 的方便指令」，而是**框架級職責規範** — Claude / Gemini / Cursor / 任何 AI 都須各自具象化這個職責。

---

## 1. Init 的核心職責（抽象，所有 AI 都要做）

任何 AI 扮演任何角色時，init 必須完成以下 **四大職責**：

### 1.1 召喚（Summon）

讓接班 AI 進入正確角色身份。動作：

- 讀 `<charter>/roles/<role>/_spec.md`（職能定義）
- 讀 `<charter>/roles/<role>/<ai-vendor>.md`（該 AI 的執行細節）
- 讀 `<common-memory-root>/roles/<role>/_role.md`（該專案的角色身份檔）
- 確認 AI 廠商與 `_role.md` 紀錄一致（不一致即視為跨 AI 接班場景）

### 1.2 校準（Calibrate）

讓接班 AI 對齊當前專案狀態。動作：

- 讀領域公理（`<common-memory-root>/protocols/<axiom>.md`）
- 讀啟用的所有 `core/*` 條款（依 `profile.yaml`）
- 讀最近 HANDOFF（`<common-memory-root>/handoffs/HANDOFF_<latest>.md`）
- 讀 NextWork（`<common-memory-root>/nextwork.md`）
- 讀失敗模式累積紀錄（`<common-memory-root>/state/failure_modes.log`）
- 套用當前模式（eco / verbose，依 `<common-memory-root>/state/output_mode`）

### 1.3 簽名（Sign-in）

留下「我是誰、何時到的」的審計痕跡。動作：

- 更新 `_role.md` 切換歷史表（加一行：日期 / AI 廠商 / 觸發原因）
- 在歷史紀錄留下審計 trail，便於後續跨 session 追蹤

### 1.4 守門（Gatekeep）

確認就緒狀態，否則拒絕推進。動作：

- 確認協議檔案存在（依 `evidence-first.md`，用工具證實）
- 確認共同記憶根目錄與必含子槽位齊全
- 確認對方角色是否在強化抽驗模式（若是，本 session 對其結案宣告強制要求附 stdout 原文）
- **讀最新 DRAFT_CONTEXT**（若啟用 `working-stack-discipline`）— size > 0 表示有 session 內未 save 的累積，依其 §5 接班動作對齊
- 全綠 → 進入待命狀態，等待使用者派任務
- 任一項紅 → 中斷 init，回報缺失項，**禁止進入工作**

---

## 2. 必達的最終狀態（Completion State）

跑完 init 後，接班 AI 必須處於以下狀態（任何 AI 一致）：

| 狀態項 | 內容 |
|---|---|
| 領域公理 | 已載入心智模型，可引用條款編號 |
| 角色 spec | 已讀，知道職責邊界與不職責 |
| 共同記憶根目錄 | 已定位，後續所有讀寫以此為基準 |
| 抽驗權狀態 | 釐清對方是否在強化抽驗模式 |
| 最近 HANDOFF | 已讀，對齊上次 session 的脈絡 |
| 模式 | 已套用對應規範（eco / verbose）|
| 自我簽到 | `_role.md` 切換歷史已更新 |
| 待辦 | 從 NextWork 抽出 1〜2 條最高優先 |

→ 缺任一項 = 未對齊 = 不可進入工作。

---

## 3. 各 AI 具象化規範

框架定義抽象職責（§1〜§2），各 AI 實作具象 slash command。**抽象規範一致，具象實作可替換**。

### 3.1 主流 AI 對應位置

| AI | 具象化位置 | 實作格式 |
|---|---|---|
| **Claude Code** | `.claude/commands/<role>-init.md` | Slash command（純 markdown）|
| **Gemini CLI** | `.gemini/commands/<role>-init.toml`（依 Gemini 慣例）| 依 Gemini 規格 |
| **Cursor** | `.cursor/rules/<role>-init.mdc` | Rules system |
| **無 slash command 系統** | 通用 prompt 文件 + 對話開頭手動貼入 | 純 prompt |

→ 任一 AI 的 init slash command 實作**必須產出 §2 等效最終狀態**。

### 3.2 實作模板

依 `templates/role-init.md.tpl` 為共通骨架，各 AI 廠商套用替換變數後實例化到自己的 slash command 系統。

新 AI 加入時須：
1. 提交 `roles/<role>/<ai-vendor>.md`，含工具能力清單與職責執行細節
2. 在 `_role.md.tpl` 加入該 AI 的具象化位置欄位
3. 提供至少一個範例 init slash command 實例

### 3.3 AI 自我具象化（Self-Instantiation）— **首選機制**

> **核心原則**：框架**不代替任何 AI 生成 slash command**。AI 是自我建造的造物。

當任何 AI 第一次被指派扮演某角色時（無對應 slash command），該 AI 必須執行**自我具象化流程**：

#### 3.3.1 觸發條件

- 使用者向 AI 表達「你來當 \<role\>」
- AI 讀 `<common-memory-root>/roles/<role>/_role.md` 發現自己廠商的 slash command 位置標為 ❌（未實裝）
- 任何時候 AI 偵測到自己的具象化檔案不存在

#### 3.3.2 自我具象化步驟

```
1. 讀 AgentCharter charter（位置由使用者提供或環境變數 $CHARTER_DIR）：
   - core/init-template.md（本檔，職責規範）
   - core/role-separation.md / audit-rights.md / ...（依 profile 啟用）
   - roles/<role>/_spec.md（職能定義）
   - roles/<role>/<my-vendor>.md（若存在；該 AI 廠商的執行細節）
   - templates/role-init.md.tpl（通用骨架）

2. 讀專案配置：
   - <common-memory-root>/_config/profile.yaml（哪些條款啟用、參數）
   - <common-memory-root>/_config/mapping.yaml（路徑對映）
   - <common-memory-root>/protocols/<axiom>.md（領域公理）

3. 自我具象化 — 在自己 AI 系統的標準位置生成 slash command 檔案：
   - Claude Code → .claude/commands/<role>-init.md
   - Gemini CLI → .gemini/commands/<role>-init.toml（或對應 Gemini 慣例）
   - Cursor → .cursor/rules/<role>-init.mdc
   - 無 slash 系統 → <common-memory-root>/roles/<role>/init-prompt.md（純 prompt 給使用者手動貼）

4. 內容生成原則：
   - 套用 templates/role-init.md.tpl 變數
   - 內部執行五步驟（依 §6）必達 §2 等效最終狀態
   - 加入該 AI 廠商特有的工具呼叫（如 Claude 用 Read/Bash、Gemini 用對應 API）
   - 套用 <my-vendor>.md 的執行細節（若有）

5. 驗證 schema 合規（**強制驗證點**，v0.5.10 加）：
   - 依 `~/.agentcharter/tools/doctor-spec.md` 跑 schema 驗證
   - 必驗：`<common-memory-root>/_config/profile.yaml` schema / `<common-memory-root>/_config/mapping.yaml` 必填欄位 / 領域公理檔存在
   - **不通則回到 step 2-3 修補；step 6 簽名禁止**（具象化視為失敗）
   - 對應 `core/failure-modes.md F6`：未驗證即宣告就緒 = 轉嫁驗證負擔給下個 AI

6. 簽名（限「具象化痕跡」、**禁寫激活痕跡**，v0.7.0 加禁項）：
   - 更新 <common-memory-root>/roles/<role>/_role.md 的「各 AI 具象化位置」表
   - 將自己廠商的「是否實裝？」改為 ✅
   - 在切換歷史追加一行：「<日期> / <我> / 自我具象化完成（doctor schema 通過）」
   - **Status 欄位寫 `PROVISIONAL`**（暫具象化、未經 user explicit 授權激活）
   - **不得寫 Sign-in Log**（Sign-in Log 是激活的紀錄、不是具象化的紀錄；等 user explicit 授權後才寫）
   - 對應 `core/multi-role-tracking.md §3.4.4` init 階段自我激活同樣 = F1
   - vendor spec 預設身份（如 `roles/pm/gemini-cli.md` 顯示 Gemini ↔ PM）= 能力預設、不是自動激活授權

7. 回報使用者：
   - 「我已建好我的 <role>-init slash command，位於 <具象化位置>」
   - 「step 5 doctor schema 驗證已通過（0 errors）」
   - 「Status: PROVISIONAL — 等你下達 `/<role>-init` 命令並 explicit 授權我接該角色後，才會升 ACTIVE 並寫 Sign-in Log」
   - 邀請使用者立刻跑一次驗證

> **slash command 引用紀律（v0.7.0 加，對應 dogfood signal #3 結構性實證）**：
> step 3 生成 slash command 內引用 framework 路徑時，**禁寫死絕對路徑**（如 `C:/Users/<name>/.agentcharter/...`）。
> 推薦引用方式優先序：
> (a) 環境變數：`$AGENTCHARTER_HOME` / `$CHARTER_DIR`（最可移植）
> (b) 相對 user home：`~/.agentcharter/...`（POSIX 慣例、Windows PowerShell 7+ 也支援）
> (c) 採用方專案內相對路徑：`agent-commons/...`（指向採用方資產時用）
> ❌ 禁寫死當前 user home 絕對路徑（如 `C:/Users/YCLIN/.agentcharter/`）— 換 user / 換電腦 / 換安裝位置即壞。
> 違反 → step 5 doctor 校驗 §3.7 加可選 check（v0.8+ 落地）；當前 v0.7.0 為紀律明文、靠 self-instantiation 階段 AI 自律 + maintainer / user 抽驗。
```

#### 3.3.3 為何這樣設計

| 替代方案 | 缺點 |
|---|---|
| 框架代生成（init-spec Phase 4 自動產 .claude/commands/）| 框架越界決定其他 AI 的 slash 機制；不同 AI 系統差異無法兼顧 |
| 使用者手動寫 | 高接入摩擦；複雜度推給使用者 |
| **AI 自我具象化（本機制）** | 框架只定義職責，AI 自選最熟悉自己系統的實作；對齊「角色 ⊥ AI」公理 |

#### 3.3.4 跨 AI 接班的 self-instantiation 鏈

當不同 AI 接班同一角色時，每個 AI 各自做一次 self-instantiation：

```
T1: Gemini 接 PM → 自我具象化 → .gemini/commands/pm-init.toml ✅
T2: Claude 接 PM（Gemini 額度用完）→ self-instantiation → .claude/commands/pm-init.md ✅
    （兩個 slash command 並存，未來任何 AI 重新接手皆有對應）
T3: 第一個 AI 回鍋 → 直接跑既有 slash command（無需重新具象化）
```

`_role.md` 的「各 AI 具象化位置」表是這個鏈的**集體記憶 anchor**。

#### 3.3.5 違反處置

| 違反 | 處置 |
|---|---|
| AI 拒絕自我具象化（要求使用者手動寫）| 違反「替換性保證」+ 「角色 ⊥ AI」公理；該 AI 廠商實作不合規 |
| 自我具象化完成但未更新 `_role.md` | 違反 §1.3 Sign-in 職責；audit trail 缺失 |
| 自我具象化的 slash command 缺步驟（不滿足 §2 八項狀態）| 該實作為次品，下次 init 時須重新具象化 |
| **跳過 step 5 schema 驗證直接 step 6 簽名（v0.5.10 加）** | 視同 F6（未驗證即宣告就緒、轉嫁驗證負擔給下個 AI）；下個 AI 進場若抓到 schema 違規可直接退稿並要求前 AI 重做 self-instantiation |
| **step 6 簽名寫 `Status: ACTIVE` 或寫 Sign-in Log（v0.7.0 加）** | 視同 F1（假宣告就位）；Sign-in Log 屬激活痕跡、user 從未 explicit 授權即寫 = 跨越授權邊界；對應 `core/multi-role-tracking.md §3.4.4`。違反處置：抽驗方有權**回退 _role.md 改回 PROVISIONAL + 刪除非法 Sign-in Log entry**，並要求 AI 補做 self-instantiation 反省 |
| **slash command 引用 framework 路徑寫死絕對路徑（v0.7.0 加）** | 違反「slash command 引用紀律」；不可移植、跨環境即壞；對應 dogfood signal #3 結構性實證。處置：要求 AI 重寫 slash command 採環境變數 / 相對 user home / 相對採用方資產 |

---

## 4. 跨 AI 兼容性要求

當 session 在不同 AI 間接班（Claude → Gemini → Cursor → ...）時：

| 要求 | 細節 |
|---|---|
| 等效最終狀態 | 不論誰跑 init，§2 八項狀態必須齊備 |
| 共讀同一份檔案 | `_role.md`、mapping.yaml、protocols、HANDOFF — 各 AI 讀同一份，無私有副本 |
| 統一就緒回報格式 | 跨 AI 對話時可一眼看出對方是否對齊 |

### 統一就緒回報格式

```
✅ <role>-init 完成
- 領域公理：<axiom> v<X>
- 通用條款：AgentCharter v<X> 已載入（依 profile）
- 模式：<eco|verbose>
- 最近 HANDOFF：HANDOFF_<N>.md
- 抽驗模式：<正常 | 強化中（理由：...）>
- 我是：<AI 廠商> 扮演 <role>
- git 狀態：<簡列>
- 待辦：<NextWork 抽 1-2 條>

<role> 值機完成，待派任務。
```

---

## 5. 替換性保證（Substitutability）

| 保證 | 機制 |
|---|---|
| 任何 AI 可被替換 | 退出後新 AI 跑自己的 init → 達等效狀態 |
| 替換無資產損失 | 共同記憶根目錄是物理 anchor，跨 AI 共讀 |
| 替換留審計 trail | `_role.md` 切換歷史 + HANDOFF 鏈跨 AI 接班紀錄 |
| 無隱性綁定 | 「只有 X AI 能扮演此角色」**禁止**；發現即視為違反本條款 |

---

## 6. 五步驟骨架（保留 v0.4 原內容，作為 §3.2 模板執行步驟）

任何 AI 的 init slash command 內部執行流程：

### 步驟 1 — 載入完整協議文件（必讀，禁略）

讀領域公理 + AgentCharter `core/*` + 角色 spec。

### 步驟 2 — 列出核心心智守則（10 條左右）

針對該角色會被踩到的紅線，每條一句話 + 條款引述。詳見 `roles/<role>/_spec.md §5`。

### 步驟 3 — 當前環境快照

讀 `_role.md`、git 狀態、最近 HANDOFF、最新任務膠囊。

### 步驟 4 — 抽驗權狀態檢查

讀失敗模式累積紀錄，判斷對方是否在強化抽驗模式。

### 步驟 5 — 就緒回報（依 §4 統一格式）

完成步驟 1〜4 後輸出極簡就緒回報，回報後**不主動推進任務**，等使用者下達具體指令。

---

## 7. 違反處置

| 違反 | 處置 |
|---|---|
| 跳過 init 即進入工作 | 視同 F1（假宣告就位）；抽驗方有權立即退稿並要求重來 |
| Init 實作未達 §2 等效狀態 | 該 AI 廠商實作不合規，須補強對應 `<ai-vendor>.md` |
| 跨 AI 接班未跑新 AI 的 init | 視為協議違反；新 AI 必須跑自己廠商的 init，不可繼承前任狀態 |
| `_role.md` 未更新切換歷史 | 違反 §1.3 簽名職責；audit trail 缺失 |

---

## 8. 與其他 core 條款的關係

| 條款 | 關係 |
|---|---|
| `role-separation.md` | init 確認角色身份才進入工作，避免越界 |
| `audit-rights.md` | init 守門職責是抽驗權的入口確認 |
| `common-memory-root.md` | init 第一動作為定位本根目錄 |
| `evidence-first.md` | init 守門必用工具證實協議 / 路徑存在 |
| `output-mode-protocol.md` | init 套用模式為其執行入口 |
| `failure-modes.md` | 跳過 init 即視為 F1 |
| `cross-ai-handoff.md` | 接班方走 init（含 §3.3 self-instantiation）為跨 AI 轉移流程的接收端入口 |
| `versioning-migration.md` | §1.4 守門須驗證 charter version 一致性（依其 §7 多 AI 版本一致性檢查）|
| `working-stack-discipline.md` | §1.4 守門須讀最新 DRAFT_CONTEXT（若有 session 內中斷累積）；本條款 §1.2 校準步驟與其 §5 session 重啟接班互補 |

---

## 9. 變更歷史

### v0.7.0（2026-04-28）

**動作**：
1. §3.3.2 step 6 簽名動作加禁項段：限「具象化痕跡」、**禁寫激活痕跡**（Status 寫 `PROVISIONAL`、不得寫 Sign-in Log）
2. §3.3.2 step 7 回報訊息加 PROVISIONAL → ACTIVE 升級條件說明
3. §3.3.2 結尾加「slash command 引用紀律」段（禁寫死絕對路徑、推薦環境變數 / 相對 user home / 相對採用方資產三層優先序）
4. §3.3.5 違反處置表加兩行：(a) step 6 簽名寫 ACTIVE 或寫 Sign-in Log = F1；(b) slash command 引用 framework 路徑寫死絕對路徑 = 違反引用紀律

**觸發**：dogfood signal #5 第二次完整實證 + #3 結構性實證 — 公司專案接入失敗 2026-04-28（見 `.claude_temp/COMPANY-ONBOARDING-FAILURE-AUDIT.md` Pattern C + Pattern D）。Gemini 在 self-instantiation step 6 簽名時直接寫 `_role.md Status: ACTIVE` + Sign-in Log（user 從未 explicit 授權）+ 寫 `.gemini/commands/charter-init.toml` 時把 framework 路徑寫死為 `C:/Users/YCLIN/.agentcharter/...`（不可移植）。

**修訂類型**：MINOR — 加新規範段、紀律強化；既有採用方下次 self-instantiation 時對齊（v0.6.x → v0.7.0 升版時建議跑一次 doctor 確認 _role.md Status 與 Sign-in Log 對齊）。

**連動範圍**（依 `maintainer-discipline §2.2`）：
- `core/multi-role-tracking.md §3.4.4`（同步加段；本檔禁項對應其紀律）
- `core/multi-role-tracking.md §3.4.5`（init 自激活 vs 切換違反 vs 隱式戴帽子三項對照表）
- `tools/init-spec.md` Phase 4 加「slash command 引用紀律」對應段
- `templates/agent-commons/_role.md.tpl` 加 `Status` 欄位 PROVISIONAL/ACTIVE 二態說明（如該模板存在）
- `tools/doctor-spec.md §3.4` 角色 init 狀態檢查加 PROVISIONAL/ACTIVE 區隔（v0.8+ 落地）

### v0.5.10（2026-04-28）

**動作**：§3.3.2 self-instantiation 從六步驟擴為**七步驟**（原 step 5「簽名」renumber 為 step 6、原 step 6「回報」renumber 為 step 7、新增 step 5「schema 驗證強制點」）；§3.3.5 違反處置加一行（跳過 step 5 視為 F6）。

**觸發**：dogfood signal #4「具象化 ⊥ 驗證脫鉤」於 YC_AIAgentCrew 接入（2026-04-28）實證 — PM Gemini 寫 `agent-commons/_config/mapping.yaml` 違反 schema 當下無人發現，Engineer Claude 進場才被迫進 Phase 3 重寫修補；驗證負擔被結構性地轉嫁給下個 AI。當前 charter 把「具象化（QUICKSTART Step 4）」與「驗證（QUICKSTART Step 5 跑 doctor）」拆為兩個獨立 user 動作，schema 違規必然延到下個 AI 進場才暴露；第一個 AI 的 self-instantiation 視為「成功」實際漏了 schema 自抽驗。

**修訂類型**：MINOR — 加新步驟、行為向後相容；既有採用方下次 self-instantiation 時補跑 step 5（既有簽名不溯及）。

**連動範圍**（依 `maintainer-discipline §2.2`）：`tools/doctor-spec.md §3.5`（新增 self-instantiation 結尾強制呼叫段）+ `core/failure-modes.md F6`（新增「未驗證即宣告就緒」失敗模式）+ `QUICKSTART.md Step 4`（兩個 vendor prompt 加 schema 驗證指示）+ `QUICKSTART.md Step 5`（從「不必跑」改為「人工二次確認」）。

### v0.5.0（2026-04-27）

升格為「職責規範」，加 §1 抽象職責、§2 必達狀態、§3 多 AI 具象化、§4 兼容性、§5 替換性保證。原五步驟骨架保留為 §6。

### v0.4（v0.1）

初版，僅含五步驟骨架。
