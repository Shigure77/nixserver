<!-- Extends the secrets rule (`.agents/rules/secrets.md`). Adjust conventions to match the project. -->

# Version control

## Committing

- Only commit when the user asks, or when a workflow explicitly authorizes it.
  Never commit on your own initiative mid-task.
- Make **atomic** commits: one logical change per commit; don't bundle unrelated edits.
- **Stage files explicitly by name** (`git add path/to/file`). Never `git add -A`
  or `git add .` — bulk-add is how real `secrets/*.nix` and untracked junk get
  committed by accident. (Bonus: flakes only evaluate git-tracked files, so
  staging new `.nix` files by name before `nix flake check` is required anyway —
  see `.agents/rules/lang/nix.md`.)
- Commit message style: Conventional Commits — `feat: ...`, `fix: ...`,
  `docs: ...`, `chore: ...`, `refactor: ...`. Scope by area when useful, e.g.
  `feat(hyprland): ...`, `fix(niri): ...`, `chore(flake): update inputs`.
  - Subject in imperative mood, <= ~72 chars; body explains *why*, not *what*.
- Run `nix fmt` + `nix flake check` (and a host build when relevant) **before**
  committing — see Definition of done.

## Never do

- Never commit secrets, credentials, `.env` files, or PII. Real secrets under
  `secrets/` must stay encrypted (sops/agenix); only `*.example` files are
  plaintext. If a secret is staged, stop and warn.
- Never commit machine-generated `hardware-configuration.nix` changes without
  understanding them; treat `flake.lock` bumps as their own atomic commit.
- Never `git push --force` (or `--force-with-lease`) to a shared branch (`main`, `develop`, release branches).
- Never rewrite published history (`rebase`/`amend` on pushed commits) without explicit user approval.
- Never commit merge-conflict markers, commented-out debug code, or generated files that are gitignored.
- Never commit large binaries/build artifacts — respect `.gitignore`; add to it if missing.

## Branches & PRs

- Personal repo: work happens on `master`. Use short-lived `feat/<short-desc>`
  or `fix/<short-desc>` branches for larger/riskier changes (e.g. Dendritic
  migration steps), then merge back.
- Keep branches focused and short-lived.
- If a PR is opened, its description states: what changed, why, how verified
  (build/check output), and any follow-ups (mirrors Definition of done).

## Destructive operations (ask first)

- `git reset --hard`, `git clean -fd`, branch deletion, tag deletion, history rewrites:
  confirm with the user and show what will be lost before running.
