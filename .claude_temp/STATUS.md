# AgentCharter — Current Status

> **更新時間**：2026-04-27（台灣時間）
> **當前版本**：v0.5.1
> **GitHub**：https://github.com/moerasermax/AgentCharter（private）
> **最後 checkpoint**：本檔即為 session 斷點儲存（仿 /checkpoints save，但 AgentCharter 用 .claude_temp/ 替代 management/）

---

## Version 軌跡（最新 8 次 commit）

| 版本 | Commit | 主題 |
|---|---|---|
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
| `init-template.md` | **Role Init Mandate（v0.5）**：四職責（召喚 / 校準 / 簽名 / 守門）+ 多 AI 具象化（v0.5.1 自我具象化）|
| `charter-config.md` | mapping.yaml + profile.yaml schema（v0.5：配置在 `agent-commons/_config/`）|
| `common-memory-root.md` | **架構級約定**：多 AI 共享資產位於單一根（預設 `agent-commons/`）（v0.4.1）|

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

## 本 session 重要設計決策（給跨 session 接班用）

### A. v0.4 → v0.5.1 演化軸

| 階段 | 設計突破 |
|---|---|
| v0.4.0 | 工具化接入：mapping/profile/preset/scan/init/doctor 完整 spec |
| v0.4.1 | **架構級約定**：Common Memory Root（agent-commons/）為採用識別 |
| v0.4.2 | 完整 templates 1:1 萃取 CryptoBot 模式（capsule / handoff / IM / nextwork / domain-axioms / _role）|
| v0.5.0 | **Init Mandate** + 配置合併（單一採用識別目錄）|
| v0.5.1 | **AI Self-Instantiation**：框架不代生成，AI 讀規範自己具象化 |

### B. 兩個架構級概念已釐清

1. **Common Memory Root**（v0.4.1）：多 AI 共享資產位於單一根；可覆寫名稱但禁止分散；典型路徑 `agent-commons/`
2. **AI Self-Instantiation**（v0.5.1）：「角色 ⊥ AI」公理的執行機制；AI 自己讀 charter → 自己生成 slash command → 自己簽名

### C. 模擬演練紀錄（討論完成，未寫入 examples）

| 演練 | 重點 |
|---|---|
| ShopStack 接入 framework | T0〜T14 完整生命週期（接入 → 派任務 → 修法 → 驗收 → HANDOFF → 跨 AI 接班 → 違規反省）|
| Codex 接 Engineer 角色 | 新 AI 加入流程（無 vendor spec → 自評能力 → 兩種 case 分支 → 簽名 → 可貢獻回 charter）|

### D. 跨議題已釐清的盲點

- **「Gemini 不認識 /pm-init」**：原本是 v0.4 設計漏洞（init-spec Phase 4 只生成 Claude 端），v0.5.1 改為 AI 自我具象化解決
- **「.agentcharter/ 與 agent-commons/ 兩個 dot-folder 違反單一識別」**：v0.5.0 合併解決
- **dogfooding 取捨**：v0.x 條款還在演化，硬上會卡死遞迴；用 .claude_temp/ 暫代，v1.0 後升格

---

## 下次接班起點

詳見 `NEXT.md`。當前未做的最高優先：

1. **核心條款覆蓋率盤點**（剩餘候選：Domain Axiom Slot 撰寫規範 / Versioning-Migration / Cross-AI handoff 細則 / Conflict resolution between roles / Multi-role tracking）
2. **roles/pm/gemini-cli.md** 提交（待 Gemini 端代理）
3. **v0.5+ Reference Impl**（把三工具 spec 變成可跑的工具）

跨 session 接班指引：
- Claude 第一輪 → 讀本檔 + NEXT.md → 對齊脈絡 → 等使用者下達議題
