# bootstrap-project-docs

> 为项目搭建可落地、可维护、跨 AI coding agent 的文档体系。
> 以 `AGENTS.md` 为项目规则唯一真相源，并配套 `ARCHITECTURE.md`、`docs/` 和项目级维护 Skill。

## 这个仓库提供什么

- **`bootstrap-project-docs` Skill** — 三阶段三检查点流程，把空项目、已有代码项目或已有旧文档的项目引导成一整套文档体系
- **跨 Agent 安装** — 支持安装到公共 Agent Skills、Codex、Claude Code 或其他兼容客户端的 Skill 目录
- **7 条可移植设计原则** — 关注点分离 / 决策追溯独立 / 自维护索引 / 计划驱动 / 自检纪律 / 克制 / 防漂移闭环
- **7 种项目类型变体** — Web / CLI / Library / Service / Monorepo / Mobile / Data
- **16 个模板 + 2 份样例** — 拿去就能填

## 产出什么

在目标项目里生成。**核心集**一次建好，可选层 lazy（有内容才建）：

```
项目根/
├── AGENTS.md                                   # 规则、流程、改动自查（≤4 核心项）
├── ARCHITECTURE.md                             # 结构、数据流、技术栈
├── GLOSSARY.md              （lazy）           # 项目术语表（统一黑话）
├── docs/
│   ├── adr/README.md                           # 架构决策记录索引（ADR，0001- 顺序编号）
│   ├── adr/adr-template.md                     # 极简 ADR 模板（标题 + 1-3 句）
│   ├── exec-plans/
│   │   ├── README.md                           # 执行计划索引
│   │   ├── tech-debt-tracker.md                # 技术债务追踪
│   │   └── exec-plan-template.md               # 执行计划模板（含 Blocked by 依赖）
│   ├── insights/            （lazy）           # 产品思考
│   ├── research/            （lazy）           # 调研
│   └── source-of-truth-map.md                 # 真相源映射表（防漂移用）
├── .agents/skills/maintain-project-docs/
│   └── SKILL.md                                # 项目级维护 skill —— 按需文档体检 + 访谈式记录决定 / 术语
├── .agents/skills/split-into-tickets/
│   └── SKILL.md                                # 项目级拆票 skill —— 纵切票 + 阻塞边，发布到选定的追踪处
├── .agents/skills/bootstrap-project-docs/      # 本 Skill 的锁定版本副本，成员升级 / 重建时用同一版本
├── .claude/skills/<上面三个>                   # 相对软链接 → ../../.agents/skills/<name>（Claude Code 只扫描 .claude/skills/）
└── .git/hooks/pre-push                         # 防漂移 hook（Phase 2.6 生成）
```

项目级 Skill 随项目仓库提交，成员 clone 即可用，无需各自安装；生成的 AGENTS.md `## 文档体系` 写明三者用法、本 Skill 版本与升级命令。维护与拆票两个项目级 Skill 是核心创新：`AGENTS.md` 是静态规则文件，项目级 Skill 通过 description 提供按需入口（非每次改动自动运行）。

- `maintain-project-docs`：阶段性文档体检；记录决定或术语时，先对照术语表和代码，发现冲突就先问一轮（每问附推荐答案），术语定型当场入表。
- `split-into-tickets`：把计划拆成纵切票（每张票打通一条端到端路径、自带测试），标注阻塞边，用户确认后按依赖顺序发布。追踪方式在 bootstrap 时选定：本地文件（默认，`docs/exec-plans/active/<topic>/` 每票一个文件）、GitLab issues（glab）或 GitHub issues（gh）。

## 安装

先 clone 仓库，并把 Skill 源目录记为绝对路径：

```bash
git clone https://github.com/Gevtolev/bootstrap-project-docs.git
cd bootstrap-project-docs
skill_source="$PWD/skills/bootstrap-project-docs"
```

推荐使用软链接，`git pull` 后即可获得更新。根据实际客户端选择一个或多个安装目标：

### 公共 Agent Skills 目录

```bash
mkdir -p "$HOME/.agents/skills"
ln -sfn "$skill_source" "$HOME/.agents/skills/bootstrap-project-docs"
```

仅适用于会发现 `~/.agents/skills/` 的客户端。

### Codex

```bash
codex_skills_dir="${CODEX_HOME:-$HOME/.codex}/skills"
mkdir -p "$codex_skills_dir"
ln -sfn "$skill_source" "$codex_skills_dir/bootstrap-project-docs"
```

### Claude Code

```bash
mkdir -p "$HOME/.claude/skills"
ln -sfn "$skill_source" "$HOME/.claude/skills/bootstrap-project-docs"
```

### 其他 Agent

把同一个 `skill_source` 链接或复制到该 Agent 文档指定的用户级 Skill 目录。不要复制成多个长期维护的独立副本，否则版本容易漂移。

## 使用

进入要搭文档体系的项目：

```bash
cd ~/projects/your-project
```

在支持 `$skill-name` 调用语法的 Agent 中输入：

```
$bootstrap-project-docs
```

Claude Code 也可使用 `/bootstrap-project-docs`。或者直接说：“帮我为这个项目搭一套文档体系，以 AGENTS.md 为项目规则入口。”

接下来会走三阶段：

| Phase | 做什么 | 你要做什么 |
|-------|--------|----------|
| 0 | 检测项目状态，告诉你走哪条路径（greenfield / complete / restructure） | 确认路径 |
| 1 | 扫描代码，识别项目类型，列假设清单 | 审阅假设，修正错误推断 |
| 2 | 按模板生成骨架到 `.project-docs-staging/` | 审阅 staging，确认后 skill 原子 mv 到正式位置 |
| 3 | 深填 ARCHITECTURE 的真实数据，校验索引完整性 | 最终确认 |

每个检查点都会停下等你确认——不会一把梭哈。

## 和相邻工具的关系

| 工具 | 职责 | 关系 |
|------|------|------|
| Agent 自带的初始化命令 | 通常只生成单一入口文件 | 本 Skill 补齐架构、决策、计划与维护体系 |
| 本 skill 生成的项目级 `maintain-project-docs` / `split-into-tickets` | 文档体检、访谈式记录、拆票 | 本 skill 的产物，长期生效，不依赖其他第三方 Skill |
| Claude CLI 防漂移 hook | 提交前检查机械文档漂移 | 可选能力；没有 Claude CLI 时自动降级为人工体检 |

## 进一步阅读

- [docs/design.md](./docs/design.md) — 完整设计文档（理念、架构、决策日志）
- [docs/plan.md](./docs/plan.md) — 实现计划（17 task）
- [skills/bootstrap-project-docs/SKILL.md](./skills/bootstrap-project-docs/SKILL.md) — skill 主流程
- [skills/bootstrap-project-docs/references/design-philosophy.md](./skills/bootstrap-project-docs/references/design-philosophy.md) — 7 大设计哲学详述
- [skills/bootstrap-project-docs/references/project-type-variants.md](./skills/bootstrap-project-docs/references/project-type-variants.md) — 7 种项目类型适配
- [skills/bootstrap-project-docs/references/sample-AGENTS.md](./skills/bootstrap-project-docs/references/sample-AGENTS.md) / [sample-ARCHITECTURE.md](./skills/bootstrap-project-docs/references/sample-ARCHITECTURE.md) — 去标识化样例

## 致谢

ADR / 术语表约定、访谈式追问与纵切拆票的思路参考了 [mattpocock/skills](https://github.com/mattpocock/skills)（MIT，Copyright (c) 2026 Matt Pocock），本仓库按自身体系用中文重写，不依赖其 Skill。

## License

MIT — 见 [LICENSE](./LICENSE)。
