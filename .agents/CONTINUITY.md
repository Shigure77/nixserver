# CONTINUITY.md — nixserver

Living briefing. Read at the start of every turn. Format & rules:
`.agents/rules/continuity.md`. Facts only; timestamp + provenance per entry.

## [PLANS]

- 2025-09 `[USER]` nixserver = one modular Nix flake for the whole homelab
  (rpi3, rpi4 aarch64; m90q x86_64). Goal: minimal per-machine config; shared
  behaviour in reusable modules. See `.agents/rules/project-goal.md`.
- 2025-09 `[USER]` Convert the repo to the **Dendritic Pattern** (flake-parts +
  auto-import). Currently classic `modules/{core,home,apps}` + `hosts/` with a
  `mkSystem` helper in `flake.nix`. Plan/scope pending confirmation.

## [DECISIONS]

- 2025-09 `[USER]` Wiped the copied-from-nixtalia CONTINUITY.md; started fresh
  for this repo.
- 2025-09 `[USER]` Dendritic migration decisions: (1) specialArgs->inputs
  rework OK; (2) `username` HARDCODED to `keion`; (4) use `import-tree`; (5) keep
  home-manager AS a NixOS module (not standalone homeConfigurations); (6) wire
  `apps/packages.nix` into m90q; (7) keep stale aliases in `aliases.nix` for now
  but add a cleanup TODO to README. (3) RESOLVED: Option A (import-to-enable)
  plus a `server-base` bundle feature; no enable flags.
- 2025-09 `[USER]` Repo is old; modernize outdated app config during migration
  (e.g. `nerdfonts.override` -> `nerd-fonts.*`, deprecated `gnome-terminal`).
  Track as a modernization TODO list; don't silently rewrite behaviour.

## [PROGRESS]

- 2025-09 `[CODE]` Dendritic migration S1-S5 DONE (unbuilt; nix unavailable here).
  New: thin `flake.nix` (flake-parts + `import-tree [./flake ./features ./hosts]`,
  added `flake-parts`+`import-tree` inputs); `flake/{systems,formatter,topology}.nix`;
  17 `features/*.nix` (nixos: nix-settings boot nixpkgs openssh docker nfs users
  server-packages server-base; HM: home-base shell git neovim user-packages;
  colocated theme; desktop; desktop-apps); `hosts/{rpi3,rpi4,m90q}.nix` +
  `hosts/_{rpi3,rpi4,m90q}/hardware.nix`. DELETED `modules/` + old `hosts/*/`.
  Reworks applied: specialArgs->inputs (nvf/nix-colors/self); dropped gdm-gating
  (theme/desktop are m90q-only selections); `nerdfonts.override`->`nerd-fonts.jetbrains-mono`;
  HM wired per-host via `home-manager.users.keion.imports`.
- 2025-09 `[CODE]` FIXED `.gitignore`: it ignored `**/hardware.nix` and
  `flake.lock`, both of which flakes REQUIRE tracked. Now tracked; hardware +
  flake.lock committable. rpi hardware files are PLACEHOLDERS (fail-fast until
  `nixos-generate-config`); m90q hardware is real.
- 2025-09 `[CODE]` Rewrote README (Dendritic layout, build/deploy, Modernization
  TODO: git.settings, gnome-terminal, stale aliases, allowUnfree) + REPO_LAYOUT.
- 2025-09 `[CODE]` Wrote approved migration plan to `.agents/PLAN-dendritic.md`
  (target layout, feature mapping, stages S1-S6, modernization TODO, risks).
  Execution starts at S1 on user "go". Not started.
- 2025-09 `[CODE]` Rewrote `.agents/rules/project-goal.md` and
  `.agents/REPO_LAYOUT.md` to describe nixserver (homelab-server flake) instead
  of the copied nixtalia desktop project.

## [DISCOVERIES]

- 2025-09 `[TOOL]` `nix` is NOT installed in this agent environment
  (`nix: command not found`). Cannot run `nix flake lock/check/fmt` here; the
  Dendritic migration will need the user to run lock + check on a real Nix host.
- 2025-09 `[TOOL]` Working tree has staged deletions under `examples/KeiOS-main/`
  (unrelated to current task). Not touched.
- 2025-09 `[CODE]` Current flake threads `nix-colors`, `nvf`, `self`, `username`
  via `specialArgs`/`extraSpecialArgs`; `stylix`+`gnome` gate on
  `services.displayManager.gdm.enable`; assets referenced via `self + "/assets/..."`.
  These are the main things to rework for Dendritic (specialArgs -> inputs/options).

## [OUTCOMES]

- 2025-09 `[CODE]` Repo converted to Dendritic (S1-S5). REMAINING = S6, USER must
  run on a real Nix host (nix absent here): `git add -A` -> `nix flake lock`
  (pin flake-parts + import-tree) -> `nix flake check` -> `nix fmt` ->
  `nix build .#nixosConfigurations.m90q.config.system.build.toplevel`. Expect a
  fix-up round. Known likely issues to watch: (1) `import-tree` list-arg form;
  (2) `programs.git.settings` HM schema; (3) `programs.gnome-terminal` may be
  gone on unstable; (4) `allowUnfree=false` vs vscode-extensions; (5) rpi hosts
  fail until hardware filled (expected).

- 2026 `[USER]` Pis dropped entirely: removed rpi3/rpi4 hosts+hardware, aarch64 system,
  extlinux; boot.nix now systemd-boot (UEFI). Stylix split into `stylix.nix`
  (ayu-dark, autoEnable default), `fonts.nix`, wallpaper in `desktop.nix`.
  `server-packages`/`user-packages` removed; `shell-tools` now in `server-base`.
  gh/qdirstat/superfile selected on m90q. `nix` here can't eval (store perms).
