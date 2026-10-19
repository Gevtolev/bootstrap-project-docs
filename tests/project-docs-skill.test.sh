#!/usr/bin/env bash

set -uo pipefail

root_dir="$(cd "$(dirname "$0")/.." && pwd)"
skill_dir="$root_dir/skills/bootstrap-project-docs"
fail=0

check() {
  local label="$1"
  shift
  if "$@"; then
    printf '  ✓ %s\n' "$label"
  else
    printf '  ✗ %s\n' "$label"
    fail=1
  fi
}

check "新 Skill 目录存在" test -d "$skill_dir"
check "Skill frontmatter 使用新名称" grep -q '^name: bootstrap-project-docs$' "$skill_dir/SKILL.md"
check "AGENTS.md 主模板存在" test -f "$skill_dir/templates/AGENTS.md.tmpl"
check "不再发布 CLAUDE.md 模板" test ! -e "$skill_dir/templates/CLAUDE.md.tmpl"
check "子包使用 AGENTS.md 模板" test -f "$skill_dir/templates/sub-package-AGENTS.md.tmpl"
check "维护 Skill 使用通用名称" grep -q '^name: maintain-project-docs$' "$skill_dir/templates/maintain-project-docs-SKILL.md.tmpl"
check "README 包含公共 Agent Skills 安装入口" grep -q '\.agents/skills/bootstrap-project-docs' "$root_dir/README.md"
check "README 包含 Codex 安装入口" grep -q '\.codex}/skills' "$root_dir/README.md"
check "README 包含 Claude Code 安装入口" grep -q '\.claude/skills/bootstrap-project-docs' "$root_dir/README.md"
check "维护 Skill 含访谈式记录" grep -q '^## 访谈式记录$' "$skill_dir/templates/maintain-project-docs-SKILL.md.tmpl"
check "访谈式记录要求每问附推荐答案" grep -q '推荐答案' "$skill_dir/templates/maintain-project-docs-SKILL.md.tmpl"
check "拆票 Skill 模板存在" test -f "$skill_dir/templates/split-into-tickets-SKILL.md.tmpl"
check "拆票 Skill 使用固定名称" grep -q '^name: split-into-tickets$' "$skill_dir/templates/split-into-tickets-SKILL.md.tmpl"
check "拆票 Skill 要求纵切" grep -q '纵切' "$skill_dir/templates/split-into-tickets-SKILL.md.tmpl"
check "拆票 Skill 票模板含 Blocked by" grep -q 'Blocked by' "$skill_dir/templates/split-into-tickets-SKILL.md.tmpl"
check "拆票 Skill 留有追踪方式占位" grep -q '{{TICKET_TRACKER_SECTION}}' "$skill_dir/templates/split-into-tickets-SKILL.md.tmpl"
check "追踪方式参考含本地文件" grep -q 'docs/exec-plans/active/' "$skill_dir/references/ticket-trackers.md"
check "追踪方式参考含 GitLab" grep -q 'glab issue create' "$skill_dir/references/ticket-trackers.md"
check "追踪方式参考含 GitHub" grep -q 'gh issue create' "$skill_dir/references/ticket-trackers.md"
check "AGENTS.md 模板含任务追踪节" grep -q '^## 任务追踪$' "$skill_dir/templates/AGENTS.md.tmpl"
check "exec-plan 模板指向拆票 Skill" grep -q 'split-into-tickets' "$skill_dir/templates/exec-plan.tmpl"
check "主流程生成拆票 Skill" grep -q 'split-into-tickets' "$skill_dir/SKILL.md"
check "不依赖外部第三方 Skill" bash -c "! grep -rqE 'domain-modeling|grill-with-docs|(^|[^a-z-])to-tickets|setup-matt-pocock' '$skill_dir'"
check "ADR 索引模板改名为 docs-adr-README" test -f "$skill_dir/templates/docs-adr-README.tmpl"
check "旧 decisions 索引模板已移除" test ! -e "$skill_dir/templates/docs-decisions-README.tmpl"
check "ADR 使用顺序编号命名" grep -q 'NNNN-<topic>.md' "$skill_dir/templates/docs-adr-README.tmpl"
check "Skill 内不再引用 docs/decisions/" bash -c "! grep -rq 'docs/decisions' '$skill_dir'"
check "Skill 内不再使用日期前缀 ADR 命名" bash -c "! grep -rqE 'YYYY-MM-DD-(<topic>|topic|other-topic)\.md' '$skill_dir/templates/adr.tmpl' '$skill_dir/templates/docs-adr-README.tmpl' '$skill_dir/templates/maintain-project-docs-SKILL.md.tmpl'"
check "fixture 生成 docs/adr/README.md" grep -q '^docs/adr/README\.md$' "$root_dir/tests/fixtures/empty/expected-structure.txt"
check "Skill 内不再引用 docs/glossary.md" bash -c "! grep -rq 'glossary\.md' '$skill_dir'"
check "AGENTS.md 模板指向根目录 GLOSSARY.md" grep -q 'GLOSSARY\.md' "$skill_dir/templates/AGENTS.md.tmpl"
check "fixture 不预建 GLOSSARY.md" grep -q '^GLOSSARY\.md ' "$root_dir/tests/fixtures/empty/expected-structure.txt"
check "推翻规则要求在旧 ADR 加状态行" grep -q '旧 ADR 标题下' "$skill_dir/templates/docs-adr-README.tmpl"
check "推翻规则覆盖部分推翻" grep -q '部分被' "$skill_dir/templates/docs-adr-README.tmpl"
check "推翻规则不再写不修改原文" bash -c "! grep -rqE '不修改原文|不改原文' '$skill_dir/templates'"
check "维护 Skill 推翻时同步旧 ADR" grep -q '旧 ADR' "$skill_dir/templates/maintain-project-docs-SKILL.md.tmpl"
check "拆票 Skill 跳过已推翻的 ADR" grep -q 'Superseded' "$skill_dir/templates/split-into-tickets-SKILL.md.tmpl"
check "CHANGELOG 记录 0.7.0" grep -q '^## \[0.7.0\]' "$root_dir/CHANGELOG.md"
check "CHANGELOG 记录 0.6.0" grep -q '^## \[0.6.0\]' "$root_dir/CHANGELOG.md"

agents_count="$(grep -c '^AGENTS\.md$' "$root_dir/tests/fixtures/empty/expected-structure.txt")"
if [ "$agents_count" -eq 1 ]; then
  printf '  ✓ fixture 只生成一份 AGENTS.md\n'
else
  printf '  ✗ fixture 应只生成一份 AGENTS.md，实际为 %s\n' "$agents_count"
  fail=1
fi

split_count="$(grep -c '^\.agents/skills/split-into-tickets/SKILL\.md$' "$root_dir/tests/fixtures/empty/expected-structure.txt")"
if [ "$split_count" -eq 1 ]; then
  printf '  ✓ fixture 生成拆票 Skill\n'
else
  printf '  ✗ fixture 应生成一份拆票 Skill，实际为 %s\n' "$split_count"
  fail=1
fi

if [ "$fail" -ne 0 ]; then
  exit 1
fi

printf 'ALL PASS\n'
