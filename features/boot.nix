# Boot loader (extlinux for Raspberry Pi; nixos-hardware may override per host).
{
  flake.nixosModules.boot = {
    lib,
    pkgs,
    ...
  }: {
    # Latest mainline kernel; override per host for a specific/LTS kernel.
    boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

    boot.loader.grub.enable = lib.mkDefault false;
    boot.loader.generic-extlinux-compatible.enable = lib.mkDefault true;
  };
}
