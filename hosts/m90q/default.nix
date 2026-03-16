# Lenovo ThinkCentre M90q Gen 3 host: pulls in core system modules and host-specific users + hardware.

{ ... }:

{
  imports = [
    ../../modules/core/default.nix
    ../../modules/core/gnome.nix
    ../../modules/apps/default.nix
    ./hardware-configuration.nix   # fileSystems, swap (from nixos-generate-config)
  ];
}
