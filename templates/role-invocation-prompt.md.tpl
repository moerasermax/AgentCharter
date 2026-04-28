# Role Invocation Prompt Template（角色派任 prompt 通用骨架）

> **位階**：`templates/` — 結構模板。採用方依此骨架替換 placeholder 後貼給 AI。
> **使用時機**：採用方第一次讓某 AI 接某角色（該 AI 在本專案無對應 init slash command）。
> **不適用**：AI 已具象化過 init slash command — 直接打 `/<ROLE>-init` 即可，不需重貼 prompt。

---

## 設計原則

1. **placeholder 區段必填**：採用方填具體值前 prompt 不可貼出（避免 AI 收到 `<...>` 字樣的不完整 prompt）。
2. **六個 ⭐ 結構區塊不可省**：對應 [`core/init-template.md §3.3.2`](../core/init-template.md) self-instantiation 七步驟必達點。
3. **vendor 慣例自填**：本骨架不寫 Claude / Gemini / Cursor 任何特定慣例，由 AI 自己依 vendor spec 對應自家工具（Read / Bash / shell tool）。
4. **charter 不蒐集案例庫**：依 [`core/ai-vendor-onboarding.md`](../core/ai-vendor-onboarding.md) 邀請制 + A3「專案 ⊥ 框架」公理 — 採用方拿骨架自己填、自己用、自己累積。

---

## 骨架（複製、替換 `<...>` 後貼給 AI）

```
我採用了 AgentCharter，charter 在 <CHARTER_DIR>。

⭐ 角色派任：
請接 <ROLE> 角色，依 <CHARTER_DIR>/core/init-template.md §3.3.2
七步驟自我具象化到 <YOUR_VENDOR_COMMAND_PATH>。

⭐ 參考依據：
- 角色概念層（必讀）：<CHARTER_DIR>/roles/<ROLE>/_spec.md
- 廠商執行細節：<CHARTER_DIR>/roles/<ROLE>/<YOUR_VENDOR>.md
  （若不存在則以概念層為主、參考姊妹 vendor 慣例）
- 通用 init 骨架：<CHARTER_DIR>/templates/role-init.md.tpl

⭐ 採用方環境：
- 共同記憶根：<COMMON_MEMORY_ROOT>
- profile：<COMMON_MEMORY_ROOT>/_config/profile.yaml
- mapping：<COMMON_MEMORY_ROOT>/_config/mapping.yaml
- 領域公理：<COMMON_MEMORY_ROOT>/protocols/<DOMAIN_AXIOM>.md

⭐ Step 5 schema 驗證強制點：
簽名前必跑 doctor schema 驗證（依 <CHARTER_DIR>/tools/doctor-spec.md §2.1 模式 B
— self-instantiation 結尾強制驗證點，硬強制、0 errors 才允許 step 6 簽名）。
不通請告訴我，**不要強行 step 6 簽名 _role.md** — 這會命中
core/failure-modes.md F6（未驗證即宣告就緒、轉嫁驗證負擔給下個 AI）。

⭐ Step 6 簽名要求：
通過後簽名 <COMMON_MEMORY_ROOT>/roles/<ROLE>/_role.md：
- 「各 AI 具象化位置」表你那行 ❌ → ✅
- 切換歷史追加一行（日期 / AI 廠商 / 觸發原因 / Self-instantiation: 是）

⭐ Step 7 回報格式：
回報以下三行：
- 「我已建好 <ROLE>-init slash command，位於 <YOUR_VENDOR_COMMAND_PATH>」
- 「step 5 doctor schema 通過 0 errors」
- 「step 6 _role.md 簽名完成」
邀請我立刻打 /<ROLE>-init 驗證一次。
```

---

## Placeholder 對照表

| Placeholder | 含義 | 範例值 |
|---|---|---|
| `<CHARTER_DIR>` | charter 在採用方本機的位置 | `~/.agentcharter/` |
| `<ROLE>` | 該 AI 要接的角色名（kebab-case，對應 `roles/` 子目錄）| `engineer` / `pm` / `validator` |
| `<YOUR_VENDOR>` | AI 廠商代號（對應 `roles/<role>/<vendor>.md` 檔名）| `claude-code` / `gemini-cli`（已實裝）；`cursor` 等其他 vendor 尚無 vendor spec → 走骨架兜底「以概念層為主」|
| `<YOUR_VENDOR_COMMAND_PATH>` | AI 自家 slash command 對應位置 | `.claude/commands/<role>-init.md` / `.gemini/commands/<role>-init.toml` / `.cursor/rules/<role>-init.mdc` |
| `<COMMON_MEMORY_ROOT>` | 採用方共同記憶根目錄（相對或絕對路徑）| `./agent-commons/` |
| `<DOMAIN_AXIOM>` | 領域公理檔名（去副檔名）| `IRON` / `RECON` / `HIPAA` |

---

## 已實證填充範例

`QUICKSTART.md Step 4.2` 提供兩個典型組合的已填充對照版本：

- Engineer × Claude Code（CryptoBot + YC_AIAgentCrew 實證）
- PM × Gemini CLI（CryptoBot + YC_AIAgentCrew 實證）

其他組合（PM × Claude / Validator × Gemini / Cursor × Engineer / auditor × 任一 vendor 等）依本骨架自填。

---

## 採用方擴展貢獻路徑

若採用方在自家專案累積出有用的 vendor / role 組合擴展（如新增 Cursor 對 Engineer 的派任慣例），歡迎依 [`core/ai-vendor-onboarding.md §3`](../core/ai-vendor-onboarding.md) 邀請制四步驟貢獻回 charter。

**邀請制觸發前置**：採用方主動反饋 — charter 無 telemetry，不會自動知道擴展存在；維護者在收到反饋後才會啟動 §3 邀請制流程。

**§3 邀請制正式四步驟**（依 ai-vendor-onboarding.md §3 原文）：

1. **charter 寫概念層 `_spec.md`**（charter maintainer 動作）— 若該角色尚無概念層
2. 邀請目標 vendor 寫 `roles/<role>/<vendor>.md` vendor 層
3. 既有 vendor 校正 regression（若有姊妹 vendor）
4. 三層結構簽收（charter maintainer 動作）

→ charter 不主動蒐集案例庫，**真實接觸觸發、邀請制接入**。
