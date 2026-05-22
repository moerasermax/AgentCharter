# 升版指引

看版本號的**第幾位數字**變了，決定走哪條路。

| 版本號變化 | 路徑 |
|---|---|
| 第三位變（`0.10.0` → `0.10.1`）| [PATCH — 2 步搞定](#patch-升版) |
| 第二位變（`0.9.x` → `0.10.0`）| [MINOR — 走升版流程](#minor--跨版本升版) |
| 跳很多版（`0.7.x` → `0.10.x`）| [跨版本 — 一樣走 MINOR 流程，一次拉到最新](#minor--跨版本升版) |

> 不知道自己是哪個版本？看 `agent-commons/_config/profile.yaml` 的 `charter_version` 欄位。

---

## PATCH 升版

**Step 1 — 拉最新 charter**

```bash
git -C ~/.agentcharter pull origin main
```

**Step 2 — 改版本號**

編輯 `agent-commons/_config/profile.yaml`：

```yaml
charter_version: "0.10.0"   # 改成新版號，其他不動
```

完成。不需要跑 doctor，不需要改任何結構。

> PATCH 通常是新增 spec 段或新角色，採用方結構零影響。
> 若想用新功能（如 `/charter-doctor --fix`），對 AI 說「請依最新 doctor-spec.md 重新自具象化」即可。

---

## MINOR / 跨版本升版

**Step 1 — 拉最新 charter**（跨多版也沒關係，一次到最新）

```bash
git -C ~/.agentcharter pull origin main
```

**Step 2 — 找升版 walkthrough**

| 從哪個版本升 | Walkthrough |
|---|---|
| **v0.10.6 → v0.12.0**（🔥 **3 in 1**：Antigravity vendor + Canonical Init Spec Layer + agents-commons rename、⚠️ **BREAKING-MEDIUM** 所有採用方需跑 migration script）| `examples/upgrades/v0.10.6-to-v0.12.0-antigravity-canonical-rename.md` |
| **v0.10.6 → v0.11.0**（Antigravity vendor only、不含 rename / canonical layer、stable midpoint）| `examples/upgrades/v0.10.6-to-v0.11.0-antigravity-migration.md` |
| **v0.10.5 → v0.10.6**（Claude PM v1.0 接入 + Gemini PM v1.8 best-of-breed 收斂、零採用方動作）| 無 walkthrough（純 charter_version 改一行、新 vendor spec 自動可用）|
| **v0.10.4 → v0.10.5**（Gemini PM generalist disable 提醒、零採用方動作）| 無 walkthrough（純 charter_version 改一行）|
| **v0.10.3 → v0.10.4**（vendor 介紹 charter 工具紀律、零採用方動作）| 無 walkthrough（純 charter_version 改一行）|
| **v0.10.2 → v0.10.3**（純 spec sweep + maintainer-only lint、零採用方動作）| `examples/upgrades/v0.10.2-to-v0.10.3.md` |
| **v0.10.1 → v0.10.2**（H7 schema-driven、⚠️ BREAKING-LITE PATCH）| `examples/upgrades/v0.10.1-to-v0.10.2.md` |
| **v0.9.x → v0.10.0**（commit hook ship）| `examples/upgrades/v0.9.x-to-v0.10.0.md` |
| v0.8.2 → v0.9.0 | `examples/upgrades/v0.8.2-to-v0.9.0.md` |
| v0.8.1 → v0.8.2 | `examples/upgrades/v0.8.1-to-v0.8.2.md` |
| v0.8.0 → v0.8.1 | `examples/upgrades/v0.8.0-to-v0.8.1.md` |
| v0.7.5 → v0.8.0 | `examples/upgrades/v0.7.5-to-v0.8.0.md` |
| v0.5.9 → v0.7.4（跨多版範例）| `examples/upgrades/yc-aiagentcrew-v0.5.9-to-v0.7.4.md` |

跨多版（例如 v0.7.x → v0.10.0）：找最接近目標版本的 walkthrough 當入口，流程會自動帶你走完。

**Step 3 — 跑升版驗證**

對 AI 說：「請依 `tools/post-upgrade-verify-spec.md` 跑升版驗證」

---

---

## ⚠️ v0.12.0 重大事件提示 — 3 in 1 BREAKING-MEDIUM ship

charter v0.12.0 一次合併三個 ship 項：

| Ship 項 | dogfood signal | 對應條款 |
|---|---|---|
| **(1) Antigravity CLI vendor 接入** | #60 LIVE | `roles/pm/antigravity-cli.md` v1.1 + `vendor-lifecycle §4` 失效 / 換手紀律 |
| **(2) Canonical Init Spec Layer**（SSS S2.5）| #61 LIVE（dbSDK PM AI 報告）| `core/init-spec-schema.md` 新檔（架構級概念第 15 個）+ `roles/<role>/init-spec.md` + `templates/vendor-adapters/*.tpl` |
| **(3) agents-commons rename**（BREAKING-MEDIUM）| user LIVE 提出 | `core/common-memory-root §10` + `core/vendor-lifecycle.md` 新檔（架構級概念第 14 個）+ `migrate-to-agents-commons.sh` migration script |

**判斷你是否要動**：

| 你的狀態 | 動作 |
|---|---|
| Gemini CLI 免費 / Pro / Ultra | 🔴 **6/18 前必須跑** v0.10.6-to-v0.12.0 walkthrough |
| Enterprise / 付費 API key / OSS / 不用 Gemini CLI | ⚠️ **agents-commons rename 必動**（跑 migration script）+ Canonical Init Spec Layer 重 self-instantiate 推薦 |

詳見 `examples/upgrades/v0.10.6-to-v0.12.0-antigravity-canonical-rename.md` 完整 walkthrough。

---

## ⚠️ v0.11.0 重大事件提示 — Gemini CLI 棄用（2026-06-18 對 Pro/Ultra/free 斷線）

Google 2026-05-19 在 I/O 2026 宣布 **Gemini CLI 將由 Antigravity CLI 取代**：

- **2026-06-18**：Gemini CLI 對 **Google AI Pro / Ultra / 個人免費** tier 停止服務
- **Enterprise / 付費 API key / OSS** tier 不受影響、可繼續用 Gemini CLI
- charter v0.11.0 ship 新 vendor spec `roles/pm/antigravity-cli.md` v1.1（path A AI-DRAFTED-FROM-GEMINI-V1.8 + 同日 LIVE 第二輪校正）+ 標 `roles/pm/gemini-cli.md` vendor_status: LEGACY_AUTO_IMPORTED（不刪、保留歷史 audit trail）

**判斷你是否要動**：

| 你的 Gemini CLI tier | 動作 |
|---|---|
| 免費 / Pro / Ultra | 🔴 **必須 6/18 前跑 `examples/upgrades/v0.10.6-to-v0.11.0-antigravity-migration.md`** |
| Enterprise / 付費 API key / OSS | ✅ 不必動、charter v0.10.6 spec 仍 work；可選擇性升 v0.11.0 拿 Antigravity 新功能 |
| 不用 Gemini CLI（只用 Claude Code 等） | ✅ 完全不受影響 |

對應 dogfood signal #60 LIVE 觸發、`core/ai-vendor-onboarding §3 step 2` 邀請制 path A LIVE 第二次應用實證。

---

## 維護說明（charter maintainer 用）

- **PATCH 發版**：不需新增 walkthrough。更新本檔 PATCH 表格的版本號即可。
- **MINOR 發版**：在 `examples/upgrades/` 新增 `v舊-to-v新.md`，並在上方表格加一行。
- **版本號命名規則**：見 `core/versioning-migration.md`。
