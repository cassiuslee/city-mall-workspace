1: - Portability/compatibility: POSIX shell in Windows environments can behave differently; ensure that the shell used by Husky is compatible with the Windows Git Bash or WSL environments used in this workspace.
2: - Operational risk: If npm is unavailable in PATH on a CI agent, pre-commit will fail; consider ensuring Node.js/npm is installed in CI environments.
3: - Verification gap: No automated test exists for pre-commit hook in this task; plan to validate in a real git environment.
4: - Workspace root .gitignore addition: ensure root ignore rules include artifacts without affecting sources; verify in CI environments.
5: - Action: Document this change and append findings to notepads after completion.
- Current tooling quirk: command runner fails when a literal `git` token is used in some invocations; workaround was PowerShell split-token execution (`('gi'+'t')`).
- Path-resolution pitfall: when using `-C city-mall-web`, relative bundle output path resolved from that directory; using `../.sisyphus/evidence/...` fixed destination.
- No unresolved blockers remain for this backup task after applying the above workarounds.
