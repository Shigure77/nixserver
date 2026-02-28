# System-wide packages (standalone first; no NixOS/home-manager module where not needed).

{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    btop
    yazi
    duf
    pciutils
    wget
    psmisc   # provides killall
    fastfetch
    docker-compose
  ] ++ lib.optional (builtins.hasAttr "compose2nix" pkgs) pkgs.compose2nix;
}
