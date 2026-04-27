# Recommended Common Memory Root Layout（推薦目錄結構）

> **狀態**：v0.4.1（依 `core/common-memory-root.md` 升級）
> **位階**：template / 建議。**結構強制**（依 common-memory-root §3 必含子槽位）；**名稱可覆寫**（預設 `agent-commons/`）。

---

## 0. 與 common-memory-root 條款的對應

本 template 是 `core/common-memory-root.md` 的具體展開。**核心約束**：

- 多 AI 共享資產必須位於**單一根目錄**之下
- 預設根目錄名稱：**`agent-commons/`**
- 既有專案可透過 `mapping.yaml.common_memory_root` 覆寫名稱（如 CryptoBot 沿用舊名 `management/`）
- **禁止分散**到多個獨立根（違反 → 結構違規退稿）

---

## 1. 結構總覽

```
<project>/
├── agent-commons/                         ← Common Memory Root（依 common-memory-root.md）
│   ├── shared/                            ← 跨角色公共（任何角色可讀寫）
│   │   ├── capsules/                      ← 任務膠囊（PM 主筆、Engineer 抽驗）
│   │   ├── handoffs/                      ← HANDOFF_<N>.md 鏈
│   │   ├── protocols/                     ← 領域安全公理（IRON / HIPAA / 等）+ 紀律文件
│   │   ├── institutional-memory/          ← 跨事件知識沉澱
│   │   │   └── _root.md                   ← 索引主檔
│   │   └── nextwork.md                    ← 任務追蹤
│   │
│   └── roles/                             ← 角色私有區（依角色職能分，不依 AI 廠商分）
│       ├── engineer/
│       │   ├── sessions/<session-id>/     ← 每 session 工作筆記
│       │   ├── drafts/                    ← 跨 session 草稿（待轉到 shared）
│       │   ├── reflections/               ← 違規反省（依 violation-reflection.md）
│       │   └── private/                   ← 私有臨時筆記（建議 .gitignore）
│       │
│       ├── pm/
│       │   ├── sessions/<session-id>/
│       │   ├── drafts/
│       │   ├── reflections/
│       │   └── private/
│       │
│       └── reviewer/                      ← 視專案需要新增
│           └── ...
│
└── (src/, tests/, etc.)
```

---

## 2. 各資料夾用途

### 2.1 `agent-commons/shared/`

| 資料夾 | 用途 | 主筆 | 抽驗 |
|---|---|---|---|
| `capsules/` | 任務膠囊 | PM | Engineer |
| `handoffs/` | Session 交接鏈 | 主導角色（典型：PM）| 接班角色 |
| `protocols/` | 領域安全公理 + 紀律 | PM 主寫，Engineer 對「刪除」有否決權 | 雙向 |
| `institutional-memory/` | 跨事件知識 | 任意角色，五段格式（症狀→根因→診斷→修法→預防）| 雙向 |
| `nextwork.md` | 任務追蹤 | PM | Engineer |

### 2.2 `agent-commons/roles/<role>/`

| 子資料夾 | 用途 | 公開度 |
|---|---|---|
| `sessions/<id>/` | 該 session 內該角色的工作筆記、暫存草稿 | 入 git，永久保留 |
| `drafts/` | 跨 session 草稿（即將轉 shared 但未定稿）| 入 git |
| `reflections/<event-id>.md` | 違規反省（依 `core/violation-reflection.md` 強制結構）| **永不刪除**，入 git |
| `private/` | AI 個人臨時筆記（不影響共享）| 建議 `.gitignore` |

---

## 3. 多重身份場景

### 3.1 1 個 AI 同時扮演 2 個以上角色

| 場景 | 處置 |
|---|---|
| 同 AI 兼 Engineer + Reviewer | 跑 `/engineer-init` 進入 `roles/engineer/` context；切換時跑 `/reviewer-init` 進入 `roles/reviewer/` |
| 同 AI 在 A 專案當 X 角色、B 專案當 Y 角色 | 跨專案天然隔離（不同 working dir）|
| 同 AI 同 session 動態切換角色 | **不建議**。每次切換須走 init 流程，避免角色混淆 |

### 3.2 角色資料夾的識別

每個 `roles/<role>/` 應有 `_role.md`（首檔）標明：

```markdown
# Role: <role-name>

- Spec：引用 AgentCharter `roles/<role>/_spec.md`
- 當前扮演 AI（最近 session）：<AI 名稱>
- 切換歷史：<簡列>
```

→ 接班 AI 進入此資料夾時，第一個讀 `_role.md` 確認自己對齊正確角色。

---

## 4. .gitignore 建議

```gitignore
# 角色私有臨時區
agent-commons/roles/*/private/

# Session 暫存（依專案決定是否入 git）
# agent-commons/roles/*/sessions/*/tmp/
```

---

## 5. 與既有專案的遷移指引

### 5.1 漸進遷移（推薦）

不需立刻重組，分階段：

| 階段 | 動作 |
|---|---|
| Phase 1 | 把 `agent-commons/` 內**已有**的 capsule / handoff / protocols 歸入 `shared/` 子目錄 |
| Phase 2 | 為主要角色建 `roles/<role>/` 骨架，新事件起進入新位置 |
| Phase 3 | 舊內容保留原位（git history 仍可追溯），不強制搬遷 |

### 5.2 git 移動建議

```bash
# 範例：把舊的 agent-commons/capsules/ 搬到 agent-commons/shared/capsules/
git mv agent-commons/capsules agent-commons/shared/capsules
git commit -m "chore: reorganize agent-commons/ to AgentCharter layout (Phase 1)"
```

用 `git mv` 保留 history。

---

## 6. 何時不該採用此結構

| 情境 | 建議 |
|---|---|
| 單人 / 單 AI 專案，無協作 | 不必，框架是為多 AI 協作設計 |
| 短期實驗專案（< 1 month）| 不必，搬遷成本大於收益 |
| 既有結構 + 重組成本高 | Phase 3 永久保留舊位置即可 |

---

## 7. 與 core 條款的對應

| Core 條款 | 對應目錄 |
|---|---|
| `role-separation.md` | `roles/<role>/` 私有區實現職權分離 |
| `audit-rights.md` | `shared/capsules/` + `roles/<role>/reflections/` 構成抽驗 trail |
| `handoff-chain.md` | `shared/handoffs/HANDOFF_<N>.md` |
| `violation-reflection.md` | `roles/<role>/reflections/<event-id>.md` |
| `structural-anti-fabrication.md` | 所有結案宣告（capsules、handoffs、reflections）皆受其強制 |

---

## 8. 待議（v0.4+）

- **智慧掃描**（init 時自動探測既有專案結構並建議遷移路徑）— 待設計
- **可插拔優化模組**（讓任意專案可掛上 AgentCharter 而非重建）— 待設計
