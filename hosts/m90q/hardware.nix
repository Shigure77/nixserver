# Hardware configuration for Lenovo ThinkCentre M90q Gen 3 (Intel, x86_64).
# Uses nixos-hardware common-pc-ssd; no device-specific profile exists for M90q.
# Add fileSystems/swapDevices from nixos-generate-config when installing.

{ config, lib, pkgs, nixos-hardware, ... }:

{
  imports = [
    nixos-hardware.nixosModules.common-pc
    nixos-hardware.nixosModules.common-pc-ssd
  ];

  # x86_64: use GRUB (EFI); overrides core/boot.nix defaults for ARM.
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
    };
    generic-extlinux-compatible.enable = lib.mkForce false;
  };

  # fileSystems and swapDevices: run nixos-generate-config --root /mnt on the M90q
  # and copy the generated entries here. These placeholders match a typical install;
  # adjust device paths (by-label or by-uuid) to match your disk.
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };
  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-label/EFI";
    fsType = "vfat";
  };
  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];
}
