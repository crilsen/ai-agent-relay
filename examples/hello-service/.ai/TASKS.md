# Current Work

## Active

- Finish the `GET /hello/{name}` endpoint: add the space-in-name test and validate input (see `.ai/HANDOFF.md`).

## Planned

- Map missing or empty `name` to 400 instead of FastAPI's default 422.
- Add a container build check to CI.

## Blocked

- None.

## Completed

- Added the route and a Pydantic response model.
- Added the happy-path test in `tests/test_hello.py`.
