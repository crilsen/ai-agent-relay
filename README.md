# ai-agent-relay

[![lint](https://github.com/crilsen/ai-agent-relay/actions/workflows/lint.yml/badge.svg)](https://github.com/crilsen/ai-agent-relay/actions/workflows/lint.yml)
[![license: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![context: AGENTS.md](https://img.shields.io/badge/context-AGENTS.md-2ea44f.svg)](AGENTS.md)

A portable, Git-versioned context layer for software projects that use coding agents, agentic harnesses, or multiple AI tools over time. Pass the baton between agents, models, providers, and machines without losing context.

Keep project knowledge in the repository instead of a chat history, so any agent can resume work regardless of model, IDE, provider, or computer. Works with Codex, Cursor, Kiro, OpenCode, Claude Code, DeepSeek Harness, Cline, Junie, Crush, Roo Code, and future tools.

Upstream repository: [github.com/crilsen/ai-agent-relay](https://github.com/crilsen/ai-agent-relay) — source, releases, issues, and discussions live there.

> **Use at your own risk.** Provided as is, without warranty. You are responsible for reviewing context before an agent acts on it, for the agent's actions, and for all costs including AI provider usage and token consumption. See [SECURITY.md](SECURITY.md).

## Harness-ready

This template is ready to use in projects built with agentic harnesses. The portable core — `AGENTS.md`, `.ai/`, per-tool adapters, the Resume block, checkpoint/limits, and the switch-agent protocol — applies as-is to a harness project, so an agent running under any harness can pick up the context without extra setup.

It composes with harness features instead of replacing them: hooks trigger the checkpoint and handoff, subagents read the same context, skills can live under `.ai/skills/`, and MCP tools are registered in `.ai/TOOLS.md`. See [docs/harness-integration.md](docs/harness-integration.md).

Note what it is: the template is the portable context layer that a harness reads, not a harness itself. It carries no runtime.

The bundled infrastructure workflows (`terraform-change`, `kubernetes-change`, `cloud-port`) are optional; a harness or application project can ignore or remove them during adoption.

## Why this exists

Projects lose working context when a conversation ends, an agent changes, or work moves to another machine. This template provides a small, maintainable source of truth for:

- project purpose and real architecture;
- conventions and durable architectural decisions;
- product requirements (PRDs) and technical decisions (ADR/TDR), kept separate and scale-ready;
- current work and operational session handoff;
- reusable learnings captured during work and promoted into conventions, decisions, or tooling rules;
- safe tool usage and completion criteria;
- usage-limit checkpoints so switching agents is routine, not a rescue;
- repeatable implementation, review, security, IaC, Kubernetes, and cloud-port workflows.

## What it is / is not

- It is a set of small Markdown files that travel with your repository.
- It is not a framework, dependency, or service; nothing to install or run.
- It is not a chat-history dump; files stay concise and current.
- It does not store secrets; never commit credentials.

## Quickstart (plug and play)

1. Copy `AGENTS.md` and `.ai/` into the root of your project.

```bash
cp -R /path/to/ai-agent-relay/AGENTS.md /path/to/ai-agent-relay/.ai /path/to/your-project/
```

1. Optionally install the adapter for your tool. Codex, OpenCode, Cursor, Kiro, Claude Code (v2.1.277+), Cline, Junie, and Crush read `AGENTS.md` natively and need none; adapters exist for tools that do not.

```bash
sh /path/to/your-project/.ai/adapters/install.sh . claude opencode
```

1. Point any agent at `AGENTS.md`. That is all: on first read it detects the empty context, **analyzes the repository automatically**, and fills `.ai/` for you.

```text
Read AGENTS.md
```

1. Commit the context with the project so it travels across tools and computers.

On adoption the agent asks whether you want to add durable context manually or have the agent keep it updated automatically, and always asks for annotations (default English) whether to keep English or change to another language, and to which one. The initialization also creates `README.md` and `.gitignore` when missing. To run the copy and adapter steps in one command, use `.ai/adapters/bootstrap.sh`.

## How it works

`AGENTS.md` is the universal entry point and is self-driving: reading it tells an agent how to load context, detect whether the project needs adoption, resuming, implementation, or review, and what to do afterward. It routes the agent to the relevant files in `.ai/`, which remains the portable source of truth. The user only needs to say "read AGENTS.md".

```text
Tool-specific adapter (optional)
            ↓
        AGENTS.md
            ↓
          .ai/
```

Tool-specific files are thin adapters that only direct the tool to `AGENTS.md`; they never duplicate project context. Adapters live in `.ai/adapters/` and are catalogued in `.ai/ADAPTERS.md`.

## Using it across agents and providers

The context lives in the repository, so you can switch agents, models, or providers at any time, including when one provider's usage limit is reached:

1. Before switching, follow `.ai/workflows/switch-agent.md` and fill the Resume block in `.ai/HANDOFF.md`.
2. Commit and push work in progress, or list uncommitted files in `HANDOFF.md`, because a different machine or cloud agent only sees committed files.
3. In the next agent, paste: `Read AGENTS.md and .ai/HANDOFF.md. Continue from the Resume block. Do not rediscover context.`
4. If the tool does not read `AGENTS.md` automatically, install its adapter from `.ai/adapters/`.

`AGENTS.md` stays small and `.ai/` is read on demand, so agents with lower context windows or tighter limits can still resume safely.

`.ai/LIMITS.md` defines the checkpoint policy: the agent keeps the Resume block current, warns as usage approaches 70% of the budget, and finalizes the handoff before the limit is reached.

## Requirements and decisions

Product scope and technical choices are tracked separately:

- **Requirements (PRDs)** live under `docs/prd/` and are indexed by `.ai/REQUIREMENTS.md`, with a lifecycle of `Draft → Approved → Implemented → Superseded`. Only an Approved PRD drives implementation, through `.ai/workflows/feature.md`.
- **Specs (optional)** live under `docs/spec/` and are indexed by `.ai/SPECS.md`. When a change is large enough that the plan should be reviewed before code, the spec-driven flow produces design, plan, and ordered tasks. This is complementary to spec-driven tools, not a replacement; use it only when it earns its keep.
- **Decisions (ADR/TDR)** live in `.ai/DECISIONS.md`. Adoption picks **simple mode** (entries inline, for small projects) or **scale mode** (one file per record under `docs/decisions/`, with `DECISIONS.md` as the index). ADR covers architecture; TDR covers technology choices.

## Repository layout

```text
AGENTS.md                    # Self-driving agent entry point and context router
CHANGELOG.md
CODE_OF_CONDUCT.md
CONTRIBUTING.md
LICENSE
Makefile                     # make lint / make test
README.md
SECURITY.md
examples/                    # Sample adopted context (hello-service)
docs/
├── design.md                # Why this template is built this way
├── adoption.md              # Step-by-step adoption guide
├── harness-integration.md   # How it composes with hooks, subagents, skills, MCP
├── assets/                  # Social preview images
├── prd/                     # Product requirement documents (PRDs)
├── spec/                    # Optional specs (spec-driven flow)
└── decisions/               # ADR/TDR files (scale mode)
.ai/
├── PROJECT.md               # Project overview
├── ARCHITECTURE.md          # Observed architecture
├── CONVENTIONS.md           # Existing and recommended conventions
├── DECISIONS.md             # ADR/TDR decision records (simple or scale)
├── GUARDRAILS.md            # Portable policy for allowed and restricted actions
├── REQUIREMENTS.md          # PRD index and format
├── SPECS.md                 # Optional spec-driven flow (spec → plan → tasks)
├── TASKS.md                 # Current work state
├── HANDOFF.md               # Operational session handoff (Resume block)
├── LEARNINGS.md             # Append-only buffer of reusable learnings
├── ADAPTERS.md              # Adapter catalogue and mapping
├── LIMITS.md                # Usage-limit thresholds and checkpoint policy
├── TOOLS.md                 # Safe and restricted tool usage
├── VALIDATION.md            # Completion and validation criteria
├── skills/                  # Project skill template and examples
├── adapters/                # Ready-to-install thin adapters, install.sh, bootstrap.sh
├── workflows/               # Task-specific operating procedures
└── prompts/                 # Reusable task prompts
```

## Safety model

Agents may explore the repository, make scoped edits, and run safe validation. Deployments, destructive commands, real-cluster changes, secret changes, paid-resource creation, and other externally impactful operations require explicit authorization.

Context files are instructions read by an agent, so treat them as untrusted input until reviewed. [SECURITY.md](SECURITY.md) covers prompt injection, the risks you accept when using this template, and how to report a vulnerability.

## License

[MIT](LICENSE).

See [CHANGELOG.md](CHANGELOG.md) for release history and [CONTRIBUTING.md](CONTRIBUTING.md) to contribute.

This project is not affiliated with or endorsed by any of the tools it references; tool names are trademarks of their respective owners.
