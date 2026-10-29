#!/usr/bin/env sh
set -eu

src_dir=$(dirname -- "$0")
tmpl_root=$src_dir/../..

usage() {
  printf 'usage: %s <project-dir> [tool...]\n' "$0"
  printf 'example: %s ~/my-project claude opencode cursor\n' "$0"
  printf 'tools: claude cursor kiro cline roo copilot gemini windsurf aider zed qwen (opencode/codex/crush/junie need none)\n'
  exit 1
}

[ "$#" -ge 1 ] || usage
target=$1
shift

mkdir -p "$target"
project_name=$(basename -- "$target")

# Portable context layer
if [ -e "$target/AGENTS.md" ]; then
  printf 'kept existing: AGENTS.md (merge manually if needed)\n'
else
  cp "$tmpl_root/AGENTS.md" "$target/AGENTS.md"
  printf 'created: AGENTS.md\n'
fi
if [ -e "$target/.ai" ]; then
  printf 'kept existing: .ai/\n'
else
  mkdir -p "$target/.ai"
  for f in "$tmpl_root"/.ai/*; do
    cp -R "$f" "$target/.ai/"
  done
  printf 'created: .ai/ (adapters kept, so tools can be added later)\n'
fi

# Minimal project files, only when missing
if [ ! -e "$target/README.md" ]; then
  printf '# %s\n' "$project_name" > "$target/README.md"
  printf 'created: README.md\n'
fi
if [ ! -e "$target/.gitignore" ]; then
  printf '.DS_Store\n.env\n.env.*\n!.env.example\n' > "$target/.gitignore"
  printf 'created: .gitignore\n'
fi

# Adapters
if [ "$#" -gt 0 ]; then
  sh "$src_dir/install.sh" "$target" "$@"
fi

printf 'context installed in %s\n' "$target"
printf 'next: open your agent there and say "Read AGENTS.md"\n'
