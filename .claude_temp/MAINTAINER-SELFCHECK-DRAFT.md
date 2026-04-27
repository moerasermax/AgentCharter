# /maintainer-selfcheck — DRAFT spec

> **建立**：2026-04-27
> **觸發**：對話中 user 提案「讓 AI 自己再多一個檢核層」，選定 B+C 路徑（sub-agent 獨立審 + skill 化）
> **位階**：DRAFT 提案；待 user review 後決定是否落到 `.claude/commands/maintainer-selfcheck.md`
> **對應條款**：`multi-role-tracking` 自抽自驗禁令、`audit-rights`、`maintainer-discipline §3.1`（v0.5.9 後 gap 的具體填補）

---

## 1. 用途與位階

條款修訂 commit 後執行**反向引用 sweep**：spawn fresh-context sub-agent 獨立審查 cross-references 一致性。

對應 charter 自身條款：
- **`multi-role-tracking` 自抽自驗禁令**：sub-agent 物理上不同 context = 「他抽」而非「自抽」，落實此條款到 maintainer 流程
- **`audit-rights`**：把抽驗從「maintainer 記得跑」物理化為「skill 觸發」
- **`maintainer-discipline §3.1`**：原 `charter-doctor.py --self-check` 候選因 v0.5.9 移除 python 工具改為「AI 依 spec 自具象化跑」，但「誰具象化 / 何時跑」未具體化 — 本 skill 是這個 gap 的填補

不適用採用方（採用方無 maintainer 工作）；本 skill 純 charter repo 維護用，地位類似 `/maintainer-load`（接班讀），形成「修訂寫 ↔ 接班讀」紀律閉環。

## 2. Input（呼叫方式）

```
/maintainer-selfcheck [<ref>]
```

`<ref>` 可選：
- 省略 / `HEAD`（預設）：對最近一個 commit 的條款修訂跑 sweep
- `<commit-hash>`：對指定 commit 跑 sweep
- `staged`：對 staged 但未 commit 的修訂跑 sweep（commit 前最後一道防線）
- `<core/X.md>`：對某條款的當前狀態跑 sweep（不需 commit）

## 3. 動作步驟

### Step 1：收集修訂範圍

從 git diff 抽出本次修訂觸碰的：
- `core/*.md` 條款（新增 / 修改）
- `templates/*` 模板
- `tools/*-spec.md` 工具 spec
- `presets/*.yaml`（minimal / standard / strict）
- `core/charter-config.md`
- `README.md` / `ADOPTION.md` / `CHANGELOG.md`

### Step 2：spawn sub-agent（fresh context）

透過 `Agent` tool（subagent_type: `general-purpose`，或建立專用 `charter-auditor` subagent）spawn 獨立 agent，給予以下 prompt 骨架：

```
你是 AgentCharter charter sweep auditor。職責：對 commit <ref> 的條款修訂執行反向引用 sweep。

任務：
1. Read core/charter-config.md 「條款相依表」段，建立相依關係圖
2. 對每條被修訂的條款 X（清單在下方），檢查以下位置是否同步：
   a. 反向引用方：其他 core/*.md 是否有 §X 引用？引用內容是否仍正確？
   b. 三 preset 啟用清單：presets/{minimal,standard,strict}.yaml 的 enabled / parameters 是否需更新？
   c. core/charter-config.md：enabled 段、條款相依表是否新增/修訂？
   d. README.md：條款列表段（若有計數如「20 條條款」）是否同步？
   e. ADOPTION.md：條款計數、場景對照表是否同步？
   f. CHANGELOG.md：是否有本次修訂的條目？格式正確？
   g. 若條款新增 / 修改 mapping schema → core/charter-config.md 的 mapping.yaml 範本是否同步？
   h. 若條款影響工具行為 → tools/*-spec.md 是否需修訂？
   i. 若條款新增 template → templates/agent-commons/*.md.tpl 是否需新增？

3. 輸出 sweep report（格式見下方）

紀律：
- 你是 fresh context，不要假設我（呼叫方）已經做了什麼；所有結論都從檔案讀出來
- 不修改任何檔案，只輸出 report
- 嚴禁編造（charter `evidence-first` + `structural-anti-fabrication`）— 引用必須是檔案中真實存在的字串，附 file_path:line_number

被修訂的條款清單：
<從 Step 1 帶入>

修訂的具體 diff：
<git show <ref> 的 diff，或 staged diff>
```

### Step 3：呈現 sweep report 給 maintainer

sub-agent 結束後，呈現結構化結果。Maintainer 決定是否回去補修。

## 4. Output 格式

```
🔍 maintainer-selfcheck sweep（<ref>）

修訂條款：
- core/X.md（新增）
- core/Y.md（修改 §3）

✅ HIT（N 處 — 已同步）
- core/charter-config.md:42 §條款相依表 — 已加 X→Y 相依
- presets/standard.yaml:18 — enabled 已加 X
- README.md:67 — 條款列表已更新
- ...

❌ MISS（M 處 — 應同步但未發現）
- ADOPTION.md:23 — 仍寫「20 條條款」，本次新增條款 X 後應為 21
  建議：改為「21 條條款」並在 §C 段加 X 描述
- presets/minimal.yaml — 未啟用 X，但條款本身要求所有 preset 預設啟用
  建議：在 enabled 加 X: true
- CHANGELOG.md — 缺少本次修訂條目
  建議：在開頭加 v0.X.X 段，描述 X 條款新增

⚠️ MAYBE（K 處 — 需 maintainer 判斷）
- tools/init-spec.md §3 是否需提及 X？視 X 是否影響 init 流程
- examples/_walkthrough/* 是否需更新？視範例是否引用 X 場景

判斷：
[全 HIT 0 MISS → ready to push]
[有 MISS → 建議回補後再 push（push 前最後機會）]
[僅 MAYBE → maintainer 自行判斷]
```

## 5. 與其他指令的對照

| 動作 | /maintainer-load | /maintainer-selfcheck |
|---|---|---|
| 對應階段 | 接班讀 | 修訂後查 |
| 對應紀律 | working-stack-discipline §1 DRAFT 接班 | multi-role-tracking 自抽自驗禁令 |
| 副作用 | 純讀 | 純讀（sub-agent 不寫檔；maintainer 自行補修）|
| 呼叫時機 | session 開頭 | 條款 commit 後（或 push 前最後檢查）|
| 是否 spawn agent | 否（主對話讀檔）| 是（fresh-context sub-agent）|

兩者形成「修訂寫 ↔ 接班讀」紀律閉環。

## 6. 落地步驟（待 user 同意後執行）

1. **Phase 1**：建立 `.claude/commands/maintainer-selfcheck.md` slash command（仿 `/maintainer-load` 結構）
2. **Phase 2**（選）：建立 `.claude/agents/charter-auditor.md` 專用 subagent，把 prompt 骨架固化（避免每次重抄）
3. **Phase 3**（dogfood）：下次條款修訂時 user 觸發此 skill，觀察是否真能抓到 missing reference；若漏抓則改 prompt 骨架

## 7. 已知 trade-off / 風險

- **sub-agent 也會錯**：fresh context 不等於萬靈丹；sub-agent 自己的 instructions 可能被誤讀。對策：prompt 骨架要求附 `file_path:line_number`，maintainer 可二次抽驗
- **覆蓋率非 100%**：任何 sweep 規則都基於「已知該檢查什麼」；若條款修訂引入全新類型的 cross-reference（charter-config 相依表還沒收錄），會漏。對策：定期 review prompt 骨架的檢查清單
- **與 /maintainer-load 對齊維護成本**：兩個 skill 都依賴對 `.claude_temp/` + `core/*` 的理解，未來條款大幅重構時兩者都要同步修

## 8. 反向觀察（dogfood meta）

charter 把「自抽自驗禁令」寫進 `multi-role-tracking` 條款時，沒想過 maintainer 流程本身違反此條款（commit 後沒人抽驗）。本 skill 若落地，是 framework 紀律首次套到 framework 自己的維護流程，dogfood 閉環又補一格。

可選擇性沉澱：若實作後跑得通，可在 `maintainer-discipline §3` 加一個小段「`maintainer-selfcheck` 落實機制（v0.5.9+）」指向本 skill。
