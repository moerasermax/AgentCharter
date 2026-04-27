# Role Init Template（角色初始化模板）

> **狀態**：v0.1
> **位階**：core 通用條款。

---

## 1. 用途

任何角色在 session 開頭應跑一次 `<role>-init`，把「會被對話稀釋的規範」一次注入。本檔定義所有 `/<role>-init` slash command 該有的最小骨架。

---

## 2. 五步驟骨架

每個 `/<role>-init` 都應實作以下五步驟，順序固定：

### 步驟 1 — 載入完整協議文件

```
Read <project>/protocols/domain-axioms.md
Read <project>/protocols/<discipline-doc>.md
（含本框架 core/* 引用）
```

讀完後在心智中錨定：
- 領域安全公理（domain-axioms）是不可妥協底線
- 協作紀律與安全公理衝突時以安全公理為準
- 協議修訂限制（增加 / 刪除規則）

### 步驟 2 — 列出核心心智守則（10 條左右）

針對該角色**會被踩到的紅線**，每條一句話 + 條款引述。範例：

- 角色互鎖（依 `role-separation.md`）
- 抽驗權不得放棄（依 `audit-rights.md`）
- 失敗模式 F1〜Fn 偵測表（依 `failure-modes.md`）
- 實證先行（依 `evidence-first.md`）
- 完工交付規範（依 `completion-delivery.md`）
- 模式切換（依 `output-mode-protocol.md`）
- 反捏造原則
- 風險動作守則
- 拒絕越界

### 步驟 3 — 當前環境快照

執行：

```bash
echo "=== 當前模式 ==="
cat <project>/state/output_mode 2>/dev/null || echo "verbose (預設)"

echo "=== 最近 HANDOFF ==="
ls -1 <project>/handoffs/HANDOFF_*.md | sort -V | tail -1

echo "=== 最新任務膠囊 ==="
ls -1t <project>/tasks/*.md 2>/dev/null | head -5

echo "=== git 狀態 ==="
git -C <project> log --oneline -3
git -C <project> status --short
```

### 步驟 4 — 抽驗權狀態檢查

讀失敗模式累積紀錄（如 `<project>/protocols/<discipline>.md §<section>`）判斷：

- 上次事件累積失敗模式是否仍未結案
- 對方角色是否仍在「強化抽驗模式」
- 若是，本 session 對其結案宣告強制要求附實證原文

### 步驟 5 — 就緒回報（極簡單一格式）

```
✅ <role>-init 完成
- 協議：<安全公理> v<版本>、<紀律文件> v<版本> 已載入
- 模式：<eco|verbose>
- 最近 HANDOFF：HANDOFF_<N>.md
- 抽驗模式：<正常 | 強化中（理由：...）>
- git：外層 ahead <N>、內層 ahead <N>（如有未推 commit）
- 待辦：<從 NextWork 抽 1〜2 條最高優先>

<role> 值機完成，待派任務。
```

回報後**不主動推進任務**，等使用者下達具體指令。

---

## 3. 設計取捨

| 取捨 | 理由 |
|---|---|
| eco 模式下 init 過程不省略 | 規範載入須完整，否則 session 中後段易淡化 |
| 內容綁定條款編號 | 後續對話可精確引用，避免模糊「依紀律」|
| 就緒回報後不主動推進 | 等使用者下達指令，避免越界 |
| 變更歷史段（檔案末尾）| 每次協議升級時追加版本紀錄，留下決策痕跡 |

---

## 4. 各 AI 實作差異

| AI | Init 觸發 |
|---|---|
| Claude Code | slash command（`.claude/commands/<role>-init.md`）|
| Gemini CLI | slash command（不同語法，等效）|
| Cursor | 工作區 prompt template |
| 無 slash command 系統 | 對話開頭手動貼入「請執行 <role>-init」|

---

## 5. 與其他 core 條款的關係

所有 core 條款都應在 init 時被引用至少一次（步驟 1 完整讀，步驟 2 列重點）。
