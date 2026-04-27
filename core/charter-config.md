# Charter Config（協議配置 schema）

> **狀態**：v0.4 Spec
> **位階**：core 通用條款。定義 `.agentcharter/` 目錄下兩份配置檔的 schema。

---

## 1. 設計目標

讓 AgentCharter 從「規範文件集」進化為「**可被工具讀取與執行的協議**」。透過兩份 YAML 配置檔，專案可以：

- 把既有目錄結構**對映**到框架抽象槽位（不需重組）
- **可插拔啟用**框架條款（不一定全用）
- 跨 AI 共用同一份配置（每個 AI init 時必讀）

---

## 2. 配置檔位置與生命週期

| 檔案 | 位置 | 入 git？ |
|---|---|---|
| `mapping.yaml` | `<project>/.agentcharter/mapping.yaml` | ✅ |
| `profile.yaml` | `<project>/.agentcharter/profile.yaml` | ✅ |
| `scan-report.md` | `<project>/.agentcharter/scan-report.md` | 可選 |
| `health-report.md` | `<project>/.agentcharter/health-report.md` | 可選 |

`.agentcharter/` 是專案根目錄下的標準資料夾，類似 `.git/`、`.vscode/`。

---

## 3. `mapping.yaml` Schema

```yaml
version: "0.4.0"                         # mapping schema 版本

# === 路徑對映：專案實際路徑 → 框架抽象槽位 ===
# 不存在的槽位可省略；省略 = 該槽位在本專案不存在
shared:
  capsules: <path>                       # 任務膠囊目錄
  handoffs: <path>                       # HANDOFF 鏈
  protocols: <path>                      # 領域公理 + 紀律文件
  institutional_memory:                  # 知識沉澱（可多檔）
    - <path1>
    - <path2>
  nextwork: <path>                       # 任務追蹤主檔（單檔）

roles:
  <role-name>:                           # engineer / pm / reviewer / 等
    sessions: <path>                     # 該角色的 session 工作筆記
    drafts: <path>                       # 跨 session 草稿
    reflections: <path>                  # 違規反省（依 violation-reflection.md）
    private: <path>                      # 私有臨時筆記（建議 .gitignore）

# === 領域公理指向 ===
domain_axioms:
  primary: <path>                        # 主要安全公理檔（如 IRON.md）
  alias: <short-name>                    # 短名稱，便於文件引用

# === 工具狀態檔 ===
state:
  output_mode_file: <path>               # output-mode-protocol 的旗標檔
  failure_mode_log: <path>               # failure-modes 累積紀錄
```

### Schema 細節

| 欄位 | 必填？ | 說明 |
|---|---|---|
| `version` | ✅ | 對齊本檔 schema 版本，不可省 |
| `shared.capsules` | 條件 | 啟用 audit-rights / completion-delivery 時必填 |
| `shared.handoffs` | 條件 | 啟用 handoff-chain 時必填 |
| `shared.protocols` | 條件 | 啟用 evidence-first / role-separation 時必填 |
| `shared.institutional_memory` | 選填 | 沒有可省，但建議至少一份 |
| `roles.<role>` | 條件 | 該角色被任意條款引用時必填 |
| `domain_axioms.primary` | ✅ | 必填，沒有領域公理 = 採用 AgentCharter 預設一般紀律 |

---

## 4. `profile.yaml` Schema

```yaml
version: "0.4.0"                         # profile schema 版本
charter_version: "0.3.0"                 # 採用的 AgentCharter 版本
preset: <preset-name>                    # minimal | standard | strict | custom

# === B1 粒度：條款啟用 ===
enabled:
  role-separation: <bool>
  audit-rights: <bool>
  failure-modes: <bool>
  structural-anti-fabrication: <bool>
  violation-reflection: <bool>
  escalation-protocol: <bool>
  evidence-first: <bool>
  output-mode-protocol: <bool>
  completion-delivery: <bool>
  handoff-chain: <bool>
  init-template: <bool>

# === B3 粒度：條款參數 ===
parameters:
  escalation-protocol:
    enhanced_audit_threshold: <int>      # 連 N 次升級至強化抽驗
    structural_failure_threshold: <int>  # 連 N 次升級至使用者裁決
  audit-rights:
    require_stdout_in_normal_mode: <bool>  # v0.2 後預設 true
    allow_trust_boundary_disclosure: <bool>  # 嚴格專案可關
  violation-reflection:
    block_next_task_until_filed: <bool>
    max_followup_replies: <int>          # 退稿後 N 次回覆內必須補交
  output-mode-protocol:
    default_mode: <eco | verbose>
    auto_upgrade_keywords: [<str>, ...]  # 觸發自動升級 verbose 的關鍵詞
  failure-modes:
    enable_modes: [<F1, F2, ...>]        # 哪些 F-mode 在本專案啟用
```

### B2 粒度（v0.5+ 候選，本版不實作）

未來可擴增「子條款層級」配置，例如：

```yaml
audit-rights:
  enabled: true
  sections:
    "§3-audit-sop": true
    "§4-trust-boundary-disclosure": false
    "§5-user-override-exception": true
```

v0.4 暫不支援，需要時 PR 升級 schema。

---

## 5. 條款相依表（Dependency）

啟用某條款時，依賴條款必須一併啟用：

| 條款 | 依賴 |
|---|---|
| `audit-rights` | `failure-modes` |
| `escalation-protocol` | `audit-rights`, `failure-modes` |
| `violation-reflection` | `audit-rights`, `failure-modes`, `structural-anti-fabrication` |
| `structural-anti-fabrication` | `audit-rights` |
| `completion-delivery` | `evidence-first` |
| `handoff-chain` | `audit-rights` |

`/charter-doctor` 在啟動時檢查相依完整性，缺漏即 warn。

---

## 6. 解析優先序

當 AI 讀取配置時：

1. 讀 `.agentcharter/profile.yaml`
2. 對 `enabled.<condition> = false` 的條款 → 跳過該條款的所有規範
3. 對 `enabled.<condition> = true` 的條款：
   a. 套用該條款 default 規範
   b. 若 `parameters.<condition>.<key>` 有值 → 覆寫 default
4. 讀 `.agentcharter/mapping.yaml`
5. 對所有路徑型操作（讀 capsule、寫 reflection 等）→ 替換成 mapping 指向的實際路徑

---

## 7. Preset 模板對應

`preset` 欄位對應 `tools/profiles/<preset>.yaml`，提供預設值。專案可：

- 直接用 preset（profile.yaml 內只寫 `preset: standard`，其他繼承）
- 用 preset + 局部覆寫（profile.yaml 內寫 preset 名 + 個別參數）
- 純 custom（preset: custom，所有條款顯式列出）

提供三個預設：

| Preset | 適用 |
|---|---|
| `minimal` | 探索型專案、單人 + 1 AI；只啟用最核心條款 |
| `standard` | 一般雙 AI 協作；CryptoBot 級別 |
| `strict` | 嚴格合規 / 多團隊 / 高風險領域；全條款啟用 + 嚴格閾值 |

詳見 `tools/profiles/`。

---

## 8. 與 core 既有條款的關係

| 條款 | 關係 |
|---|---|
| 所有 core/* | 透過 profile.yaml 控制啟用 |
| `init-template.md` | 各角色 init slash command 啟動時讀本配置 |
| `role-separation.md` | mapping.yaml 的 `roles.<role>` 對映實作 |
| 所有處理「事件累積」的條款 | parameters 提供可調閾值 |

---

## 9. 違反 schema 的處置

| 違反類型 | 處置 |
|---|---|
| 缺必填欄位 | `/charter-doctor` 報 ERROR，AI init 時拒絕推進 |
| 條款啟用但依賴未啟用 | report ERROR + 修復建議 |
| 條款啟用但 mapping 缺對應路徑 | report WARN |
| 未知欄位 | report INFO（未來版本可能加入） |
| schema 版本與 charter_version 不相容 | report ERROR，要求升級或回退 |
