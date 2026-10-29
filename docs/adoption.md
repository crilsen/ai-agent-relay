# Adoption Guide

Step-by-step instructions to embed ai-agent-relay into an existing project, plus how to keep it healthy afterward. The template lives at [github.com/crilsen/ai-agent-relay](https://github.com/crilsen/ai-agent-relay); check upstream for updates instead of copying context between projects.

For the concepts and why the files exist, see [README](../README.md) and [design.md](design.md).

## Before you start

- Decide the decision-record mode: **simple** (entries inline in `.ai/DECISIONS.md`) or **scale** (one file per record under `docs/decisions/`).
- Know which tools and harnesses you actually use, so you install only the adapters you need.
- Do not adopt into a dirty working tree without committing first.

## Copy the context

Option A, manual:

```bash
cp -R /path/to/ai-agent-relay/AGENTS.md /path/to/ai-agent-relay/.ai /path/to/your-project/
```

Option B, bootstrap (copies files, creates `README.md` and `.gitignore` if missing, installs adapters):

```bash
sh .ai/adapters/bootstrap.sh /path/to/your-project claude opencode cursor
```

Use the tool list that matches your setup. Codex, OpenCode, Cursor, Kiro, Claude Code (v2.1.277+), Cline, Junie, and Crush need no adapter.

## Fill the context

Open an agent in the project and say only:

```text
Read AGENTS.md
```

Because `.ai/` is still empty, the agent enters the plug-and-play bootstrap: it explores the repository and fills `PROJECT.md`, `ARCHITECTURE.md`, `CONVENTIONS.md`, `VALIDATION.md`, `TOOLS.md`, `TASKS.md`, and the Resume block in `HANDOFF.md` with observed facts. It then asks once whether you want to maintain context manually or automatically, and always asks for annotations (default English) whether to keep English or change to another language, and to which one.

If your tool does not read `AGENTS.md` automatically, install its adapter first:

```bash
sh .ai/adapters/install.sh . claude
```

## Merging into a project that already has files

- If `AGENTS.md` already exists, merge by hand. Keep your existing instructions and add the router behavior from this template; do not overwrite.
- If the project has a `README.md`, leave it as the project's README. `.ai/PROJECT.md` is an agent-oriented overview, not a replacement.
- Remove or ignore the optional infrastructure workflows (`terraform-change`, `kubernetes-change`, `cloud-port`) if those technologies are not present.

## Verify

- `.ai/` no longer contains `Unknown / not determined from repository` except where genuinely unknown.
- `.ai/VALIDATION.md` lists the project's real commands.
- `HANDOFF.md` has a filled Resume block.
- `.ai/DECISIONS.md` states the chosen mode.
- The Resume prompt works in a second agent:

```text
Read AGENTS.md and .ai/HANDOFF.md. Continue from the Resume block. Do not rediscover context.
```

## Commit

Commit the context with the project so it travels across tools and machines:

```bash
git add AGENTS.md .ai
git commit -m "Add portable agent context"
```

## Keep it healthy

- Update the Resume block after meaningful steps; follow `.ai/LIMITS.md`.
- Promote durable learnings out of `.ai/LEARNINGS.md` into conventions, decisions, tools, or validation.
- Compact `.ai/LEARNINGS.md` at 40 active entries.
- Add adapters only for tools you actually use; keep them thin.
- Re-check adapters and hook paths after upgrading a tool, since their formats change.

## Troubleshooting

- **Agent ignores the context:** confirm the tool reads `AGENTS.md`, or install the adapter listed in [`.ai/ADAPTERS.md`](../.ai/ADAPTERS.md) and restart the tool.
- **Adoption did not run:** make sure `.ai/` still has placeholders or an empty Resume block; that is what triggers the bootstrap.
- **Two agents overwrite context:** enforce the concurrency rule: only the primary agent writes `HANDOFF.md`, `TASKS.md`, and `LEARNINGS.md`.
- **Context has grown noisy:** compact `LEARNINGS.md` and move durable facts to their home files.
