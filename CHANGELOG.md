# Changelog

## [0.8.0] - 2026-10-19

### Changed

- **执行计划统一为目录形式**：一个功能一个目录 `docs/exec-plans/active/<topic>/`，计划固定叫 `plan.md`，需要长篇设计时写同目录 `spec.md`；本地追踪时再加每票一个 `NN-<slug>.md`。GitLab / GitHub 追踪方式下的本地计划也改为 `active/<topic>/plan.md`（原为 `active/<topic>.md`）。
- **AGENTS.md `## 任务追踪`**：新增固定一行写明上述落点，并说明其他 Skill 或工具自带默认落点时以此为准。

## [0.7.0] - 2026-10-19

### Changed

- **ADR 目录与命名**：`docs/decisions/` 改为 `docs/adr/`，文件命名从 `YYYY-MM-DD-<topic>.md` 改为 4 位顺序编号 `NNNN-<topic>.md`（新编号 = 现有最大编号 + 1，不复用），引用写 `ADR-NNNN`，决策日期只记在矩阵里。索引模板改名为 `docs-adr-README.tmpl`。
- **ADR 推翻规则**：推翻旧决策时，除新增 ADR（写 `Supersedes ADR-MMMM`）外，旧 ADR 标题下加一行可见状态（`Superseded by ADR-NNNN`，或「部分被 ADR-NNNN 推翻——某条不再生效」），矩阵同步改；旧 ADR 正文不改。maintain 与 split-into-tickets 读到这类状态时以新 ADR 为准。
- **术语表位置**：`docs/glossary.md` 移到根目录 `GLOSSARY.md`，仍按需创建；条目格式不变（术语 + 一句定义 + `_Avoid_`）。

### Added

- **项目内安装与 Claude Code 可见**：项目级 Skill 仍写入 `.agents/skills/<name>/`，并新建相对软链接 `.claude/skills/<name> -> ../../.agents/skills/<name>`（Claude Code 只扫描 `.claude/skills/`）；本 Skill 也以锁定版本副本装进项目 `.agents/skills/bootstrap-project-docs/`，成员 clone 即用同一版本。
- **AGENTS.md `## 文档体系`**：写明三个项目级 Skill 的用法、本 Skill 版本与安装来源、升级副本的命令，以及 Claude Code 需 ≥ v2.1.277 才自动读取 AGENTS.md。检查点 1 新增确认本 Skill 版本与安装来源。

### Credits

- `docs/adr/` 顺序编号 ADR 与根目录 `GLOSSARY.md` 的约定参考 [mattpocock/skills](https://github.com/mattpocock/skills) 的 domain-modeling（MIT，Copyright (c) 2026 Matt Pocock）；推翻时在旧 ADR 加状态行为本体系补充。

## [0.6.0] - 2026-10-19

### Added

- **项目级拆票 Skill**：新增 `templates/split-into-tickets-SKILL.md.tmpl`，Phase 2.5 生成到 `.agents/skills/split-into-tickets/`。把计划拆成纵切票（每票打通端到端路径、自带测试与文档）、标注真实阻塞边、宽重构走 expand–contract；先请用户确认粒度与阻塞边，再按依赖顺序发布，不修改父项，按前沿推进。
- **任务追踪方式**：新增 `references/ticket-trackers.md`。Phase 1 推荐、检查点 1 确认，三选一：本地文件（默认，`docs/exec-plans/active/<topic>/` 每票一个文件）、GitLab issues（glab；Premium 用原生阻塞链接，否则 `Blocked by` 行）、GitHub issues（gh；有 issue dependencies 用原生关系）。AGENTS.md 新增 `## 任务追踪` 节。
- **访谈式记录**：maintain skill 新增同名一节。记录决定或术语前先读术语表、ADR 和代码；用词冲突、一词多义、与代码不一致或边界不清时，先问一轮（每问附推荐答案、边界给具体场景），术语定型当场写入 glossary。description 增加「记 ADR / 统一术语」触发词。

### Changed

- maintain checklist 第 6 项改为「起执行计划并用 split-into-tickets 拆票」；exec-plan 模板「拆分步骤」只列票编号 / 链接。

### Credits

- 访谈轮次（grilling）、领域建模追问（domain-modeling）与纵切拆票（to-tickets）的思路参考 [mattpocock/skills](https://github.com/mattpocock/skills)（MIT，Copyright (c) 2026 Matt Pocock），按本体系用中文重写，生成的 Skill 不依赖任何第三方 Skill。

## [0.5.0] - 2026-09-20

### Changed

- 主 Skill 从 `bootstrap-claude-docs` 改名为 `bootstrap-project-docs`，面向不同 AI coding agent。
- 项目规则统一使用 `AGENTS.md` 作为唯一真相源，不再生成或镜像 `CLAUDE.md`。
- 项目级维护 Skill 改名为 `maintain-project-docs`，默认生成到 `.agents/skills/`。
- README 增加公共 Agent Skills、Codex、Claude Code 和其他 Agent 的 Git + symlink 安装方式。

### Migration

- 删除旧安装目录中的 `bootstrap-claude-docs`，改为安装 `skills/bootstrap-project-docs`。
- 已有项目可把旧 `CLAUDE.md` 作为一次性迁移输入，确认内容进入 `AGENTS.md` 后不再保留双份规则文件。

## [0.4.0] - 2026-06-29

### Added

- **防漂移闭环**：新增 Phase 2.6，按项目生成真相源映射表（`source-of-truth-map.tmpl`）+ pre-push 防漂移 hook（`anti-drift-hook.sh.tmpl`，两阶段：haiku 检测 / sonnet 修复，自动改机械文档、ADR/PRD 只提醒、改动留工作区不 commit）。蓝图见 `references/anti-drift-hook.md`。
- 设计哲学第 7 条「防漂移闭环」；maintain skill 增「与 hook 分工」节。

### Changed

- README 原则数 6 → 7；maintain checklist 索引项改为「hook 兜底」。

## [0.3.0] - 2026-06-23

### Changed

吸收 [mattpocock/skills](https://github.com/mattpocock/skills) 文档管理实践（调研其全部 ~60 个 skill 后提炼）：

- **ADR 极简化**：`adr.tmpl` 重写为「标题 + 1-3 句话」，状态/候选/影响降为可选段——修正与「克制」原则的矛盾
- **durability 规则**：ADR 禁写文件路径/行号/代码片段（会过时），写理由/契约——Matt 语料里重复最多的一条
- **ADR 三段判据**：补全为「难逆转 + 没上下文会困惑 + 真有取舍」（三者同时成立才记）+ what-qualifies 分类
- **lazy 创建**：greenfield 只建核心集（CLAUDE/ARCHITECTURE/AGENTS/decisions/exec-plans + maintain skill）；glossary/insights/research 首次有内容才建，不预建空目录
- **exec-plan 增强**（借 decision-mapping）：加 `Blocked by` 依赖 DAG + 「链接不复制、保持紧凑」纪律

### Added

- **新增 `templates/glossary.tmpl`**：项目术语表层（`术语: 定义 + _Avoid_: 同义词`），统一黑话、命名一致、AI 导航更准；lazy 创建，绑定代码/决策而非对话刮取

## [0.2.0] - 2026-05-29

### Changed

**v2 文档体系重构**：`docs/handover/` 废弃，改为 `docs/decisions/`（ADR 决策追溯）。

- 设计哲学第 2 条从"双视角文档"改为"决策追溯独立"（ADR 独立目录，不混在 handover 里）
- 4 类 docs 子目录：decisions / insights / research / exec-plans
- 新增 `templates/adr.tmpl`（ADR 模板）+ `templates/docs-decisions-README.tmpl`
- 删除 `templates/docs-handover-README.tmpl` + `references/sample-handover.md`
- 新增 `templates/ignore.tmpl`（生成 `.ignore`，ripgrep 格式）+ `templates/sub-package-CLAUDE.md.tmpl`（monorepo 子包）
- maintain skill 清单从 6 项扩展为 8 项（含 ADR 提醒 + 季度审计）
- ARCHITECTURE.md 目录结构段强制每个顶层目录附一句话职责（codebase map）

参考来源：[How Claude Code works in large codebases](https://claude.com/blog/how-claude-code-works-in-large-codebases-best-practices-and-where-to-start)

## [0.1.0] - 2026-04-30

### Added

**首版发布**：bootstrap-claude-docs skill + `/bootstrap-docs` slash command。

Skill 产出：
- `skills/bootstrap-claude-docs/SKILL.md` — 三阶段三检查点主流程（≤ 500 词）
- `references/design-philosophy.md` — 5 大设计哲学（关注点分离 / 双视角 / 自维护索引 / 计划驱动 / 自检纪律）
- `references/project-type-variants.md` — 7 种项目类型变体（Web / CLI / 库 / 后端 / Monorepo / 移动 / 数据）
- `references/phase-{1,2,3}-checklist.md` — 三阶段自检清单
- `references/sample-{CLAUDE,ARCHITECTURE,handover}.md` — 去标识化样例（acme-app 虚构项目）
- `templates/*.tmpl` — 10 个模板（CLAUDE / ARCHITECTURE / AGENTS / 4× docs README / tech-debt / exec-plan / 项目级 maintain skill）
- `commands/bootstrap-docs.md` — slash command
- `tests/fixtures/empty/` — 空目录冒烟测试 fixture + 期望结构清单

核心创新：在目标项目里生成 `.claude/skills/maintain-claude-docs/SKILL.md` 项目级维护 skill，让每次相关改动自动提醒同步文档体系。

### 延期验证

以下项留待首位用户（包括作者自己）手动跑一次：
- `/bootstrap-docs` 在 `tests/fixtures/empty/` 上的实际端到端
- `/bootstrap-docs` 在已有项目上的扫描推断
- `/bootstrap-docs` 在无体系旧 CLAUDE.md 上的 restructure 路径 + diff 预览 + 备份
