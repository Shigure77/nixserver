# Nixpkgs and system state version.

{ config, lib, ... }:

{
  nixpkgs.config.allowUnfree = lib.mkDefault false;
  system.stateVersion = "24.11";
}
