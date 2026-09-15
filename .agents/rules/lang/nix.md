# Nix rules — Dendritic Pattern

> Applies to: `**/*.nix`, `flake.nix`, `modules/**`, `nixos/**`, `home-manager/**`
> Toolchain: Nix flakes + flake-parts  ·  Formatter: `alejandra`

**North star:** this repo targets the **Dendritic Pattern**. Every change
should move the tree *toward* it, never away. When in doubt, prefer a new
self-contained feature module over editing `flake.nix` or a central config.
Reference: [https://github.com/Doc-Steve/dendritic-design-with-flake-parts/wiki/FAQ](https://github.com/Doc-Steve/dendritic-design-with-flake-parts/wiki/FAQ)

## The two principles (non-negotiable)

1. **Everything is a top-level module.** Every `.nix` file is the *same* kind of
 thing — a flake-parts module (a `deferredModule`) — regardless of whether it
 ultimately configures NixOS, Home-Manager, nix-darwin, or flake outputs. No
 file is "a NixOS module" vs. "a HM module"; the class is decided *inside* the
 file, not by where it lives.
2. **Code is bundled into features.** A feature is a self-contained building
 block that puts *all* platforms/classes for one concern in one file (e.g.
 `git.nix` holds its NixOS bits *and* its Home-Manager bits together).

If a change can't be expressed as "add / remove / edit one feature", stop and
reconsider the design before writing code.

## Commands (run from repo root)


| Purpose                | Command                                                     |
| ---------------------- | ----------------------------------------------------------- |
| Format (authoritative) | `nix fmt` (alejandra)                                       |
| Check flake            | `nix flake check`                                           |
| Eval an output         | `nix eval .#<attr>`                                         |
| Build a host           | `nixos-rebuild build --flake .#<hostname>`                  |
| Build HM config        | `home-manager build --flake .#<name>`                       |
| Update inputs          | `nix flake update` (or `nix flake lock --update-input <x>`) |


- `alejandra` is **authoritative** — never hand-format; run `nix fmt`.
- Before declaring done: `nix fmt` then `nix flake check` must pass (see root DoD).

## Do

- **Keep `flake.nix` empty of logic.** It should hold `inputs` and a thin
`flake-parts` entrypoint that auto-imports feature modules. Outputs, hosts,
packages, and overlays live in feature modules, not in `flake.nix`.
- **Auto-import** feature files (e.g. `import-tree`, `haumea`, or a `readDir`
loop) so adding a feature = adding a file. No hand-maintained `imports = [...]`
lists of local paths.
- **Colocate platforms.** A feature owns its NixOS *and* Home-Manager (*and*
darwin) configuration in the same file. Bridge classes with `let ... in` or
higher-level options — not `specialArgs`.
- **Compose by import, not by flags.** Prefer including a feature over adding an
`enable` option. Enabling is often just an import.
- **Name for meaning.** Directory/file names are documentation; the pattern
makes paths free to reorganize, so name by *concern* (`features/git.nix`,
`features/desktop/hyprland.nix`), not by machine.
- **Keep files &lt; 300 LOC** (root rule). Split a fat feature into sub-features.

## Don't

- ❌ Put host lists, `nixosSystem`/`homeManagerConfiguration` calls, or output
wiring in `flake.nix`. Move them into modules.
- ❌ Introduce `specialArgs`/`extraSpecialArgs` as a communication workaround —
use options or `let ... in` within the feature. (Passing `inputs` via
flake-parts' `withSystem`/module args is fine.)
- ❌ Split one concern across a NixOS file *and* a separate HM file. That breaks
the "feature = one file" rule and scatters bug surfaces.
- ❌ Maintain relative-path `imports` lists in `default.nix` files; rely on
auto-import instead.
- ❌ Add fallback/`mkIf`-hidden breakage. Fail fast (root rule).

## Code style (idiomatic Nix)

- Prefer `lib.optional` / `lib.optionals` / `lib.optionalAttrs` for simple
conditionals over ad-hoc `if ... then ... else []`/`{}`.
- Use `inherit` (incl. `inherit (x) a b;`) to bring names into scope, especially
hyphenated identifiers — not quoted `"a-b" = x.a-b;` assignment.
- `with` is fine for short, explicit **host feature-selection lists** (e.g.
`with config.flake.nixosModules; [ ... ]` in `hosts/<host>.nix`). Avoid it
elsewhere — prefer `inherit`/explicit access, which keeps name origins clear.
- **Fail-fast messages are namespaced.** Prefix every `throw`/`assert` message
with `nixtalia:`  for traceability (e.g. the nfs/wireguard secrets checks).
- Comments follow `.agents/rules/comments.md` (why-not-what, ≤ 2 lines each,
long-form → README/`docs`). Remove any temporary `builtins.trace` before committing.
- Minimal changes: fix the issue, don't opportunistically refactor surrounding
code in the same edit (a deliberate dendritic refactor is its own task).

## Layout (Dendritic — adopted)

This repo is now Dendritic. `flake.nix` holds only inputs + a thin flake-parts
entry that `import-tree`s every module. Keep it that way.

```
flake.nix            # inputs + flake-parts entry + import-tree auto-import only
flake/               # flake-parts modules (systems, formatter, ...)
features/            # one concern per file; each contributes
  nixpkgs.nix        #   flake.{overlays,nixosModules,homeManagerModules}.<name>
  desktop.nix
hosts/
  <hostname>.nix     # thin: SELECTS features by name + declares configs
  _<hostname>/       # underscore => ignored by import-tree; plain modules
    hardware.nix     #   (hardware config), imported explicitly by the host
```

Conventions to preserve:

- A feature sets `flake.nixosModules.<name>` and/or
`flake.homeManagerModules.<name>`. Hosts compose by selecting those names
(`with config.flake.nixosModules; [ ... ]`), not by `enable` flags.
- Opt-in features that need secrets stay **commented in the host's list** so
`nix flake check` is green without secrets present. Enabling == uncommenting.
- Adding a feature = adding a file in `features/` (auto-imported). Never add a
hand-maintained relative-path `imports` list.
- `flake.lock`: after adding an input, run `nix flake lock`; never hand-edit.

Before any further restructuring, confirm scope with the user and keep
`nix flake check` green after each commit.

## Dependencies (flake inputs)

- Add inputs in `flake.nix`; always commit `flake.lock`.
- Make inputs `follows` nixpkgs where sensible to avoid dupes.
- Prefer flake-parts modules a feature can import over bespoke glue.
- Per root rule: qualify a new input/framework with the user before adding it.
- Do not hand-edit `flake.lock` — regenerate with `nix flake lock`/`update`.

## Gotchas

- A dendritic `.nix` file evaluates as a module, so top-level `{ config, lib, pkgs, ... }:` shape applies even for files that "feel like" a flake output.
- `flake.nix` no longer gives an overview of outputs — rely on naming
conventions and the `flake/` directory to find reusable outputs.
- flake-parts is a dependency: reuse is scoped to that ecosystem. Accept that
trade-off consciously (see FAQ "advantages/drawbacks").
- **Flakes only see git-tracked files.** A newly created `.nix` file is
invisible to `nix flake check` / `nixos-rebuild` until it is `git add`ed
(even without committing). After adding/moving feature files, stage them
*before* running any `nix` eval, or import-tree simply won't pick them up.

## Useful links:

[https://docs.noctalia.dev/noctalia/getting-started/nixos/](https://docs.noctalia.dev/noctalia/getting-started/nixos/)

[https://flake.parts/](https://flake.parts/)

[https://github.com/denful/den](https://github.com/denful/den)

