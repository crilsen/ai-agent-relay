# Architecture

## Observed

- Single service, no database.
- Entry point `app/main.py` creates the FastAPI application.
- Routes: `GET /health` and `GET /hello/{name}`.
- Configuration read once at startup from environment variables.
- Logs are structured JSON to stdout.
- Deployed as one container behind an external load balancer; no in-repo ingress config.

## Data flow

```text
client → load balancer → container (Uvicorn/FastAPI) → handler → JSON response
```

## Unknown / not determined from repository

- Production hosting platform and region.
- Autoscaling policy and resource limits.
- Observability backend (metrics and traces).
