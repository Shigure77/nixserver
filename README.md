# nixserver

One NixOS flake for the whole homelab — Raspberry Pi 3 B, Raspberry Pi 4
(`aarch64`), and a Lenovo ThinkCentre M90q Gen 3 (`x86_64`). Built with the
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
- A target machine running NixOS (SD image from
  [NixOS on ARM](https://nixos.wiki/wiki/NixOS_on_ARM) for the Pis, or the
  [minimal ISO](https://nixos.org/download.html) for the M90q).

## Layout

```
flake.nix              # inputs + flake-parts entry + import-tree (no logic)
flake/                 # flake-parts modules: systems, formatter, topology
features/              # one concern per file; each = a named nixos/HM module
  server-base.nix      #   bundle: the shared baseline every host selects
  boot nix-settings nixpkgs openssh docker nfs users server-packages   (NixOS)
  home-base shell git neovim user-packages                             (HM)
  theme                #   Stylix (NixOS) + nix-colors palette (HM), desktop-only
  desktop desktop-apps #   GNOME + GUI apps, desktop-only
hosts/
  rpi3.nix rpi4.nix m90q.nix   # thin: SELECT features + declare the config
  _rpi3/ _rpi4/ _m90q/         # hardware.nix (underscore => import-tree ignores)
assets/                # wallpaper / lock-screen images (desktop host)
scripts/               # helper scripts
```

**How composition works:** features set `flake.nixosModules.<name>` and/or
`flake.homeManagerModules.<name>`. A host *selects* names — enabling a feature
is just listing it. `server-base` bundles the common server set; desktop-only
hosts additionally select `theme`, `desktop`, `desktop-apps`.

## Configure before first deploy

1. **Hardware.** On each Pi run `nixos-generate-config` and paste the generated
   `fileSystems` + `swapDevices` into `hosts/_rpi3/hardware.nix` /
   `hosts/_rpi4/hardware.nix`. `hosts/_m90q/hardware.nix` is already populated.
   These files are **git-tracked on purpose** — a flake can't see untracked
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
nixos-rebuild switch --flake .#rpi4 --target-host user@rpi4   # deploy remotely
nix build .#topology.config.output          # nix-topology diagram
```

> The Pi hosts **fail fast** until their `hardware.nix` is filled (step 1) — that
> is expected, not a bug.

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
- **`features/theme.nix`** uses `programs.gnome-terminal` (HM), deprecated
  upstream (GNOME dropped it). Candidate replacement: ptyxis/Console/foot. Tied
  to the nix-colors palette, so replace deliberately.
- **`features/shell.nix`** keeps some stale/personal aliases (`hms` →
  `~/.config/nixos`, `nixhardware` → a NixOmarchy path, `xclip` on headless
  hosts). Clean up.
- **`allowUnfree`** is `false` globally; if `desktop-apps` (vscode extensions)
  needs unfree, set it on the `m90q` host or in `desktop`.
- Revisit `stateVersion` (`24.11`) once building on current unstable.
