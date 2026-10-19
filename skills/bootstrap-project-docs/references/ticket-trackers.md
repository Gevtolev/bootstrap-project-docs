# 任务追踪方式

> Phase 1 判断，检查点 1 与用户确认，Phase 2.5 生成 `split-into-tickets` 时把选中的小节原样替换模板里的 `{{TICKET_TRACKER_SECTION}}`，同时在 AGENTS.md 的 `## 任务追踪` 写一行说明。

## 如何选

| 条件 | 推荐 |
|------|------|
| 默认 / 无远端 / 个人项目 / 用户不想依赖平台 | 本地文件 |
| `git remote -v` 指向 GitLab，且 `glab` 可用、团队用 GitLab issues 排期 | GitLab |
| `git remote -v` 指向 GitHub，且 `gh` 可用、团队用 GitHub issues 排期 | GitHub |

远端存在不等于团队用它的 issue；只给推荐，由用户选。CLI 不可用时选本地文件，不阻塞 bootstrap。

---

## 本地文件

```markdown
## 追踪方式：本地文件

- 一个功能一个目录：`docs/exec-plans/active/<topic>/`；计划写在同目录 `plan.md`（按 `docs/exec-plans/exec-plan-template.md`）。
- 每张票一个文件：`NN-<slug>.md`，从 `01` 起按依赖顺序编号（阻塞项在前）；不要把多张票合成一个文件。
- `**Blocked by**` 写前置票编号，如 `01, 03`。
- 状态改在票内 `**状态**` 行：📋 待开始 / 🔄 进行中 / ✅ 已完成；讨论与结论追加到票末尾 `## 记录`。
- 全部票完成后，把整个目录移到 `docs/exec-plans/completed/`，并更新 `docs/exec-plans/README.md` 索引。
```

## GitLab

```markdown
## 追踪方式：GitLab issues（glab）

- 创建：`glab issue create --title "<NN>: <标题>" --description "<正文>"`（多行正文用 heredoc）。
- 阻塞边：Premium/Ultimate 用原生阻塞链接，发一条 note：`glab issue note <票> --message "/blocked_by #<前置>"`；免费版或不可用时，在正文第一行写 `Blocked by: #<n>, #<m>`，正文里的 `**Blocked by**` 同步写 issue 号。
- 来源是已有 issue 时，在子票正文顶部写 `Part of #<父 issue>`。
- 本地 `docs/exec-plans/active/<topic>.md` 只保留目标、决策日志和 issue 链接列表，不复制票正文。
- 前沿：`glab issue list -O json` 中仍为 open、且所有阻塞 issue 都已关闭的票。
- 完成：先 `glab issue note <票> --message "<结论>"`，再 `glab issue close <票>`。
```

## GitHub

```markdown
## 追踪方式：GitHub issues（gh）

- 创建：`gh issue create --title "<NN>: <标题>" --body "<正文>"`（多行正文用 heredoc）。
- 阻塞边：仓库启用 issue dependencies 时用原生关系：`gh api --method POST repos/<owner>/<repo>/issues/<票>/dependencies/blocked_by -F issue_id=<前置票的数据库 id>`（数据库 id 由 `gh api repos/<owner>/<repo>/issues/<n> --jq .id` 获取，不是 `#编号`）；不可用时在正文第一行写 `Blocked by: #<n>, #<m>`。
- 来源是已有 issue 时，可用 `gh issue create --parent <父 issue>` 挂成子 issue；不支持时在正文顶部写 `Part of #<父 issue>`。
- 本地 `docs/exec-plans/active/<topic>.md` 只保留目标、决策日志和 issue 链接列表，不复制票正文。
- 前沿：`gh issue list --state open` 中所有阻塞 issue 都已关闭的票。
- 完成：`gh issue close <票> --comment "<结论>"`。
```
