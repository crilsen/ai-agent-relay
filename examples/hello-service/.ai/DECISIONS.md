# Decision Records

Mode: simple — entries live inline in this file.

## Index

| ID | Type | Title | Status | Date |
| --- | --- | --- | --- | --- |
| TDR-001 | TDR | FastAPI for the HTTP layer | Accepted | 2026-09-18 |

## TDR-001 — FastAPI for the HTTP layer

Type: TDR
Status: Accepted
Date: 2026-09-18
Owners: hello-service maintainers
Supersedes: none

Context:
The service exposes two JSON endpoints and needs validation, generated documentation, and a small dependency surface. The team already runs Python 3.12 services with type checking in strict mode.

Decision:
Use FastAPI served by Uvicorn, with Pydantic models as response types.

Reasoning:
FastAPI provides request validation, OpenAPI output, and async handlers without a hand-written router or serialization layer. Pydantic keeps responses typed, which `mypy` can verify under the existing convention of returning models rather than dicts.

Consequences:

- Handlers are `async` and return Pydantic models.
- Validation errors surface as 422 by default; endpoints that need 400 must map them explicitly.
- The container runs Uvicorn directly, with no ASGI server abstraction on top.
