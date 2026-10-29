# Roadmap

Maintenance backlog for the template itself. The approved items were split into **two waves**, both shipped in `v0.7.0`; only R-8 remains open. Items keep stable IDs so they can be cited from commits and handoffs.

Each item is independent and ships as its own focused change, with `make lint` and `make test` passing.

Status: `planned`, `in progress`, `done`, `needs decision`.

| ID | Item | Wave | Effort | Status |
| --- | --- | --- | --- | --- |
| R-1 | Link checking in CI | 1 | low | done |
| R-3 | Gemini CLI adapter via `.gemini/settings.json` | 1 | low | done |
| R-4 | Verification date per tool in `.ai/ADAPTERS.md` | 1 | low | done |
| R-6 | Pin CI actions by commit SHA | 1 | low | done |
| R-2 | Harder guardrail patterns and a Kiro hook | 2 | medium | done |
| R-5 | Complete `examples/hello-service` | 2 | medium | done |
| R-7 | Release `v0.7.0` | 2 | low | done |
| R-8 | Translate the docs | 2 | medium | needs decision |

## Wave 1 — Hygiene and additive adapters

**Goal:** make CI catch its own breakage and add options that change nothing for existing adopters.

**Why first:** R-1 and R-6 harden the pipeline that must stay green while wave 2 changes scripts and docs. R-3 and R-4 are additive and can be verified by the same checks.

**Exit criteria:** the CI checks internal links, all actions are pinned, `.ai/ADAPTERS.md` carries verification dates, and the Gemini settings adapter follows the no-overwrite rule.

## Wave 2 — Enforcement, examples, release

**Goal:** change what agents are allowed to do, make the example copyable, and cut a release.

**Why second:** R-2 modifies enforced hooks, so it should land after the pipeline is trustworthy. R-5 is the largest diff. R-7 closes the wave by releasing everything the two waves accumulated, and R-8 is the only item that can be dropped without affecting the others.

## Wave 1 details

### R-1 — Link checking in CI

A broken internal link already shipped once (`.ai/adapters/ADAPTERS.md`), and external tool documentation moves often. Add a checker such as `lychee` to `.github/workflows/lint.yml` for `**/*.md`.

- Done when: internal links resolve and dead external links fail the job; allow an ignore list for known-flaky hosts.
- Risk: rate limits and transient failures on external URLs; consider checking internal links only on pull requests.

### R-3 — Gemini CLI adapter via `.gemini/settings.json`

Upstream recommends pointing Gemini CLI at `AGENTS.md` with `context.fileName` instead of a `GEMINI.md` shim. Add an optional adapter that writes `.gemini/settings.json` (`["AGENTS.md", "GEMINI.md"]`), keeping the existing `GEMINI.md` adapter for projects that prefer no settings file.

- Enforce the same no-overwrite rule: merge, never replace, an existing settings file.

### R-4 — Verification date per tool in `.ai/ADAPTERS.md`

The native-reader list says "at the time of writing" without a date, so staleness is invisible. Add `verified: YYYY-MM-DD` per row or per section, and re-verify on each release.

### R-6 — Pin CI actions by commit SHA

The workflows use floating or major-version refs (`ludeeus/action-shellcheck@master`, `actions/checkout@v4`). Pin by SHA, ideally with `dependabot.yml` updating them. This matters because the repository ships scripts that run on other people's machines.

## Wave 2 details

### R-2 — Harder guardrail patterns and a Kiro hook

`.ai/adapters/hooks/claude-code/guardrails.sh` and `.ai/adapters/hooks/opencode/guardrails.js` currently block a short list (`rm -rf`, force push, `terraform`/`tofu` apply-destroy, `kubectl apply|delete`) and secret edits. Missing: `git reset --hard`, `docker system prune`, destructive SQL, and secret reads such as `cat .env` or `cat ~/.aws/credentials`.

- Keep both implementations in parity, since they encode the same policy.
- Add a Kiro hook script: Kiro has its own hook system, documented in `docs/harness-integration.md`, but no script ships yet.
- Done when: the patterns match `.ai/GUARDRAILS.md`, both enforced targets behave the same, and a manual test per pattern is recorded.

### R-5 — Complete `examples/hello-service`

The example ships `PROJECT`, `ARCHITECTURE`, `CONVENTIONS`, and `HANDOFF` only. Add `TASKS.md`, `LEARNINGS.md`, a filled `.ai/` (including the Resume block and one ADR), and a note showing an installed adapter.

- Done when: the example can be copied as a complete, non-placeholder context.

### R-7 — Release `v0.7.0`

`CHANGELOG.md` accumulates a bug fix (`install.sh` overwriting files), a behavior change (`bootstrap.sh` keeping `.ai/adapters/`), and new CI coverage. Decide whether that is `0.7.0` or `0.6.2`, add the date, tag it, and publish release notes.

- Natural closing step of wave 2, after R-2 and R-5 land.

### R-8 — Translate the docs

The relay is English-only by the recorded annotation choice. If there is a real pt-BR audience, mirror `adoption.md` and `design.md` under `docs/pt-BR/`; otherwise leave it out, since translation doubles maintenance.

- Drop without impact on the other items if the audience does not exist.
