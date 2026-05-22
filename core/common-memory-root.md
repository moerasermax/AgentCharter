# Common Memory Root（共同記憶根目錄）

> **狀態**：v0.5（v0.12.0 BREAKING-MEDIUM rename — 預設目錄名 `agent-commons/` → `agents-commons/`、語意更貼近「**agents** 共用之 commons」、含 migration script 對既有採用方提供自動遷移）
> **位階**：core 通用條款。**架構級約定** — 採用 AgentCharter 的專案必須遵守。
> **保證強度**：結構強制（架構級前提、單一根目錄為採用識別）
> **檢測時點**：init
> **since**：v0.4.1（v0.12.0 預設名 rename）

---

## 1. 條文

任何採用 AgentCharter 的專案，**多 AI 協作的所有共享資產**（任務膠囊、HANDOFF 鏈、協議文件、Institutional Memory、各角色私有區）必須位於**單一根目錄**之下。該根目錄稱為 **Common Memory Root**（共同記憶根目錄）。

**預設名稱**：`agents-commons/`（v0.12.0+；v0.4.1〜v0.11.x 為 `agent-commons/`、依 §10 BREAKING-MEDIUM rename 紀律提供 migration script 自動遷移）

> 看到專案根目錄有 `agents-commons/` ＝ 採用 AgentCharter v0.12.0+、其內為多 AI 對齊的單一真相位置。
> 看到 `agent-commons/`（無 s）= 採用 AgentCharter v0.11.x↓、依 §10 提供 migration script 自動遷移至 `agents-commons/`。

---

## 2. 設計動機

不對齊的後果：

| 散在多處 | 後果 |
|---|---|
| capsules 在 `tasks/`、handoffs 在 `docs/`、protocols 在 `governance/` | 跨 AI 接班看不到完整脈絡，每個 AI 各自摸索 |
| 不同角色用不同根（PM 用 `pm-stuff/`、Engineer 用 `eng-stuff/`）| 違反 `role-separation.md` 對稱原則；雙方無法互相抽驗 |
| 沒有約定根目錄 | 採用框架的識別不存在，工具無法在無配置情況下啟動 |

對齊的價值：

- **物理 anchor**：跨 AI / 跨 session 的單一真相位置
- **採用識別**：看到 `agents-commons/`（v0.12.0+）或 `agent-commons/`（v0.11.x↓）即知此專案採用 AgentCharter
- **工具可預設啟動**：無 mapping.yaml 時亦可用預設路徑運作
- **跨 AI 認知一致**：任何 AI 都知道「對齊脈絡」要去哪裡讀

---

## 3. 必含子槽位（依條款啟用）

```
<project>/
└── agents-commons/                      ← Common Memory Root（v0.12.0 起預設名；v0.11.x↓ 為 agent-commons/）
    ├── _config/                         ← 框架配置層（v0.5.0 合併自原 .agentcharter/）
    │   ├── profile.yaml                 ← 條款啟用配置
    │   ├── mapping.yaml                 ← 路徑對映（內部子槽位）
    │   ├── scan-report.md               ← /charter-scan 結果（可選）
    │   └── health-report.md             ← /charter-doctor 結果（可選）
    ├── capsules/                        ← 任務膠囊（依 audit-rights / completion-delivery 啟用）
    ├── handoffs/                        ← HANDOFF 鏈（依 handoff-chain 啟用）
    ├── protocols/                       ← 領域安全公理 + 紀律文件
    ├── institutional-memory/            ← 跨事件知識沉澱
    ├── nextwork.md                      ← 任務追蹤
    ├── state/                           ← 工具狀態檔（如 output_mode_file、failure_mode_log）
    └── roles/                           ← 角色私有區（依 role-separation 啟用）
        ├── engineer/
        │   ├── _role.md                 ← 角色識別檔
        │   ├── sessions/<id>/
        │   ├── drafts/
        │   ├── reflections/
        │   └── private/                 ← 建議 .gitignore
        ├── pm/
        └── reviewer/
```

---

## 4. 預設名稱與覆寫機制

### 4.1 預設

新採用框架的專案：**直接建 `agents-commons/` 即可上線**（v0.12.0+），無需配置。

> v0.11.x↓ 採用方仍可用 `agent-commons/`、依 §10 BREAKING-MEDIUM rename 提供 migration script 升級。

### 4.2 既有專案的覆寫（向後相容）

既有專案（如 CryptoBot 已用 `management/`）可透過 `mapping.yaml.common_memory_root` 覆寫：

```yaml
# .agentcharter/mapping.yaml
common_memory_root: management/         # 覆寫預設
```

→ 框架功能完全相同，僅根目錄名稱不同。

### 4.3 不可分散原則（**強制，無覆寫例外**）

無論名稱叫什麼，**所有共享資產必須在單一根下**。

❌ **違規**：

```
project/
├── tasks/capsule_001.md
├── docs/handoff_22.md
├── governance/protocols.md
└── memory/lessons.md
```

✅ **合規**：

```
project/
└── agents-commons/                 # 或其他單一名稱（v0.12.0 預設、v0.11.x↓ 為 agent-commons/）
    ├── capsules/
    ├── handoffs/
    ├── protocols/
    └── institutional-memory/
```

→ 抽驗方有權對「分散在多處」的專案直接退稿，不進入內容判讀。

---

## 5. 跨 AI 共讀規範

每個 AI 角色 init 時的**第一動作**：

1. 解析 `mapping.yaml.common_memory_root`（缺則用預設 `agents-commons/`、v0.12.0+；v0.11.x↓ project 用 `agent-commons/`）
2. 確認該目錄存在（依 `evidence-first.md`，用 `ls -la` 證實）
3. 進入該目錄上下文（後續所有讀寫以此為基準）

任何 AI **無法定位 common_memory_root** = framework 啟動失敗，須立即停下並上報使用者。

---

## 6. 與其他 core 條款的關係

| 條款 | 關係 |
|---|---|
| `charter-config.md` | mapping.yaml 內 `common_memory_root` 為**必填欄位**（v0.4.1 起）|
| `role-separation.md` | `roles/<role>/` 目錄結構在此根下實現職權分離 |
| `audit-rights.md` | 抽驗 trail（capsules + reflections）必在此根下 |
| `handoff-chain.md` | HANDOFF 鏈必在此根下 |
| `init-template.md` | 角色 init 第一動作為定位本根目錄 |
| `evidence-first.md` | 定位失敗即視為證據缺失 |
| `structural-anti-fabrication.md` | 「分散在多處」即結構違規，缺壓縮為單一根的事實，無 stdout 區塊可建構審計 trail |

---

## 7. v0.4.1 升級指引（既有專案）

從 v0.4.0 升到 v0.4.1 的既有採用專案：

1. 檢查目前共享資產位置
2. 若已在單一根下（如 CryptoBot 的 `management/`）→ 在 `mapping.yaml` 加 `common_memory_root: <name>`，無需搬檔
3. 若散在多處 → 需要重組到單一根（建議走 `git mv` 保留歷史）
4. 跑 `/charter-doctor` 驗證

---

## 8. 命名規則（v0.4.2 加入）

### 8.1 檔名規則

| 槽位 | 命名 | 範例 |
|---|---|---|
| `_config/` | 固定名 `_config`（v0.5.0 起合併自原 `.agentcharter/`）| `_config/profile.yaml` |
| `capsules/` | `<TASK_ID>_<SHORT_DESC>.md`，TASK_ID 由專案約定 | `TASK_S70_DASHBOARD_PNL_CORRECTION.md` |
| `handoffs/` | `HANDOFF_<N>.md`，N 為連續遞增整數從 1 起 | `HANDOFF_23.md` |
| `roles/<role>/sessions/<id>/` | id 為 session 識別 | `2026-04-27-s70-dashboard/` |
| `roles/<role>/reflections/` | `<event-id>.md`，建議格式 `<task-id>-<role>-<f-mode>-x<count>` | `S70-pm-f1-x5.md` |
| `protocols/<axiom-name>.md` | 領域公理檔，建議大寫識別 | `IRON.md` / `HIPAA.md` |
| `institutional-memory/_root.md` | IM 主索引檔 | `_root.md` |
| `state/output_mode` | output-mode-protocol 旗標檔 | `output_mode` |
| `state/failure_modes.log` | failure-modes 累積紀錄 | `failure_modes.log` |
| `roles/<role>/_role.md` | 角色識別檔（依 templates/agent-commons/_role.md.tpl）| `_role.md` |

### 8.2 路徑明確性

| 項 | 規定 |
|---|---|
| 領域公理位置 | 必在 `<common-memory-root>/protocols/` 下 |
| `_role.md` 位置 | 在每個 `roles/<role>/` 根目錄（與 sessions/ / drafts/ 同層）|
| `institutional-memory/` | 是**目錄**含多檔（每章節獨立 .md）+ 一個 `_root.md` 索引 |
| `state/` | 是**目錄**，內含工具狀態檔 |
| `nextwork.md` | 是**單檔**，位於 common-memory-root 根目錄 |

### 8.3 templates 對應

依 `templates/agents-commons/`（v0.12.0 目錄 rename、原 `templates/agent-commons/`） 下的 `*.md.tpl` 範本初始化各槽位內容：

| 槽位 | Template |
|---|---|
| 任務膠囊 | `templates/agent-commons/capsule.md.tpl` |
| HANDOFF | `templates/agent-commons/handoff.md.tpl` |
| Institutional Memory 章節 | `templates/agent-commons/institutional-memory-entry.md.tpl` |
| NextWork | `templates/agent-commons/nextwork.md.tpl` |
| 領域公理 | `templates/agent-commons/domain-axioms.md.tpl` |
| 角色識別 | `templates/agent-commons/_role.md.tpl` |

---

## 9. 「為什麼不允許名稱完全自由」

允許名稱覆寫是為了向後相容；但**不允許分散**是架構性硬約束。理由：

| 場景 | 結果 |
|---|---|
| 名稱不同（agents-commons / agent-commons / management / governance）| 工具讀 mapping 即可定位，無實質損失 |
| 散在多處 | 跨 AI 對齊失敗，framework 整體失效 |

→ 名稱是「方言」，分散是「協議裂解」。前者可寬，後者必嚴。

---

## 10. v0.12.0 BREAKING-MEDIUM rename 紀律（`agent-commons/` → `agents-commons/`）

> **觸發**：2026-05-22 user LIVE 在 v0.11.0 ship 過程中提出命名語意修正 — 原 `agent-commons/`（單數 agent）→ `agents-commons/`（複數 agents）更貼近語意「**多 agents 共用之 commons**」。對齊 charter 設計初衷「跨 AI 協作 = 多 agents」+ dbSDK 採用方端 LIVE 觀察。
>
> **位階**：BREAKING-MEDIUM（依 `core/versioning-migration §2`）— 不到 BREAKING（v0.x 階段允許）+ 不只 PATCH（採用方目錄需 rename）。

### 10.1 對既有 v0.5.9 承諾的處理

`core/versioning-migration §2.3`（v0.5.9 引入）「agent-commons 結構穩定性承諾」明文：
> v0.5.9 起對所有後續變動生效；已採用 v0.5.0 之後的專案後續升版保證向下兼容

→ **本變更技術上違反 v0.5.9 承諾的 letter**、但 spirit 仍對齊：

| 項 | 處理 |
|---|---|
| 字面承諾「v0.5.9 起對所有後續變動生效」 | ⚠️ 違反（v0.12.0 改了既有採用方目錄名）|
| 精神承諾「不對既有採用方產生太大痛點」 | ✅ 對齊（提供 migration script、採用方跑 2-3 個指令即完成）|
| `core/versioning-migration §2.3.4` v0.x 階段彈性條款 | ✅ 對齊（當前仍 v0.x、明文「容許破壞性變動」）|
| v1.0+ 永久承諾 | ✅ 對齊 — 自 v0.12.0 起 `agents-commons/` 結構為 v1.0+ 永久承諾、不再 rename |

### 10.2 採用方升版動作

提供 `tools/vendor/commons/migrate-to-agents-commons.sh` 一鍵 migration script（三 phase 互動式、依 `tools/uninstall-spec` 紀律精神）：

```bash
# 採用方升 v0.12.0 跑：
bash ~/.agentcharter/tools/vendor/commons/migrate-to-agents-commons.sh
```

Script 動作：
1. **Phase 1 dry-run**：grep `agent-commons` 顯示影響清單 + `git mv` 預覽
2. **Phase 2 確認**：git status 必乾淨 + 三次 user 確認（同 uninstall-spec 紀律）
3. **Phase 3 動作**：
   - `git mv agent-commons agents-commons`
   - sed `mapping.yaml.common_memory_root` 值
   - sed 採用方專案內文檔 `agent-commons/` → `agents-commons/`（排除 `.git/` / CHANGELOG / 歷史 walkthroughs）
   - 提示重跑 self-instantiation（vendor slash command 內路徑更新）
   - 提示重跑 `install-git-hooks.sh --update`（commit hook deploy target 更新）

採用方實際痛點：跑 **2-3 個指令**（migration script + install-hooks + 重 self-instantiate）= 與 v0.10.2 BREAKING-LITE PATCH 痛點等級。

### 10.3 doctor 偵測未遷移

`tools/doctor-spec §3.14` 加 W1401「mapping.yaml `common_memory_root` 已是 `agents-commons/` 但目錄仍是 `agent-commons/`」自動偵測引導 — 漏跑 migration script 會自動提示。

### 10.4 charter 內歷史 audit trail 凍結原則

- CHANGELOG.md 過去 entry（v0.11.x↓）— **不改**、保留 `agent-commons/` 歷史敘事（對齊 F3 不捏造歷史）
- 9 個歷史 walkthroughs（`examples/upgrades/v0.7.5-to-v0.8.0.md` ... `v0.10.6-to-v0.11.0-antigravity-migration.md`）— **不改**
- `.claude_temp/` 既有 entry — **不改**
- `examples/cryptobot/mapping.md` — **不改**

v0.12.0 起新 entry 用 `agents-commons/`、舊 entry 保留 `agent-commons/` + 加交叉引用「v0.12.0 BREAKING rename 詳見 §10」。

---

## 11. 變更歷史

### v0.5（自 v0.12.0 起）

**動作**：BREAKING-MEDIUM rename 預設名稱 `agent-commons/` → `agents-commons/`：
- frontmatter 狀態 v0.4.1 → v0.5 + 加 rename 摘要 + since 加 v0.12.0 預設名 rename 註
- §1 條文 + §2 / §3 / §4 / §5 / §8.3 / §9 預設名稱全 sweep（除歷史敘事保留）
- 新加 §10「v0.12.0 BREAKING-MEDIUM rename 紀律」段
- 新加 §11 變更歷史段

**觸發**：2026-05-22 user LIVE 提出命名語意修正 — 對齊 charter 設計初衷「跨 AI 協作 = 多 agents」+ dbSDK PM AI 跨 vendor 報告 LIVE 觀察。

**修訂類型**：BREAKING-MEDIUM（依 `versioning-migration §2`）— 既有採用方需跑 migration script、對齊「提供自動遷移工具讓痛點低」精神。

**連動範圍**（同 v0.12.0 release）：
- `core/charter-config §3` mapping.yaml schema 預設值改
- `core/versioning-migration §2.3.5`（新加段）
- `tools/vendor/commons/migrate-to-agents-commons.sh` 新檔
- `tools/doctor-spec §3.14`（W1401 偵測未遷移）
- `templates/agent-commons/` 目錄 rename → `templates/agents-commons/`
- 4 個 preset YAML charter_version `0.11.0` → `0.12.0`
- `CHANGELOG.md` v0.12.0 段
- `examples/upgrades/v0.10.6-to-v0.12.0-antigravity-canonical-rename.md` 採用方完整 walkthrough

### v0.4.1（初版）

定義 Common Memory Root 架構級約定、預設名稱 `agent-commons/`、不可分散原則、跨 AI 共讀規範、命名規則。**v0.12.0 仍 hold「不可分散」+「跨 AI 共讀」核心架構紀律**、只 rename 預設目錄名。
