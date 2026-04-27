# AgentCharter — Current Status

> **更新時間**：2026-04-27（台灣時間）
> **當前版本**：v0.4.1
> **GitHub**：https://github.com/moerasermax/AgentCharter（private）

---

## Version 軌跡（最新 6 commit）

| 版本 | Commit | 主題 |
|---|---|---|
| v0.4.2 | (待 push) | agent-commons 完整 templates 6 份（capsule/handoff/IM/nextwork/domain-axioms/_role）+ §8 命名規則 |
| v0.4.1 | `8539854` | Common Memory Root 架構級約定（預設名 `agent-commons/`，採用識別）|
| v0.4.0 | `ff70165` | 工具化接入 Spec only — charter-config schema + scan/init/doctor specs + 3 profile presets |
| v0.3.0 | `35fce4c` | violation-reflection condition + management-layout template |
| v0.2.0 | `9aa9521` | 結構性反捏造升為全模式預設強制 |
| v0.1.1 | `c3dcf7a` | 結構性反捏造條款（自我 hook 議題沉澱）|
| v0.1.0 | `55be5d9` | 初版骨架（20 檔）|

---

## 檔案總數：30

```
core/        12 條（11 條紀律 + 1 條 v0.4 schema）
roles/       4 份（engineer/pm 各 spec + 1 reference impl + 1 placeholder）
examples/    1 個（cryptobot）
templates/   2 份（role-init.md.tpl + management-layout.md）
tools/       4 份（scan/init/doctor specs + 3 profiles + 1 spec each = 共 4 + 3 = 7）
meta/        4 份（README / GOVERNANCE / CONTRIBUTING / CHANGELOG）+ .gitignore
.claude_temp 本目錄（3 份）
```

實際 30：詳見 `git ls-files`。

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

## 13 條 core 條款清單

| 條款 | 一句話 |
|---|---|
| `role-separation.md` | 程式碼權與結案權對稱分離 |
| `audit-rights.md` | 抽驗權不得放棄；結案宣告默認待抽驗 |
| `failure-modes.md` | F1〜F5（假宣告 / 假 hash / 捏造數據 / 編號偏差 / 規則記憶失效）|
| `structural-anti-fabrication.md` | 缺 stdout 區塊即視同未交付（v0.2 全模式強制）|
| `violation-reflection.md` | 違規退稿後須補交反省；價值在審計痕跡 / 集體記憶 |
| `escalation-protocol.md` | 連續 ≥2 次升級強化抽驗、≥3 次觸發使用者裁決 |
| `evidence-first.md` | 隱性 bug 嚴禁盲猜；數字嚴禁心算 |
| `output-mode-protocol.md` | eco / verbose 雙段式 + 自動升級條件 |
| `completion-delivery.md` | 完工 VCP 必含 Directive Header / 雙保險 / 危險度標籤 / 期望錨點 / 失敗解讀表 |
| `handoff-chain.md` | session 交接鏈必含項目 |
| `init-template.md` | `/<role>-init` 五步驟骨架 |
| `charter-config.md` | mapping.yaml + profile.yaml schema（v0.4）|
| `common-memory-root.md` | **架構級約定** — 多 AI 共享資產位於單一根（預設 `agent-commons/`）（v0.4.1）|

---

## 三個工具 spec（v0.4，未實作）

| 工具 | 用途 | 實作狀態 |
|---|---|---|
| `/charter-scan` | A3 LLM 判讀既有專案結構，產 mapping draft | spec only |
| `/charter-init <preset>` | 套用 preset，5 phase 接入 | spec only |
| `/charter-doctor` | 健康檢查（含 status code 表）| spec only |

---

## 三個 preset

| Preset | 條款啟用 | 適用 |
|---|---|---|
| `minimal.yaml` | 6 / 11 條，寬鬆參數 | 探索型 / 單人 + 1 AI |
| `standard.yaml` | 11 / 11 條，中等參數 | 一般雙 AI 協作（CryptoBot 級）|
| `strict.yaml` | 11 / 11 條，嚴格上限 | 嚴格合規 / 高風險領域 |

---

## 已對外實證

| 事件 | 框架條款被驗證 |
|---|---|
| CryptoBot S70 PM 連環假宣告（F1×5 + F3×3 + F5×1）| audit-rights / failure-modes / escalation-protocol / 使用者裁決選項 B |
| S70 修法後 Dashboard PnL 顯示對齊真值 | role-separation / completion-delivery / 結構性反捏造 |
| 使用者觀察 v0.1.1 引入後 Token 影響 | structural-anti-fabrication §7.1 估算合理 |

---

## 未做事項（依 NEXT.md 優先序）

詳見 `NEXT.md`。當前最高優先：核心條款覆蓋率盤點。
