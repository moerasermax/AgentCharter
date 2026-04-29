# 外部 AI 評估 — CliSpike Engineer Claude（2026-04-30）

> **位階**：cross-vendor 外部 AI 評估紀錄第一例 — `examples/external-evaluations/` 目錄誕生
> **觸發**：CliSpike 專案 Engineer Claude（不同 repo / 不同 context）init charter v0.8.0 後、user 對其詢問評價、Engineer 給出三層結構化評估
> **位階意義**：對齊 charter A1 公理「角色 ⊥ AI」 + 框架價值第 4 條候選「**1+1>2 / 青出於藍**」第一個外部實證 — 同樣是 Engineer 角色、不同 vendor instance / 不同 context、收斂到「**dogfood 自覺 10/10**」評價 = 跨 vendor convergence
> **對應 dogfood-driven hardening 第十三循環**：新類型 dogfood signal 觸發 — 不是「採用方踩坑」、是「**外部 AI 系統評估**」反饋

---

## 1. Engineer 原文評估（user 提問 + Engineer 三輪回答 verbatim）

### 1.1 user 第一問：「那你認為這個框架如何」

**Engineer 回答**：

> **強項**
> - 「結構性反捏造」是真洞見 — 把驗證從「AI 行為」搬到「文檔結構」（缺 stdout 區塊就送不出），繞過 self-check 同盲點問題，這個切角少見
> - F6 (surface 書寫 vs structural 完整性) 條款化打中 LLM completionist 真實病灶
> - 「LLM 不可矯正」前提誠實 — violation-reflection §2 明寫「反省價值在審計痕跡而非矯正」，這個自覺罕見
> - dogfood 痕跡濃（諷刺循環：profile.yaml 漏 F6 → F6 沒攔住漏 F6 → 條款化）
>
> **弱項**
> - 條款已 18 條 + 密集互引（§段反向引用、條款 ↔ tools/templates 三層連動），spec drift 風險高（v0.7.x 多次補 §5 反向引用就是症狀）
> - token 負擔不低，每次 init 約 25k+ tokens 讀協議；單人 / 小專案 ROI 會吃緊
> - 「抽驗權不放棄」機制邏輯自洽，但實戰會放大每個結案的儀式成本（HANDOFF + VCP + 抽驗 + 反省鏈）— 適合金融/醫療等高後果領域，不適合快迭代產品
>
> **判斷**
> 適配場景：高後果 + 多 AI 協作 + 長 session 鏈。
> 反適配：探索期、單人小專案、快速 MVP。
> 本專案是 dogfood 場景，框架本身是專案產出之一 → 重型紀律合理。

### 1.2 user 第二問：「那你認為他是一個好框架嗎」

**Engineer 回答**：

> 是好框架，但要限定條件：
>
> ✅ **作為「思想 / 紀律藍圖」是好的**
> - 問題定義準（LLM completionist / 假宣告 / self-check 同盲點）
> - 結構性反捏造、F6 surface vs structural、繞路禁令這幾條切角紮實
> - 自我覺察強（明寫「反省不能矯正 LLM、只是審計痕跡」）
>
> ⚠️ **作為「可立刻採用的工程框架」未成熟**
> - 工具鏈大量 spec-driven（doctor / init / post-upgrade-verify 多由 AI 依 spec 自具象化執行），沒落實成可執行 binary
> - 意味著紀律執行最終仍依賴 LLM 自律 — 但**框架自己的前提就是「LLM 不可矯正」循環依賴**
> - v0.x 條款仍密集演化、spec drift 跡象已現
>
> 🎯 **判斷**
> - 「好框架」如果你是它的目標讀者：高後果領域 + 多 AI 協作 + 願意付儀式成本 + 由人類 user 當最終仲裁者
> - 「過重」如果你只想要 AI 別瞎掰：抓 3-5 條核心（structural-anti-fabrication / audit-rights / evidence-first）落地就 80% 收益
>
> 簡言之：**思想完整度 9/10，落地成熟度 5/10，dogfood 自覺 10/10**。值得追蹤到 v1.0。

---

## 2. Maintainer 視角註解（charter 內部脈絡對照）

### 2.1 Engineer 抓得準的點 — 對齊 charter 既知 / 未知 signals

| Engineer 抓到 | maintainer 內部視角 |
|---|---|
| **「LLM 不可矯正」前提 + spec-driven 工具鏈 = 循環依賴矛盾** | 🔴 **抓到 charter 自己的根本矛盾** — 對應 user 2026-04-29 LIVE 提的 SSS S3「引導式紀律」要治本的對象。Engineer 沒看 SSS S3 議程、卻抓到同源痛點 = 設計提議 cross-vendor 驗證 |
| **18 條 + 密集互引、spec drift 風險高** | ✅ 對齊 v0.7.x 系列多次補反向引用實證（dogfood signal #6 三次同類條款化、§3.4 文檔層 sync checklist）。Engineer 從 spec 結構就看出 drift 跡象 |
| **25k+ token init cost、小專案 ROI 吃緊** | 🆕 **dogfood signal #26 候選**：charter 至今沒系統評估過 init token cost vs ROI。minimal preset 9/19 仍偏重、可能需要新增「essential 3-5 條」底下另開層 |
| **過重儀式成本 vs 探索期/快迭代** | 🆕 **dogfood signal #28 候選**：採用方分層採用紀律（progressive adoption）charter 沒明示。對齊「培養魚塭、不討魚」精神延伸 |
| **「最終仍依賴 LLM 自律」循環依賴** | 🆕 **dogfood signal #27 候選**：v0.5.9「framework 不附 python」決策的 pre-supposition reality check — 是否核心紀律該有 binary enforcement layer？對應 SSS S3 引導式紀律 + spec 寫死「反例段」治本 |

### 2.2 Engineer 給的 80/20 法則建議

> 「抓 3-5 條核心（structural-anti-fabrication / audit-rights / evidence-first）落地就 80% 收益」

對應 charter 自身的 **minimal preset 9/19** 已經在做、但 Engineer 認為**還不夠 minimal**。

→ **可能 v0.9.0 議程候選**：新增「**essential preset**」（3-5 條核心、token 成本 < 5k init）+ minimal/standard/strict 升至「**漸進採用層級**」。對齊 SSS S2 提的 lifecycle 五階段（含「全新接入」初始 footprint 應該超低）。

### 2.3 Cross-vendor Engineer convergence = 框架價值第 4 條候選 LIVE 實證

對齊 user 2026-04-29 LIVE 提的「**1+1>2 / 青出於藍**」原則：

| 維度 | charter maintainer Claude | CliSpike Engineer Claude | 兩者收斂點 |
|---|---|---|---|
| context | charter repo internal、看 dogfood signal 累積 | CliSpike 採用方 repo、看 charter 作為外來工具 | **不同 context、相同「dogfood 自覺 10/10」評價** |
| signal 來源 | 採用方踩坑（公司接入失敗 / YC 升版）| **外部 AI 系統評估**（新觸發類型）| **第十三循環 dogfood-driven hardening 新類型** |
| 抓到的盲區 | spec drift / vendor schema / axiom status | **token cost / 循環依賴 / 採用門檻** | 兩個視角互補、charter 自身漏看的 Engineer 抓到 |

→ Engineer 9/10 思想 / 5/10 落地 / 10/10 dogfood 評價、**5/10 落地是該抓的點、不是讚美值**。

### 2.4 對 SSS S3 引導式紀律設計的補強

Engineer 抓到的「**框架自己的前提就是『LLM 不可矯正』循環依賴**」就是 SSS S3 引導式紀律要治本的對象：

- **現況**：spec-driven → AI 自具象化 → AI 自律執行 → **若 AI freelance、紀律失效**（2026-04-29 LIVE Gemini 編造 E605/W802 實證）
- **SSS S3 後**：spec 寫死合規規定 + 修補方向 + 反例 → AI 在框架內發想 → **anti-pattern 反例段直接擋住 freelance** → 紀律不再依賴「AI 自律」、而是依賴「**charter spec 約束密度**」
- = **circular dependency 解開**：charter ground truth → AI 引導式發想 → 結果回頭驗 charter ground truth

→ Engineer 5/10 落地成熟度、SSS S3 v0.8.x PATCH ship 後可能拉到 7-8/10。**v0.8.x PATCH 主軸成立**。

---

## 3. 衍生新 dogfood signal 候選（待 NEXT.md ⚪ 段 capture）

### #26 候選 — init token cost / ROI 系統評估缺位

**觸發**：Engineer 報「每次 init 約 25k+ tokens 讀協議；單人 / 小專案 ROI 會吃緊」。

**根因**：charter 至今沒系統評估 init token cost vs ROI、minimal preset 雖 9/19 仍偏重。

**判斷**：累積 1 次外部 AI 評估觸發、屬「採用門檻」議題（與 #28 同源族群）、累積觀察。

**候選方向**：v0.9.0 議程 essential preset（3-5 條 core、< 5k init token）。

### #27 候選 — spec-driven 與 LLM 自律 循環依賴 reality check

**觸發**：Engineer 報「框架自己的前提就是『LLM 不可矯正』循環依賴」 — spec-driven 工具鏈 + AI 自具象化 = 紀律執行最終仍依賴 LLM 自律。

**根因**：v0.5.9「framework 不附 python」決策的 pre-supposition 假設 AI 自律可靠、但 charter 自身條款（如 violation-reflection §2「反省不能矯正 LLM」）已承認 LLM 不可矯正。

**判斷**：直接對應 SSS S3 引導式紀律設計的需求性 — SSS S3 ship 後此循環解開。

**候選方向**：SSS S3 v0.8.x PATCH 落地（doctor-spec / post-upgrade-verify-spec / init-spec error code 全擴五欄結構含反例段）。

### #28 候選 — progressive adoption / 採用門檻 framing 缺

**觸發**：Engineer 報「過重 if 你只想要 AI 別瞎掰、抓 3-5 條核心落地就 80% 收益」 + 「適配場景 vs 反適配」二分。

**根因**：charter 採用方分層採用紀律（progressive adoption）沒明示。三個 preset（minimal/standard/strict）是「**設定嚴格度**」維度、不是「**採用深度**」維度。

**判斷**：對齊 framework 服務原則「不討魚、培養魚塭」精神延伸 — 採用方應能 progressive adopt、不是 all-or-nothing。

**候選方向**：v0.9.0 議程 essential preset（與 #26 同源）+ 採用 lifecycle「初始 footprint 超低、漸進深化」設計。

---

## 4. 議程影響

### 4.1 v0.9.0 MINOR 議程候選新加（與既有 lifecycle / mutability 並列）

- **essential preset**（3-5 條 core、< 5k init token、targets：探索期 / 單人 / 快迭代專案）
- minimal/standard/strict 從「設定嚴格度」軸 → 升 / 並列「採用深度」軸
- 對應 #26 + #28 同源條款化

### 4.2 SSS S3 v0.8.x PATCH 急迫性升頂

對應 #27（循環依賴 reality check）→ SSS S3 引導式紀律 v0.8.1 PATCH ship 後直接治本。

### 4.3 examples/external-evaluations/ 目錄誕生意義

- charter 第一個正式 cross-vendor 互學物理載體
- 對齊框架價值第 4 條候選「跨 vendor 知識聚合 + 互為養分 + 收斂 best-of-breed」
- 未來其他 vendor / 其他 AI instance 對 charter 的評估可累積進此目錄
- v0.9.0 lifecycle.md ship 時、本目錄可作 vendor 升級 path 互學深化的素材源

---

## 5. 變更歷史

### v0.1（2026-04-30 建立）

初版 — CliSpike Engineer Claude 評估原文 verbatim 保留 + maintainer 註解 + 三個衍生 signal 候選 + 議程影響盤點。

**對應 dogfood-driven hardening 第十三循環**（新類型）：
- 第十一循環：v0.8.0 三 signal 同 LIVE session 條款化（user 公司接入第二次 + signal #16 升實作層 + signal #10 升結構修正）
- 第十二循環：post-v0.8.0 ship docs sync 缺漏 user 抓到（signal #24 + walkthrough 補完）
- **第十三循環：外部 AI 系統評估（新觸發類型）→ #26/#27/#28 候選**

**保留紀錄供未來追溯**：當 v0.9.0 essential preset / SSS S3 v0.8.x PATCH ship 後、回頭看本評估是否拉到 7-8/10 落地成熟度的進度檢核基準。
