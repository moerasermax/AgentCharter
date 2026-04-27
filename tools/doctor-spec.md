# /charter-doctor — 健康檢查設計

> **狀態**：v0.4 Spec only（無實作）
> **位階**：tools / 設計文檔。

---

## 1. 目標

驗證專案的 AgentCharter 接入狀態完整，可隨時 `/charter-doctor` 檢視：

- 啟用的條款是否依賴完整
- mapping 對映的路徑是否實際存在
- 領域公理檔案是否存在
- 角色 init slash command 是否就緒
- profile schema 版本是否與 AgentCharter 相容

---

## 2. 用法

```
/charter-doctor
/charter-doctor --fix       # 互動式修復建議
/charter-doctor --json      # 輸出 machine-readable 格式
```

---

## 3. 檢查項

### 3.1 結構完整性

| 檢查 | 狀態碼 | 失敗處置 |
|---|---|---|
| `.agentcharter/profile.yaml` 存在 | E001 | 建議跑 `/charter-init` |
| `.agentcharter/mapping.yaml` 存在 | E002 | 建議跑 `/charter-init` |
| profile schema 版本相容 | E003 | 建議跑 `/charter-init --update` |
| 必填欄位齊全（依 charter-config §3 / §4）| E004 | 列出缺項 |

### 3.2 條款相依

依 `core/charter-config.md §5` 相依表逐一驗：

```
若 enabled.violation-reflection = true:
  則 enabled.audit-rights 必須 true
  且 enabled.failure-modes 必須 true
  且 enabled.structural-anti-fabrication 必須 true
```

| 失敗 | 狀態碼 | 處置 |
|---|---|---|
| 條款啟用但依賴未啟用 | E101 | 列出依賴鏈，建議啟用或停用該條款 |

### 3.3 路徑對映

```
對 mapping.yaml 內每個指向的路徑：
  1. 路徑是否存在
  2. 是否為對應類型（檔案 vs 目錄）
  3. 是否可讀（permission）
  4. 對 institutional_memory 列表內每個檔，個別檢查
```

| 失敗 | 狀態碼 | 處置 |
|---|---|---|
| 路徑不存在 | W201 | 警告（可能是計畫中還沒建的目錄）|
| 路徑類型錯（指向檔但實為目錄）| E202 | 修正 mapping |
| 無讀權限 | E203 | 檢查 OS 權限 |

### 3.4 角色 init slash command

對 enabled 的每個角色：

```
1. .claude/commands/<role>-init.md 存在？
2. 內容是否含 init-template §2 五步驟骨架（用 grep 偵測）
3. 引用的 charter 路徑是否仍指向有效目錄
```

| 失敗 | 狀態碼 | 處置 |
|---|---|---|
| slash command 缺失 | W301 | 建議跑 `/charter-init` 重新生成 |
| 骨架不完整 | W302 | 建議用 `templates/role-init.md.tpl` 重新生成 |

### 3.5 領域公理

```
1. domain_axioms.primary 路徑指向的檔存在
2. 含至少一個「條款」型結構（依 grep 啟發式偵測 §/##）
```

| 失敗 | 狀態碼 | 處置 |
|---|---|---|
| 公理檔不存在 | E401 | 致命錯誤，無領域公理協議無法運作 |
| 公理檔結構薄弱（< 5 個 § 或 ##）| W402 | 建議補充內容 |

### 3.6 失敗模式累積紀錄

```
1. 是否有對應追蹤紀錄（位置由 mapping.state.failure_mode_log 指向）
2. 最新事件是否仍在「強化抽驗模式」
3. 最近 3 筆事件的 F-mode 分布
```

| 觀察 | 狀態碼 | 處置 |
|---|---|---|
| 當前處於強化抽驗模式 | I501 | INFO，提醒下個 session 接班 AI |
| 結構性失靈未解 | W502 | 警告，提醒使用者裁決尚未結 |

---

## 4. `health-report.md` 輸出格式

依 `structural-anti-fabrication.md` 強制：含實際 stdout 區塊，非純文字結論。

```markdown
# AgentCharter Health Report — <project-name>

> 產生時間：<UTC + 本地>
> Charter version：0.4.0
> Profile preset：standard
> 整體狀態：✅ 全綠 / ⚠️ 有 N 個警告 / ❌ 有 N 個錯誤

## 1. 結構完整性

​```bash
ls -la .agentcharter/
​```

​```text
<實際輸出>
​```

✅ profile.yaml 存在
✅ mapping.yaml 存在
✅ schema 版本相容（0.4.0 ↔ 0.4.0）

## 2. 條款相依

| 條款 | 啟用 | 依賴狀態 |
|---|---|---|
| audit-rights | ✅ | OK |
| violation-reflection | ✅ | OK（依賴 audit-rights / failure-modes / structural-anti-fabrication 全綠）|

## 3. 路徑對映

​```bash
for p in $(yq '.shared | to_entries | .[].value' mapping.yaml); do ls -la "$p" 2>&1; done
​```

​```text
<實際輸出>
​```

✅ 所有 shared 路徑存在
⚠️ roles.engineer.reflections 路徑不存在（可能是計畫中目錄）

## 4. 角色 init slash command

​```bash
ls -la .claude/commands/*-init.md
grep -l "步驟 1〜5" .claude/commands/*-init.md
​```

✅ engineer-init.md 結構完整
✅ pm-init.md 結構完整

## 5. 領域公理

​```bash
ls -la <domain_axioms.primary>
grep -c "^##" <domain_axioms.primary>
​```

✅ IRON.md 存在，含 11 個 § 條款

## 6. 失敗模式狀態

抽驗 `<failure_mode_log>` 最近事件：

​```bash
tail -20 <failure_mode_log>
​```

INFO 當前無進行中事件。

## 7. 修復建議（若有失敗）

- W201：建立 management/roles/engineer/reflections/ 目錄
  ​```bash
  mkdir -p management/roles/engineer/reflections
  ​```
```

---

## 5. 退出碼

| Code | 含義 |
|---|---|
| 0 | 全綠 |
| 1 | 有 INFO 但無錯誤 |
| 2 | 有警告 |
| 3 | 有錯誤（必修）|
| 4 | 致命錯誤（無 .agentcharter / domain_axioms 缺失）|

CI / pre-commit hook 可依退出碼 gate。

---

## 6. `--fix` 互動模式

對每個失敗項：

```
1. 顯示問題描述 + 建議修復指令
2. 詢問使用者：apply / skip / explain more
3. apply → 自動執行修復指令並重檢
4. skip → 標註於 health-report，繼續
5. explain → 顯示對應 condition 條文的相關段
```

對致命錯誤（E001/E002/E401）：直接中斷，無互動。

---

## 7. 與其他條款的關係

| 條款 | 關係 |
|---|---|
| `core/charter-config.md` | doctor 是 schema 的執行驗證器 |
| `core/structural-anti-fabrication.md` | health-report 含 stdout 區塊 |
| `tools/init-spec.md` | init Phase 5 自動跑一次 doctor |
| `core/escalation-protocol.md` | 偵測強化抽驗模式狀態 |

---

## 8. 實作節奏

| 版本 | 內容 |
|---|---|
| v0.4 | Spec only — 本文檔 |
| v0.5 | bash 原型（用 yq + ls + grep）|
| v0.6 | Claude Code slash command 包裝 |
