# Validation

Before considering work complete, run the applicable checks and report each as **Validated**, **Partially validated**, or **Not validated** with the reason.

## Checks

1. `make lint` — `ruff check` and `mypy` in strict mode.
2. `make test` — `pytest` for the modules touched.
3. Manual check for the endpoint under change, when behavior is not covered by a test.

## Completion criteria

- Lint and tests pass locally.
- CI passes on the pull request.
- `.ai/HANDOFF.md` Resume block reflects the current state.
