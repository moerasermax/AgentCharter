# /charter-init — 接入流程設計

> **狀態**：v0.5.9（純 spec — 由 AI 自具象化執行，不附 python 工具）
> **位階**：tools / 設計文檔。
> **v0.5.9 演化軌跡**：
> - v0.4 起初版（Spec only）
> - v0.5.0 配置從 `.agentcharter/` 合併到 `agent-commons/_config/`
> - v0.5.1「框架不代生成 slash command」原則生效（Phase 4 改寫 — 採用方第一次接入時 prompt AI，AI 自具象化）
> - v0.5.7 曾落地為 python 工具（後於 v0.5.9 移除）
> - **v0.5.9 回歸純 spec** — framework 是規範集，不應包含實作工具。AI 依本 spec 自具象化 `/charter-init` slash command 為主流路徑
>
> **實作模式**：採用方對 AI 下 prompt「依本 spec 跑接入流程」，AI 完成接入 + 自具象化為 slash command（依 `core/init-template.md §3.3`）。未來重用打 `/charter-init <args>` 即可。

---

## 1. 目標

一鍵把 AgentCharter 接入既有專案：

1. 套用 preset profile.yaml（寫到 `agent-commons/_config/profile.yaml`）
2. 寫 mapping.yaml（從 scan-draft 升級或從 preset 預設）
3. 建立角色資料夾 + 預留 self-instantiation 位置（**不代生成 slash command**，依 v0.5.1）
4. 跑 `/charter-doctor` 一次驗收結果（Phase 5）
5. **觸發 Phase 5b 邀請第二 context 抽驗 init 結果**（v0.7.0 加 — 採用方接入流程「他抽」屬性）

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
1. 檢查 <common-memory-root>/_config/ 是否已存在（預設 agent-commons/_config/）
   - 不存在 → mkdir -p
   - 已存在且有 profile.yaml → 警告「已 init 過」+ 列出當前 preset
     詢問使用者：跳過 / 重新 init（須 --force）/ 局部更新
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
4. 寫 <common-memory-root>/_config/profile.yaml（對齊 v0.5.0 配置合併）
   - 確保 charter_version 對齊當前 charter repo 的 standard.yaml
```

### Phase 3：產生 mapping.yaml

```
1. 若 preset = from-scan：
   - 讀 <common-memory-root>/_config/mapping-draft.yaml（或 scan-spec 指定位置）
   - 對信心 < 0.7 的條目，逐一詢問使用者
   - 升級為 <common-memory-root>/_config/mapping.yaml
2. 若 preset = minimal/standard/strict：
   - 用 templates/management-layout.md 推薦結構填預設值
   - 詢問使用者是否客製化（建議走 /charter-scan 後再來）
3. 寫 <common-memory-root>/_config/mapping.yaml
   - 啟用 working-stack-discipline 時必含 shared.draft_context + shared.archive
```

### Phase 4：建立角色資料夾 + 預留 self-instantiation 位置

對每個 `enabled.<role>: true` 的角色：

```
1. 建立 <common-memory-root>/roles/<role>/ 目錄結構：
   - sessions/ / drafts/ / reflections/ / private/
2. 寫入 _role.md（依 templates/agent-commons/_role.md.tpl）
   - 「各 AI 具象化位置」表所有 AI 標為 ❌（未實裝）
   - 切換歷史空白
   - **Status 欄位寫 PROVISIONAL**（v0.7.0 加）— 等 user explicit 授權某 AI 接該角色後才升 ACTIVE
3. ⚠️ 不自動生成任何 AI 的 slash command 檔
   - 框架不代生成（依 core/init-template.md §3.3 自我具象化原則）
   - 各 AI 第一次被指派此角色時自行具象化
4. ⚠️ standard / strict preset 預期至少 scaffold pm + engineer 雙角色（v0.7.0 加）
   - 即使 user 尚未明示哪個 AI 扮 Engineer，仍應 scaffold 結構（保留兩端對稱可能）
   - 違反 = role-separation 對稱原則 + 採用方未來邀請新 vendor 時需補 scaffold 才能 self-instantiate
```

#### Phase 4.x — slash command 引用紀律（v0.7.0 加）

當 AI 跑完接入流程順便**自具象化** `/charter-init` slash command（依 `core/init-template.md §3.3.2` 七步驟）時，slash command 內引用 framework 路徑必須遵守紀律：

```
推薦引用方式優先序（v0.7.0）：
  (a) 環境變數 $AGENTCHARTER_HOME / $CHARTER_DIR     ← 最可移植
  (b) 相對 user home：~/.agentcharter/...              ← POSIX 慣例 + Windows PowerShell 7+ 支援
  (c) 採用方專案內相對路徑：agent-commons/...          ← 指向採用方資產時用

❌ 禁寫死當前 user home 絕對路徑：
   - C:/Users/<name>/.agentcharter/...   ← 換 user / 換電腦 / 換安裝位置即壞
   - /home/<user>/.agentcharter/...      ← 同上
```

對應 `core/init-template.md §3.3.2` 結尾的 slash command 引用紀律段。違反處置：要求 AI 重寫 slash command 採推薦引用方式。對應 dogfood signal #3 結構性實證（公司專案接入失敗 2026-04-28 — Gemini 寫 `.gemini/commands/charter-init.toml` 內含 `C:/Users/YCLIN/.agentcharter/`）。

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

依 `tools/doctor-spec.md` 由 AI 自具象化跑健康檢查（**呼叫模式 A**：人工健康檢查，依 `tools/doctor-spec.md §2.1`）。輸出 stdout 報告，採用方可 redirect 保存。

驗收項：

- 啟用的條款是否全部相依完整
- mapping 路徑是否全部存在
- 領域公理檔是否存在（依 domain-axiom-slot §3.1 強制要求）
- 每個角色的 init slash command 自我具象化狀態（依 v0.5.1）
- **§3.7 結構頂層完整性 + namespace vs 檔案路徑校驗**（v0.7.0 加，dogfood signal #4 第三次同類條款化）

### Phase 5b：邀請第二 context 抽驗 init 結果（v0.7.0 加）

> **動機**：dogfood signal #7 候選條款化 — 公司專案接入失敗 2026-04-28（見 `.claude_temp/COMPANY-ONBOARDING-FAILURE-AUDIT.md` 環境條件分析）：採用方接入流程「**單 AI、單 prompt、無中途介入**」是危險組合 — 跑 init-spec 5 phase + self-instantiation 七步驟 = 10+ 動作鏈，期間 doctor 自抽驗（Phase 5 / step 5）走的是同一條 LLM 自跑自驗鏈、結構性「自抽自驗禁令」名義上滿足實質上失效。
>
> 對比 maintainer 場景：v0.6.0 加 `roles/auditor/_spec.md` 封閉了 maintainer 半邊「自抽自驗」結構性盲區（透過 fresh-context sub-agent 達成「他抽」屬性）。**採用方場景需對稱機制** — 即 init 階段也走「他抽」。

**實作方式**（採用方擇一執行）：

| 路徑 | 動作 | 對應角色 |
|---|---|---|
| **A. fresh-context sub-agent** | 第一個 AI 在 init 結尾 spawn 一個 fresh-context sub-agent（如 Claude `Task` tool / Gemini sub-agent），給它讀 init 產物（agent-commons/ + .claude or .gemini/commands/ + doctor stdout）跑抽驗 | 由本 AI 兼任 validator 一次性抽驗（fresh context 達成「他抽」）|
| **B. 邀請另一 vendor AI** | 在不同 AI（不同 session / 不同 vendor）跑「請依 charter v0.x.x 對 \<採用方專案路徑\> 的 init 結果跑 validator 抽驗」 | 對應 `roles/validator/_spec.md §3.6`（v0.7.0 加 init 階段抽驗）|
| **C. user 親自抽驗** | user 親自跑 PowerShell / shell 對齊實際結構與 schema | user 直接行使抽驗權；對應 `audit-rights.md` 不放棄抽驗權 |

**抽驗集**（針對 init 結果）：

```
1. agent-commons/ 結構頂層完整性（capsules/ handoffs/ protocols/ institutional-memory/ 都在頂層）
2. agent-commons/shared/ 不應存在（namespace ≠ 檔案目錄）
3. profile.yaml schema 必填欄位齊（charter_version / preset / enabled / parameters）
4. profile.yaml `parameters.failure-modes.enable_modes` 含 F6
5. mapping.yaml `common_memory_root` + `working_stack_discipline.shared.draft_context` 必填齊
6. mapping.yaml layout.<key>: <value> 不含 namespace 同名中介層
7. domain_axioms.primary 指向的檔案實際存在（不只 schema 寫了路徑）
8. roles/<role>/_role.md `Status` 為 PROVISIONAL（除非 user 後續 explicit 授權升 ACTIVE）
9. roles/<role>/_role.md Sign-in Log 為空（除非 user 後續 explicit 授權）
10. <vendor>/commands/charter-init.<ext> 不寫死 user home 絕對路徑
```

**處置**：

- 0 errors → init 完全合格、向 user 回報「Phase 5b 通過、init 真正就緒」
- ≥ 1 errors → 第一個 AI 修補 + 重跑 Phase 5 + Phase 5b；不通過則 init 視為失敗、不可進工作階段

**對 user 的接入流程影響**：

```
原 v0.6.x：user prompt AI → AI 跑 Phase 1-5 → 回報就緒（user 看到回報才驗）
v0.7.0+：  user prompt AI → AI 跑 Phase 1-5 → AI 觸發 Phase 5b 他抽 → 回報含他抽結果 → user 看到雙重保證
```

採用方第一次接入時，第一個 AI 在 prompt 末加：「請依 init-spec.md 跑 Phase 1-5 + Phase 5b」即可觸發。

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

## 5. 輸出（v0.5.7 對齊）

完成後 `<common-memory-root>/_config/` 應含：

```
<common-memory-root>/                ← 預設 agent-commons/
├── _config/
│   ├── profile.yaml                 ← 條款啟用配置
│   ├── mapping.yaml                 ← 路徑對映
│   ├── scan-report.md               ← （若有跑 /charter-scan）
│   └── mapping-draft.yaml           ← （若有跑 /charter-scan）
├── capsules/  handoffs/  protocols/
├── institutional-memory/  state/  roles/
├── DRAFT_CONTEXT.md  nextwork.md
└── ...
```

**slash command 不在 init 輸出範圍**（依 v0.5.1）：

```
.claude/commands/<role>-init.md      ← Claude 自我具象化（不由 init 生成）
.gemini/commands/<role>-init.toml    ← Gemini 自我具象化（不由 init 生成）
.cursor/rules/<role>-init.mdc        ← Cursor 自我具象化（不由 init 生成）
```

→ 參見 `core/init-template.md §3.3` AI 自我具象化規範。

---

## 6. 已 init 過的更新流程

當 charter version 升級或專案需求改變：

```
/charter-init --update
```

流程（依 versioning-migration §3.1 7 步流程）：

1. 讀現有 `<common-memory-root>/_config/profile.yaml`
2. 比對最新 AgentCharter charter_version（讀 charter repo `tools/profiles/standard.yaml`）
3. 跑 `charter-doctor.py --target-version <new> --dry-run` 列出 BREAKING / 需修補項
4. 列出新增 / 修訂 / 移除的條款，詢問使用者每項是否採用
5. 產出 diff，使用者確認後寫入
6. 升 `charter_version` 欄位 + commit
7. 重跑 doctor 確認

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

避免半成品 `<common-memory-root>/` 污染專案。

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

| 版本 | 內容 | 狀態 |
|---|---|---|
| v0.4 | Spec only — 本文檔初版 | ✅ |
| v0.5.0 | 配置目錄合併 `.agentcharter/` → `agent-commons/_config/` | ✅ |
| v0.5.1 | Phase 4 改寫：不代生成 slash command | ✅ |
| v0.5.7 | 曾落地為 python 工具 | ⛔ 後於 v0.5.9 移除 |
| **v0.5.9** | **回歸純 spec** — framework 不附實作工具，AI 依本 spec 自具象化 | ✅ |
| **v0.7.0** | (a) Phase 4 加「採用方流程模板的 scaffold 完整性」紀律（standard / strict 預期至少 pm + engineer 雙角色 scaffold）+ Phase 4 寫 _role.md 時 Status 寫 `PROVISIONAL`；(b) Phase 4.x 加「slash command 引用紀律」段（禁絕對路徑、推薦環境變數 / 相對 user home / 相對採用方資產三層優先序）；(c) **Phase 5b 加「邀請第二 context 抽驗 init 結果」段**（dogfood signal #7 候選條款化 — 對稱 maintainer 場景的 auditor，封閉採用方接入流程「自抽自驗」結構性盲區）。**觸發**：公司專案接入失敗 2026-04-28（dogfood signal #3 + #4 第三次 + #5 第二次 + #7 候選 + #8 候選一次集中爆發）| ✅ |

**實作模式**：採用方第一次接入 → prompt AI（依 `core/init-template.md §3.3` self-instantiation）→ AI 完成接入並自建 `/charter-init` slash command 到自己廠商位置。未來重用打 `/charter-init <args>`。

→ framework 不維護 python / npm / brew 等實作通道，避免「規範框架」與「工具實作」混雜（v0.5.9 設計決策）。
