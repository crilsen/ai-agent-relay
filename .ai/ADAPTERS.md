# Agent Adapters

Any coding agent or harness must find the same source of truth: `AGENTS.md` and `.ai/`. Adapters exist only to route or scope instructions for a specific tool; they must never duplicate project context.

These adapters ship with the [ai-agent-relay](https://github.com/crilsen/ai-agent-relay) template. In an adopted project, use the copy under `.ai/adapters/` and fetch template updates from upstream instead of copying adapters between repositories.

## Native AGENTS.md readers

These tools read `AGENTS.md` on their own and need no routing adapter:

- **Codex**, **OpenCode**, **Cursor**, **Kiro** — verified against each tool's documentation at the time of writing.
- **Claude Code** — from v2.1.277 (2026-09-18) it reads `AGENTS.md` when the project has no `CLAUDE.md`; v2.1.281 extended that to Bedrock, Vertex AI, Foundry, and LLM gateways. A `CLAUDE.md` still takes precedence, so the Claude Code adapter below remains useful when the file must be read explicitly.
- **Cline** — reads `AGENTS.md` and `~/.agents/AGENTS.md`, in addition to `.cline/rules/`.
- **Junie (JetBrains)** — reads `AGENTS.md` at the project root; `.junie/AGENTS.md` takes precedence.
- **Crush (Charm)** — reads `AGENTS.md`, `CRUSH.md`, `CLAUDE.md`, and `GEMINI.md`.
- **GitHub Copilot coding agent** — supports `AGENTS.md`, including nested files. Copilot Chat in the IDE still reads `.github/copilot-instructions.md`, so keep the adapter for that surface.
- **Amp, Augment Code, Devin, Factory, goose, Jules, Kilo Code, Ona, Roo Code, UiPath, Warp, Windsurf, Zed** — listed as `AGENTS.md`-compatible on [agents.md](https://agents.md).
- **Gemini CLI** — reads `GEMINI.md` by default; point it at `AGENTS.md` with `context.fileName` in `.gemini/settings.json`, or keep the `GEMINI.md` adapter below.

Passing `opencode`, `codex`, `crush`, or `junie` to the installer is harmless; it reports that no file is needed.

## Ready adapters

Prebuilt thin adapters are in `.ai/adapters/`. Install them into a project with:

```text
sh .ai/adapters/install.sh [target-dir] [tool...]
```

With no tool names it installs all supported adapters into the target directory (default: the current directory). Example:

```text
sh .ai/adapters/install.sh . claude cursor kiro
```

Supported: `claude`, `cursor`, `kiro`, `cline`, `roo`, `copilot`, `gemini`, `windsurf`, `aider`, `zed`, `qwen`. `opencode`, `codex`, `crush`, and `junie` need no file.

For native readers, the Claude Code, Cursor, Kiro, Cline, Zed, and Windsurf adapters are **optional routing aids**: useful when you prefer a rules file over relying on `AGENTS.md` discovery, or when another instruction file already exists and must import the context.

## Scoped guardrail rules

Rules that apply only to specific paths, materialized per tool:

| Tool | Source | Installed as |
| --- | --- | --- |
| Cursor | `.ai/adapters/cursor-guardrails.mdc` | `.cursor/rules/guardrails.mdc` (scoped by `globs`) |
| Kiro | `.ai/adapters/kiro-guardrails.md` | `.kiro/steering/guardrails.md` (scoped by `fileMatch`) |

See `.ai/GUARDRAILS.md` for the portable policy.

## Plug and play

`.ai/adapters/bootstrap.sh` copies the context, creates the project files when missing, and installs adapters in one step:

```text
sh .ai/adapters/bootstrap.sh ~/my-project claude opencode
```

Then open an agent in the project and say only `Read AGENTS.md`. The agent detects the empty context, analyzes the repository, and fills `.ai/` automatically.

## Mapping

| Tool | Installed file | Source |
| --- | --- | --- |
| Claude Code | `CLAUDE.md` | `.ai/adapters/claude.md` |
| Cursor | `.cursor/rules/agents.mdc` | `.ai/adapters/cursor.mdc` |
| Kiro | `.kiro/steering/agents.md` | `.ai/adapters/kiro.md` |
| Cline | `.cline/rules/agents.md` | `.ai/adapters/cline.md` |
| Roo Code | `.roo/rules/00-agents.md` | `.ai/adapters/roo.md` |
| GitHub Copilot | `.github/copilot-instructions.md` | `.ai/adapters/copilot.md` |
| Gemini CLI | `GEMINI.md` | `.ai/adapters/gemini.md` |
| Windsurf | `.windsurf/rules/agents.md` | `.ai/adapters/windsurf.md` |
| Aider | `.aider.conf.yml` | `.ai/adapters/aider.yml` |
| Zed | `.rules` | `.ai/adapters/zed.md` |
| Qwen Code | `QWEN.md` | `.ai/adapters/qwen.md` |
| OpenCode | none (native `AGENTS.md`) | `.ai/adapters/opencode.md` |
| Codex | none (native `AGENTS.md`) | `.ai/adapters/codex.md` |
| Cursor (guardrails) | `.cursor/rules/guardrails.mdc` | `.ai/adapters/cursor-guardrails.mdc` |
| Kiro (guardrails) | `.kiro/steering/guardrails.md` | `.ai/adapters/kiro-guardrails.md` |

## Rules

- One source of truth: `AGENTS.md` and `.ai/`. Adapters contain no project facts.
- Install adapters only for tools actually in use.
- Adapter paths and formats change between tool versions; verify against the tool's current documentation.

## Notes

- Claude Code: a `CLAUDE.md` containing `@AGENTS.md` wins over the `AGENTS.md` fallback and keeps working on Claude Code versions or providers where the fallback is unavailable.
- Gemini CLI: the upstream recommendation is `{"context": {"fileName": ["AGENTS.md", "GEMINI.md"]}}` in `.gemini/settings.json`; the `GEMINI.md` adapter achieves the same routing without touching settings.
- Cursor: project rules use `.cursor/rules/*.mdc` with `description`/`globs`/`alwaysApply`; `AGENTS.md` is also read from the root and subdirectories.
- Kiro: steering lives in `.kiro/steering/` with inclusion modes (`always`, `fileMatch`, `manual`, `auto`); `AGENTS.md` is also read from the root, `~/.kiro/steering/`, and subdirectories. Kiro CLI does not support inclusion modes and loads all steering files.
- Do not add adapters for tools with no living user base: Amazon Q Developer was replaced by Kiro (end of support 2027-04-30), and Continue stopped development in June 2026. Kiro reads `AGENTS.md` natively, so it needs no replacement adapter.
