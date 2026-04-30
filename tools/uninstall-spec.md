# /charter-uninstall — 採用方棄用工具設計

> **狀態**：v0.9.0（純 spec — 由 AI 自具象化執行）
> **位階**：tools / 設計文檔。對應 `core/adoption-lifecycle.md`「棄用」階段執行載體（v0.9.0 加；5 階段 lifecycle 第 3 階段）。
> **核心精神**：「**保留最後的溫柔**」— 對齊 charter v0.7.3 北極星「培養魚塭、不討魚」、棄用是有尊嚴的離別、不是 lock-in。
> **實作模式**：採用方對 AI 下 prompt「依本 spec 自具象化 `/charter-uninstall` slash command 給未來重用」OR「依本 spec 直接執行棄用流程」、AI 完成 5 phases 並輸出 archive 報告位置。

---

## 1. 目標

驗證採用方棄用 charter 流程的**完整性 + 可逆性**：

- 三次確認（不可逆 user authorization 閘三層防誤觸）
- export adoption archive（保留採用期間的紀律遺產、為未來「重新採用」階段預留入口）
- 三 level 選擇（Soft / Full / Nuclear、對應採用方資產保留度）
- charter clone 處理（`~/.agentcharter` 跨專案共用、不可任意刪）
- 結束 + 輸出 archive 位置（user 後續可參考、`adoption-lifecycle.md`「重新採用」階段直接讀回）

**vs `core/adoption-lifecycle.md` 條款本體**：條款規範棄用紀律 + 5 階段邏輯；本 spec 規範**執行載體**動作流（5 phases）。

**vs `tools/doctor-spec.md` / `post-upgrade-verify-spec.md`**：doctor / verify 是接入期間驗證工具；本 spec 是**離開**期間動作工具 — lifecycle 對稱性補完（接入有 init / 離開有 uninstall）。

---

## 2. 用法

```
/charter-uninstall                      # 互動式 5 phases（推薦）
/charter-uninstall --level soft         # 指定 level（仍跑三次確認）
/charter-uninstall --level full
/charter-uninstall --level nuclear
/charter-uninstall --dry-run            # 模擬執行、不實動、列出將執行的動作
/charter-uninstall --archive-only       # 只跑 phase 2 archive、不實際 uninstall
```

### 2.1 呼叫模式

| 模式 | 觸發者 | 用途 | 失敗處置 |
|---|---|---|---|
| **A. 互動式 uninstall**（預設） | 採用方使用者 | 完整 5 phases | 任一 phase user 拒絕 / AI 抓到結構不一致 → 中止、不實動 |
| **B. dry-run 模擬** | 採用方使用者 | 評估棄用影響面、列將刪檔 / 將保留檔 | 純資訊輸出、不實動 |
| **C. archive-only** | 採用方使用者 | 只跑 phase 2、保留 charter 接入完整、僅產 archive 報告 | 用於「定期紀律遺產備份」場景 |

> 模式 A 為預設；模式 B/C 屬 spec 層提及、實作層 v0.9.0 ship。

---

## 3. 五 phases

### Phase 1：三次確認（user authorization 三層閘）

對應 `core/adoption-lifecycle.md §2.3` 棄用紀律「不可逆動作 user explicit 授權閘」。

```
Q1: 確定要棄用 charter？
    [是 / 否]
    → 否：終止、無動作
    → 是：→ Q2

Q2: 已備份 agent-commons/ 重要資產（capsules / handoffs / IM / reflections）？
    [是 / 否 / 跑 archive 給我看]
    → 否：終止、提示先手動備份或選 phase 2 archive
    → 跑 archive：先跑 phase 2 archive 再回 Q2
    → 是：→ Q3

Q3: 確認執行不可逆操作？將執行 level [soft|full|nuclear]、影響範圍 [列檔案]
    [是 / 否]
    → 否：終止、無動作
    → 是：→ phase 2
```

**紀律提示**：
- AI **不可代決** Q1/Q2/Q3 的回答（user explicit 授權閘三層）
- 任一 Q 答「否」即立即終止、不實動
- Q3 的「影響範圍」必含**具體 file path 列表**（依 phase 3 level 選擇 + phase 4 charter clone 處理範圍預先掃描）— 不可純文字描述「將刪除大量檔案」

### Phase 2：保留最後的溫柔 — export adoption archive

對應 `core/adoption-lifecycle.md §2.3.2` 紀律遺產保留 + `core/violation-reflection §5` 永不刪除精神。

**動作**：寫入 `<project>/charter-archive/CHARTER_ADOPTION_REPORT_<YYYY-MM-DD>.md`：

```
# Charter Adoption Report — <project_name>

> 產生時間：<UTC + 本地>
> Charter version (when uninstalled)：<X.Y.Z>
> Profile preset：<preset>
> 採用期間：<first commit date> ~ <today>

## 1. 接入摘要
- 第一次 init 日期 + 對應 commit hash
- 接入 vendor 列表（claude-code / gemini-cli / cursor 等）
- 角色列表（依 _role.md 切換歷史最後 ACTIVE 狀態）

## 2. capsules 統計
- 總數
- 結案 / VOIDED / 進行中比例
- 平均 VCP 覆蓋情境數

## 3. HANDOFF 鏈時間線
- HANDOFF_1 ~ HANDOFF_<N> 摘要（每筆 1 行：日期 + 里程碑 tag + 接班 AI）

## 4. Institutional Memory entries
- 每章節摘要（§章節編號 + 主題 + 來源觸發事件）

## 5. protocols snapshot
- 領域公理檔最新 frontmatter（status / mutability_default / 條款計數）
- charter version 升版軌跡（依 profile.yaml.charter_version 變更歷史）

## 6. failure_mode_log 統計
- F1 ~ F6 各觸發次數
- 強化抽驗模式進入次數
- user 裁決事件次數

## 7. dogfood signal 觸發紀錄（採用方角度）
- 採用方對 charter 提的 issue / 觀察（若有）
- 採用方升版實證（依 examples/upgrades/*.md 任一）

## 8. 個體層學習迴圈累積（v0.9.0 加）
- 每角色 reflections/ 累積數量 + 最近 3 個 entry 摘要
- 對應 core/individual-learning-loop §2 雙寫紀律執行軌跡

## 9. 結語
感謝採用 AgentCharter v<X.Y.Z>。
你的紀律遺產保留於本檔；如未來「重新採用」（依 core/adoption-lifecycle.md §2.4）
charter（同版本或更新版本），可：
1. 讀本檔回顧採用期紀律累積
2. 依 core/adoption-lifecycle.md §2.4 重新採用流程恢復
3. failure_mode_log + reflections 可選擇性恢復（依 charter version 兼容性）

—— charter 紀律不依賴採用方持續使用、而依賴採用方需要時找得回。
```

**紀律提示**：
- archive 必寫 `<project>/charter-archive/`（與 `agent-commons/` 同層、不在 `agent-commons/` 子層 — 確保 phase 3 nuclear 砍 `agent-commons/` 時 archive 仍存）
- archive 檔名必含日期前綴 `CHARTER_ADOPTION_REPORT_<YYYY-MM-DD>.md`（多次 archive-only 模式跑時不互相覆蓋）
- archive 為**永不刪除**檔（依 `core/violation-reflection §5` append-only 精神延伸）

### Phase 3：level 選擇（預設 Soft、依 user explicit 授權升 Full/Nuclear）

對應 `core/adoption-lifecycle.md §2.3.3` 三 level 棄用紀律。

| level | 動作範圍 | user 額外確認 | 可逆性 |
|---|---|---|---|
| **Soft**（預設） | (1) 移除 vendor slash command（`.claude/commands/*` / `.gemini/commands/*` / `.cursor/rules/*`）<br>(2) `agent-commons/roles/<role>/_role.md` 加 `Status: ARCHIVED`（v0.9.0 加；對齊 PROVISIONAL/ACTIVE 二態擴 ARCHIVED 三態）<br>(3) 保留 `agent-commons/_config/`、`agent-commons/protocols/`、所有資產 | 0（phase 1 三次確認已足）| 高 — 重新採用走 init self-instantiation 即恢復 |
| **Full** | Soft + 砍 `agent-commons/_config/`（profile.yaml + mapping.yaml）；保留 `agent-commons/protocols/` + 所有 capsules / handoffs / IM / reflections | 1 次（phase 1 三次 + 此 1 次 = 4 次確認）| 中 — 重新採用須重跑 `/charter-init` 重建 _config/、但領域公理 + 紀律遺產仍在 |
| **Nuclear** | Full + 砍**整個 `agent-commons/`**（archive 已先寫到 `<project>/charter-archive/`、不在此被砍）| 2 次（phase 1 三次 + 此 2 次 = 5 次確認；其中第 2 次須 user 鍵入「YES NUCLEAR」字串）| 低 — 只能從 `<project>/charter-archive/` archive 報告恢復摘要、不可恢復 capsules / handoffs / IM / reflections 完整內容 |

**紀律提示**：
- AI 預設 Soft；level 升 Full/Nuclear **必由 user explicit 授權**（不可 AI 主動建議升 level）
- Nuclear 額外確認的「YES NUCLEAR」字串**寫死**（不可改 vendor / locale-specific 變體 — 確保任一 vendor 一致行為）
- Soft level 加 `Status: ARCHIVED` 是新加二態擴展（PROVISIONAL/ACTIVE/ARCHIVED 三態、對應 `core/multi-role-tracking.md §3.4.4` 既有二態紀律延伸）

### Phase 4：charter clone 處理

對應 `core/adoption-lifecycle.md §3` vendor 升級 path 三路徑紀律延伸（A 維持現狀 / B 開 issue / C AI 自驅修復）— 棄用階段對 charter clone 同樣三路徑：

```
檢查 ~/.agentcharter / $AGENTCHARTER_HOME 有無**其他 active 專案**在用：

  for project in $(grep -rl "AGENTCHARTER_HOME\|~/.agentcharter\|charter_version" ~/proj* ~/work* 2>/dev/null):
      讀 <project>/agent-commons/_config/profile.yaml charter_version
      若 == 採用方棄用前版本：列為「同版本仍 active」
      若 != 採用方棄用前版本：列為「異版本仍 active」

詢問 user：
  路徑 A（維持現狀、推薦）：保留 ~/.agentcharter、僅本專案棄用 — 跨專案共用 charter clone 不動
  路徑 B（清除 charter clone）：本專案是唯一 active 專案 + user explicit 確認後刪 ~/.agentcharter
  路徑 C（保留 + 標記）：保留 ~/.agentcharter 但寫 ~/.agentcharter/.last_uninstall_<project>_<date>（記錄棄用追蹤、為「重新採用」預留）
```

**紀律提示**：
- AI **不可代決**路徑 A/B/C（user explicit 授權）
- 路徑 B 預設**不推薦**（跨專案共用 charter clone 是 v0.7.3 北極星「培養魚塭」精神 — 砍 charter clone 等同棄用 framework 整體、超越本專案棄用範圍）
- 路徑 C 為 v0.9.0 加（對應 `core/adoption-lifecycle.md §2.4` 重新採用階段、`.last_uninstall_*` 是恢復路徑入口）

### Phase 5：結束 + 輸出 archive 報告位置

```
✅ /charter-uninstall 完成

執行摘要：
- Level：<soft|full|nuclear>
- Archive 位置：<project>/charter-archive/CHARTER_ADOPTION_REPORT_<YYYY-MM-DD>.md
- charter clone 路徑處置：<A 維持現狀 | B 已清除 | C 保留 + 標記>
- 移除檔案數：<N>
- 保留檔案數：<N>

下一步：
- 重新採用：依 core/adoption-lifecycle.md §2.4「重新採用」階段、跑 /charter-init 並讀 archive 報告恢復脈絡
- 純離開：本檔 + archive 已留、charter 紀律不依賴採用方持續使用
```

**紀律提示**：
- 結束輸出**必含 stdout 區塊**（依 `core/structural-anti-fabrication.md`、實際 mv / rm / sed 指令的真實輸出、不可純文字「已完成」摘要）
- archive 報告位置**必為絕對路徑**（user 後續可直接 `cat <archive-path>` / `cd <archive-dir>`、不可寫死 `~/` 或相對路徑）

---

## 4. self-instantiation 規範

採用方對 vendor AI 下 prompt 自具象化為 slash command（依 `core/init-template §3.3` 八步驟、引用 framework 路徑禁寫死絕對路徑）：

```
我採用了 AgentCharter v0.9.0+，charter 在 ~/.agentcharter/。

請依 ~/.agentcharter/tools/uninstall-spec.md 自具象化為
/charter-uninstall slash command 到你廠商標準位置（依 init-template §3.3）。

紀律提示：
- step 0（v0.9.0 加）— 必先讀我 reflections/ 最近 5 個（個體學習迴圈強制起手）
- step 5 — 簽名前必跑 doctor schema 驗證
- 引用 framework 路徑禁寫死 user home 絕對路徑（推薦 $AGENTCHARTER_HOME / ~/.agentcharter / agent-commons/ 三層）
- 預設執行模式為本 spec §2.1 模式 A（互動式 5 phases）
- phase 1 三次確認禁 AI 代決
- phase 3 level 預設 Soft、升 Full/Nuclear 必由 user explicit 授權
- phase 4 charter clone 處理預設路徑 A（維持現狀、跨專案共用不動）
- phase 5 結尾必附 stdout 區塊（不要只回報「成功」摘要、對齊 structural-anti-fabrication 紀律）
```

具象化後 user 打 `/charter-uninstall` 直接重用。

---

## 5. 與其他 spec / condition 的關係

| 對應 | 關係 |
|---|---|
| `core/adoption-lifecycle.md`（v0.9.0 加） | 條款本體、本 spec 為其「棄用」階段執行載體（5 階段 lifecycle 第 3 階段）|
| `core/violation-reflection §5`（永不刪除）| Phase 2 archive + Soft level 保留 reflections/ 對齊「個體層 reflection 永不刪除」精神 |
| `core/init-template §3.3`（self-instantiation 八步驟）| Phase 1 三次確認對應 user authorization 閘紀律、與 init step 0 過去違反讀取雙端對稱 |
| `core/multi-role-tracking §3.4.4`（PROVISIONAL/ACTIVE 二態）| Phase 3 Soft level 加 `Status: ARCHIVED` 為二態擴 ARCHIVED 三態（v0.9.0 加）|
| `core/structural-anti-fabrication §5`（stdout 區塊強制）| Phase 5 結束輸出必附實際 mv / rm 指令 stdout、不可純文字摘要 |
| `core/individual-learning-loop §2`（v0.9.0 加；雙寫紀律）| Phase 2 archive §8 個體層學習迴圈累積段對齊 |
| `tools/doctor-spec.md`、`tools/post-upgrade-verify-spec.md` | 並列 — 接入期工具（doctor 任意時點 / verify 升版後）vs 離開期工具（本 spec 棄用時）；lifecycle 對稱性補完 |
| `tools/init-spec.md`（接入期入口）| 對稱 — init 是「進入」/ uninstall 是「離開」；lifecycle 入口 vs 出口 |
| `core/ai-vendor-onboarding §3`（vendor 邀請制）| Phase 4 charter clone 處理路徑 B/C 對齊 vendor 各自實作（charter 不附 binary）|

---

## 6. 觸發 / 累積紀錄

- v0.9.0（自 v0.9.0 引入）—— 初版。對應：
  - SSS S2.1 設計素材（user 2026-04-29 LIVE 提案 /charter-uninstall 流程 + vendor 升級 path 三路徑 A/B/C + 互學深化）
  - `core/adoption-lifecycle.md`（v0.9.0 加）「棄用」階段執行載體需求
  - charter v0.9.0 主軸「紀律完整性」配套 — lifecycle 對稱性補完（接入 init / 離開 uninstall）

---

## 7. 變更歷史

### v0.1（自 v0.9.0 引入）

初版 — 對應 SSS S2.1 設計素材 + `core/adoption-lifecycle.md` v0.9.0 ship 配套。

含：
- 5 phases（三次確認 / archive export / level 選擇 / charter clone 處理 / 結束輸出）
- 三 level 選擇（Soft 預設 / Full 1 次額外確認 / Nuclear 2 次額外確認 + 「YES NUCLEAR」寫死字串）
- charter clone 三路徑處置（A 維持現狀 / B 清除 / C 保留 + 標記、對齊 `adoption-lifecycle §3` vendor 升級 path 對稱）
- self-instantiation 規範（依 `init-template §3.3.2` 八步驟、含 v0.9.0 加 step 0 過去違反讀取）
- structural-anti-fabrication 對齊（phase 5 結束輸出必附實際 stdout）
- archive 報告 9 段（接入摘要 / capsules / HANDOFF / IM / protocols / failure_mode_log / dogfood signal / 個體學習迴圈 / 結語）

**對齊「保留最後的溫柔」精神**：archive 為永不刪除檔、charter 紀律不依賴採用方持續使用、而依賴採用方需要時找得回 — 對齊 v0.7.3 北極星「培養魚塭、不討魚」。
