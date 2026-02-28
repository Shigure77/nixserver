# Hardware configuration for Raspberry Pi 3 B.
# Add fileSystems/swapDevices from nixos-generate-config when installing.

{ config, lib, pkgs, nixos-hardware, ... }:

{
  imports = [
    nixos-hardware.nixosModules.raspberry-pi-3
  ];

  # fileSystems and swapDevices: run nixos-generate-config --root /mnt on the Pi
  # and copy the generated entries here (or import a hardware-configuration.nix).
  # fileSystems."/" = { device = "/dev/disk/by-label/NIXOS_SD"; fsType = "ext4"; };
  # swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];
}
