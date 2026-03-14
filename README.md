# nixserver

NixOS flake for self-hosted servers (Raspberry Pi 3 B, 4, and Lenovo ThinkCentre M90q Gen 3), with Bash, Gruvbox Dark theme, and common server tooling.

Layout follows the [core / home / hosts structure](https://discourse.nixos.org/t/how-do-you-structure-your-nixos-configs/65851): system-wide config in **modules/core/**, user config in **modules/home/**, optional apps in **modules/apps/**, and per-machine config in **hosts/**.

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
├── modules/
│   ├── core/                # System-wide common
│   │   ├── default.nix      # Imports all core modules
│   │   ├── boot.nix
│   │   ├── gnome.nix        # GDM + GNOME (import from desktop hosts only)
│   │   ├── packages.nix
│   │   ├── openssh.nix
│   │   ├── docker.nix
│   │   ├── nfs.nix
│   │   ├── nixpkgs.nix
│   │   └── users.nix       # users.users + home-manager
│   ├── home/                # Home Manager common
│   │   ├── default.nix
│   │   ├── theme.nix        # Gruvbox Dark (Oh My Posh)
│   │   ├── cli.nix
│   │   ├── git.nix
│   │   ├── nvf.nix
│   │   └── packages.nix
│   └── apps/
│       ├── default.nix
│       └── ...
├── hosts/
│   ├── rpi3/
│   │   ├── default.nix      # Imports modules/core, hardware
│   │   └── hardware-configuration.nix
│   ├── rpi4/
│   │   ├── default.nix
│   │   └── hardware-configuration.nix
│   └── m90q/                # Lenovo ThinkCentre M90q Gen 3 (x86_64)
│       ├── default.nix      # Imports modules/core, modules/core/gnome.nix, hardware
│       └── hardware.nix
└── assets/                  # Wallpaper / lock screen images (GNOME)
```

- **modules/core/** – Shared NixOS modules. Every host imports `../../modules/core`; m90q also imports `../../modules/core/gnome.nix` for the desktop.
- **modules/home/** – Shared Home Manager config. Core `users.nix` sets `home-manager.users.<username>.imports = [ ../home ]`.
- **hosts/** – Per-host entrypoint: `default.nix` imports core (+ gnome for m90q) and host hardware.

## Configure before first deploy

1. **File systems / swap**  
   On the Pi (or from an installer root), run `nixos-generate-config --root /mnt` and copy the generated `fileSystems` and `swapDevices` into **`hosts/rpi3/hardware-configuration.nix`** or **`hosts/rpi4/hardware-configuration.nix`** (or **`hosts/m90q/hardware.nix`** for the M90q).

2. **User**  
   Default user is `keion` (see `username ? "keion"` in **`modules/core/users.nix`**). Override per host by passing `username` in the flake’s `specialArgs` if needed.

3. **Git**  
   Set `programs.git.userName` and `programs.git.userEmail` in **`modules/home/git.nix`**.

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
2. In **`hosts/<newhost>/hardware.nix`** (or `hardware-configuration.nix`), switch the nixos-hardware import and add fileSystems/swapDevices as needed.
3. In **`flake.nix`**, add e.g. `newhost = mkSystem "newhost" ./hosts/newhost;` to `nixosConfigurations`.

Theme-related options live in **`modules/home/theme.nix`** so you can switch theme later by editing or replacing that file.
