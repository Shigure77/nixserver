# Lenovo ThinkCentre M90q Gen 3 host: pulls in core system modules and host-specific users + hardware.

{ ... }:

{
  imports = [
    ../../core
    ./hardware.nix
  ];
}
