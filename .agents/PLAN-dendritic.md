<!-- Working plan for the Dendritic migration. Living doc until S6 completes, then fold into OUTCOMES. -->

# Plan: migrate nixserver to the Dendritic Pattern

Status: **APPROVED, not yet started.** Execution begins at Stage S1 on user "go".
Companion state: `.agents/CONTINUITY.md`. Rules: `.agents/rules/lang/nix.md`.

## Goal

One modular homelab flake where adding/redeploying a machine is "pick a bundle +
a couple extras + declare hardware". Convert the classic
`modules/{core,home,apps}` + `mkSystem` layout to Dendritic (flake-parts +
`import-tree`), colocating NixOS + HM per concern, composing by import.

## Resolved decisions (user)

1. **specialArgs → inputs** rework: YES. Features reference `inputs.*` and
   `inputs.self + "/assets/..."` directly; drop `specialArgs`/`extraSpecialArgs`.
2. **`username`**: HARDCODE `keion` in `features/users.nix`.
3. **Composition**: **Option A (import-to-enable)** + a `server-base` bundle
   feature that aggregates the shared server baseline. No `enable` flags/`mkIf`
   gating for feature selection.
4. **Auto-import**: `import-tree` (adds `flake-parts` + `import-tree` inputs).
5. **Home-Manager**: keep AS a NixOS module
   (`home-manager.nixosModules.home-manager`), not standalone `homeConfigurations`.
6. **`apps/packages.nix`**: wire into m90q (desktop app packages).
7. **`aliases.nix`**: keep stale/personal aliases for now; add a cleanup TODO to
   README (handle later).

Plus: repo is old — modernize outdated app config during the port (track in a
README "Modernization TODO"); never silently change behaviour.

## Target layout

```
flake.nix              # inputs + flake-parts entry + import-tree ONLY
flake/
  systems.nix          # aarch64-linux + x86_64-linux
  formatter.nix        # nix fmt -> alejandra
  topology.nix         # nix-topology output (reads config.flake.nixosConfigurations)
features/              # one CONCERN per file; colocate NixOS + HM
  nix-settings.nix     # nixosModules.nix-settings
  boot.nix             # nixosModules.boot
  nixpkgs.nix          # nixosModules.nixpkgs (+ overlays if needed)
  openssh.nix          # nixosModules.openssh
  docker.nix           # nixosModules.docker
  nfs.nix              # nixosModules.nfs
  users.nix            # nixosModules.users (hardcoded keion + HM wiring)
  server-packages.nix  # nixosModules.server-packages
  server-base.nix      # nixosModules.server-base = imports of the shared baseline
  shell.nix            # homeManagerModules.shell (bash + aliases + cli merged)
  git.nix              # homeManagerModules.git
  neovim.nix           # homeManagerModules.neovim (nvf)
  theme.nix            # nixosModules.theme (stylix) + homeManagerModules.theme (nix-colors + terminal)
  user-packages.nix    # homeManagerModules.user-packages
  desktop.nix          # nixosModules.desktop (GNOME + GDM) — m90q only
  desktop-apps.nix     # homeManagerModules.desktop-apps (ghostty/alacritty/lazy*, vscodium) — m90q only
hosts/
  rpi3.nix rpi4.nix m90q.nix   # thin: SELECT features + declare nixosConfigurations.<host>
  _rpi3/hardware.nix _rpi4/hardware.nix _m90q/hardware.nix  # underscore => import-tree ignores
```

Deleted when done: `modules/` tree, `mkSystem` + host list + `topology` in
`flake.nix`, all `default.nix` import lists.

## Feature mapping (current → Dendritic)

| New feature | Class(es) | Source |
|---|---|---|
| nix-settings | NixOS | core/nix.nix |
| boot | NixOS | core/boot.nix |
| nixpkgs | NixOS | core/nixpkgs.nix |
| openssh | NixOS | core/openssh.nix |
| docker | NixOS | core/docker.nix |
| nfs | NixOS | core/nfs.nix |
| users | NixOS | core/users.nix (hardcode keion) |
| server-packages | NixOS | core/packages.nix |
| server-base (bundle) | NixOS | imports the above shared set |
| shell | HM | home/cli.nix + home/aliases.nix (merged) |
| git | HM | home/git.nix |
| neovim | HM | home/nvf.nix (inputs.nvf) |
| theme | NixOS + HM | core/stylix.nix + home/theme.nix (colocated; inputs.nix-colors/stylix) |
| user-packages | HM | home/packages.nix |
| desktop | NixOS | core/gnome.nix (inputs.self assets) |
| desktop-apps | HM | apps/vscodium.nix + apps/packages.nix (wired into m90q) |

## Host composition (Option A)

- **rpi3 / rpi4** (`aarch64-linux`): select `server-base` + HM baseline
  (shell, git, neovim, user-packages). No desktop/theme.
- **m90q** (`x86_64-linux`): `server-base` + `theme` + `desktop` + HM
  (baseline + `desktop-apps`).
- Host closure also pulls the non-feature nixos modules directly from inputs:
  `home-manager.nixosModules.home-manager`, `stylix.nixosModules.stylix`
  (m90q only), `nix-topology.nixosModules.default`, plus `./_<host>/hardware.nix`.

## Stages (each independently reviewable; keep flake check green after S6)

- **S1** Scaffolding: rewrite `flake.nix` (inputs + flake-parts + import-tree);
  add `flake/{systems,formatter,topology}.nix`.
- **S2** NixOS features: nix-settings, boot, nixpkgs, openssh, docker, nfs,
  users, server-packages, server-base.
- **S3** HM features: shell, git, neovim, user-packages.
- **S4** theme (NixOS+HM colocated) + desktop + desktop-apps, with inputs rework.
- **S5** Host files + `_<host>/hardware.nix` moves; delete `modules/` + old
  `flake.nix` logic; update README + REPO_LAYOUT.
- **S6** USER runs on a real Nix host: `git add -A` (flakes only see tracked
  files) → `nix flake lock` → `nix flake check` → `nixos-rebuild build --flake
  .#m90q` (+ rpi3/rpi4). Report errors; agent iterates.

## Modernization TODO (fill README during S5)

- `stylix.nix`: `pkgs.nerdfonts.override { fonts = ["JetBrainsMono"]; }` →
  `pkgs.nerd-fonts.jetbrains-mono` (unify with packages.nix; old API is gone on
  current unstable).
- `home/theme.nix`: `programs.gnome-terminal` HM module is deprecated upstream
  (GNOME dropped it). Flag for replacement (Console/ptyxis/foot); do NOT swap
  silently — tied to nix-colors palette.
- `aliases.nix`: stale/personal aliases (`hms` → `~/.config/nixos`,
  `nixhardware` → NixOmarchy path, xclip on headless). Clean up later (decision 7).
- Review `stateVersion` values (`24.11`) once building on current unstable.

## Risks / gotchas

- Flakes only see **git-tracked** files → new files must be `git add`ed before
  any `nix` eval (S6).
- `nix` unavailable in agent env → migration delivered UNBUILT; expect a fix-up
  round after the user's first `nix flake check`.
- Confirm input attr paths survive restructure: `home-manager.nixosModules.*`,
  `stylix.nixosModules.stylix`, `nix-topology.nixosModules.default`,
  `nvf.homeManagerModules.default`, `nix-colors.homeManagerModules.default`.
- Keep all shared features arch-agnostic (nothing x86-only in `server-base`).
- `flake.lock`: regenerate with `nix flake lock`; never hand-edit.
