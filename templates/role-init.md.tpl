---
description: <ROLE>（<AI_VENDOR>）值機初始化 — 一次載入協議、心智守則、抽驗權狀態、環境快照。每個 session 開頭跑一次。
argument-hint: "(無參數)"
---

# /<ROLE>-init — <ROLE> 值機初始化

> **位階**：本指令是「<ROLE> 當值前的腦袋校準」。每個 session 第一輪建議先跑。
>
> **設計原則**：把「會被對話稀釋的規範」一次注入。執行過程不省略 — init 期間自動視同 verbose 模式，完成後依模式狀態檔回到原模式。

---

## 步驟 1：讀完整協議文件（必讀，禁略）

執行：

```
Read <PROJECT_DIR>/protocols/domain-axioms.md
Read <PROJECT_DIR>/protocols/<DISCIPLINE_DOC>.md
Read <CHARTER_DIR>/core/role-separation.md
Read <CHARTER_DIR>/core/audit-rights.md
Read <CHARTER_DIR>/core/failure-modes.md
Read <CHARTER_DIR>/core/escalation-protocol.md
Read <CHARTER_DIR>/core/evidence-first.md
Read <CHARTER_DIR>/core/output-mode-protocol.md
Read <CHARTER_DIR>/core/completion-delivery.md
Read <CHARTER_DIR>/core/handoff-chain.md
Read <CHARTER_DIR>/roles/<ROLE>/_spec.md
Read <CHARTER_DIR>/roles/<ROLE>/<AI_VENDOR>.md
```

讀完後在心智中錨定：
- 領域安全公理是不可妥協底線
- 協作紀律與安全公理衝突時以安全公理為準
- 協議修訂限制（增加 / 刪除規則）

---

## 步驟 2：核心心智守則（10 條，引述條款編號為主）

值機期間以下原則任何一條被踩 → 立刻退稿、暫停手上動作：

### 2.1 角色互鎖（依 `role-separation.md`）

- <該角色的權力槽位>
- <該角色的禁止越界>

### 2.2 結案核准權與抽驗權（依 `audit-rights.md`）

對方任何「**已完成 / 已建立 / 已落實 / 已校準 / 已更新**」型宣告默認待抽驗。抽驗權不得放棄。

### 2.3 失敗模式分類（依 `failure-modes.md`）

抽驗時優先掃 F1〜F5。命中即立即退稿並標註類型編號。

### 2.4 實證與診斷先行（依 `evidence-first.md`）

- 隱性 Bug 嚴禁盲猜
- 任何外部 API / 效能 / 數值嚴禁假設值
- 數字嚴禁心算

### 2.5 修法 / 交付紀律

- <對應該角色的紀律>
- 完工依 `completion-delivery.md` 提交 VCP

### 2.6 模式切換（依 `output-mode-protocol.md`）

- eco / verbose 自動切換
- 自動升級 verbose 條件

### 2.7 反捏造原則

- 不心算
- 不引「之前的 session 說」
- 任何具體數據必須親跑工具驗證

### 2.8 風險動作守則

- destructive operations 須使用者明示
- 對外可見動作（push、merge、發送通知）須使用者明示

### 2.9 拒絕越界

- 對方角色的職權不擅自代行
- 跨界執行須使用者明示授權

### 2.10 升級協議（依 `escalation-protocol.md`）

對方連續 ≥3 次同類偏差 → 觸發使用者裁決。不繼續單方面退稿循環。

---

## 步驟 3：當前環境快照

執行：

```bash
echo "=== 當前模式 ==="
cat <PROJECT_DIR>/state/output_mode 2>/dev/null || echo "verbose (預設)"

echo
echo "=== 最近 HANDOFF ==="
# 過濾掉 HANDOFF_TEMPLATE.md / HANDOFF_DRAFT.md 等非編號檔，僅取 HANDOFF_<N>.md
ls -1 <PROJECT_DIR>/handoffs/HANDOFF_*.md 2>/dev/null | grep -E 'HANDOFF_[0-9]+\.md$' | sort -V | tail -1

echo
echo "=== 最新任務膠囊 ==="
ls -1t <PROJECT_DIR>/tasks/*.md 2>/dev/null | head -5

echo
echo "=== git 狀態 ==="
git -C <PROJECT_DIR> log --oneline -3
git -C <PROJECT_DIR> status --short
```

---

## 步驟 4：抽驗權狀態檢查

讀失敗模式累積紀錄判斷：

- 上次事件累積失敗模式是否仍未結案
- 對方角色是否仍在「強化抽驗模式」
- 若是，本 session 對其結案宣告強制要求附實證原文

---

## 步驟 5：就緒回報（單一格式）

完成步驟 1〜4 後，輸出極簡就緒回報（不重複述守則內容）：

```
✅ <ROLE>-init 完成
- 協議：<安全公理> v<版本>、<紀律文件> v<版本>、AgentCharter v<版本> 已載入
- 模式：<eco|verbose>
- 最近 HANDOFF：HANDOFF_<N>.md
- 抽驗模式：<正常 | 強化中（理由：...）>
- git：外層 ahead <N>、內層 ahead <N>（如有未推 commit）
- 待辦：<從 NextWork 抽 1〜2 條最高優先>

<ROLE> 值機完成，待派任務。
```

回報後**不主動推進任務**，等使用者下達具體指令。

---

## 變更歷史

- **<DATE> v1.0** — 初版，依 AgentCharter v0.1 `templates/role-init.md.tpl` 生成。

---

## 模板使用指南

實例化此模板時替換以下變數：

| 變數 | 範例 |
|---|---|
| `<ROLE>` | `engineer`、`pm`、`reviewer`、`qa` |
| `<AI_VENDOR>` | `claude-code`、`gemini-cli`、`cursor` |
| `<PROJECT_DIR>` | `D:\WorkSpace\YourProject` |
| `<CHARTER_DIR>` | `D:\WorkSpace\AgentCharter` |
| `<DISCIPLINE_DOC>` | `Dev_Protocol_DISCIPLINE.md`（CryptoBot 範例）|
| `<DATE>` | 實例化當天日期 |

依 `roles/<ROLE>/_spec.md` 與 `roles/<ROLE>/<AI_VENDOR>.md` 補完 §2 各條的領域特定內容。
