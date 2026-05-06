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

## 維護說明（charter maintainer 用）

- **PATCH 發版**：不需新增 walkthrough。更新本檔 PATCH 表格的版本號即可。
- **MINOR 發版**：在 `examples/upgrades/` 新增 `v舊-to-v新.md`，並在上方表格加一行。
- **版本號命名規則**：見 `core/versioning-migration.md`。
