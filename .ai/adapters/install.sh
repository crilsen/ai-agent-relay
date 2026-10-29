#!/usr/bin/env sh
set -eu

src_dir=$(dirname -- "$0")
target=${1:-.}
if [ "$#" -gt 0 ]; then shift; fi

if [ "$#" -eq 0 ]; then
  set -- claude cursor kiro cline roo copilot gemini windsurf aider zed qwen
fi

copy_file() {
  # Never overwrite: adapter targets such as CLAUDE.md, GEMINI.md, .rules, or
  # .aider.conf.yml often already exist. Merge by hand instead.
  if [ -e "$1" ]; then
    printf 'kept existing: %s (merge the adapter manually)\n' "$1"
    return 0
  fi
  mkdir -p "$(dirname -- "$1")"
  cp "$2" "$1"
}

for tool in "$@"; do
  case "$tool" in
    claude)   copy_file "$target/CLAUDE.md" "$src_dir/claude.md" ;;
    cursor)   copy_file "$target/.cursor/rules/agents.mdc" "$src_dir/cursor.mdc" ;;
    kiro)     copy_file "$target/.kiro/steering/agents.md" "$src_dir/kiro.md" ;;
    cline)    copy_file "$target/.cline/rules/agents.md" "$src_dir/cline.md" ;;
    roo)      copy_file "$target/.roo/rules/00-agents.md" "$src_dir/roo.md" ;;
    copilot)  copy_file "$target/.github/copilot-instructions.md" "$src_dir/copilot.md" ;;
    gemini)   copy_file "$target/GEMINI.md" "$src_dir/gemini.md" ;;
    gemini-settings) copy_file "$target/.gemini/settings.json" "$src_dir/gemini-settings.json" ;;
    windsurf) copy_file "$target/.windsurf/rules/agents.md" "$src_dir/windsurf.md" ;;
    aider)    copy_file "$target/.aider.conf.yml" "$src_dir/aider.yml" ;;
    zed)      copy_file "$target/.rules" "$src_dir/zed.md" ;;
    qwen)     copy_file "$target/QWEN.md" "$src_dir/qwen.md" ;;
    cursor-guardrails) copy_file "$target/.cursor/rules/guardrails.mdc" "$src_dir/cursor-guardrails.mdc" ;;
    kiro-guardrails)   copy_file "$target/.kiro/steering/guardrails.md" "$src_dir/kiro-guardrails.md" ;;
    opencode|codex|crush|junie)
      printf 'no adapter needed: %s reads AGENTS.md natively\n' "$tool"
      continue ;;
    *) printf 'unknown tool: %s\n' "$tool" >&2; exit 1 ;;
  esac
  printf 'installed adapter: %s\n' "$tool"
done

if [ -f "$target/AGENTS.md" ] && [ ! -e "$target/CLAUDE.md" ] && [ ! -e "$target/.cursor" ] && [ ! -e "$target/.opencode" ] && [ ! -e "$target/.kiro" ]; then
  printf 'hint: install an adapter for your tool, e.g. sh %s/install.sh %s claude\n' "$src_dir" "$target"
fi
