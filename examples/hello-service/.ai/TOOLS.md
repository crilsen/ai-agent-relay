# Tools

The rules behind these lists live in the template's `.ai/GUARDRAILS.md`, which this example assumes was copied on adoption.

## Allowed without additional authorization

- Read and search repository files.
- Make scoped task-related edits.
- Run `make lint` (`ruff check`, `mypy`) and `make test` (`pytest`).
- Read-only commands and safe dry runs.

## Requires explicit authorization

- Deployments, container registry pushes, and production changes.
- Secret or credential changes.
- Destructive git operations (`reset --hard`, force push).

## MCP servers and external tools

| Tool or MCP server | Purpose | Allowed | Restricted |
| --- | --- | --- | --- |
| none configured | - | - | - |

Never store endpoints, tokens, or credentials in this file.
