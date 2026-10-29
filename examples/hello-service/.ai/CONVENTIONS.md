# Conventions

## Observed

- Python formatted with `ruff format`; linted with `ruff check`.
- Types checked with `mypy` in strict mode.
- Tests use `pytest`, one module per source module under `tests/`.
- Route handlers are `async` and return Pydantic models, not raw dicts.
- Commit messages use the imperative mood, one concern per commit.
- Branch names: `feat/...`, `fix/...`, `chore/...`.

## Validation

- `make lint` runs `ruff check` and `mypy`.
- `make test` runs `pytest`.
- CI must pass before merge.
