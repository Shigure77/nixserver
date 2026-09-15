# System user `keion` + Home-Manager global settings (HM runs as a NixOS module).
# Host files select which HM feature modules this user imports.
{
  flake.nixosModules.users = {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;

    users.users.keion = {
      isNormalUser = true;
      extraGroups = ["wheel" "docker" "networkmanager"];
      description = "Server admin";
    };
  };
}
