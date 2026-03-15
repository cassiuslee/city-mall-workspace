---
description: Generate one backend module from docs
---

Generate one backend module under `city-mall-api` based on frontend analysis and API docs.

Process:

1. Create backend design doc first
2. Create SQL tables and Flyway migration
3. Create entity/DTO/VO/Query/Mapper/Service/Controller
4. Add validation and OpenAPI annotations
5. Ensure `ApiResult` unified response

Ask which module to generate if not specified.
Supported modules:

- home
- category
- product
- auth
- address
- cart
- order
- payment
