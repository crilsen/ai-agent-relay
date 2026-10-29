# Project

## Identity

- **Name:** hello-service
- **Objective:** Minimal HTTP service that returns a greeting and a health check.
- **Repository purpose:** Example project for ai-agent-relay.
- **Status:** Illustrative example, not a real application.

## Observed

- Language: Python 3.12, packaged with `pyproject.toml`.
- Framework: FastAPI, served with Uvicorn.
- Tests: `pytest` under `tests/`.
- Container: single-stage `Dockerfile`, exposed on port 8080.
- CI: GitHub Actions running lint and tests on pull requests.
- Configuration via environment variables; no secrets in the repository.

## Template priorities

- Keep documentation concise and evidence-based.
- Prefer small, reviewable changes.
