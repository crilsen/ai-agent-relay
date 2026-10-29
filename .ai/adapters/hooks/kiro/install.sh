#!/usr/bin/env sh
# Install the Kiro hooks into .kiro/hooks/.
# Creates the file only if it does not already exist; never overwrites.
#
# Kiro 1.0 (IDE) and CLI V3 use the `.kiro/hooks/<name>.json` format with
# `version: "v1"`, `trigger`, and `action`. Verify against your Kiro version:
# the pre-1.0 format used `when`/`then` in `.kiro.hook` files.
set -eu

src_dir=$(dirname -- "$0")
target=${1:-.}
dest="$target/.kiro/hooks/ai-agent-relay.json"

if [ -e "$dest" ]; then
  printf 'kept existing: %s (merge the hooks manually)\n' "$dest"
  exit 0
fi

mkdir -p "$(dirname -- "$dest")"
cp "$src_dir/hooks.json" "$dest"
printf 'created: %s\n' "$dest"
printf 'note: guardrails stay in .kiro/steering/guardrails.md; these hooks only route and remind\n'
