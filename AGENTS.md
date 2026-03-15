# Project Rules

## Workspace Structure

- `city-mall-web/` contains the frontend source code
- `api-docs/` contains API documentation and OpenAPI files
- `city-mall-api/` contains the Spring Boot 3 backend project
- `prompts/` contains reusable prompts

## Backend Stack

- Java 17
- Spring Boot 3.0.4
- Spring Security web 3.0.4
- sa-token 1.34.0
- MySQL 8
- Flyway
- MyBatisPlus 3.5.3.1
- spring-doc 2.0.0
- jakarta-validation
- redisson 3.19.3
- hikari 5.0.1
- logback 1.4.5  
- lombok
- hutool 5.8.15
- knife4j 4.0.0

## Coding Rules

- All APIs use unified response wrapper `ApiResult`
- Controller must not directly expose entity objects
- Must create DTO / VO / Query classes
- Every schema change must generate Flyway migration
- All tables include:
  - id
  - create_time
  - update_time
  - deleted
- Prefer aligning API fields with frontend request/response structure
- Prioritize actual frontend usage over outdated API docs when conflicts exist

## Workflow

1. Analyze frontend first
2. Compare with API docs
3. Design database schema
4. Generate Flyway migrations
5. Generate backend module one by one
6. Align request/response contract with frontend
7. Add validation and OpenAPI annotations
