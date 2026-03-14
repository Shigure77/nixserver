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
    imports = [ ../home ../apps ];
    # Compatibility lock for stateful data; set once at first install and leave unchanged.
    # You already use the latest home-manager (flake input master); this does not control that.
    home.stateVersion = "24.11";
  };
}
