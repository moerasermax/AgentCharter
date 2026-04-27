# Common Memory Root（共同記憶根目錄）

> **狀態**：v0.4.1
> **位階**：core 通用條款。**架構級約定** — 採用 AgentCharter 的專案必須遵守。

---

## 1. 條文

任何採用 AgentCharter 的專案，**多 AI 協作的所有共享資產**（任務膠囊、HANDOFF 鏈、協議文件、Institutional Memory、各角色私有區）必須位於**單一根目錄**之下。該根目錄稱為 **Common Memory Root**（共同記憶根目錄）。

**預設名稱**：`agent-commons/`

> 看到專案根目錄有 `agent-commons/` ＝ 採用 AgentCharter，其內為多 AI 對齊的單一真相位置。

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
- **採用識別**：看到 `agent-commons/` 即知此專案採用 AgentCharter
- **工具可預設啟動**：無 mapping.yaml 時亦可用預設路徑運作
- **跨 AI 認知一致**：任何 AI 都知道「對齊脈絡」要去哪裡讀

---

## 3. 必含子槽位（依條款啟用）

```
<project>/
└── agent-commons/                       ← Common Memory Root
    ├── capsules/                        ← 任務膠囊（依 audit-rights / completion-delivery 啟用）
    ├── handoffs/                        ← HANDOFF 鏈（依 handoff-chain 啟用）
    ├── protocols/                       ← 領域安全公理 + 紀律文件
    ├── institutional-memory/            ← 跨事件知識沉澱
    ├── nextwork.md                      ← 任務追蹤
    ├── state/                           ← 工具狀態檔（如 output_mode_file、failure_mode_log）
    └── roles/                           ← 角色私有區（依 role-separation 啟用）
        ├── engineer/
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

新採用框架的專案：**直接建 `agent-commons/` 即可上線**，無需配置。

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
└── agent-commons/                  # 或其他單一名稱
    ├── capsules/
    ├── handoffs/
    ├── protocols/
    └── institutional-memory/
```

→ 抽驗方有權對「分散在多處」的專案直接退稿，不進入內容判讀。

---

## 5. 跨 AI 共讀規範

每個 AI 角色 init 時的**第一動作**：

1. 解析 `mapping.yaml.common_memory_root`（缺則用預設 `agent-commons/`）
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

## 8. 「為什麼不允許名稱完全自由」

允許名稱覆寫是為了向後相容；但**不允許分散**是架構性硬約束。理由：

| 場景 | 結果 |
|---|---|
| 名稱不同（agent-commons / management / governance）| 工具讀 mapping 即可定位，無實質損失 |
| 散在多處 | 跨 AI 對齊失敗，framework 整體失效 |

→ 名稱是「方言」，分散是「協議裂解」。前者可寬，後者必嚴。
