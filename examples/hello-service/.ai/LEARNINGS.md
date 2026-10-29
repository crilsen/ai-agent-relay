# Learnings

Append-only buffer of reusable, non-obvious learnings for this example project.

## Entries

### L-001 — FastAPI returns 422 for missing path parameters

Date: 2026-09-18
Status: active
Confidence: observed
Scope: app/main.py
Context: Adding `GET /hello/{name}` and deciding how to handle an empty name.
Evidence: Removing the `name` segment made FastAPI answer 422 before the handler ran.
Pattern / rule: Validation failures that never reach the handler default to 422. When the API contract requires 400, add an exception handler rather than checking inside the handler.
Promotion: none
