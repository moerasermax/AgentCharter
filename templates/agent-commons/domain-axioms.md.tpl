---
# v0.7.1 加：mutability frontmatter（紀律本體留 v0.8.0 完整條款化）
status: USER-RATIFIED          # 或 AI-DRAFTED（路徑 B AI 代產草稿、待 user 校）/ DRAFT
mutability_default: APPEND-ONLY # 或 IMMUTABLE-by-AI / FULL-MUTABLE（per-clause 可在條款層覆寫）
created_by: user                # 或 ai-drafted（路徑 B）
created_at: <YYYY-MM-DD>
---

# <PROJECT_NAME> 開發鐵律 (Domain Axioms)

> **版本**：v<X.Y> · <YYYY-MM-DD> · <更新主題>
> **位階**：本文件為本專案最高且唯一不可妥協之領域底線。違反任一條，系統將面臨直接 <核心後果，如「資金損失 / 安全事故 / 合規違反」>。
> **口訣**：<n 字濃縮，便於記憶>
> **修訂限制**：本文件**僅限增加**內容。若需執行「刪除」，必須向使用者連續確認三次並取得授權（對應 `core/domain-axiom-slot §3.2`；v0.7.1 frontmatter scaffold；v0.8.0 將升格為架構級 condition mutability 條款 — IMMUTABLE-by-AI / APPEND-ONLY / FULL-MUTABLE 三層）。

---

## 🛑 第一梯 · <血鐵律名>（違反 = <直接後果>）

### ① <條款名>（<層級標籤，如 L1>）

<!-- 可選：每條款 per-clause mutability 覆寫（v0.7.1 加；不寫則繼承 frontmatter mutability_default）
mutability: IMMUTABLE-by-AI    # 或 APPEND-ONLY / FULL-MUTABLE
-->

<條款內容 — 簡潔陳述，可分多面向：計算面 / 解析面 / 操作面 / ...>

> **後果**：<違反的具體後果，禁用「會出錯」這類模糊描述>

### ② <條款名>

<條款內容>

> **後果**：<具體後果>

### ③ ...

---

## 🏛️ 第二梯 · <架構鐵律名>（違反 = <骨架崩潰後無法救>）

### ⑥ <條款名>（架構限制）

<條款內容 — 含具體禁令、相依方向、絕對禁令清單>

具體執行面的絕對禁令：
- <禁令 1>
- <禁令 2>

### ⑦ <條款名>

<條款內容>

> **後果**：<具體後果>

---

## ✅ 已落實鐵律 · <主題分組>（<事件 ID> 完成 <YYYY-MM-DD>）

- <鐵律編號 + 條款名> ✅ <事件 ID>（含補強附註）
- <鐵律編號 + 條款名> ✅ <事件 ID>

---

## 模板使用指南

實例化此模板時替換以下變數：

| 變數 | 範例 |
|---|---|
| `<PROJECT_NAME>` | 你的專案名 |
| 條款編號 | ①②③ 連續編號（沿襲 CryptoBot IRON 慣例）|
| 層級標籤 | L1（精度級）、L2（時間級）、L3（編碼級）等專案約定 |

### 撰寫紀律

| 紀律 | 範例 |
|---|---|
| 每條必含「後果」段 | 違反此條的具體損害（資金 / 安全 / 合規），禁模糊描述 |
| 條款應**可被驗證** | 「禁用 float / double」可 grep；「應該寫得好」不可驗 |
| 「血鐵律」vs「架構鐵律」分梯 | 血鐵律：違反即時損失；架構鐵律：違反緩慢腐蝕 |
| 修訂只增不刪 | 刪除須三重授權（依 CryptoBot IRON 慣例）|
| 引用 IM 章節 | 條款補強處引用具體 `Institutional_Memory §<n>` |

### 與 AgentCharter 的關係

- 本文件是**領域特定**的，AgentCharter 不規範內容
- AgentCharter 提供「**Domain Safety Axiom Slot**」：你的條款放在這個槽位
- AgentCharter 的 `core/*` 是**通用紀律**，與本文件互補（紀律衝突時以本文件為準，依 `core/domain-axiom-slot.md §2.1`）

依 `mapping.yaml.domain_axioms.primary` 指向本檔位置；通常放在 `<common-memory-root>/protocols/` 下。

→ **撰寫紀律的最低要求**（必含後果段、可驗證、有編號等）由 `core/domain-axiom-slot.md §3` 規範；本檔的「撰寫紀律」段是其建議實作。違反 → `/charter-doctor` 報錯（依 `domain-axiom-slot.md §6` 嚴重度分級）。

### 初次生成路徑（v0.7.1 加，雙路徑）

依 `core/domain-axiom-slot.md §3.3`：

| 路徑 | 動作 | 適用 |
|---|---|---|
| **A. user 主筆** | user 親自寫 → 預設 `Status: USER-RATIFIED` + `created_by: user` | user 對領域底線有明確心智模型；典型場景 |
| **B. AI 讀 codebase 代產草稿 + user 校** | user 邀請 AI 讀既有 codebase 推斷紀律 → 寫 draft → 預設 `Status: AI-DRAFTED` + `created_by: ai-drafted` → user 校過後親自改為 `USER-RATIFIED` | user 想低門檻起手 / AI 有 codebase context 比通用 stub 準 |

**路徑 B 觸發 prompt 範本**：見 `templates/agent-commons/domain-axioms-via-ai-draft-prompt.md.tpl`。

**路徑 B 紀律**（對齊 v0.7.0 PROVISIONAL/ACTIVE 二態 + multi-role-tracking §3.4.4）：
- AI 寫的草稿**不能自己升 `USER-RATIFIED`** — 必須 user 親自改
- 草稿每條附「我從哪推斷的」（檔案路徑或 grep 結果）— 給 user 校時知道推斷依據
- AI 不可編造（只顯化 codebase 真實紀律 / 找不到就少寫幾條）
