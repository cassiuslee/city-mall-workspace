# Project Rules

## Workspace Structure

- `city-mall-web/` contains the frontend source code
- `api-docs/` contains API documentation and OpenAPI files
- `city-mall-api/` contains the Spring Boot 3 backend project
- `docs/` contains analysis docs, ER diagrams, and mapping results
- `prompts/` contains reusable prompts

## Backend Stack

- Java 17
- Spring Boot 3.0.4
- Spring Security
- sa-token 1.34.0
- MySQL 8
- Flyway
- MyBatis-Plus 3.5.3.1
- springdoc 2.0.0
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
  - `id`
  - `create_time`
  - `update_time`
  - `deleted`
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

## Output Requirements

- Always write analysis results into `docs/`
- Always create SQL/Flyway files before generating repository and service code
- Generate backend incrementally by domain: home, category, product, auth, address, cart, order, payment
- Before modifying code, summarize the plan

# Agent Repo Guide

This file is the practical operating guide for coding agents in this workspace.
Use repo evidence first, then act.

## Current Workspace Reality

- Active implementation today is `city-mall-web/` (uni-app Vue 3 + TypeScript frontend).
- `api-docs/` and `docs/` are present and used for analysis and contract reference.
- `prompts/` is present for reusable prompts.
- `city-mall-api/` is referenced in docs and README as a planned backend, but backend code is not implemented yet.
- There is currently no runnable Spring Boot module, no Maven wrapper, and no Gradle wrapper in this workspace.

## Workspace Layout

- `city-mall-web/`: frontend source, lint/typecheck/build scripts, husky hooks.
- `api-docs/`: exported API documents (source of backend contract expectations).
- `docs/`: analysis output, ER notes, mapping docs.
- `prompts/`: prompt assets.
- `.sisyphus/`: orchestrator planning/notepad artifacts.

## Source of Truth Priority

When sources conflict, use this order:

1. Existing frontend behavior in `city-mall-web/src/**`
2. Frontend service contracts in `city-mall-web/src/services/**`
3. API docs in `api-docs/**`
4. Historical notes in `docs/**`

## Package Manager and Command Conventions

- `city-mall-web/package.json` defines all active scripts.
- `pnpm-lock.yaml` indicates pnpm is available.
- Husky hook calls npm from workspace root with `--prefix`.
- Safe default for agents: run commands from workspace root using explicit frontend path prefix.

Install dependencies:

- npm: `npm --prefix city-mall-web install`
- pnpm: `pnpm --dir city-mall-web install`

## Frontend Dev Commands (`city-mall-web`)

Common development:

- WeChat mini program dev: `npm --prefix city-mall-web run dev:mp-weixin`
- H5 dev: `npm --prefix city-mall-web run dev:h5`
- Custom platform dev: `npm --prefix city-mall-web run dev:custom -- <platform>`

Build commands:

- H5 build: `npm --prefix city-mall-web run build:h5`
- WeChat mini program build: `npm --prefix city-mall-web run build:mp-weixin`
- App build: `npm --prefix city-mall-web run build:app`

Quality gates:

- Type check: `npm --prefix city-mall-web run tsc`
- Lint and auto-fix: `npm --prefix city-mall-web run lint`

## Git Hook Behavior

- Hook file: `city-mall-web/.husky/pre-commit`.
- Hook executes: `npm --prefix city-mall-web run lint-staged`.
- This is intentionally root-compatible; do not rewrite hook commands to assume cwd is `city-mall-web`.
- `lint-staged` currently runs `eslint --fix` for `*.{js,ts,vue}`.

## Testing Reality (Current)

- There is no dedicated unit/integration test runner configured in this repository right now.
- No `test` script exists in `city-mall-web/package.json`.
- Do not claim Jest/Vitest/Cypress coverage unless added later.

Use these substitutes for changed-surface validation:

- Targeted lint (single file):
  - `npm --prefix city-mall-web exec eslint src/path/to/file.ts --fix`
  - `npm --prefix city-mall-web exec eslint src/path/to/file.vue --fix`
- Full lint before handoff: `npm --prefix city-mall-web run lint`
- Full type check before handoff: `npm --prefix city-mall-web run tsc`
- Run the smallest relevant dev/build command for the touched area when runtime behavior changes.

## Code Style and Patterns (Repo-Grounded)

Formatting and linting (from ESLint/Prettier config):

- Single quotes.
- No semicolons.
- Print width 100.
- Trailing commas: `all`.
- End of line: `auto`.

TypeScript and imports:

- Use path alias `@/` for `src` imports (configured in `tsconfig.json`).
- Prefer `import type` for type-only imports.
- Keep request/response types explicit in service and store layers.

Vue and uni-app patterns:

- Use Composition API with `<script setup lang="ts">` in Vue SFCs.
- Keep page data in `ref(...)` and load via `onLoad` when page-driven.
- Register Pinia in app bootstrap (`src/main.ts`).

Service layer patterns:

- Services live under `src/services/**`.
- Naming pattern is verb+domain+`API` (for example `getHomeBannerAPI`).
- Use typed `http<T>(...)` wrapper from `src/utils/http.ts`.

Store patterns:

- Use `defineStore` composition style (`src/stores/modules/member.ts`).
- Expose state plus explicit setter/clearer actions.
- Persist member data via uni storage adapter in store config.

Error handling and auth behavior:

- User-facing request errors use `uni.showToast`.
- Network failures show toast feedback.
- `401` in `http.ts` clears member profile and redirects to `/pages/login/login`.
- Preserve this auth flow unless intentionally redesigning it.

## Backend Planning Constraints (Preserved Guidance)

These rules apply when backend implementation starts:

- Analyze frontend first, then reconcile with API docs.
- All APIs should use unified wrapper `ApiResult`.
- Controllers should not expose entity objects directly; use DTO/VO/Query models.
- Every schema change must include a Flyway migration.
- Table baseline fields: `id`, `create_time`, `update_time`, `deleted`.
- Prefer frontend-observed fields over stale doc fields when conflicts exist.
- Implement backend incrementally by domain: home, category, product, auth, address, cart, order, payment.
- Always write analysis outputs to `docs/`.
- Before modifying code, state a short execution plan.

## Cursor/Copilot Rules Status

- `.cursor/rules/**`: none found.
- `.cursorrules`: none found.
- `.github/copilot-instructions.md`: none found.
- Until such files exist, follow this `AGENTS.md` and direct repo evidence.

## Do / Don't for Agents

Do:

- Keep changes scoped to the requested files and module boundaries.
- Validate with lint + typecheck for touched frontend code.
- Reference concrete file evidence when documenting constraints.
- Keep docs aligned with actual scripts and existing structure.

Don't:

- Do not invent backend build/test commands that are not present.
- Do not claim backend services are implemented today.
- Do not introduce non-repo style rules or generic boilerplate guidance.
- Do not skip stating verification limits when no test runner exists.
