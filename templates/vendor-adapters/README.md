# Vendor Adapter Templates（v0.12.0 加）

> **位階**：charter framework 端 vendor adapter 模板集中地、對應 `core/init-spec-schema.md` 架構級概念第 15 個「Canonical Init Spec + Vendor Adapter pattern」
> **設計**：canonical / adapter 兩層分離 — 角色 init 邏輯只在 `roles/<role>/init-spec.md` canonical 寫一次、各 vendor 透過 adapter 模板轉成 vendor 對應格式
> **since**：v0.12.0

---

## 1. 為什麼有這個目錄

charter v0.11.x↓ init 鏈缺「**生成什麼內容**」的統一規範 — 跨 vendor 行為不一致（dbSDK 2026-05-22 報告實證、三 vendor pm-init 量化差異 604 / 11842 / 1645 bytes）。

v0.12.0 引入 canonical / adapter 兩層分離：

| 層 | 位置 | 職責 |
|---|---|---|
| **Canonical layer** | `core/init-spec-schema.md` + `roles/<role>/init-spec.md` | 定義 init 內容（6 段 required sections）|
| **Adapter layer**（本目錄）| `templates/vendor-adapters/` | 把 canonical 6 段轉成 vendor 對應 slash command 格式 |

---

## 2. 目錄結構

```
templates/vendor-adapters/
├── README.md
├── gemini-cli.toml.tpl       ← Gemini CLI（LEGACY）adapter、flat TOML
├── claude-code.md.tpl        ← Claude Code adapter、YAML frontmatter + Markdown
└── antigravity.skill.tpl     ← Antigravity CLI adapter、SKILL.md 子目錄結構 + name: frontmatter
```

未來新 vendor 接入（依 `core/ai-vendor-onboarding §3`）：
- Cursor → `cursor.mdc.tpl`（待邀請）
- Kiro → `kiro.<ext>.tpl`（待邀請）
- Codex / 其他 → `<vendor>.<ext>.tpl`（待邀請）

---

## 3. Adapter 紀律（依 `core/init-spec-schema §3.2`）

| # | 紀律 | 規範 |
|---|---|---|
| 1 | **只做格式轉換** | 不增減邏輯 |
| 2 | **保留 6 段順序** | adapter 不可重排 step 0-5 |
| 3 | **vendor-specific 擴展走 Step 5+** | 置於 canonical 6 段之後、不混入 |
| 4 | **vendor schema 對齊** | 對齊各 vendor `<vendor>.md §3.6` 規範 |
| 5 | **單向性** | canonical → vendor 單向轉換 |

違反 → `tools/doctor-spec §3.13` W1301 / E1302。

---

## 4. 採用方端使用流程

依 `core/init-template §3.3.2` 八步驟 + `core/init-spec-schema §3.3`：

```
Step 0: 讀過去違反紀錄
Step 0.5: charter version 比對
Step 1: 自我介紹 + vendor-specific 提醒
Step 2: 讀 _spec.md 概念層 + canonical init-spec.md
Step 3: 從 canonical init-spec.md 透過對應 vendor adapter 轉換、生成 vendor slash command
  - Gemini CLI: gemini-cli.toml.tpl → .gemini/commands/<role>-init.toml
  - Claude Code: claude-code.md.tpl → .claude/commands/<role>-init.md
  - Antigravity: antigravity.skill.tpl → ~/.gemini/skills/<role>-init/SKILL.md
Step 4-8: 依 init-template §3.3.2 後續步驟
```

---

## 5. Placeholder 變數約定

| Placeholder | 來源 |
|---|---|
| `{{role_name}}` | 角色名（如 `pm` / `engineer`）|
| `{{charter_version}}` | 當前 charter 版本（讀 profile.yaml）|
| `{{vendor_name}}` | 對應 vendor 名 |
| `{{underlying_model}}` | 僅 Antigravity adapter 用（multi-model 場景）|
| `{{step_0_content}}` 〜 `{{step_5_content}}` | 從 canonical init-spec.md 6 段對應內容轉換填入 |

---

## 6. 與既有條款的關係

| 條款 | 關係 |
|---|---|
| `core/init-spec-schema.md` | 本目錄的紀律本體 |
| `core/init-template §3.3` | self-instantiation 流程入口、本目錄 adapter 是其執行載體 |
| `core/ai-vendor-onboarding §3` | 邀請制紀律 — 新 vendor 接入時 charter 寫 adapter |
| `core/vendor-lifecycle §6` | 跨 vendor 紀律 propagate — adapter 變更時 sync 既有 vendor |
| `roles/<role>/<vendor>.md §3.6` | vendor schema 規範（adapter 必對齊）|
| `tools/doctor-spec §3.13` | adapter 一致性校驗 |

---

## 7. 變更歷史

### v1.0（自 v0.12.0 引入）

新增本目錄 — charter v0.12.0 SSS S2.5「Canonical Init Spec + Vendor Adapter pattern」ship 一部分、對齊 dbSDK PM AI 跨 vendor 報告 §4.1 提案。
