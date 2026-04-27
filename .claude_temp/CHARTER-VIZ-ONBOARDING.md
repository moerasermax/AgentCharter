# Charter Viz — Onboarding Tracking

> **建立**：2026-04-27
> **觸發**：使用者第二採用案例（charter 自己的視覺化版本）接入過程
> **位階**：暫時追蹤檔。`.claude_temp/` 是 charter repo dogfooding 取捨下對 working-stack-discipline §1 DRAFT_CONTEXT.md 的替代路徑（charter 自己 v0.x 階段不採用 charter，詳見 STATUS §D）
> **生命週期**：接入完成 + dogfood signal 驗證後 → 合併重點到 `examples/_walkthrough/charter-viz-onboarding.md`（NEXT.md §中優先 #8）→ 本檔歸檔

---

## 第二專案脈絡

| 屬性 | 內容 |
|---|---|
| 領域 | charter framework 自己的視覺化版本（**meta-dogfood**） |
| AI 配置 | Claude（Engineer）+ Gemini（PM），**預期很快加第三 AI** |
| 既有結構 | 已有 `protocols/` 目錄（user 未說具體內容） |
| 採用 preset | `standard` |

## meta-dogfood 的特殊意義

charter 第一次被**meta-採用** — 用 charter 管理一個「關於 charter」的視覺化專案。比一般「第二個 example」多一層意義：

- 驗證 charter 不只能管金融（CryptoBot），能管框架自身的元產品
- 視覺化專案的業務邏輯 = charter 條款本身 → capsule 會頻繁引用 `core/*`
- 是否需要 charter 條款新增「meta-採用模式」特別段，等接入過程觀察

對應 charter A3 公理「專案 ⊥ 框架」的反向實證：原本 A3 是「框架不知道領域差異」，meta-採用是「框架自身也是一個領域」— 確認 A3 的對稱性。

## preset = `standard` 的決策（含多 AI 擴展性評估）

| 理由 | 細節 |
|---|---|
| 條款覆蓋度 | standard / strict 啟用條款一樣（17/17）— 包含 cross-ai-handoff / role-conflict-resolution / multi-role-tracking 三條多 AI 條款 |
| 第三 AI onboarding 容錯 | standard escalation@2 / structural@3；strict 1/2 第一次違規即升級，會卡住 onboarding |
| 視覺化專案風險屬性 | fidelity 失真 ≠ 金融資金損失，不需 strict 上限 |
| 可單點調嚴 | 若日後紀律不夠，改 `parameters.<condition>.<key>` 即可，不必切 preset |

## 領域公理 alias 候選

- `FIDELITY`（單義、清楚）
- `VIZ`（短）
- `CHARTER-VIZ`（明示）

**血鐵律方向**（user 自己寫，不代寫）：

- ① 視覺化展示的 charter 狀態 ≡ git 真實狀態（禁緩存假呈現）
- ② 條款啟用判斷直接讀 `profile.yaml.enabled`（禁推測）
- ③ failure mode 統計引用實際事件 ID（禁虛構）
- ④ 條款引用顯示具體 `§段`（禁模糊「依紀律」）

## 既有 protocols 處理建議

走「**新建 agent-commons + 手動對映**」路徑（避免 `--common-root protocols` 把 16 子目錄建在既有結構上污染）：

```bash
# init 建乾淨 agent-commons/
python ~/.agentcharter/tools/charter-init.py --preset standard ...

# 手動把既有 protocols 內容移進 agent-commons/protocols/
git mv protocols/<files>.md agent-commons/protocols/

# doctor 確認對映
python ~/.agentcharter/tools/charter-doctor.py
```

## 給 user 的 init 指令（已給對話）

```bash
cd ~/projects/<charter-viz>
git clone https://github.com/moerasermax/AgentCharter ~/.agentcharter
python ~/.agentcharter/tools/charter-init.py \
  --preset standard \
  --domain-axioms-path protocols/FIDELITY.md \
  --domain-axioms-alias FIDELITY
# 手動移既有 protocols 內容
# 編 agent-commons/protocols/FIDELITY.md
python ~/.agentcharter/tools/charter-doctor.py
```

雙 AI 觸發 prompt（已給對話，要點）：

- **Claude → Engineer**：依 `~/.agentcharter/core/init-template.md §3.3.2` 6 步驟自我具象化到 `.claude/commands/engineer-init.md`，簽名 `agent-commons/roles/engineer/_role.md`
- **Gemini → PM**：依 `~/.agentcharter/roles/pm/gemini-cli.md`（Gemini 親手寫的 vendor spec）+ `init-template §3.3.2` 自我具象化到 `.gemini/commands/pm-init.toml`，簽名 `agent-commons/roles/pm/_role.md`

## 已浮現的 meta-dogfood 觀察（不等接入即生效）

| # | 觀察 | 沉澱位置 | 處置 |
|---|---|---|---|
| 0 | **framework 設計者本人也會踩自己定義的坑**（2026-04-27）— Claude 在 onboarding 討論中說「signal 記在腦中」違反 `working-stack-discipline §1`；使用者提醒後才補做紀錄。揭露 framework 條款對「設計者 / 維護者」無強制力的盲區 | `STATUS.md §D` + `NEXT.md ⚪ 待對話`（候選 `core/maintainer-discipline.md` 或擴充 `working-stack-discipline §X`）| 暫不條款化；累積 ≥ 3 次同類觀察後再評估 |

## 浮現的 dogfood signal（待接入過程實證）

| # | Signal | 觸發後動作 |
|---|---|---|
| 1 | 視覺化專案的業務邏輯 = charter 條款本身 → capsule 反覆引用 `core/*` | 觀察是否需要「**meta-採用模式**」特別段（init-template / vendor spec 加？）|
| 2 | visualization fidelity 公理 vs charter `evidence-first` 高度重疊 | 若高度重疊 → charter 抽象正確的 signal；若有歧義 → 條款用詞需精化 |
| 3 | 三個 AI 進來時 `cross-ai-handoff §5` 能力快照會被實證 | 浮現痛點直接反饋為 charter 修訂候選 |
| 4 | charter-init.py / charter-doctor.py 在真實外部專案的踩坑 | bug fix / UX 改善反饋為 v0.5.8+ patch |

## 接入後待追蹤（checklist）

- [ ] `git clone` + `charter-init.py` 跑通沒？
- [ ] `charter-doctor.py` 0 errors？
- [ ] 雙 AI self-instantiation 完成？兩份 `_role.md` 簽名？
- [ ] 領域公理 `FIDELITY.md`（或 user 改的 alias）寫好？doctor 二次驗證通過？
- [ ] 第一個 capsule 跑完整生命週期（PM 寫 → Engineer 抽驗 → 接收 → VCP → PM 抽驗 → 結案）？
- [ ] 浮現的條款修訂候選有哪些 → 移到 NEXT.md §1 候選清單

## 完成後處置

接入完成 + dogfood signal 都觀察過後：

1. 本檔重點合併到 `examples/_walkthrough/charter-viz-onboarding.md`（對應 NEXT.md §中優先 #8 「ShopStack / Codex walkthrough 寫成實檔」的同類）
2. 浮現的條款修訂候選移到 NEXT.md §1 候選清單
3. 如果出現 charter v0.5.8+ 的 patch 候選（如 init / doctor 工具改善），記到 NEXT.md §3 工具 phase
4. 本檔從 `.claude_temp/` 移除或註明「已歸檔」
