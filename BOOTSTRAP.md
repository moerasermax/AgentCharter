# AgentCharter — 入口

> **給誰**：第一次接觸 AgentCharter 的採用方，或「我記得它怎麼用但忘了入口在哪」。
> **30 秒讀完**，然後點連結執行。
> **要看完整說明？** → [README.md](./README.md)

---

## 這是什麼

AgentCharter 是一套多 AI 協作規範框架 — 解決「**Claude 和 Gemini 在同一個專案工作時如何不互相踩踏、AI 宣告成功但實際沒做、兩個 AI 彼此對不上**」的問題。

框架本體是一份規範集（`~/.agentcharter/`）。你的專案裡會有一個共享記憶目錄（`agent-commons/`），讓不同廠商的 AI 能對齊狀態、安全協作。

---

## 兩層架構（30 秒看懂隔離設計）

```
~/.agentcharter/                ← ① framework 層（規範集，一次 clone，所有專案共用）
  core/          條款（25 條紀律規範）
  tools/         spec（init / doctor / upgrade-verify 等工具設計）
  templates/     範本（capsule / handoff / reflection 等）
  roles/         角色 spec（engineer / pm / auditor / doctor）

your-project/
└── agent-commons/              ← ② project 層（每個專案自己的，framework 升級不影響這裡）
    ├── _config/                profile.yaml（preset 設定）+ mapping.yaml（路徑對應）
    ├── capsules/               任務契約（PM 寫、Engineer 抽驗）
    ├── handoffs/               跨 session 接班點
    ├── protocols/              領域公理（金融 / 醫療 / 業務規則等鐵律）
    ├── state/                  工具狀態（failure_mode_log / nextwork）
    └── roles/                  角色私有空間
        ├── engineer/           Engineer sessions / drafts / reflections
        └── pm/                 PM sessions / drafts / reflections
```

**三個關鍵保證**：

| 保證 | 含義 |
|---|---|
| **framework 升級 ≠ 自動升專案** | `git pull` 更新 `~/.agentcharter/` 不會動你的 `agent-commons/`；升版是你的主動選擇 |
| **framework 比專案新 OK** | `~/.agentcharter/` 是 v0.9.x、你的專案 profile 寫 v0.8.x — 完全合法，按 [UPGRADE.md](./UPGRADE.md) 升版即可 |
| **專案資產完全獨立** | `agent-commons/` 只在你的 repo 裡；即使砍掉 `~/.agentcharter/`，現有資產（capsules / handoffs / protocols）不會消失 |

---

## 你要做什麼？

### 🆕 第一次接入

**貼給你的 AI（替換 `<>` 內容後貼）**：

```
請幫我採用 AgentCharter 框架。

前置確認：
- charter 在 ~/.agentcharter/（請先確認目錄存在，若不存在請執行：
  git clone https://github.com/moerasermax/AgentCharter ~/.agentcharter）
- 我的專案在目前工作目錄

請依 ~/.agentcharter/QUICKSTART.md 的 5 步流程帶我完成接入：
- preset: standard（不確定選 standard；探索期選 essential）
- domain-axioms: 我先用路徑 B（AI 讀 codebase 代產草稿，我校正）

依流程執行，每步完成後告訴我下一步要做什麼。
```

→ 詳細 5 步流程說明：**[QUICKSTART.md](./QUICKSTART.md)**

---

### ⬆️ 已有專案、要升版

先看決策表（30 秒）：**[UPGRADE.md](./UPGRADE.md)**

**PATCH 升版（直接貼給 AI）**：

```
請對本專案執行 AgentCharter PATCH 升版：

1. cd ~/.agentcharter && git pull origin main
2. 告訴我 pull 後的最新版本號（讀 CHANGELOG.md 首行）
3. 把本專案 agent-commons/_config/profile.yaml 的 charter_version 改為該版本號
4. 跑 /charter-doctor（或依 tools/doctor-spec.md §2.1 模式 A 跑一次 doctor 健康檢查）
5. 回報結果：errors / warnings 數量 + 需要人工確認的項目
```

**MINOR 升版** — 需要 walkthrough，依 [UPGRADE.md](./UPGRADE.md) 找對應版本的 step-by-step 指引。

---

### 🔍 只是想讀文件 / 了解設計

| 我想知道 | 讀這個 |
|---|---|
| charter 的設計哲學是什麼 | [README.md §設計哲學](./README.md) |
| 每個步驟為什麼這樣做 | [TUTORIAL.md](./TUTORIAL.md) |
| 有哪些條款、各條款在做什麼 | [core/](./core/)（25 個 .md）|
| 真實採用案例長什麼樣 | [examples/cryptobot/](./examples/cryptobot/) |
| AI 要讀的採用指南 | [ADOPTION.md](./ADOPTION.md) |

---

## 不確定選哪個 preset？

| 你的情況 | 選這個 | init token 消耗 |
|---|---|---|
| 探索期 / 單人 / 快迭代 / 「只要 AI 別瞎掰」| `essential` | **< 5k** |
| 一般雙 AI 協作（Claude + Gemini）| `standard`（推薦預設）| ~ 30k |
| 嚴格合規 / 金融 / 醫療 / 高風險領域 | `strict` | ~ 35k |

漸進升維：essential → minimal → standard → strict。任何時候只需改 `agent-commons/_config/profile.yaml` 一行：`preset: standard`。

---

## 文件地圖

| 文件 | 受眾 | 用途 |
|---|---|---|
| **`BOOTSTRAP.md`（本文）** | 人類採用方 | 30 秒入口 + 快速路由 |
| [`QUICKSTART.md`](./QUICKSTART.md) | 人類採用方 | 5 分鐘接入流程（第一次）|
| [`UPGRADE.md`](./UPGRADE.md) | 人類採用方 | 升版決策表 + 快速路徑 |
| [`TUTORIAL.md`](./TUTORIAL.md) | 人類採用方 | 工具書 / reference（卡關時查）|
| [`ADOPTION.md`](./ADOPTION.md) | AI | AI 自含 context 採用指南（AI 接班時讀）|
| [`README.md`](./README.md) | 任何人 | 介紹 + 設計哲學 + 條款索引 |

---

## 變更歷史

- **v1.0（2026-05-03，charter v0.9.9）** — 初版入口檔（v0.7.6 議程、持續延後至 v0.9.9 落地）：兩層架構圖 + 三個關鍵保證 + 快速路由 + 升版快速執行版（全部「給 AI 的 prompt」格式）+ 文件地圖 + preset 決策表。對應 dogfood signal #21（雙層架構無清楚入口）+ NEXT.md v0.7.6 BOOTSTRAP 設計紀律（所有執行段必給 AI prompt）。
