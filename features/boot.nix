# UEFI boot via systemd-boot, latest mainline kernel.
{
  flake.nixosModules.boot = {
    lib,
    pkgs,
    ...
  }: {
    boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
  };
}
