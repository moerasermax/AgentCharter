# Versioning & Migration（版本演化與升級遷移規範）

> **狀態**：v0.1（自 v0.5.6 引入）
> **位階**：core 通用條款。**框架對自身版本演化的紀律**，並規範已採用專案的升級流程。
> **依存**：`charter-config.md`（schema 版本欄位）、`handoff-chain.md`（升級紀錄）、`audit-rights.md`（升級結果抽驗）

---

## 0. 為何需要本條款

當前狀態（v0.5.5）：
- `profile.yaml` 已有 `version`（profile schema 自身版本）+ `charter_version`（採用的 charter 版本）兩欄
- `tools/init-spec.md §6` 提到 `/charter-init --update` 但只 5 步驟，缺判斷依據
- `tools/doctor-spec.md §3.1` 引用「profile schema 版本相容」但無「相容」定義

採用方面對的盲區：
- 條款 v0.5 → v0.6 升級**破壞了什麼**？（若未明示，採用方不敢升）
- 升級失敗如何**安全回退**？
- 多 AI 環境下，**版本一致性**如何保證？

---

## 1. 條文

採用 AgentCharter 的專案 SHALL 在 `profile.yaml` 標明 `charter_version`；條款升級時依本條款流程遷移。框架在發布破壞性升級時 SHALL 提供 migration guide。

---

## 2. SemVer 對 AgentCharter 的具體含義

```
charter_version = MAJOR.MINOR.PATCH
```

| 升級類型 | 範圍 | 採用方需要做 | CHANGELOG 標籤 |
|---|---|---|---|
| **PATCH**（如 0.5.5 → 0.5.6）| 修字 / 補例 / 文件勘誤 / 不影響語意的明顯錯字 | 0 動作；自動相容 | （無特殊標籤）|
| **MINOR**（0.5.x → 0.6.0）| 新增條款、新增建議、schema 向後相容擴充、新增 preset、新增 §段 | 讀 CHANGELOG；視需要啟用新條款；既有專案無強制動作 | `### Added` / `### Modified` |
| **MAJOR**（0.x → 1.0、1.x → 2.0）| 條款重命名 / 移除 / 語意改變、schema 不相容、預設值改變 | **強制走 migration**；doctor 報告通過才得繼續使用 | `### BREAKING` |
| **架構級**（如 v0.4.1 / v0.5.0）| 架構級約定變更（在 0.x 階段），技術上 minor 但實質影響大 | 雙語：標 minor + CHANGELOG 顯著標明「架構級」；建議走 migration | `### BREAKING-LITE` 或顯著文字標明 |

### 2.1 BREAKING 升級的判定條件

任一即視為 BREAKING：

- 條款被**移除**或**重命名**（如 `init-template.md` → `role-init-mandate.md`）
- 條款 §段或欄位的**語意改變**（同名但行為不同）
- `mapping.yaml` / `profile.yaml` schema 的**必填欄位新增** / 既有欄位語意改變
- 預設值改變且新預設**更嚴格**（如 `audit-rights.require_stdout_in_normal_mode` 從 false 改 true 即 v0.2 的歷史改動）
- F-mode 編號**重新分配**

新增條款、新增可選欄位、新增寬鬆建議皆**不**為 BREAKING。

### 2.2 PATCH 升級的判定條件

僅以下類型為 PATCH（其餘均升 MINOR）：

- 錯字修正
- CHANGELOG / README / GOVERNANCE 等 meta 檔內容修訂
- 條款內**範例**修改（不改規範本身）
- 模糊措辭澄清（澄清前後語意應等價）

---

## 3. 已採用專案的遷移流程

### 3.1 標準流程（依 `tools/init-spec.md §6` 落實）

```
1. 讀 CHANGELOG.md 對應版本段
   ├─ 看 BREAKING 標籤 → 必走完整 migration
   ├─ 看 Added / Modified → 視需要啟用新條款
   └─ PATCH → 直接升 charter_version 即可

2. （MAJOR 才需要）讀 migrations/<from>-to-<to>.md（若 framework 提供）

3. 跑 /charter-doctor --target-version=<new>（dry-run 模式）
   └─ 列出本專案在新版下會踩到的問題

4. 應用 migration（依 §3.2 工具支援）

5. 跑 /charter-doctor 確認 ERROR/WARN 都通過

6. 升級 profile.yaml.charter_version = <new>

7. commit：「chore: bump charter_version <old> → <new>」
   commit message 須引用 BREAKING 條款編號（若有）
```

### 3.2 工具支援（v0.5+ 候選）

| 工具動作 | 描述 |
|---|---|
| `/charter-init --update` | 已落實（init-spec §6）；本條款 §3.1 是其判斷依據 |
| `/charter-doctor --target-version=<v>` | dry-run 模式，列出升新版會踩的問題（v0.5+ 候選）|
| `migrations/<from>-to-<to>.md` | BREAKING 升級時 framework 提供的人類可讀遷移指引 |
| `migrations/<from>-to-<to>.script` | （可選）自動化遷移腳本，僅修改 mapping.yaml / profile.yaml，不動專案內容 |

### 3.3 跨 MAJOR 升級

不允許跨 MAJOR 跳升（如 0.5 直跳 2.0）。

| 場景 | 處置 |
|---|---|
| 採用方在 0.5.x，最新為 1.2.0 | 須先升至 1.0.0 走完 migration，再升至 1.x.y 最新 |
| 採用方在 1.0.0，最新為 2.5.0 | 須先升至 2.0.0 走 migration，再升至 2.x.y |

理由：每次 MAJOR migration 規範「上一版 → 本版」，跳升等於跳過中間 migration，無法保證最終狀態一致。

---

## 4. 破壞性升級的告警

### 4.1 框架側（發布方）責任

| 動作 | 強度 |
|---|---|
| `CHANGELOG.md` 該版本段含 `### BREAKING` 標籤 | **強制** |
| BREAKING 段列出每項變更 + 影響範圍 + 對應 migration 步驟 | **強制** |
| 提供 `migrations/<from>-to-<to>.md`（若改動 ≥ 3 條 BREAKING）| 建議 |
| GOVERNANCE / Release notes 顯著標明 | 建議 |

### 4.2 採用方側責任

| 動作 | 強度 |
|---|---|
| `/charter-init --update` 偵測到主版號跳動 → 強制 prompt 確認 | **強制**（工具實作義務）|
| 升級前先 commit 當前狀態（dirty tree 拒絕升級）| **強制** |
| 升級後跑 doctor 通過才得 commit `charter_version` 升版 | **強制** |
| 升級事件寫進 HANDOFF（依 `handoff-chain §2` 第 3 項「協議版本迭代軌跡」）| **強制** |

---

## 5. 回退路徑

### 5.1 升級失敗的安全回退

```
1. /charter-doctor 報 ERROR 後 → 中斷 migration
2. git restore profile.yaml mapping.yaml
3. 如有 framework 提交的自動化遷移修改 → git restore 對應檔案
4. 回報使用者：哪一步失敗、CHANGELOG 對應段、建議下一動作
```

### 5.2 升級後發現問題的回退

升級後正常運行一段時間才發現問題（如某條款新行為不符專案需求）：

| 場景 | 處置 |
|---|---|
| 條款參數不適合 | 不必降版；修改 `profile.yaml.parameters.<condition>` |
| 條款本身不適合 | 不必降版；`profile.yaml.enabled.<condition> = false`（若 charter 允許停用）|
| 整版升級不適合 | 走 §5.3 整版降回 |

### 5.3 整版降回（最後手段）

```
1. git revert 到升級前的 commit（profile.yaml + mapping.yaml + HANDOFF）
2. 在 HANDOFF 寫降版理由（依 handoff-chain §2 第 3 項）
3. 視情況回報 framework 上游（issue / discussion）
```

降版**不是常態**。降版前先嘗試 §5.2 的局部關閉。

---

## 6. `version` 與 `charter_version` 雙軌

`profile.yaml` 開頭兩欄：

```yaml
version: "0.4.0"           # profile schema 自身版本
charter_version: "0.5.5"   # 採用的 charter 版本
```

| 欄位 | 演化軸 | 升級條件 |
|---|---|---|
| `version` | profile schema 結構變化 | 新增 / 移除 / 重命名 schema 欄位 |
| `charter_version` | charter 條款集變化 | 新增 / 移除 / 修訂條款 |

### 6.1 兩者獨立演化

兩個版號**不必同步**。例如：

| charter_version | version | 說明 |
|---|---|---|
| 0.5.5 | 0.4.0 | charter 已演化到 0.5.5，但 profile schema 自 0.4.0 後無結構變化 |
| 0.6.0 | 0.5.0 | charter 與 schema 同步升 minor |
| 1.0.0 | 1.0.0 | charter v1.0 公開化時，profile schema 也同步重整 |

### 6.2 相容性檢查

`/charter-doctor` 啟動時：

```
1. 讀 profile.yaml 的 version 與 charter_version
2. 對比 charter 目錄的最新 version 與 charter_version
3. 任一不相容 → 報 ERROR + 建議升級路徑
```

不相容判定：
- profile schema `version` MAJOR 不匹配 → ERROR（schema 結構不相容）
- profile schema `version` MINOR 落後 → WARN（建議升級但非阻擋）
- `charter_version` MAJOR 落後 → WARN（建議走 migration）
- `charter_version` 比 framework 還新 → ERROR（framework 不認得未來條款）

---

## 7. 多 AI 環境的版本一致性

同專案的所有 AI 須讀**同一份** `profile.yaml`，故 `charter_version` 自動一致。但跨 AI 接班的 init 守門步驟須額外驗證：

| 檢查項 | 動作 |
|---|---|
| AI 本機 charter 目錄存在且版本 ≥ profile.charter_version | init 守門 §1.4 必查 |
| 跨 AI 接班時前任 AI 跑的 charter 版本 | 在 HANDOFF 第 3 項「協議版本迭代軌跡」標明 |
| 接班 AI 的 charter 版本與 profile 不一致 | 中斷 init，要求使用者裁決（升 charter / 升 profile / 抓特定版）|

**禁令**：不允許不同 AI 在同 session 用不同 charter version；會導致協議解讀差異，破壞 cross-AI 兼容性。

---

## 8. 違反處置

| 違反方式 | 失敗模式 |
|---|---|
| 升級不走 doctor 即用新版運行 | F1（假宣告升級就位）|
| BREAKING 升級未在 HANDOFF 標明 | F4（紀錄偏差）+ 違反 `handoff-chain §2-3` |
| 框架發布破壞性升級未標 BREAKING 標籤 | 框架自身違規；採用方有權回退並回報 |
| 跨 MAJOR 跳升 | F5（規則記憶失效）；強制中斷 |
| 不同 AI 在同 session 用不同 charter version | F5 + cross-AI 兼容性破壞；強制中斷 |

---

## 9. 與其他 core 條款的關係

| 條款 | 關係 |
|---|---|
| `charter-config.md` | `version` / `charter_version` 欄位 schema 由其定義；本條款規範**何時、如何**升 |
| `handoff-chain.md` | 升級事件須寫進 HANDOFF §2 第 3 項；本條款是其依據 |
| `audit-rights.md` | 升級結果須由抽驗方驗證 doctor 通過 |
| `init-template.md §1.4` | init 守門須驗證 charter version 一致性（§7）|
| `cross-ai-handoff.md` | 跨 AI 場景的 charter version 一致性由本條款 §7 規範 |
| `failure-modes.md` | 違反觸發 F1 / F4 / F5（依 §8）|

---

## 10. 變更歷史

- **v0.1（自 v0.5.6 引入）** — 初版。定義 SemVer 對 AgentCharter 的具體語意（PATCH / MINOR / MAJOR / 架構級）、BREAKING 判定條件、已採用專案遷移流程、回退路徑、雙軌版號獨立演化、多 AI 版本一致性。

### 規劃中（v1.0 完整化）

- v1.0 公開化時本條款須升至 v1.0；屆時：
  - 補完 `migrations/<from>-to-<to>.md` 模板與範例
  - `/charter-doctor --target-version` dry-run 模式落實為工具
  - 第一次正式 BREAKING 升級時走完本條款流程，作為實證範例
- v0.5.6（本條款引入）→ v1.0 之間發生的所有版本提升均**不視為 BREAKING**（v0.x 階段條款仍在演化）；v1.0 之後嚴格遵循 SemVer
