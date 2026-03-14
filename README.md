# nixserver

NixOS flake for self-hosted servers (Raspberry Pi 3 B, 4, and Lenovo ThinkCentre M90q Gen 3), with Bash, Gruvbox Dark theme, and common server tooling.

Layout follows the [core / home / hosts structure](https://discourse.nixos.org/t/how-do-you-structure-your-nixos-configs/65851): system-wide config in **core/**, user config in **home/**, and per-machine config in **hosts/**.

## Requirements

- Nix with flakes and nix-command enabled. If `nix build` fails with "experimental Nix feature … is disabled", add to `~/.config/nix/nix.conf`:
  ```ini
  experimental-features = nix-command flakes
  ```
  (Create the file and directory if needed.) Run `nix build` as your user, not with `sudo`.
- For deployment: a Raspberry Pi 3 B or 4 with NixOS (e.g. SD image from [NixOS on ARM](https://nixos.wiki/wiki/NixOS_on_ARM)), or a Lenovo ThinkCentre M90q Gen 3 (x86_64) with NixOS (e.g. [minimal ISO](https://nixos.org/download.html))

## Layout

```
├── flake.nix
├── core/                    # System-wide common
│   ├── default.nix          # Imports all core modules
│   ├── boot.nix
│   ├── packages.nix
│   ├── openssh.nix
│   ├── docker.nix
│   ├── nfs.nix
│   └── nixpkgs.nix
├── home/                    # Home Manager common
│   ├── default.nix          # Imports all home modules
│   ├── theme.nix            # Gruvbox Dark (Oh My Posh)
│   ├── cli.nix              # Bash, fastfetch
│   ├── git.nix
│   ├── nvf.nix
│   └── packages.nix
└── hosts/
    ├── rpi3/
    │   ├── default.nix      # Imports core, users, hardware
    │   ├── users.nix        # users.users + home-manager
    │   └── hardware.nix     # nixos-hardware RPi 3
    ├── rpi4/
    │   ├── default.nix
    │   ├── users.nix
    │   └── hardware.nix      # nixos-hardware RPi 4
    └── m90q/                 # Lenovo ThinkCentre M90q Gen 3 (x86_64)
        ├── default.nix
        ├── users.nix
        └── hardware.nix      # nixos-hardware common-pc + common-pc-ssd, GRUB/EFI
```

- **core/** – Shared NixOS modules (boot, packages, OpenSSH, Docker, NFS, nixpkgs). Every host pulls these in via `hosts/<name>/default.nix`.
- **home/** – Shared Home Manager config (theme, cli, git, nvf, packages). Each host’s `users.nix` sets `home-manager.users.<username>.imports = [ ../../home ]`.
- **hosts/rpi3**, **hosts/rpi4**, **hosts/m90q** – Per-host entrypoint: `default.nix` imports core + `users.nix` + `hardware.nix`.

## Configure before first deploy

1. **File systems / swap**  
   On the Pi (or from an installer root), run `nixos-generate-config --root /mnt` and copy the generated `fileSystems` and `swapDevices` into **`hosts/rpi3/hardware.nix`** or **`hosts/rpi4/hardware.nix`** (or import a separate `hardware-configuration.nix` there).

2. **User**  
   Default user is `keion` (see `username ? "keion"` in **`hosts/*/users.nix`**). Override per host by passing `username` in the flake’s `specialArgs` if needed, or edit `users.nix` and the corresponding `home-manager.users.<name>` key.

3. **Git**  
   Set `programs.git.userName` and `programs.git.userEmail` in **`home/git.nix`**.

## Build and deploy

- **Build system (e.g. RPi 4):**
  ```bash
  nix build .#nixosConfigurations.rpi4.config.system.build.toplevel
  ```

- **Deploy (from a machine that can reach the Pi):**
  ```bash
  nixos-rebuild switch --flake .#rpi4 --target-host user@rpi4
  ```

- **Topology (nix-topology):**
  ```bash
  nix build .#topology.config.output
  ```

## Adding a new host

1. Copy **`hosts/rpi4`** (or rpi3) to **`hosts/<newhost>`**.
2. In **`hosts/<newhost>/hardware.nix`**, switch the nixos-hardware import and add fileSystems/swapDevices as needed.
3. In **`flake.nix`**, add e.g. `newhost = mkSystem "newhost" ./hosts/newhost;` to `nixosConfigurations`.

Theme-related options live in **`home/theme.nix`** so you can switch theme later by editing or replacing that file.
