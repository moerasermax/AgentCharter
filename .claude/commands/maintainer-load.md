---
description: AgentCharter 維護者接班 — 讀 .claude_temp/ 對齊當前脈絡，等待下達議題
argument-hint: "(無參數)"
---

# /maintainer-load

接班 AgentCharter charter 維護工作。本指令是 `core/maintainer-discipline.md` 的便利化工具（對應 §3 三層機制 + 跨 session 接班需求）。

## 不是給採用方用的

- 採用方的「角色 init」走 `core/init-template.md §3.3` self-instantiation（在 `.claude/commands/<role>-init.md`）
- 本指令僅給 **charter repo 維護者** 用，目的是快速對齊 `.claude_temp/` 累積的脈絡

## 執行流程

### Step 1：讀 charter 當前狀態（依序，不要批次）

依以下順序讀檔（每檔讀完不主動評論，只累積脈絡）：

1. `Read .claude_temp/STATUS.md` — 當前版本 / 條款清單 / 設計決策 / 接班指引
2. `Read .claude_temp/NEXT.md` — 待議事項 / 已完成清單 / dogfood signals
3. 若 `.claude_temp/` 內含 `*ONBOARDING.md`：用 Glob 找出並逐個 Read（進行中採用案例追蹤）

### Step 2：簡短就緒回報

讀完後輸出**就緒回報**（不主動推進，等使用者下達議題）。格式：

```
✅ /maintainer-load 完成

- charter 當前版本：v<X>（最近 commit `<hash>`）
- 條款數：<N> 條（其中 <M> 條 maintainer-only）
- 三 preset 啟用：minimal <a>/<總> · standard <b>/<總> · strict <c>/<總>
- 八個架構級概念已釐清（最近一個：<v0.5.X 的概念>）
- dogfood signal 累積：#1〜#<N>（最近一條：<簡述>）
- 待議事項（高優先 抽 1-2 條）：
  • <條目 1>
  • <條目 2>
- 採用案例追蹤（若有）：
  • <案例名稱>：<進度>

charter maintainer 接班完成，待下達議題。
```

### Step 3：禁主動推進

讀完只輸出就緒回報。**不**主動：
- 建議「我發現你應該做 X」
- 跑 `git status` / `git log`（除非使用者問）
- 讀 `core/*` 條款全文（太大；要時再讀）
- 讀 `templates/` / `examples/` / `tools/` 全文
- 任何 side effect（pull / push / commit / mkdir）

## 與 /checkpoints 的對照

| 動作 | /checkpoints（user 全域）| /maintainer-load（charter repo）|
|---|---|---|
| 對應專案 | CryptoBot 等用 `management/` 結構 | charter repo 自身（dogfooding 取捨用 `.claude_temp/`）|
| 讀什麼 | 最新 HANDOFF_<N>.md | STATUS.md + NEXT.md + ONBOARDING.md |
| 輸出 | 摘述為四點 | 八項就緒回報 |
| 副作用 | save 會寫 HANDOFF + git commit | **無 side effect**（純讀取）|

## 與 maintainer-discipline §3 的關係

`maintainer-discipline.md §3` 規定三層執行機制（工具層 / 流程層 / commit 層）。本指令是「**接班便利化**」的延伸 — 不在 §3 列出的三層內，而是對應 §1 條文「DRAFT 須是檔案」紀律的反向（**接班讀檔**對應**累積寫檔**）。

當前狀態（v0.6.1）：
- 寫檔：自然執行（每次重要工作更新 `.claude_temp/` + commit）
- 讀檔：本指令落實
- 抽驗執行載體：`roles/auditor/_spec.md`（v0.6.0 概念層誕生）— 跑 spec sync check 走 fresh-context sub-agent 達成「他抽」屬性
