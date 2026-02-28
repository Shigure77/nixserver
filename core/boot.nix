# Boot loader (extlinux for Raspberry Pi; overridden by nixos-hardware per host).

{ config, lib, ... }:

{
  boot.loader.grub.enable = lib.mkDefault false;
  boot.loader.generic-extlinux-compatible.enable = lib.mkDefault true;
}
