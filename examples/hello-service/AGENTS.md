# Agent Context Router

This example project keeps its portable agent context in `.ai/`. Read `.ai/PROJECT.md`, `.ai/ARCHITECTURE.md`, and `.ai/CONVENTIONS.md` first; read other files in `.ai/` only when the task needs them.

Work in progress and the next action live in `.ai/HANDOFF.md` and `.ai/TASKS.md`.

## Adapters

This example assumes a tool that reads `AGENTS.md` natively (Codex, OpenCode, Cursor, Kiro, Claude Code, Cline, Junie, Crush). For a tool that does not, install its adapter from the template and keep it thin, for example:

```bash
sh .ai/adapters/install.sh . claude
```

An installed adapter contains only a routing line such as "Read and follow AGENTS.md at the repository root"; it never duplicates project context.
