# Frontend Scan Skill

## Goal

Analyze `city-mall-web` and extract backend requirements from actual frontend usage.

## Steps

1. Scan `src/services`, `src/pages`, `src/pagesMember`, `src/pagesOrder`, `src/stores`, and `src/types`.
2. Identify all request functions, request URLs, methods, params, payloads, and response structures.
3. Map each request to actual page usage.
4. Detect which APIs are really used by frontend and which fields are actually rendered.
5. Output markdown files into `docs/frontend-analysis/`:
   - `api-list.md`
   - `page-api-mapping.md`
   - `field-usage.md`
   - `missing-api.md`

## Rules

- Prefer actual frontend code over README examples.
- Capture both request shape and expected response shape.
- Group endpoints by domain: home, category, product, auth, address, cart, order, payment.
