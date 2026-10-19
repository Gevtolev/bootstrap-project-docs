---
name: bootstrap-project-docs
description: |
  Use when initializing, creating, restructuring, or scaffolding a project's documentation
  system for AI coding agents — covering AGENTS.md, ARCHITECTURE.md, and docs/
  subdirectories with adr/insights/research/exec-plans. Use when user says: 初始化文档体系,
  搭建 AGENTS.md 体系, 建立项目文档框架, bootstrap project docs, scaffold AGENTS.md system.
  Use also when an agent's init output feels too thin, when an existing AGENTS.md needs
  restructuring, or when legacy CLAUDE.md guidance must be migrated into AGENTS.md.
  Use also when a project needs a ticket-splitting and task-tracking convention for agents
  (拆票规范, 任务追踪, 本地任务文件 / GitLab / GitHub issues).
---

# Bootstrap Project Docs

为目标项目从零搭建或重构一套可落地、可维护、跨 AI coding agent 的文档体系。`AGENTS.md` 是项目规则唯一真相源。

## When to Use / Skip

**Use when:**
- 新项目初始化，需要文档骨架
- 已有项目代码丰富但文档稀薄
- 已有 AGENTS.md 但全堆一文件，需拆分为体系
- 仅有旧 `CLAUDE.md`，需要一次性迁移到 `AGENTS.md`

**Skip when:**
- 只需更新单个 AGENTS.md 段落 → 直接 Edit
- 已有完整体系，只需审计 → 直接使用项目的维护 Skill
- 项目极小（单文件脚本） → 不必上完整体系

## Workflow

三阶段，三检查点。每个 phase 使用当前 Agent 的原生任务跟踪能力记录进度。

**Phase 0 — 入口分流**
检测 cwd → 三种路径：greenfield / complete / restructure。✋ 检查点 0：用户确认走哪条。

**Phase 1 — 扫描与推断**（不动文件）
读 manifest（package.json/pyproject.toml/Cargo.toml/...）→ 识别类型；列模块；清点现有文档。
判断任务追踪方式（本地文件默认；GitLab / GitHub 按 `git remote -v` 与 CLI 可用性推荐，规则见 `references/ticket-trackers.md`），写进假设清单。
确定本 Skill 的版本（本 Skill 仓库 CHANGELOG 最新版本号，对应 tag `v<版本>`）与团队成员能访问的安装来源（默认本 Skill 仓库的 remote），写进假设清单。
输出"假设清单"。✋ 检查点 1：用户确认假设（含追踪方式、本 Skill 版本与安装来源）。
完整自检见 `references/phase-1-checklist.md`。

**Phase 2 — 骨架生成**（写到 `.project-docs-staging/`）
按项目类型选模板（见 `references/project-type-variants.md`），只建**核心集**：
`AGENTS.md`/`ARCHITECTURE.md`、`docs/adr/`（README + ADR 模板）、`docs/exec-plans/`（README + plan 模板 + tech-debt）。
**lazy**：`GLOSSARY.md` / `insights/` / `research/` 不预建，首次有内容才创建（空目录是净亏损）。
可选：`.ignore`（ripgrep 格式）。Monorepo 另为每个子包生成 `AGENTS.md`。
✋ 检查点 2：用户审阅 staging → 确认后原子 mv 到正式位置。完整自检见 `references/phase-2-checklist.md`。

**Phase 2.5 — 生成项目级 skill**（核心创新）
三个项目级 Skill 都写入 `.agents/skills/<name>/`（Codex 等客户端读取），再为每个建相对软链接 `.claude/skills/<name> -> ../../.agents/skills/<name>`（Claude Code 只扫描 `.claude/skills/`），内容只有一份。团队有 Windows 成员且未开启 `core.symlinks` 时改为复制，并在 AGENTS.md `## 文档体系` 注明两处同步。
- `maintain-project-docs`：实例化 `templates/maintain-project-docs-SKILL.md.tmpl`；description 按类型定制（见 `references/project-type-variants.md`），body 含按需文档体检清单和访谈式记录（记决定 / 术语前先对照术语表与代码追问），非每改动自动跑。
- `split-into-tickets`：实例化 `templates/split-into-tickets-SKILL.md.tmpl`；把检查点 1 选定的追踪方式小节从 `references/ticket-trackers.md` 原样填入 `{{TICKET_TRACKER_SECTION}}`，并填 AGENTS.md 的 `## 任务追踪`。
- `bootstrap-project-docs`：把本 Skill 目录原样复制到 `.agents/skills/bootstrap-project-docs/`（检查点 1 确认的版本），成员升级或重建文档体系时用同一版本，无需另装。

填 AGENTS.md 的 `## 文档体系`：`{{BOOTSTRAP_VERSION}}`、`{{BOOTSTRAP_SOURCE_URL}}` 用检查点 1 确认的值。

**Phase 2.6 — 生成项目级防漂移 hook（防漂移闭环）**
检测 `git` 与 `claude` CLI：
- 同时可用 → 用 `templates/source-of-truth-map.tmpl` 生成 `docs/source-of-truth-map.md`（按 Phase 1 扫描填规则行），并用 `templates/anti-drift-hook.sh.tmpl` 安装 pre-push hook（默认 `.git/hooks/pre-push`，多人项目用 `core.hooksPath`）。
- 缺少任一项 → 跳过 hook，把防漂移落回维护 Skill 的手动 reconcile 步骤；不影响其余 Agent 使用本 Skill。
完整蓝图（两阶段 prompt / 挂点 / 安装 / 降级）见 `references/anti-drift-hook.md`。✋ 检查点 2.6：把生成的映射表规则给用户确认（哪些 `auto` 哪些 `notify`）。

**Phase 3 — 深度填充与验证**
对用户标注的章节读源码深推；ARCHITECTURE 真实化；索引与 ADR 矩阵校验。
输出「日常如何维护这套体系」卡片。
完整自检见 `references/phase-3-checklist.md`。

## Quick Reference

docs 子目录，目的互斥不重叠（★=核心集，其余 lazy 按需建）：

| 目录 | 回答的问题 |
|------|-----------|
| ★ `adr/` | **为什么是这样而不是另一种**（ADR 决策追溯） |
| ★ `exec-plans/` | **现在在做什么 / 进度**（active / completed） |
| `GLOSSARY.md`（根目录） | **这个词指什么**（统一项目黑话；术语表，仅此而已） |
| `insights/` | **为什么做这个产品**（用户视角 / 商业理由 / 设计动机） |
| `research/` | **有什么备选 / 可行性如何**（调研，可能不落地） |
| `source-of-truth-map.md` | **哪些文件是真相源、如何同步**（防漂移映射表，Phase 2.6 生成） |

回答"项目现在长什么样"由顶层 `ARCHITECTURE.md` + 代码 docstring 承担，不再放 docs/。

| 项目类型 | docs/ 调整 |
|---------|-----------|
| Web | 全 4 类 |
| CLI | 默认无 insights |
| Library | adr + research |
| Service | 全 4 类 |
| Monorepo | 顶层 + 每包轻量 |
| Mobile | adr + insights |
| Data | research 重于 insights |

类型 → 模板映射的详细规则见 `references/project-type-variants.md`。

## Common Mistakes

| 错误 | 修正 |
|------|------|
| 直接覆盖现有 AGENTS.md | 走 restructure，备份 `.bak.<ts>`，逐章确认 |
| 跳过检查点 | 三个检查点必须停下问用户 |
| 把架构写进 AGENTS.md | 关注点分离——架构进 ARCHITECTURE.md |
| 忘了项目级维护 skill | Phase 2.5 必做；维护体系长期靠它 |
| 项目级 Skill 只放 `.agents/skills/` | Claude Code 看不到；同时建 `.claude/skills/<name>` 相对软链接 |
| 拆票 skill 留着三种追踪方式 | 只填检查点 1 选定的一种，AGENTS.md `## 任务追踪` 与之一致 |
| 忘了生成防漂移 hook/映射表 | Phase 2.6：有 git 就装 pre-push hook + 映射表，无 git 落回 maintain |
| 直接写到 cwd | 必须先 staging，用户确认后 mv |

## Design Philosophy

7 大可移植原则（关注点分离 / 决策追溯独立 / 自维护索引 / 计划驱动 / 自检纪律 / 克制 / 防漂移闭环）详见 `references/design-philosophy.md`。
