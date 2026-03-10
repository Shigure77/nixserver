# Boot loader (extlinux for Raspberry Pi; overridden by nixos-hardware per host).
# Kernel: latest mainline (override per host if you need a specific or LTS kernel).

{ config, lib, pkgs, ... }:

{
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

  boot.loader.grub.enable = lib.mkDefault false;
  boot.loader.generic-extlinux-compatible.enable = lib.mkDefault true;
}
