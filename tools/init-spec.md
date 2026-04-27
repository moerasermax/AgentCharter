# /charter-init — 接入流程設計

> **狀態**：v0.4 Spec only（無實作）
> **位階**：tools / 設計文檔。

---

## 1. 目標

一鍵把 AgentCharter 接入既有專案：

1. 套用 preset profile.yaml
2. 寫 mapping.yaml（從 scan-draft 升級或從 preset 預設）
3. 為每個啟用的角色生成 `<role>-init` slash command
4. 跑 `/charter-doctor` 一次驗收結果

---

## 2. 用法

```
/charter-init <preset>
```

| 參數 | 說明 |
|---|---|
| `<preset>` | `minimal` / `standard` / `strict` / `from-scan`（從 scan-draft 升級） |

無參數時：呼叫 AskUserQuestion 詢問 preset。

---

## 3. 流程

### Phase 1：前置檢查

```
1. 檢查 .agentcharter/ 是否已存在
   - 不存在 → mkdir
   - 已存在且有 profile.yaml → 警告「已 init 過」+ 列出當前 preset
     詢問使用者：跳過 / 重新 init / 局部更新
2. 檢查 charter version 相容性
3. 檢查專案 git 狀態（建議乾淨工作樹）
```

### Phase 2：產生 profile.yaml

```
1. 讀 tools/profiles/<preset>.yaml 模板
2. 套用使用者環境（如時區）的局部覆寫
3. 詢問使用者：domain_axioms.primary 路徑
   - 若 scan-report 已偵測 → 預填，使用者確認
   - 若無 → 列出專案內候選，使用者選
4. 寫 .agentcharter/profile.yaml
```

### Phase 3：產生 mapping.yaml

```
1. 若 preset = from-scan：
   - 讀 .agentcharter/mapping-draft.yaml
   - 對信心 < 0.7 的條目，逐一詢問使用者
   - 升級為 .agentcharter/mapping.yaml
2. 若 preset = minimal/standard/strict：
   - 用 templates/management-layout.md 推薦結構填預設值
   - 詢問使用者是否客製化（建議走 /charter-scan 後再來）
3. 寫 .agentcharter/mapping.yaml
```

### Phase 4：建立角色資料夾 + 預留 self-instantiation 位置

對每個 `enabled.<role>: true` 的角色：

```
1. 建立 <common-memory-root>/roles/<role>/ 目錄結構：
   - sessions/ / drafts/ / reflections/ / private/
2. 寫入 _role.md（依 templates/agent-commons/_role.md.tpl）
   - 「各 AI 具象化位置」表所有 AI 標為 ❌（未實裝）
   - 切換歷史空白
3. ⚠️ 不自動生成任何 AI 的 slash command 檔
   - 框架不代生成（依 core/init-template.md §3.3 自我具象化原則）
   - 各 AI 第一次被指派此角色時自行具象化
```

### Phase 4.5：通知使用者下一步

init 完成後輸出：

```
✅ /charter-init 完成
- agent-commons/ 目錄建立完成
- 角色資料夾就位（_role.md 已生成，待 AI 自我具象化）
- 領域公理：<狀態：已就位 / PENDING_AXIOM>

下一步：
1. 若領域公理未補 → 撰寫 <common-memory-root>/protocols/<axiom>.md
2. 對每個要啟用的 AI 角色，跟該 AI 說「請以 <role> 身份接此專案」
   → AI 會讀 charter 規範 → 自我具象化 slash command 到自己位置
3. 跑 /charter-doctor 驗證
```

### Phase 5：跑 /charter-doctor

自動執行健康檢查（依 `tools/doctor-spec.md`），把結果寫入 `.agentcharter/health-report.md`，列出：

- 啟用的條款是否全部相依完整
- mapping 路徑是否全部存在
- 每個角色的 init slash command 是否就緒

---

## 4. 互動模式

`/charter-init` 設計為**半自動**：

| 操作 | 是否互動 |
|---|---|
| 套 preset | 自動（依 preset 模板）|
| 領域公理路徑 | 互動（詢問使用者確認）|
| mapping 低信心條目 | 互動（逐一確認）|
| 生成 slash command | 自動 |
| 健康檢查 | 自動 |

跨 AI 的考量：

- Claude Code：用 AskUserQuestion tool 互動
- 無互動工具的 AI：產生「待確認清單」由使用者另跑指令補完

---

## 5. 輸出

完成後 `.agentcharter/` 應含：

```
.agentcharter/
├── profile.yaml          ← 條款啟用配置
├── mapping.yaml          ← 路徑對映
├── health-report.md      ← /charter-doctor 結果
├── scan-report.md        ← (若有跑 /charter-scan)
└── mapping-draft.yaml    ← (若有跑 /charter-scan)
```

`.claude/commands/` 應含：

```
.claude/commands/
├── engineer-init.md      ← 自動生成
├── pm-init.md            ← 自動生成（若啟用）
└── <other-role>-init.md
```

---

## 6. 已 init 過的更新流程

當 charter version 升級或專案需求改變：

```
/charter-init --update
```

流程：

1. 讀現有 .agentcharter/profile.yaml
2. 比對最新 AgentCharter charter_version
3. 列出新增 / 修訂 / 移除的條款
4. 詢問使用者每項是否採用
5. 產出 diff，使用者確認後寫入

不覆寫舊配置 — 安全升級。

---

## 7. 失敗回滾

任何 phase 失敗 → 整個 init 操作回滾：

```
1. 用 git stash 暫存當前更動
2. 跑 init
3. 失敗 → git stash pop（恢復 init 前狀態）
4. 成功 → git stash drop
```

避免半成品 .agentcharter/ 污染專案。

---

## 8. 與其他條款的關係

| 條款 | 關係 |
|---|---|
| `core/charter-config.md` | 寫入 mapping/profile 須符合該 schema |
| `core/init-template.md` | 生成的 `<role>-init.md` 須符合該模板 |
| `tools/scan-spec.md` | from-scan preset 的輸入來源 |
| `tools/doctor-spec.md` | Phase 5 健康檢查 |

---

## 9. 實作節奏

| 版本 | 內容 |
|---|---|
| v0.4 | Spec only — 本文檔 |
| v0.5 | Claude Code slash command（讀 spec、執行 phase 1-5）|
| v0.6 | 跨 AI 共用 CLI |
