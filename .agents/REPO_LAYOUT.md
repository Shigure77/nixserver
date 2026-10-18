<!-- Canonical repo map. Keep high-signal; update when structure materially changes. -->

# Repository layout — nixserver

Single NixOS + Home-Manager flake for the whole homelab (Lenovo ThinkCentre M90q Gen 3). See `.agents/rules/project-goal.md` for the
"why" and `.agents/rules/lang/nix.md` for the Dendritic design rules.

> Status: **Dendritic Pattern** (flake-parts + `import-tree`). `flake.nix` holds
> no logic; every `.nix` under `flake/`, `features/`, `hosts/` is an
> auto-imported flake-parts module. Migrated from the old classic
> `modules/{core,home,apps}` + `mkSystem` layout.

## Tree (2 levels)

```
flake.nix                 # inputs + thin flake-parts entry + import-tree ONLY
flake.lock                # pinned inputs — generated, do not hand-edit (committed)
flake/                    # flake-parts modules
  systems.nix             # build systems (x86_64-linux)
  formatter.nix           # `nix fmt` -> alejandra (perSystem)
  topology.nix            # flake.topology output (nix-topology)
features/                 # one concern per file; each contributes a named module
  nix-settings.nix boot.nix nixpkgs.nix openssh.nix docker.nix nfs.nix
  users.nix shell-tools.nix                     # NixOS features
  server-base.nix                               # bundle: shared baseline (imports the above)
  home-base.nix shell.nix git.nix neovim.nix gh.nix qdirstat.nix superfile.nix   # HM features
  stylix.nix fonts.nix                          # NixOS: stylix theming + fonts
  desktop.nix                                   # NixOS (GNOME+GDM, wallpaper), desktop-only
  desktop-apps.nix                              # HM (vscodium + GUI apps), desktop-only
hosts/
  momo.nix                  # x86_64 desktop; server-base + stylix/fonts/desktop
  _momo/hardware.nix        # underscore => import-tree ignores; imported explicitly (real, generated)
assets/                   # wallpaper / lock-screen images (desktop host)
scripts/                  # helper shell scripts
setup-server.sh           # bootstrap/provisioning helper
.gitignore                # tracks flake.lock + hardware.nix on purpose (flakes need them)
.agents/                  # agent rules, continuity, plan, layout (this file)
AGENTS.md · README.md
```

## Entry points

- **Build a host:** `nix build .#nixosConfigurations.<host>.config.system.build.toplevel`.
- **Deploy remotely:** `nixos-rebuild switch --flake .#<host> --target-host user@<host>`.
- **Check / format:** `nix flake check` · `nix fmt` (alejandra, authoritative).
- **Topology:** `nix build .#topology.x86_64-linux.config.output`.
- **Update inputs:** `nix flake update` · pin new inputs with `nix flake lock`.
- **Add a host:** `hosts/<name>.nix` (select features) + `hosts/_<name>/hardware.nix`.
- **Add a feature:** drop a `.nix` in `features/` (auto-imported), select by name.

## Conventions & gotchas

- **Composition = import, not flags.** Features set `flake.nixosModules.<name>` /
  `flake.homeModules.<name>`; hosts SELECT names. `server-base` bundles
  the shared server set. No `enable` toggles.
- **Home-Manager runs AS a NixOS module** (`home-manager.nixosModules.home-manager`);
  each host wires `home-manager.users.keion.imports` from `config.flake.homeModules`.
- **specialArgs dropped.** Features reference `inputs.*` directly
  (`inputs.nvf`, `inputs.nix-colors`, `inputs.self + "/assets/..."`).
- **Generated / do-not-hand-edit:** `flake.lock`, `hosts/_*/hardware.nix` (once real).
- **import-tree** ignores any path component starting with `_` (so
  `hosts/_<host>/` holds plain NixOS modules, imported explicitly by the host).
- **Flakes only see git-tracked files** — `git add` new feature/hardware files
  before any `nix` eval.
- `username` hardcoded `keion`; `stateVersion` `24.11` (system + HM).
- Modernization follow-ups live in `README.md` "Modernization TODO".
- Keep `README.md` "Layout" in sync with this file.
