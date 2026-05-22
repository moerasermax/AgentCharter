# Init Spec Schema（Canonical Init Spec Layer 統一 init 指令規範）

> **狀態**：v0.1（自 v0.12.0 引入）
> **位階**：core 通用條款 + **架構級概念第 15 個誕生**「Canonical Init Spec + Vendor Adapter pattern」（與第 14 個 `vendor-lifecycle` 同 release ship）
> **依存**：`init-template.md`、`ai-vendor-onboarding.md`、`role-separation.md`、`vendor-lifecycle.md`
> **保證強度**：結構強制（charter 端 canonical schema + vendor adapter 模板 + doctor §3.13 一致性校驗三層）
> **檢測時點**：init + post-self-instantiation
> **since**：v0.12.0

---

## 0. 概念定位（為何引入）

### 0.1 觸發背景：dbSDK PM AI 報告（2026-05-22 LIVE）

dbSDK 採用方端 PM（Antigravity CLI / Claude Sonnet 4.6 Thinking）提交「Slash Command 跨 AI Vendor 可攜性報告」（存於 `.claude_temp/DBSDK-CROSS-VENDOR-SLASH-COMMAND-REPORT-2026-05-22.md`），揭露三 vendor pm-init 量化差異：

| 維度 | Gemini CLI | Claude Code | Antigravity |
|---|---|---|---|
| 檔案大小 | 604 bytes | 11,842 bytes | 1,645 bytes |
| 流程步驟數 | 4（隱含）| 6（Step 0~5 明確）| 4 |
| 心智守則注入 | ❌ 無 | ✅ 10 條 | ❌ 無 |
| Reflection 強制讀取 | ❌ | ✅ Step 0 | ✅ Step 4（漂浮）|
| Cheatsheet 支援 | ❌ | ✅ Step 1 | ❌ |
| 就緒回報格式 | ❌ 無統一 | ✅ Step 5 | ❌ 無統一 |

**核心缺口**：`core/init-template.md §3` 定義「**去哪裡生成**」、但**沒有定義「生成什麼內容」的統一規範**。

### 0.2 「Canonical + Adapter pattern」核心

> **charter 寫一份 canonical init-spec（vendor-neutral）、各 vendor 透過 adapter 模板轉成自己格式的 slash command**。

```
┌─────────────────────────────────────────┐
│ Canonical Init Spec Layer (vendor-neutral) │
│  core/init-spec-schema.md (本條款)       │ ← schema 定義（6 段 required sections）
│  roles/<role>/init-spec.md              │ ← 各角色 canonical init 邏輯
└─────────────────┬───────────────────────┘
                  │  透過 vendor adapter 轉換
                  ▼
┌─────────────────────────────────────────┐
│ Vendor-Specific Slash Command Layer      │
│  templates/vendor-adapters/             │ ← adapter 模板
│    gemini-cli.toml.tpl                  │
│    claude-code.md.tpl                   │
│    antigravity.skill.tpl                │
│                                          │
│  採用方端產出（self-instantiation）：    │
│    .gemini/commands/<name>.toml         │
│    .claude/commands/<name>.md           │
│    ~/.gemini/skills/<name>/SKILL.md     │
└─────────────────────────────────────────┘
```

→ 同源於 charter A1 公理「角色 ⊥ AI」設計精神 — 角色 init 邏輯 ⊥ vendor 工具系統。

---

## 1. 條文

任何 charter 角色的 init 邏輯：

1. **MUST** 在 `roles/<role>/init-spec.md` 寫 vendor-neutral canonical init spec（依 §2 6 段 required sections）
2. **MUST** 提供 vendor adapter 模板於 `templates/vendor-adapters/<vendor>.<ext>.tpl`
3. vendor AI self-instantiation 時 **MUST** 讀 canonical init-spec.md + 透過對應 vendor adapter 模板轉換、不可自由詮釋
4. **MUST** doctor §3.13 偵測跨 vendor pm-init 深度偏差（W1301）+ vendor command 引用過時路徑（E1302）

違反條文 → 跨 vendor 切換時行為不一致 + 採用方迭代成本增加 + charter A1 公理「角色 ⊥ AI」精神被破壞。

---

## 2. Canonical Init Spec Required Sections（6 段）

每個角色的 `roles/<role>/init-spec.md` **MUST** 包含以下 6 段（依序、不可跳號）：

### Step 0：Pre-Init（歷史學習迴圈）

對齊 `core/individual-learning-loop §3` 讀紀律。

**MUST 內容**：
- 必讀路徑清單：`reflections/` + `state/failure_mode_log.md` + `institutional-memory/`
- 必讀順序
- 觸發跳過條件

### Step 1：Load（協議載入）

對齊 `core/init-template §3.3.2 step 2`。

**MUST 內容**：
- 必讀檔案清單：`roles/<role>/_spec.md` + `roles/<role>/init-spec.md` + `roles/<role>/<vendor>.md` + adapter 模板
- 觸發讀全文 scenario 清單（vendor-neutral）

### Step 2：Mental Anchors（心智守則）

對應 `roles/<role>/_spec.md §5` 心智守則直譯。

**MUST 內容**：
- 角色寫權範圍
- 角色禁區
- F-mode 偵測清單
- vendor 特化盲區（§K 機制、由 vendor adapter 加註）

### Step 3：Environment Snapshot（環境快照）

對齊 `core/init-template §3.3.2 step 4`。

**MUST 內容**：
- 必查項目（output_mode / HANDOFF / capsules / git）
- 工具語意描述（不綁定特定 shell）

### Step 4：Audit State（抽驗狀態）

對齊 `core/audit-rights` + `core/escalation-protocol`。

### Step 5：Ready Report（就緒回報、統一格式）

**MUST 內容**：

```markdown
✅ <Role> init 完成（charter v<X.Y.Z>、vendor <vendor-name>）

- step 0 歷史學習迴圈：讀 <N> 條 reflections + <M> 條 IM、過去命中 F-mode <list>
- step 1 協議載入：本角色 _spec.md + init-spec.md + <vendor>.md + adapter 全讀
- step 2 心智守則：<N> 條
- step 3 環境快照：output_mode=<eco/verbose>、最新 HANDOFF=#<N>、活躍 capsules=<count>
- step 4 抽驗狀態：<normal/enhanced>
- step 5 就緒、等下個任務派發

vendor-specific 提醒（若有）：
<adapter 加註內容>
```

### Step 5+：vendor-specific 擴展（可選）

各 vendor adapter 可加 vendor-specific 擴展段（如 §3.5.5 generalist disable）— 置於 canonical 6 段之後、**不可改 step 0-5 順序或內容**。

---

## 3. Vendor Adapter Layer

### 3.1 charter framework 端維護的 adapter 模板

| Vendor | Adapter 模板 | 採用方端產出 |
|---|---|---|
| Gemini CLI（LEGACY）| `templates/vendor-adapters/gemini-cli.toml.tpl` | `.gemini/commands/<name>.toml`（flat TOML、依 §3.6）|
| Claude Code | `templates/vendor-adapters/claude-code.md.tpl` | `.claude/commands/<name>.md` |
| Antigravity CLI | `templates/vendor-adapters/antigravity.skill.tpl` | `~/.gemini/skills/<name>/SKILL.md`（子目錄結構 + frontmatter `name:` 必填）|
| Cursor / Kiro / 其他 vendor | 待邀請（依 `ai-vendor-onboarding §3`）| 待 vendor 寫對應 adapter |

### 3.2 Adapter 紀律

adapter 模板 **MUST** 滿足：

| 紀律 | 規範 |
|---|---|
| **只做格式轉換** | 不增減邏輯 |
| **保留 6 段順序** | adapter 不可重排 step 0-5 |
| **vendor-specific 擴展走 Step 5+** | 置於 canonical 6 段之後、不混入 |
| **vendor schema 對齊** | adapter 對齊各 vendor `<vendor>.md §3.6` 規範 |
| **單向性** | canonical → vendor 單向轉換 |

### 3.3 採用方端 self-instantiation 流程（v0.12.0 對齊新 canonical layer）

對應 `core/init-template §3.3.2` 八步驟 + 本條款規範：

```
Step 0: 讀過去違反紀錄
Step 0.5: charter version 比對
Step 1: 自我介紹 + vendor-specific 提醒
Step 2: 讀 _spec.md 概念層 + **canonical init-spec.md（本條款規範對象）**
Step 3: **從 canonical init-spec.md 透過 vendor adapter 轉換、生成 vendor slash command**
Step 4-8: 依 init-template §3.3.2 後續步驟
```

---

## 4. 違反處置

| 違反方式 | 處置 |
|---|---|
| 角色缺 `roles/<role>/init-spec.md` canonical | `tools/doctor-spec §3.13` W1301 |
| AI self-instantiation 跳過 canonical 自編 init | doctor §3.13 W1301 跨 vendor 深度偏差超閾值即觸發 |
| Vendor command 引用過時路徑 | doctor §3.13 E1302 |
| adapter 內加邏輯 | 違反 §3.2、退回 |
| canonical 6 段順序被 adapter 重排 | 違反 §3.2、退回 |

---

## 5. 與既有條款的關係 / 互補矩陣

| 時序 | 條款 | 動作主體 | 工件 |
|---|---|---|---|
| **T-1** 角色概念層 | `ai-vendor-onboarding §3 step 1` | charter maintainer | `roles/<role>/_spec.md` |
| **T-1a** **角色 canonical init**（本條款 v0.12.0 新加）| **本條款 §2** | **charter maintainer** | **`roles/<role>/init-spec.md`** |
| **T-1b** **vendor adapter 模板**（本條款 v0.12.0 新加）| **本條款 §3.1** | **charter maintainer** | **`templates/vendor-adapters/<vendor>.<ext>.tpl`** |
| T0 | vendor 接入 | `ai-vendor-onboarding §3 step 2-4` | vendor + maintainer | `roles/<role>/<vendor>.md` |
| T1 | AI 第一次扮演角色 | `init-template §3.3` + **本條款 §3.3** | AI 自己 | `.{vendor}/commands/<role>-init.{md,toml}` 等 |

→ 本條款**只負責 T-1a + T-1b**、把 init「內容統一」+「格式轉換」分離。

---

## 6. 對應 dogfood signal / 觸發背景

| Signal / 事件 | 對應本條款段 |
|---|---|
| dbSDK PM AI 跨 vendor 報告（2026-05-22 LIVE）| §0.1 觸發背景 + §1 條文 + §2 6 段 required sections |
| dogfood signal #61 條款化候選 | 本條款 v0.12.0 ship 落地 |
| multi-perspective 第十四循環新類型（採用方 vendor AI 對 charter 行使結構性反向觀察）| dbSDK PM AI 提出 §4 SSS S2.5 議程 |

---

## 7. 變更歷史

### v0.1（自 v0.12.0 引入）

**動作**：新增本條款 — 把 v0.x 隱性的「init 內容深度由 vendor 自由詮釋」缺口顯性化為「Canonical Init Spec + Vendor Adapter pattern」、charter 架構級概念第 15 個誕生。

**觸發**：
- 2026-05-22 dbSDK PM AI 提交跨 vendor 報告、揭露三 vendor pm-init 量化差異
- user 直接條款化 pattern — user explicit 授權「全能 SSS S2.5 ship」

**修訂類型**：MINOR — 條款數 25 → 27（同 release ship vendor-lifecycle 一起）；架構級概念 13 → 15。

**連動範圍**（同 v0.12.0 release）：
- `roles/pm/init-spec.md` 新檔（PM canonical init、依 §2 6 段）
- `roles/engineer/init-spec.md` 新檔
- `templates/vendor-adapters/{README.md, gemini-cli.toml.tpl, claude-code.md.tpl, antigravity.skill.tpl}` 4 個新檔
- `tools/doctor-spec §3.13` W1301 / E1302
- `core/charter-config §5` 條款相依表加 init-spec-schema entry
- `tools/profiles/*.yaml` charter_version `0.11.0` → `0.12.0`
- `CHANGELOG.md` v0.12.0 段
- `examples/upgrades/v0.10.6-to-v0.12.0-antigravity-canonical-rename.md` 採用方完整 walkthrough（3 in 1）
