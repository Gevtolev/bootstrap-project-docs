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

agents_count="$(grep -c '^AGENTS\.md$' "$root_dir/tests/fixtures/empty/expected-structure.txt")"
if [ "$agents_count" -eq 1 ]; then
  printf '  ✓ fixture 只生成一份 AGENTS.md\n'
else
  printf '  ✗ fixture 应只生成一份 AGENTS.md，实际为 %s\n' "$agents_count"
  fail=1
fi

if [ "$fail" -ne 0 ]; then
  exit 1
fi

printf 'ALL PASS\n'
