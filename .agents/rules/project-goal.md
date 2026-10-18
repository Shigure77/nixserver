# Project goal (read first for context)

Context, not a checklist — so an agent knows what this project is before acting.

**nixserver** is a single **Nix flake for the whole homelab**: one repository
that configures every self-hosted machine (NixOS system + Home-Manager user
environment). The aim is *one modular repo* so that standing up a new box or
re-deploying an existing one needs as little per-machine work as possible —
shared behaviour lives in reusable modules, and a host is mostly "pick which
modules apply + declare its hardware".

## The setup

- **OS:** NixOS (flakes), `nixpkgs-unstable`. `home-manager` runs as a NixOS
  module (not standalone). Theming via `stylix` (Gruvbox Dark).
- **Hosts (current):**
  - `momo` — Lenovo ThinkCentre M90q Gen 3 (`x86_64-linux`); the one desktop
    box (GDM + GNOME).
  - New homelab machines are expected to be added over time.
- **Primary user:** `keion` (overridable per host via `specialArgs.username`).
- **Extras:** `nix-topology` (network/infra diagram), `nvf` (Neovim), plus the
  usual server tooling (docker, nfs, openssh, ...).

## What "good" looks like

- **Modular & reusable.** Common concerns are NixOS/HM modules under
  `modules/`; a host imports the shared set and adds only what's unique to it.
  Adding a machine should mean: new `hosts/<name>/`, its hardware, and a
  one-line entry in `flake.nix` — not copy-pasting system config.
- **Server-first, mixed-arch aware.** Keep desktop-only bits (GNOME, GUI apps)
  out of the default server core. Don't hard-wire arch assumptions into shared
  modules.
- **Reproducible & deployable remotely.** Everything expressed in Nix, pinned
  via `flake.lock`; hosts build and deploy with
  `nixos-rebuild switch --flake .#<host> --target-host user@<host>`.
- Config stays **buildable**: each host's `system.build.toplevel` evaluates.
- Secrets stay out of the store in plaintext (see `.agents/rules/secrets.md`).

## Where to look

- Root rules & pointers → `AGENTS.md`
- Nix language/design rules → `.agents/rules/lang/nix.md`
- Repo layout map → `.agents/REPO_LAYOUT.md`
- Current state & decisions → `.agents/CONTINUITY.md`

> Note: this repo currently uses a classic `core` / `home` / `apps` / `hosts`
> module layout with a `mkSystem` helper in `flake.nix`, **not** the Dendritic
> pattern described in `nix.md`. Treat `nix.md`'s Dendritic guidance as a
> possible future direction, not the current shape — confirm with the user
> before restructuring toward it.
