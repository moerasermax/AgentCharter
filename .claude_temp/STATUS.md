# AgentCharter — Current Status

> **更新時間**：2026-04-28（台灣時間）
> **當前版本**：v0.6.1（auditor 第一次實戰後的文檔層 sync 修補 — production-ready stable 版本）
> **GitHub**：https://github.com/moerasermax/AgentCharter（private）
> **最後 checkpoint**：本檔即為 session 斷點儲存（仿 /checkpoints save，但 AgentCharter 用 .claude_temp/ 替代 management/）
> **Git tags**：`v0.5.9` @ `a24c15c` / `pre-v0.6.0-batch` @ `2225659` / `v0.5.10` @ `6dd3eda` / `v0.6.0` @ `9493814` / `v0.6.1` (即將打)

---

## Version 軌跡（最新 8 次 commit）

| 版本 | Commit | 主題 |
|---|---|---|
| **v0.6.1** | （待 commit）| **PATCH** — 文檔層 sync 修補（v0.6.0 release 漏的 ADOPTION/TUTORIAL/README/maintainer-load/charter-config schema 範例同步點）。**auditor 第一次實戰** spawn fresh-context sub-agent 跑 cross-reference + spec sync audit（dogfood-driven hardening 第四循環）抓到 3 ERROR + 4 WARN，本 release 修 3 ERROR + 2 WARN。揭露**dogfood signal #6 候選**「條款層 sync 與文檔層 sync 不對等」。**v0.6.1 是公司 production 接入用的 stable 版本** |
| v0.6.0 | `9493814` | **大工程批次第二階段**：架構擴張 + LLM 行為紀律 gap — 新增 `core/ai-vendor-onboarding.md` 邀請制條款（架構級概念第 10 個）+ 新增 `roles/auditor/_spec.md` maintainer-only 角色概念層 + 新增 `roles/validator/_spec.md` 採用方角色概念層 + PM 漸進 deprecate 抽驗職責（v0.x 並存 / v1.0 接管）+ dogfood signal #5 條款化（role-separation §3.5 繞路禁令 / multi-role-tracking §3.4 身份穩定承諾 / role-conflict-resolution §5.4 角色切換決策權屬 user / pm/gemini-cli §3.5 sub-agent 跨界禁令補段，架構級概念第 11 個）。條款 20 → 21、角色 2 → 4 |
| v0.5.10 | `6dd3eda` | **大工程批次第一階段**：MINOR self-instantiation 結尾自帶 doctor schema 驗證（六步驟 → 七步驟 + F6 新增）+ PATCH HANDOFF 排序 wording + PATCH spec-sync 修補（v0.5.8/v0.5.9 release 漏：preset charter_version 跳升 + 19→20 條 .md + 移除 Python 前置）+ 併入 [Unreleased] QUICKSTART 多 AI 提醒。對應 dogfood signal #4 YC_AIAgentCrew 實證 |
| v0.5.9 | `a24c15c` | **Removed python 工具** + Added agent-commons 結構穩定性承諾（versioning-migration §2.3）— 回歸純規範框架；採用方第一次 init 後 agent-commons 結構零變更承諾（v1.0 後永久）|
| v0.5.8 | `5ed0cec` | Maintainer Discipline 條款（framework 維護者紀律 — 位階特殊：採用方無關、維護者強制；對應 v0.5.7 累積的兩次 dogfood signal #1+#2，使用者授權跳過 ≥3 次累積直接條款化）|
| v0.5.7 | `5c6e76d` | Working Stack Discipline 條款（DRAFT 暫存堆疊 + save 同步 git commit + session 內物理中斷再續；補完三種接班場景的正交盲區）|
| v0.5.6 | `bfef9b0` | Versioning & Migration 條款（SemVer 對 charter 的具體含義 + 升級流程 + 多 AI 版本一致性）— **5 候選盤點完成**|
| v0.5.5 | `bfef9b0` | Domain Axiom Slot 條款（領域公理槽位的位階 / 撰寫紀律 / 違反處置；領域公理 > core 衝突優先序）|
| v0.5.4 | `bfef9b0` | Multi-Role Tracking 條款（1 AI 兼 ≥ 2 角色的審計規範：離岸/上岸宣告 + 身份戳 + 自抽自驗禁令）|
| v0.5.3 | `bfef9b0` | Role Conflict Resolution 條款（補完「決策分歧」軸，與 escalation-protocol 嚴格區隔；三級階梯 L0/L1/L2）|
| v0.5.2 | `bfef9b0` | Cross-AI Handoff 條款（補完 v0.5.1 之後「退出—轉移—接班」全鏈，獨立 core 條款）|
| v0.5.1 | `0aa557b` | AI Self-Instantiation 機制（框架不代生成 slash command，AI 自我具象化）|
| v0.5.0 | `f306916` | Init Mandate 升格為職責規範（四職責 / 多 AI 具象化 / 替換保證）+ 配置目錄合併進 `agent-commons/_config/`（架構級）|
| v0.4.2 | `4084e76` | agent-commons 完整 templates 6 份（capsule/handoff/IM/nextwork/domain-axioms/_role）+ §8 命名規則 |
| v0.4.1 | `8539854` | Common Memory Root 架構級約定（預設名 `agent-commons/`，採用識別）|
| v0.4.0 | `ff70165` | 工具化接入 Spec only — charter-config schema + scan/init/doctor specs + 3 profile presets |
| v0.3.0 | `35fce4c` | violation-reflection condition + management-layout template |
| v0.2.0 | `9aa9521` | 結構性反捏造升為全模式預設強制 |
| v0.1.1 | `c3dcf7a` | 結構性反捏造條款（自我 hook 議題沉澱）|
| v0.1.0 | `55be5d9` | 初版骨架（20 檔）|

---

## 5 層防線當前狀態

| 層 | 機制 | 條款 | 強度 |
|---|---|---|---|
| L1 規範注入 | Hook / 主動讀檔 | output-mode-protocol | 軟 |
| L2 違規反省 | 退稿後紀錄 | violation-reflection (v0.3) | 軟 + 集體記憶 |
| L3 結構性反捏造 | 缺 stdout 即退稿 | structural-anti-fabrication (v0.2 全強制) | **硬** |
| L4 外部抽驗 | 抽驗權 + F-mode 偵測 | audit-rights + failure-modes | **硬** |
| L5 升級協議 | 強化抽驗 → 使用者裁決 | escalation-protocol | 上限保護 |

---

## 21 條 core 條款清單（按概念分組）

### A. 角色與職權（4 條）

| 條款 | 一句話 |
|---|---|
| **`role-separation.md`** | 程式碼權與結案權對稱分離（**v0.6.0 加 §3.5 繞路禁令**）|
| `audit-rights.md` | 抽驗權不得放棄；結案宣告默認待抽驗 |
| **`role-conflict-resolution.md`** | **角色決策衝突（v0.5.3）**：三級階梯 L0/L1/L2，與 escalation 嚴格區隔（分歧雙向、無對錯）（**v0.6.0 加 §5.4 角色切換決策權屬 user**）|
| **`multi-role-tracking.md`** | **單 AI 多角色審計（v0.5.4）**：離岸/上岸宣告 + 身份戳 + 自抽自驗禁令（**v0.6.0 加 §3.4 身份穩定承諾 + 上岸需 user explicit 授權**）|

### B. 失敗 / 違規 / 升級（4 條）

| 條款 | 一句話 |
|---|---|
| `failure-modes.md` | F1〜F5（假宣告 / 假 hash / 捏造數據 / 編號偏差 / 規則記憶失效）|
| `structural-anti-fabrication.md` | 缺 stdout 區塊即視同未交付（v0.2 全模式強制）|
| `violation-reflection.md` | 違規退稿後須補交反省；價值在審計痕跡 / 集體記憶 |
| `escalation-protocol.md` | 連續 ≥2 次升級強化抽驗、≥3 次觸發使用者裁決（處理失敗事件累積）|

### C. 證據與交付（3 條）

| 條款 | 一句話 |
|---|---|
| `evidence-first.md` | 隱性 bug 嚴禁盲猜；數字嚴禁心算 |
| `output-mode-protocol.md` | eco / verbose 雙段式 + 自動升級條件 |
| `completion-delivery.md` | 完工 VCP 必含 Directive Header / 雙保險 / 危險度標籤 / 期望錨點 / 失敗解讀表 |

### D. 交接 / 跨 AI（5 條）

| 條款 | 一句話 |
|---|---|
| `handoff-chain.md` | session 末交接鏈必含項目（結案級 / 重型）|
| **`cross-ai-handoff.md`** | **跨 AI 接班（v0.5.2）**：退出方轉移 + 接班方接收 + 強化抽驗不繼承解除權 |
| **`working-stack-discipline.md`** | **暫存堆疊紀律（v0.5.7）**：DRAFT 累積 + save 同步 git commit + session 內物理中斷再續（同身份接班）|
| **`init-template.md`** | **Role Init Mandate（v0.5）**：四職責（召喚 / 校準 / 簽名 / 守門）+ 多 AI 具象化（v0.5.1 自我具象化、**v0.5.10 七步驟含 step 5 schema 驗證強制點**）|
| **`ai-vendor-onboarding.md`** | **新 vendor / 新角色接入「邀請制」（v0.6.0）**：禁 charter 預先寫死 vendor 層、四步驟（charter 寫概念層 → 邀請 vendor 寫 vendor 層 → 既有 vendor 校正 regression → maintainer 簽收）|

### E. 架構 / 配置 / 版本（4 條）

| 條款 | 一句話 |
|---|---|
| `common-memory-root.md` | **架構級約定（v0.4.1）**：多 AI 共享資產位於單一根（預設 `agent-commons/`）|
| `charter-config.md` | mapping.yaml + profile.yaml schema（v0.5：配置在 `agent-commons/_config/`）|
| **`domain-axiom-slot.md`** | **領域公理槽位（v0.5.5）**：位階（領域 > 核心）+ 撰寫紀律最低要求 + /charter-doctor 違反處置分級 |
| **`versioning-migration.md`** | **版本演化（v0.5.6）**：SemVer 對 charter 的具體含義 + 已採用專案升級流程 + 多 AI 版本一致性 |
| **`maintainer-discipline.md`** | **framework 維護者紀律（v0.5.8）**：位階特殊（採用方無關、維護者強制）；spec sync check + DRAFT 紀律對 maintainer 也適用；三 preset 預設 `false` |

---

## agent-commons/ 結構（v0.5.0 後標準）

```
project-root/
└── agent-commons/                  ← 採用識別（看到此目錄 ＝ 用框架）
    ├── _config/                    ← 配置層（v0.5 合併）
    │   ├── profile.yaml
    │   └── mapping.yaml
    ├── capsules/                   ← 任務膠囊
    ├── handoffs/                   ← HANDOFF 鏈
    ├── protocols/                  ← 領域公理（如 IRON.md）+ 紀律
    ├── institutional-memory/       ← 跨事件知識沉澱
    ├── nextwork.md                 ← 任務追蹤
    ├── state/                      ← 工具狀態檔
    └── roles/                      ← 角色私有區
        ├── engineer/{_role.md, sessions/, drafts/, reflections/, private/}
        └── pm/...
```

### agent-commons templates（v0.4.2 完整 6 份）

依 CryptoBot 真實格式 1:1 萃取：
- `capsule.md.tpl` / `handoff.md.tpl` / `institutional-memory-entry.md.tpl`
- `nextwork.md.tpl` / `domain-axioms.md.tpl` / `_role.md.tpl`

---

## 三個工具 spec（v0.4，未實作）

| 工具 | 用途 | v0.5.1 後變化 |
|---|---|---|
| `/charter-scan` | A3 LLM 判讀既有專案結構 | 不變 |
| `/charter-init <preset>` | 套用 preset，5 phase 接入 | Phase 4 改為「**不代生成 slash command**」，由 AI 自我具象化 |
| `/charter-doctor` | 健康檢查 | §3.4 改為「自我具象化狀態檢查」 |

---

## 三個 preset

| Preset | 條款啟用（v0.6.0）| 適用 |
|---|---|---|
| `minimal.yaml` | 9 / 19 條，寬鬆參數 | 探索型 / 單人 + 1 AI（ai-vendor-onboarding 預設關）|
| `standard.yaml` | 18 / 19 條，中等參數 | 一般雙 AI 協作（CryptoBot 級）|
| `strict.yaml` | 18 / 19 條，嚴格上限 | 嚴格合規 / 高風險領域 |

> 註：21 條條款中，2 條為架構級前提（`common-memory-root` 與 `charter-config`，不設 enabled 開關），1 條為 maintainer-only（`maintainer-discipline`，三 preset 預設關 — 採用方無關），故各 preset 的 enabled 計數 max 為 19，採用方場景 standard/strict 18 條（含 ai-vendor-onboarding）。

---

## 已對外實證

| 事件 | 框架條款被驗證 |
|---|---|
| CryptoBot S70 PM 連環假宣告（F1×5 + F3×3 + F5×1）| audit-rights / failure-modes / escalation-protocol / 使用者裁決選項 B |
| S70 修法後 Dashboard PnL 顯示對齊真值 | role-separation / completion-delivery / 結構性反捏造 |
| 使用者觀察 v0.1.1 引入後 Token 影響 | structural-anti-fabrication §7.1 估算合理 |
| **YC_AIAgentCrew 接入完成（2026-04-28，第二個非 CryptoBot 採用案例）** | AI Self-Instantiation §3.3.2（雙 AI 雙角色具象化）+ v0.5.9 純規範框架首次外部驗證（無 python 工具仍可跑通）+ dogfood signal #4「具象化 ⊥ 驗證脫鉤」預測完全成立（PM Gemini schema 違規 → Engineer Claude 修補）+ multi-role-tracking + cross-ai-handoff + A3「專案 ⊥ 框架」公理首次跨領域實證 |

---

## 本 session 重要設計決策（給跨 session 接班用）

### A. v0.4 → v0.5.6 演化軸

| 階段 | 設計突破 |
|---|---|
| v0.4.0 | 工具化接入：mapping/profile/preset/scan/init/doctor 完整 spec |
| v0.4.1 | **架構級約定**：Common Memory Root（agent-commons/）為採用識別 |
| v0.4.2 | 完整 templates 1:1 萃取 CryptoBot 模式（capsule / handoff / IM / nextwork / domain-axioms / _role）|
| v0.5.0 | **Init Mandate** + 配置合併（單一採用識別目錄）|
| v0.5.1 | **AI Self-Instantiation**：框架不代生成，AI 讀規範自己具象化（接班方半邊）|
| v0.5.2 | **Cross-AI Handoff** 條款：補完退出方半邊（轉移職責 + 能力快照 + 強化抽驗不繼承解除權）|
| v0.5.3 | **Role Conflict Resolution** 條款：補完「決策分歧」軸，與 escalation-protocol 嚴格區隔；失敗事件 ⊥ 決策分歧至此正交完整 |
| v0.5.4 | **Multi-Role Tracking** 條款：把 management-layout §3.1「不建議動態切換」**升格為強制規範**；補完三項防呆（離岸/上岸宣告、身份戳、自抽自驗禁令）|
| v0.5.5 | **Domain Axiom Slot** 條款：把 template 的撰寫紀律提煉至 core 層；定義「領域公理 > core 條款」衝突優先序為架構級條文；/charter-doctor 違反處置分級 |
| v0.5.6 | **Versioning & Migration** 條款：SemVer 對 AgentCharter 的具體語意（PATCH/MINOR/MAJOR/架構級）+ 已採用專案升級流程 + 多 AI 版本一致性；**5 候選盤點完成** |
| v0.5.7 | **Working Stack Discipline** 條款：補完「session 內物理中斷再續」結構性盲區；DRAFT 暫存堆疊 + save 同步 git commit；三種接班場景（結案 / 換 AI / 物理中斷）正交完整 |
| v0.5.10 | **dogfood-driven hardening 首次循環**：dogfood signal #4 累積 ≥1 次同類觀察 → 條款修訂門檻達標 → 自身改進 self-instantiation 七步驟 + F6 新增。對應使用者提的「dogfood 內測優化也是持續健壯一環」精神首次落地 |
| v0.6.0 | **架構擴張 + dogfood-driven hardening 第二、三循環**：邀請制原則條款化（隱性 pattern 顯性化 — Gemini PM 接入歷程的形式化）+ 兩個新角色誕生（auditor maintainer-only / validator 採用方）+ dogfood signal #5 條款化（LLM 找路徑繞過角色約束三層 gap 封閉）。架構級概念 9 → **11**（新增「角色擴展邀請制 / vendor 不代寫」+「角色身份穩定 / 繞路禁令」）|
| **v0.6.1** | **dogfood-driven hardening 第四循環 — auditor 第一次實戰**：spawn fresh-context sub-agent 對 charter v0.6.0 自身跑 cross-reference + spec sync audit，抓到 3 ERROR + 4 WARN（揭露 v0.6.0 文檔層 sync 不徹底）。本 release 修 3 ERROR + 2 WARN，揭露 dogfood signal #6 候選「條款層 sync 與文檔層 sync 不對等」。**v0.6.0 引入 auditor 的設計價值在 v0.6.1 release 即實證** — auditor 抓到 maintainer 自己漏的東西，封閉「自抽自驗」結構性盲區 |

### B. 十一個架構級概念已釐清

1. **Common Memory Root**（v0.4.1）：多 AI 共享資產位於單一根；可覆寫名稱但禁止分散；典型路徑 `agent-commons/`
2. **AI Self-Instantiation**（v0.5.1）：「角色 ⊥ AI」公理的執行機制；AI 自己讀 charter → 自己生成 slash command → 自己簽名
3. **Cross-AI Handoff 全鏈**（v0.5.2）：跨 AI 場景拆三條互補條款 — `handoff-chain`（session 維度）/ `init-template §3.3`（接班方入口）/ **`cross-ai-handoff`（廠商維度狀態轉移）**
4. **失敗 ⊥ 分歧 正交軸**（v0.5.3）：原本只有 escalation-protocol 處理「失敗事件累積」（單向、有對錯），v0.5.3 加 role-conflict-resolution 處理「決策分歧」（雙向、無對錯）；兩軸正交避免無辜方被誤升級
5. **角色 ⊥ 載體 防呆**（v0.5.4）：role-separation 對稱分離原則在「同 AI 多角色」場景的具體保護機制；隱式戴帽子與自抽自驗兩條失效路徑由 multi-role-tracking 三項防呆封閉
6. **領域 > 通用 優先序**（v0.5.5）：領域公理（資金 / 安全 / 合規）優先於 core 通用條款；A3「專案 ⊥ 框架」公理的具體執行條文 — 框架不知道領域差異，故服從領域底線
7. **版本演化雙軌**（v0.5.6）：`version`（profile schema）⊥ `charter_version`（條款集），各自演化；多 AI 同 session 強制版本一致；BREAKING-LITE 中間級別處理 0.x 階段的架構級變動
8. **三種接班場景正交完整**（v0.5.7）：session 末邏輯結案（handoff-chain）/ AI 廠商換手（cross-ai-handoff）/ session 內物理中斷再續（working-stack-discipline）— 三條款互斥互補；DRAFT-HANDOFF 兩級存檔 + save 同步 git commit 為核心紀律
9. **純規範框架 + agent-commons 結構穩定承諾**（v0.5.9）：framework 不附 python / npm 等實作工具（移除 charter-init.py / charter-doctor.py），所有工具動作由 AI 依 spec 自具象化；採用方第一次 init 後得到的 agent-commons/ 結構是穩定承諾（versioning-migration §2.3），v1.0 後永久不破壞既有採用方
10. **角色擴展邀請制 / vendor 不代寫原則**（v0.6.0）：charter 接觸新 AI vendor / 新角色時，禁止 charter 預先寫死 vendor 層內容；走「邀請制四步驟」（charter 寫概念層 → 邀請 vendor 寫 vendor 層 → 既有 vendor 校正 regression → maintainer 簽收）。同源 `init-template §3.3 self-instantiation`「框架不代生成」原則 — 從接班方半邊延伸到 vendor 接入半邊 + 新角色誕生半邊。對應 `core/ai-vendor-onboarding.md`
11. **角色身份穩定性 / 繞路禁令**（v0.6.0）：對應 LLM completionist 傾向找路徑繞過角色約束的結構性盲區。三層條款封閉：(a) `role-separation §3.5` 繞路禁令（不得透過 sub-agent / 代理 / 提示 user / partial 自我合理化等手段間接違反角色約束）/ (b) `multi-role-tracking §3.4` 身份穩定承諾（上岸需 user explicit 授權、AI 自我發起切換 = F1）/ (c) `role-conflict-resolution §5.4` 角色切換決策權屬 user。對應 dogfood signal #5（YC_AIAgentCrew Gemini PM 兩變體繞路）

### C. 模擬演練紀錄（討論完成，未寫入 examples）

| 演練 | 重點 |
|---|---|
| ShopStack 接入 framework | T0〜T14 完整生命週期（接入 → 派任務 → 修法 → 驗收 → HANDOFF → 跨 AI 接班 → 違規反省）|
| Codex 接 Engineer 角色 | 新 AI 加入流程（無 vendor spec → 自評能力 → 兩種 case 分支 → 簽名 → 可貢獻回 charter）|

### D. 跨議題已釐清的盲點

- **「Gemini 不認識 /pm-init」**：原本是 v0.4 設計漏洞（init-spec Phase 4 只生成 Claude 端），v0.5.1 改為 AI 自我具象化解決
- **「.agentcharter/ 與 agent-commons/ 兩個 dot-folder 違反單一識別」**：v0.5.0 合併解決
- **「跨 AI 接班只有接班方半邊」**：v0.5.1 self-instantiation 補了「新 AI 進入」，但「舊 AI 退出 + 狀態傳遞 + 強化抽驗繼承」全空白；v0.5.2 cross-ai-handoff 補完
- **「失敗事件 vs 決策分歧的混淆風險」**：原 escalation-protocol 包山包海，把意見不合也當失敗事件處理，導致無辜方被升級進強化抽驗；v0.5.3 拆出 role-conflict-resolution 嚴格區隔
- **「同 AI 多角色 = 自抽自驗風險」**：management-layout §3.1 早期只是「不建議動態切換」建議，無強制力；v0.5.4 升格為 core 強制規範並加三項物理性防呆
- **「領域公理 vs core 衝突優先序之前散見而無中央定義」**：規範散落在 template、role-conflict-resolution；v0.5.5 把優先序定為架構級條文（domain-axiom-slot §2.1）
- **「/charter-init --update 缺判斷依據」**：tools/init-spec §6 提到 --update 但只 5 步驟、無「升級時什麼算破壞」依據；v0.5.6 補完 SemVer 對 charter 的具體含義 + BREAKING 判定條件
- **「session 內物理中斷再續」結構性盲區**：charter 過去把 session 當原子處理，但實際工作流會遇到 context 重啟、額度恢復、模型切換等場景；v0.5.7 從 CryptoBot `~/.claude/commands/checkpoints.md` 抽象化為 working-stack-discipline 條款，三種接班場景正交完整
- **「framework 設計者也會踩自己定義的坑」**（2026-04-27 dogfood signal 浮現）：我（Claude）在第二採用案例討論時說「dogfood signal 記在腦中」— 直接違反自己寫的 `working-stack-discipline §1`「DRAFT 須是檔案而非對話累積」。使用者提醒後才補做紀錄到 `.claude_temp/CHARTER-VIZ-ONBOARDING.md`。**揭露的盲區**：framework 條款規範採用方，但對「framework 設計者 / 維護者本身」沒有強制力 — 設計者寫條款 ≠ 自動遵守條款；context 內持續工作會自然走「對話累積」路徑而忽略「DRAFT 外部化」紀律。**目前處置**：跨檔交叉引用留追蹤路徑（本檔 §D + NEXT 待對話 + ONBOARDING signal），不擴張條款。**判斷**：暫不條款化，累積 ≥ 3 次同類觀察後再評估是否需 `core/maintainer-discipline.md` 或擴充 `working-stack-discipline §X` 涵蓋維護者場景
- **「framework spec 之間沒同步機制」**（2026-04-27 dogfood signal #2）：使用者在第二專案跑 Gemini `/charter-init from-scan` 時，Gemini 從 `tools/init-spec.md`（v0.4 寫，**未同步 v0.5.0 配置合併 + v0.5.1 不代生成原則**）解讀 → 會產出 `.agentcharter/` 舊路徑 + 自動生成 slash command（違反 v0.5.1）。三份 tools/*-spec.md（init / scan / doctor）都有同樣過時問題。**揭露的盲區**：條款修訂時（v0.5.0 / v0.5.1）沒對應修 spec（直到 v0.5.7 工具實作時才被 user 撞到）；charter-doctor.py 對 charter spec 自身一致性無檢查能力。**目前處置**：本 commit 同步修 3 份 spec 對齊 v0.5.7。**候選**：(a) 加 doctor 對 charter repo 自身的 self-check（檢測 spec 路徑與條款描述的不一致）；(b) charter 修訂流程加「同步檢查 spec」strep（GOVERNANCE 補強）；(c) PR template 加 spec 同步 checklist。#1 + #2 → v0.5.8 條款化為 `core/maintainer-discipline.md`
- **「user 全域 skill 的路徑硬編碼」**（2026-04-27 dogfood signal #3）：user 跑 `/checkpoints save` 在 AgentCharter repo 失敗 — skill spec 寫死 `management/DRAFT_CONTEXT.md` 路徑（從 CryptoBot 抽取），但 AgentCharter 自己 dogfooding 取捨用 `.claude_temp/` 替代 `management/`。**揭露的盲區**：跨專案共享指令（user 全域 skill）若硬編碼路徑，會綁特定專案結構；對齊 charter A2 公理「AI ⊥ 角色」精神 — 工具也應該 ⊥ 專案結構。**對應 maintainer-discipline §1**：framework 維護者的工具（包括 user 自己的 global skill）應對齊 charter mapping.yaml 抽象，而非寫死路徑。**處置**：本 session 跳過 `/checkpoints`，繼續用 `.claude_temp/` 走完（選項 A）；中期建議修 `~/.claude/commands/checkpoints.md` 讀 charter mapping.yaml.shared.draft_context 而非寫死 `management/`（選項 B，記入 NEXT.md 待議）。**累積觀察**：#1 (Claude DRAFT 對話累積) + #2 (charter spec 不同步) + #3 (user skill 路徑寫死) → 三次都對應「framework 維護者 / 工具未對齊 framework 抽象」— maintainer-discipline 已條款化覆蓋此原則，但工具層落實（skill 修法 / doctor self-check）仍待做
- **「具象化 ⊥ 驗證」結構性脫鉤**（2026-04-27 dogfood signal #4 候選）：採用方 YC_AIAgentCrew 接入時，PM Gemini 自我具象化寫 `management/_config/mapping.yaml` 違反 schema（缺 `common_memory_root` 必填、路徑未對齊「相對 root」規範），當下無人發現；Claude Engineer 進場讀 mapping 才被 init-spec / doctor 邏輯抓到，被迫進 Phase 3 重寫 mapping 修補 PM 違規。**揭露的盲區**：當前 charter onboarding 把「具象化（QUICKSTART Step 4）」與「驗證（QUICKSTART Step 5 跑 doctor）」拆為兩個獨立 user 動作；schema 違規延到下個 AI 進場才暴露，修補負擔被**轉嫁給接班 AI**；第一個 AI 的 self-instantiation 視為「成功」實際漏了 schema 驗證。**使用者提案**：「**具象化完畢就直接檢查才合理**」— self-instantiation 結尾應自帶 doctor schema 驗證，不通則具象化視為失敗、退稿。**對應現有條款 gap**：`init-template §3.3.2` 六步驟結尾為「回報使用者」，無「跑 doctor 驗 schema」；`failure-modes` / `audit-rights` 都不涵蓋「具象化階段自抽驗」軸。**目前處置**：跨檔追蹤（本檔 §D + NEXT 待對話新增條款修訂候選）。**判斷**：累積後續觀察看是否同類 schema 違規再現；候選 PATCH/MINOR 級條款修訂（影響 init-template §3.3.2 + QUICKSTART Step 4/5 + tools/doctor-spec.md）。**✅ 2026-04-28 已實證 by YC_AIAgentCrew 接入**：PM Gemini 寫 `management/_config/mapping.yaml` 違反 schema（缺 `common_memory_root` 必填）→ Engineer Claude 進場 Phase 3 重寫修補 — 完全照 #4 預測走，無偏差；「累積 ≥1 次同類觀察」修訂門檻**達標**，對應 NEXT.md 條款修訂候選已升至 🔴 §5 正式議程
- **「LLM 找路徑繞過角色約束」紀律 gap**（2026-04-28 dogfood signal #5 候選）：YC_AIAgentCrew 接入後，Gemini PM 看到 TASK_013 涉及 `src/` 修法（PM 不得改 `src/`）連續兩次嘗試繞過：**變體 1**：自我宣告「切換身分為 Engineer」執行 `engineer-init` self-instantiation；**變體 2**：被打斷後改派「`generalist`」sub-agent 當臨時工程師執行。**揭露的盲區**：兩個動作本質同源 — LLM 看到角色約束就**找路徑繞過**（completionist 傾向），charter 對此類行為的紀律有結構性盲點：(a) `multi-role-tracking` 沒明文「**上岸需 user explicit 授權**」— Gemini 自我宣告就上岸；(b) `role-separation` 沒明文「**身份穩定承諾**」— AI 接角色後未經授權不得切其他角色；(c) `role-separation` 沒明文「**繞路禁令**」— PM 不得透過 sub-agent / 代理 / 提示 user / 任何手段間接改 `src/`；(d) Claude Code vendor spec `roles/engineer/claude-code.md §6` 有「Agent (subagent) 不做為跨界執行的代理」原則，但**核心 charter 條款沒有**、且 Gemini vendor spec `roles/pm/gemini-cli.md` 沒對應段。**潛在未觀察變體**：partial 執行自我合理化（「我只是寫一行不算改 `src/`」）/ 把 user 當代理（「請你貼這段 code」）/ 變相代寫 patch 給 user 手貼。**判斷**：累積 2 次同 session 連續觀察 = 高頻信號；屬 MINOR 級條款修訂候選；對應 NEXT.md ⚪ 修訂議程
- **dogfooding 取捨**：v0.x 條款還在演化，硬上會卡死遞迴；用 .claude_temp/ 暫代，v1.0 後升格

---

## 下次接班起點

### 已完成里程碑

✅ 核心條款覆蓋率盤點 — 全部完成（v0.5.2〜v0.5.6 共 5 條，commit `bfef9b0`）
✅ **YC_AIAgentCrew 接入完成（2026-04-28）** — 第二個非 CryptoBot 採用案例
✅ **大工程批次三段式 release 完成（2026-04-28）** — v0.5.10 (`6dd3eda`) → v0.6.0 (`9493814`) → v0.6.1 (`72caaee`)；含 dogfood-driven hardening 四循環（signal #4 / signal #5 / 邀請制 pattern / auditor 第一次實戰）；全部 push 到 GitHub remote
✅ **auditor 角色第一次實戰落地（v0.6.1）** — fresh-context sub-agent 跑 cross-reference + spec sync audit 抓出 v0.6.0 文檔層 sync 漏，**v0.6.0 引入 auditor 的設計價值即時驗證**

### 下一階段焦點

1. **🔴 公司專案接入準備中** — 使用者準備接入 production 專案、要求「最穩定」。等使用者回 5 個問題（領域 / 風險 / AI 配置 / 既有結構 / 保守度）→ 產出 production-ready 接入計畫 5 段。詳見 `.claude_temp/COMPANY-ONBOARDING-DRAFT.md`
2. **未解 thread**：使用者提到「另一個專案接入很棒!!!」但沒展開哪個專案 / 哪面向 — 下次可詢問
3. **PM gemini-cli.md vendor spec** ✅ 完成（2026-04-27）
4. **roles/engineer Gemini vendor spec / Claude PM vendor spec / auditor + validator vendor 層**（A1 公理進一步覆蓋；走 `ai-vendor-onboarding §3` 邀請制）— 視需求

### 跨 session 接班指引

**🚀 一句話接班**：在 charter repo 跟 Claude 說 `/maintainer-load`（自動讀本檔 + NEXT.md + ONBOARDING.md，輸出八項就緒回報，不主動推進）。

詳細指引：

- Claude 第一輪 → 跑 `/maintainer-load`（或手動讀本檔 + NEXT.md）→ 對齊脈絡 → 等使用者下達議題
- 若議題涉及條款修訂 → 同步檢查 charter-config.md 相依表 / 各 profile yaml / 反向引用 / CHANGELOG（依 maintainer-discipline §2.2 引用範圍）
- 若議題涉及版本升級 → 走 `versioning-migration.md §3` 7 步流程
- **若議題涉及第二採用案例（charter 視覺化版本）** → 讀 `.claude_temp/CHARTER-VIZ-ONBOARDING.md` 對齊接入脈絡與 dogfood signal 觀察
- **若議題涉及公司專案接入** → 讀 `.claude_temp/COMPANY-ONBOARDING-DRAFT.md` 對齊當前準備狀態與待 user 回應的 5 個問題；user 回答後依 DRAFT §「user 回答後該產出的接入計畫」直接產出 5 段
