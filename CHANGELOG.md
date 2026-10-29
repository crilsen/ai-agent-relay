# Changelog

All notable changes to this project are documented here. The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

_None yet._

## [0.7.0] - 2026-10-29

### Added

- Social preview images under `docs/assets/` (1200×630 for GitHub/link cards, plus wide and portrait variants and the SVG source).
- `.ai/ADAPTERS.md` now records the full native `AGENTS.md` roster (Claude Code, Cline, Junie, Crush, DeepSeek Harness, and the [agents.md](https://agents.md) tools) and explains why Amazon Q Developer and Continue get no adapter.
- `docs/prd/` and `docs/decisions/` exist with a short README each, matching the layout the README already documented; both remain empty until a PRD or a scale-mode decision record is written.
- `docs/roadmap.md` records the approved maintenance backlog, split into two waves so it survives across sessions.
- CI gained a `links` job (lychee) and a `test` job (`make test`), plus `.github/dependabot.yml`, so broken links and script regressions fail the build.
- `gemini-settings` adapter writes `.gemini/settings.json` with `context.fileName`, the configuration Gemini CLI documents for reading `AGENTS.md`.
- Kiro hooks in `.ai/adapters/hooks/kiro/`: `SessionStart` routes to `AGENTS.md`, `Stop` triggers the checkpoint, using the Kiro 1.0 `version: "v1"` schema.
- `examples/hello-service` now ships `AGENTS.md` plus a complete `.ai/` (`DECISIONS` with TDR-001, `TASKS`, `LEARNINGS`, `TOOLS`, `VALIDATION`), so the example can be copied as a finished context.

### Changed

- CI actions are pinned by commit SHA, with Dependabot keeping them current.
- `.ai/ADAPTERS.md` records a verification date per tool (2026-09-20 for the original four, 2026-10-29 for the rest) and asks for re-verification on each release.
- Guardrail patterns now also block `git reset --hard`, `git clean -f/-x/-d`, `docker system prune`, `docker volume rm`, `DROP TABLE`, `DROP DATABASE`, `TRUNCATE TABLE`, and secret reads such as `cat .env` or `cat ~/.aws/credentials`; the Claude Code and OpenCode implementations stay in parity.
- `make test` now checks that a second bootstrap run keeps the existing `AGENTS.md` instead of overwriting it.
- `bootstrap.sh` keeps `.ai/adapters/` in the adopted project, so a tool can be added later with the documented `sh .ai/adapters/install.sh . <tool>` command.
- The Cline adapter installs to `.cline/rules/agents.md`, the location Cline's docs lead with; `.clinerules/` remains supported by the tool.
- `install.sh` reports `no adapter needed` for `crush` and `junie`, which read `AGENTS.md` natively.

### Fixed

- `install.sh` no longer overwrites existing files: `CLAUDE.md`, `GEMINI.md`, `.rules`, `.aider.conf.yml`, `.github/copilot-instructions.md`, and rule files are preserved and reported as `kept existing`.
- `docs/adoption.md` pointed to a non-existent `.ai/adapters/ADAPTERS.md`; the catalogue is `.ai/ADAPTERS.md`.

## [0.6.1] - 2026-09-21

### Added

- `docs/design.md` documents two deliberate non-goals: context is curated rather than retrieved (no RAG / embeddings / external index), and the layer records the outcome of reasoning rather than injecting chain-of-thought.

## [0.6.0] - 2026-09-20

### Added

- Optional spec-driven flow: `.ai/SPECS.md` (spec → plan → tasks) with `docs/spec/` and an example spec. It is complementary to spec-driven tools (Spec Kit, Kiro specs), not a replacement, and is used only for large or risky changes.
- `docs/design.md` now documents the spec-driven decision and the learning feedback loop, including how the promotion step differs from harness memory features.

### Changed

- `.ai/workflows/feature.md` gained an optional spec step; `AGENTS.md`, `REQUIREMENTS.md`, `CONVENTIONS.md`, `adopt.md`, and the README were updated to route to it.

## [0.5.0] - 2026-09-20

### Added

- `.ai/GUARDRAILS.md` — portable policy for allowed, restricted, and authorization-required actions, with advisory, scoped, and enforced levels.
- Scoped guardrail rules: Cursor (`.cursor/rules/guardrails.mdc`, `globs`) and Kiro (`.kiro/steering/guardrails.md`, `fileMatch`).
- Enforcement hooks: Claude Code `PreToolUse` (`guardrails.sh`) and OpenCode `tool.execute.before` (`guardrails.js`) block destructive commands and secret access.

### Fixed

- Corrected adapter guidance: Cursor and Kiro read `AGENTS.md` natively (confirmed against their docs), so their adapters are optional routing aids rather than required.
- OpenCode plugin installer now installs both `relay.js` and `guardrails.js`.

## [0.4.1] - 2026-09-20

### Fixed

- OpenCode integration corrected: OpenCode uses JavaScript/TypeScript plugins (`.opencode/plugins/`), not shell hooks. Replaced the shell hook with `.ai/adapters/hooks/opencode/relay.js` plus `install.sh`, subscribing to `session.idle`.
- Claude Code hooks updated to verified events: `SessionStart`, `Stop`, `SessionEnd` (the previous example used an incorrect session-end name).

## [0.4.0] - 2026-09-20

### Added

- `docs/adoption.md` — step-by-step adoption guide and troubleshooting.
- Tool-specific hook examples: OpenCode (`session-end.sh`) and Claude Code (`hook.sh` + `install.sh` writing `.claude/settings.json`).

## [0.3.0] - 2026-09-20

### Added

- `docs/harness-integration.md` explaining how the context layer composes with hooks, subagents, skills, and MCP.
- Project skill template under `.ai/skills/`.
- Example hooks (`.ai/adapters/hooks/pre-commit.sh`, `session-end.sh`) that trigger the checkpoint workflow.
- MCP/tool registration table in `.ai/TOOLS.md`.

### Changed

- Concurrency rule: only the primary agent writes `HANDOFF.md`, `TASKS.md`, and `LEARNINGS.md`; subagents report back.

## [0.2.0] - 2026-09-20

### Added

- `Makefile` with `make lint` (markdownlint + shellcheck) and `make test` (script tests).
- `examples/hello-service` showing a filled-in context after adoption.
- CI status, license, and AGENTS.md badges in the README.

### Changed

- Renamed the project to **ai-agent-relay**.

## [0.1.0] - 2026-09-20

### Added

- Portable, Git-versioned context layer under `.ai/` with a self-driving `AGENTS.md` entry point.
- Plug-and-play bootstrap: reading `AGENTS.md` makes an agent analyze the repository and fill the context automatically, then ask once whether to update it manually or automatically.
- `.ai/HANDOFF.md` with a Resume block for switching agents, models, providers, or machines.
- Learning loop: `.ai/LEARNINGS.md` with promotion and compaction rules, plus `.ai/workflows/capture-learning.md`.
- Usage-limit safety: `.ai/LIMITS.md` thresholds, `.ai/workflows/checkpoint.md`, and rolling checkpoints.
- Switch-agent protocol: `.ai/workflows/switch-agent.md` and `.ai/ADAPTERS.md`.
- Requirements (PRDs) in `.ai/REQUIREMENTS.md` and `docs/prd/`, with `.ai/workflows/feature.md`.
- Decision records for architecture (ADR) and technology (TDR) in `.ai/DECISIONS.md`, with simple and scale modes (`docs/decisions/`).
- Ready-to-install thin adapters in `.ai/adapters/` for Claude Code, Cursor, Kiro, Cline, Roo Code, GitHub Copilot, Gemini CLI, Windsurf, Aider, Zed, and Qwen Code, plus `install.sh` and `bootstrap.sh`. OpenCode and Codex need no adapter.
- Optional infrastructure workflows: implementation, review, security review, Terraform/OpenTofu change, Kubernetes change, and cloud port.
- `docs/design.md` describing why the template is built this way.
- MIT license.

[Unreleased]: https://github.com/crilsen/ai-agent-relay/compare/v0.7.0...HEAD
[0.7.0]: https://github.com/crilsen/ai-agent-relay/compare/v0.6.1...v0.7.0
[0.6.1]: https://github.com/crilsen/ai-agent-relay/compare/v0.6.0...v0.6.1
[0.6.0]: https://github.com/crilsen/ai-agent-relay/compare/v0.5.0...v0.6.0
[0.5.0]: https://github.com/crilsen/ai-agent-relay/compare/v0.4.1...v0.5.0
[0.4.1]: https://github.com/crilsen/ai-agent-relay/compare/v0.4.0...v0.4.1
[0.4.0]: https://github.com/crilsen/ai-agent-relay/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/crilsen/ai-agent-relay/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/crilsen/ai-agent-relay/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/crilsen/ai-agent-relay/releases/tag/v0.1.0
