# .claude_temp — 工作脈絡同步區

> **位階**：輕量同步區，非正式管理目錄。
> **用途**：讓使用者與工程師（Claude）隨時能跨 session 對齊「當前進度 / 待議 / 下一步」，不需要走完整 management/ + HANDOFF 流程。
> **生命週期**：v1.0 前用此目錄；v1.0 stable 後評估升格成 dogfooding 用的 `management/`。

---

## 含什麼

| 檔案 | 用途 |
|---|---|
| `STATUS.md` | 當前 snapshot — 版本、最近 commit、5 層防線狀態 |
| `NEXT.md` | 待議清單 — 含優先序、依存關係 |

## 不含什麼

- ❌ HANDOFF 鏈（單檔 STATUS.md 取代）
- ❌ DRAFT_CONTEXT（v0.x 階段不需要）
- ❌ 任務膠囊（v0.5 reference impl 開始才考慮）

## 跟對話 context 的差別

| 對話 context | .claude_temp |
|---|---|
| 揮發、跨 session 不存 | 入 git，跨機 / 跨 session 同步 |
| 完整討論軌跡 | 只存「結論 + 待議」 |
| 工程師單方寫 | 使用者也可手動編輯 |

## 與 framework 自身條款的關係

本目錄不採用框架自己的 capsule / handoff / institutional-memory 等流程 — 因為 v0.x 條款仍在演化，硬套自己會卡死遞迴。等到 v1.0 後再 dogfooding。

詳見 README.md「dogfooding 取捨」段（待補）。
