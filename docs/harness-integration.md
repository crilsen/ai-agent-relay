# Harness Integration

ai-agent-relay is a context layer, not a harness. It does not run agents, schedule work, or execute tools. It defines **what** an agent should know and do; the harness provides **how** it triggers and runs. This page explains how the two compose for hooks, agents/subagents, skills, and MCP.

## Division of responsibility

| Concern | ai-agent-relay | Harness |
| --- | --- | --- |
| Context and conventions | Defines (`AGENTS.md`, `.ai/`) | Reads |
| Workflows and prompts | Defines (`.ai/workflows/`, `.ai/prompts/`) | Runs an agent against them |
| Limits and checkpoints | Policy (`.ai/LIMITS.md`) | Detects usage, fires the trigger |
| Tool permissions | Rules (`.ai/TOOLS.md`) | Enforces |
| Hooks | Target behavior | Event and execution |

The rule: the template carries the **policy**, the harness carries the **trigger**.

## Hooks

Hooks belong to the harness. Wire a hook to call the template's workflows instead of duplicating their logic.

- **Pre-commit / pre-push:** run `make lint` and refresh the Resume block (`checkpoint`).
- **Session end / usage threshold:** run `.ai/workflows/checkpoint.md` and commit.
- **Before switching agent:** run `.ai/workflows/switch-agent.md`.

Example hook scripts live in `.ai/adapters/hooks/`. They are plain `sh` and call the same behavior described in the workflows, so the portable policy stays in Markdown and the harness only decides *when*.

Generic examples:

- `.ai/adapters/hooks/pre-commit.sh` — run checks and remind about the Resume block.
- `.ai/adapters/hooks/session-end.sh` — prompt the checkpoint at session end.

Tool-specific examples (verified against each tool's documentation):

- **OpenCode** — plugins are JavaScript/TypeScript loaded from `.opencode/plugins/` or `~/.config/opencode/plugins/`, not shell hooks. `.ai/adapters/hooks/opencode/relay.js` subscribes to `session.idle` and logs the checkpoint reminder; `guardrails.js` blocks destructive commands and secret access via `tool.execute.before`. Install with `.ai/adapters/hooks/opencode/install.sh`.
- **Claude Code** — hooks are shell commands declared in `.claude/settings.json`. Events `SessionStart`, `Stop` (per turn), and `SessionEnd` drive the checkpoint; `PreToolUse` runs `guardrails.sh` to deny destructive commands and secret edits. `install.sh` writes `.claude/settings.json` only when missing.
- **Kiro** — hooks live in `.kiro/hooks/<name>.json` with `version: "v1"`, a `trigger` (`SessionStart`, `Stop`, `PreToolUse`, `PostFileSave`, ...), and an `action` (`agent` injects a prompt; `command` runs a shell command with session JSON on stdin). `.ai/adapters/hooks/kiro/hooks.json` routes `SessionStart` to `AGENTS.md` and reminds about the checkpoint on `Stop`; guardrails remain in `.kiro/steering/guardrails.md`. Kiro 1.0 and CLI V3 use this schema; the pre-1.0 format used `when`/`then` in `.kiro.hook` files. Kiro also reads `AGENTS.md` natively.

Adapt event names and paths to your tool version; hook formats change and are verified against current docs at the time of writing.

## Guardrails and enforcement

`.ai/GUARDRAILS.md` states the portable policy. Materialize it per tool:

- **Advisory:** `AGENTS.md`, `.ai/GUARDRAILS.md`, `.ai/TOOLS.md`.
- **Scoped by path:** Cursor `.cursor/rules/guardrails.mdc` (`globs`), Kiro `.kiro/steering/guardrails.md` (`fileMatch`).
- **Enforced:** Claude Code `PreToolUse` (`guardrails.sh`), OpenCode `tool.execute.before` (`guardrails.js`), and Kiro `PreToolUse` hooks when you add a `command` action (verify exit-code semantics for your Kiro version).

Prefer enforcement for irreversible actions.

## Agents and subagents

Subagents are agents. If they run in the same repository, they read the same `AGENTS.md` and `.ai/`, which makes parallel work possible:

- Give each subagent a scoped task and its own files; avoid two writers on one file.
- **Concurrency rule:** only the primary agent writes `.ai/HANDOFF.md`, `.ai/TASKS.md`, and `.ai/LEARNINGS.md`. Subagents report back; the primary agent integrates. Concurrent writes to these files corrupt the single source of truth.
- A subagent that finishes work should hand its result to the primary agent rather than committing shared state directly.

## Skills

A skill is a packaged instruction. Two ways to combine with the template:

1. **Reference an existing skill** from a workflow or `AGENTS.md` when the skill's behavior is stable.
2. **Ship a project skill** under `.ai/skills/<name>/SKILL.md`. Keep the skill thin: it describes the procedure and points to `.ai/` for facts. Use `.ai/skills/SKILL-TEMPLATE.md` as a starting point.

Skills follow the same principle as adapters: they may route and describe, but they must not duplicate project facts that belong in `.ai/`.

## MCP and tools

MCP servers are configured by the harness. The template does not call them. Instead:

- Record which tools and MCP servers are available, and what is safe versus restricted, in `.ai/TOOLS.md`.
- Record the rules to follow when using them, not their credentials or endpoints.
- If a tool changes how context is written, note it in `.ai/LEARNINGS.md`.

## What this project does not do

- It does not install or run hooks, skills, or MCP servers.
- It does not manage models, quotas, or routing.
- It does not guarantee compatibility with a specific harness version; verify adapter and hook paths against the harness's current documentation.
