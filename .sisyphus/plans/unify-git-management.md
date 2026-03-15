# Unify Git Management (Remove Nested Repo)

## TL;DR
> **Summary**: Remove the nested Git repo at `city-mall-web/.git` and make `city-mall-workspace/` the only Git repository.
> **Deliverables**: Nested `.git` removed, root repo initialized + initial commit on `main`, root `.gitignore`, reproducible pre-commit hook setup.
> **Effort**: Short
> **Parallel**: YES - 2 waves
> **Critical Path**: Backup nested repo -> remove `city-mall-web/.git` -> root ignore + hook wiring -> initial root commit

## Context
### Original Request
1. Remove the Git repository inside `city-mall-web/`.
2. Use a single Git repository rooted at `city-mall-workspace/` to manage everything.

### Interview Summary (decisions)
- History: discard `city-mall-web` Git history (but create a safety backup bundle before deletion).
- Pre-commit: keep enforcing the existing behavior (lint-staged + ESLint fixes).
- Branch: root default branch is `main`.
- Hook onboarding: acceptable to require a one-time setup command per clone (git config is not versioned).

### Metis Review (gaps addressed)
- Added explicit branch naming decision (`main`).
- Added guardrails for Windows hook execution and deterministic verification.
- Added a tracked setup script so hook configuration is reproducible.

## Work Objectives
### Core Objective
- A single Git repository at workspace root manages `city-mall-web/` (and any future folders) with no nested `.git` directories.

### Deliverables
- `city-mall-web/.git` removed.
- Root `.gitignore` added to prevent committing generated/vendor artifacts.
- Root repo has an initial commit on branch `main`.
- Pre-commit linting works again for the root repo by running `city-mall-web`'s existing `lint-staged`.
- Tracked hook setup scripts exist (Windows + POSIX).

### Definition of Done (verifiable)
- `city-mall-web/.git` does not exist.
- From repo root: `git rev-parse --is-inside-work-tree` returns `true`.
- From repo root: `git rev-parse HEAD` succeeds.
- From repo root: `git branch --show-current` returns `main`.
- From repo root: `git status --porcelain` does not list any `node_modules/` or `dist/` paths.
- From repo root: `npm --prefix city-mall-web run lint-staged` succeeds on a clean tree.
- After setup: `git config --get core.hooksPath` equals `city-mall-web/.husky`.

### Must NOT Have (guardrails)
- Do NOT keep `city-mall-web/` as a separate Git repo or submodule.
- Do NOT rewrite or import `city-mall-web` history into root.
- Do NOT commit `city-mall-web/node_modules/` or other build outputs.
- Do NOT introduce new lint/test tools.

## Verification Strategy
> All verification is agent-executed via commands; no manual steps.
- Topology checks: filesystem existence + `git` commands.
- Ignore checks: ensure artifacts do not appear in `git status` output.
- Hook checks: run the hook script directly from repo root.
- Evidence saved under `.sisyphus/evidence/`.

## Execution Strategy
### Parallel Execution Waves
Wave 1 (safety + prep)
- T1: backup nested git metadata
- T2: add root `.gitignore`
- T3: update pre-commit hook to run lint-staged from root

Wave 2 (switch + root repo + verification)
- T4: remove `city-mall-web/.git`, init root commit on `main`
- T5: add tracked hook setup scripts + document one-time setup

### Dependency Matrix
- T1 blocks T4
- T2 blocks T4
- T3 blocks T5
- T4 blocks T5

## TODOs

- [x] 1. Backup `city-mall-web` git metadata (safety net)

  **What to do**:
  - Create a backup artifact before deletion.
  - Preferred: git bundle of the nested repo.

  **Must NOT do**:
  - Do not delete `city-mall-web/.git` yet.

  **Recommended Agent Profile**:
  - Category: `unspecified-low`
  - Skills: []

  **Parallelization**: Can Parallel: NO | Wave 1 | Blocks: [4] | Blocked By: []

  **References**:
  - Nested repo: `city-mall-web/.git/`

  **Acceptance Criteria**:
  - [ ] `.sisyphus/evidence/city-mall-web-git-backup.bundle` exists and is non-empty.

  **QA Scenarios**:
  ```
  Scenario: Create backup bundle
    Tool: Bash
    Steps:
      1) git -C city-mall-web bundle create ..\\.sisyphus\\evidence\\city-mall-web-git-backup.bundle --all
      2) verify file exists and is non-empty
    Expected: backup bundle created
    Evidence: .sisyphus/evidence/city-mall-web-git-backup.bundle
  ```

  **Commit**: NO

- [ ] 2. Add root `.gitignore` (prevent committing artifacts)

  **What to do**:
  - Create `./.gitignore` at workspace root.
  - Include at least:
    - `**/node_modules/`
    - `**/dist/`
    - `**/logs/` and `*.log`
    - `.DS_Store`
    - `*.local`
    - `city-mall-web/unpackage/`
    - `city-mall-web/.hbuilderx/`

  **Must NOT do**:
  - Do not ignore source directories.

  **Recommended Agent Profile**:
  - Category: `quick`
  - Skills: []

  **Parallelization**: Can Parallel: YES | Wave 1 | Blocks: [4] | Blocked By: []

  **References**:
  - Existing ignores: `city-mall-web/.gitignore`

  **Acceptance Criteria**:
  - [ ] Root `.gitignore` exists and contains the required patterns.

  **QA Scenarios**:
  ```
  Scenario: Ignore rules are effective
    Tool: Bash
    Steps:
      1) git status --porcelain
    Expected: no `node_modules/` or `dist/` paths appear in status output
    Evidence: .sisyphus/evidence/task-2-status.txt
  ```

  **Commit**: NO (committed in Task 4)

- [x] 3. Update pre-commit hook to run lint-staged from root

  **What to do**:
  - Edit `city-mall-web/.husky/pre-commit` so it runs lint-staged against the frontend folder even when executed from workspace root.
  - Replace `npm run lint-staged` with:
    - `npm --prefix city-mall-web run lint-staged`

  **Must NOT do**:
  - Do not change which checks run (still lint-staged).

  **Recommended Agent Profile**:
  - Category: `quick`
  - Skills: []

  **Parallelization**: Can Parallel: YES | Wave 1 | Blocks: [5] | Blocked By: []

  **References**:
  - Hook: `city-mall-web/.husky/pre-commit`
  - Lint-staged config: `city-mall-web/package.json`

  **Acceptance Criteria**:
  - [ ] `npm --prefix city-mall-web run lint-staged` succeeds from repo root on a clean tree.

  **QA Scenarios**:
  ```
  Scenario: Hook runs from repo root
    Tool: Bash
    Steps:
      1) npm --prefix city-mall-web run lint-staged
    Expected: exit code 0
    Evidence: .sisyphus/evidence/task-3-precommit-ok.txt
  ```

  **Commit**: NO (committed in Task 4)

- [ ] 4. Remove nested git repo and create initial root commit on `main`

  **What to do**:
  - Delete `city-mall-web/.git/`.
  - Ensure the workspace root repo has an initial commit and branch is `main`.
    - If this root repo was already initialized without commits, create the first commit.
    - If it starts on `master`, rename to `main` before/after the first commit.

  **Must NOT do**:
  - Do not delete frontend files.

  **Recommended Agent Profile**:
  - Category: `unspecified-low`
  - Skills: []

  **Parallelization**: Can Parallel: NO | Wave 2 | Blocks: [5] | Blocked By: [1,2]

  **References**:
  - Root git dir: `.git/`
  - Nested git dir: `city-mall-web/.git/`

  **Acceptance Criteria**:
  - [ ] `city-mall-web/.git` no longer exists.
  - [ ] From root, `git rev-parse HEAD` succeeds.
  - [ ] From root, `git branch --show-current` is `main`.

  **QA Scenarios**:
  ```
  Scenario: Remove nested repo and initialize root commit
    Tool: Bash
    Steps:
      1) Remove city-mall-web/.git (Windows cmd: rmdir /s /q city-mall-web\.git)
      2) Ensure branch is main (if no commits yet): git checkout -b main
      3) Commit 1 (initial): git add .gitignore && git commit -m "chore(git): add root .gitignore"
      4) Commit 2: git add city-mall-web/.husky/pre-commit && git commit -m "chore(hooks): run lint-staged from root"
      5) Commit 3: git add -A && git commit -m "chore: add workspace files"
      6) git status
    Expected: root has commits on main; workspace files are tracked; status works
    Evidence: .sisyphus/evidence/task-4-init-root.txt
  ```

  **Commit**: YES | Message(s): `chore(git): add root .gitignore`, `chore(hooks): run lint-staged from root`, `chore: add workspace files` | Files: (many)

- [ ] 5. Reproducible hook setup (tracked scripts + doc)

  **What to do**:
  - Add `scripts/setup-git-hooks.ps1` and `scripts/setup-git-hooks.sh`.
  - Each script must:
    1) Run `git config core.hooksPath city-mall-web/.husky`
    2) Print `git config --get core.hooksPath`
    3) Run `npm --prefix city-mall-web run lint-staged` as a smoke test
  - Update `AGENTS.md` to mention the one-time setup step.

  **Must NOT do**:
  - Do not add new lint tooling; just wiring.

  **Recommended Agent Profile**:
  - Category: `quick`
  - Skills: []

  **Parallelization**: Can Parallel: NO | Wave 2 | Blocks: [] | Blocked By: [3,4]

  **References**:
  - Agent doc: `AGENTS.md`
  - Hook dir: `city-mall-web/.husky/`

  **Acceptance Criteria**:
  - [ ] Running the setup script sets `core.hooksPath` to `city-mall-web/.husky`.
  - [ ] Smoke test passes on a clean tree.

  **QA Scenarios**:
  ```
  Scenario: Configure hooksPath and verify
    Tool: Bash
    Steps:
      1) Run setup script (OS-appropriate)
      2) git config --get core.hooksPath
      3) npm --prefix city-mall-web run lint-staged
    Expected: hooksPath set; hook runs successfully
    Evidence: .sisyphus/evidence/task-5-hooks-setup.txt
  ```

  **Commit**: YES | Message: `chore(git): add hook setup scripts` | Files: `scripts/setup-git-hooks.ps1`, `scripts/setup-git-hooks.sh`, `AGENTS.md`

## Final Verification Wave (4 parallel agents, ALL must APPROVE)
- [ ] F1. Plan Compliance Audit - oracle
- [ ] F2. Code Quality Review - unspecified-high
- [ ] F3. Repo QA - unspecified-high
- [ ] F4. Scope Fidelity Check - deep

## Commit Strategy
- Keep commits small and reviewable:
  1) `chore(git): add root .gitignore`
  2) `chore(hooks): run lint-staged from root`
  3) `chore: add workspace files`
  4) `chore(git): add hook setup scripts`

## Success Criteria
- Workspace root is the only Git repo; `city-mall-web/.git` is gone.
- Artifacts are ignored by default.
- Pre-commit lint-staged enforcement is restored via reproducible setup.
