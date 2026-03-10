# Shared users and Home Manager (all hosts).
# Override username via specialArgs or host config if needed.

{ config, pkgs, lib, username ? "keion", ... }:

{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "networkmanager" ];
    description = "Server admin";
  };

  home-manager.users.${username} = {
    imports = [ ../home ];
    home.stateVersion = "24.11";
  };
}
