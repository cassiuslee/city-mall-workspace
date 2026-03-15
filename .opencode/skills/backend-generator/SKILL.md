# Backend Generator Skill

## Goal

Generate Spring Boot 3 backend modules in `city-mall-api` from frontend analysis and API docs.

## Steps

1. Read `docs/frontend-analysis/*`
2. Read `api-docs/index.md`, `api-docs/llms.txt`, and markdown files under `api-docs/apifox-md/`
3. Compare frontend usage with API docs
4. Produce `docs/backend-design/<module>.md`
5. Produce SQL schema and Flyway migrations first
6. Then generate entities, DTOs, VOs, Query classes, mapper, service, controller
7. Add validation and OpenAPI annotations
8. Ensure all controllers return `ApiResult`

## Rules

- Prefer compatibility with frontend request/response structures
- If API docs conflict with actual frontend usage, follow frontend and note the difference in docs
- Do not generate all modules at once
- Work one module at a time
