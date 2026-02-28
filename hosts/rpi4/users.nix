# Users and Home Manager for this host.

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
    imports = [ ../../home ];
    home.stateVersion = "24.11";
  };
}
