# Docker daemon and Compose (NixOS module).

{ config, pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };
}
