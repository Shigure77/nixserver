# nixserver

One NixOS flake for the homelab — a Lenovo ThinkCentre M90q Gen 3 (`x86_64`). Built with the
**Dendritic Pattern** (flake-parts + `import-tree`): every `.nix` file is an
auto-imported feature module, and a host is just a short *selection* of
features. Adding a machine ≈ new `hosts/<name>.nix` + its hardware.

See `.agents/rules/project-goal.md` (why) and `.agents/rules/lang/nix.md`
(Dendritic rules) for the design.

## Requirements

- Nix with flakes + nix-command enabled. If a command fails with "experimental
  Nix feature … is disabled", add to `~/.config/nix/nix.conf`:
  ```ini
  experimental-features = nix-command flakes
  ```
- A target machine running NixOS ([minimal ISO](https://nixos.org/download.html)).

## Layout

```
flake.nix              # inputs + flake-parts entry + import-tree (no logic)
flake/                 # flake-parts modules: systems, formatter, topology
features/              # one concern per file; each = a named nixos/HM module
  server-base.nix      #   bundle: the shared baseline every host selects
  boot nix-settings nixpkgs openssh docker nfs users shell-tools       (NixOS)
  stylix fonts                                                         (NixOS)
  home-base shell git gh qdirstat superfile neovim                     (HM)
  desktop desktop-apps #   GNOME + GUI apps, desktop-only
hosts/
  m90q.nix           # thin: SELECT features + declare the config
  _m90q/             # hardware.nix (underscore => import-tree ignores)
assets/                # wallpaper / lock-screen images (desktop host)
scripts/               # helper scripts
```

**How composition works:** features set `flake.nixosModules.<name>` and/or
`flake.homeModules.<name>`. A host *selects* names — enabling a feature
is just listing it. `server-base` bundles the common server set; desktop-only
hosts additionally select `stylix`, `fonts`, `desktop`, `desktop-apps`.

## Configure before first deploy

1. **Hardware.** `hosts/_m90q/hardware.nix` is already populated.
   It is **git-tracked on purpose** — a flake can't see untracked
   files.
2. **User.** Default user is `keion` (hardcoded in `features/users.nix`).
3. **Git identity.** Set name/email in `features/git.nix`.

## Build and deploy

```bash
git add -A                                  # flakes only see git-tracked files
nix flake lock                              # pin flake-parts + import-tree
nix flake check                             # evaluate all hosts
nix fmt                                     # alejandra (authoritative)

nix build .#nixosConfigurations.m90q.config.system.build.toplevel
nixos-rebuild switch --flake .#m90q --target-host user@m90q   # deploy remotely
nix build .#topology.x86_64-linux.config.output          # nix-topology diagram
```

## Adding a new host

1. Add `hosts/<name>.nix` selecting features, plus `hosts/_<name>/hardware.nix`
   for its hardware.
2. No `flake.nix` edit needed — `import-tree` picks up the new files (after
   `git add`).

## Modernization TODO

This repo predates current `nixpkgs-unstable`; a few things need review/fixup
(tracked so behaviour changes stay visible, not silent):

- **`features/git.nix`** uses `programs.git.settings` — verify against current
  Home-Manager (may need `userName`/`userEmail`/`extraConfig`).
- **`features/shell.nix`** keeps some stale/personal aliases (`hms` →
  `~/.config/nixos`, `nixhardware` → a NixOmarchy path, `xclip` on headless
  hosts). Clean up.
- **`allowUnfree`** is `false` globally; if `desktop-apps` (vscode extensions)
  needs unfree, set it on the `m90q` host or in `desktop`.
- Revisit `stateVersion` (`24.11`) once building on current unstable.
