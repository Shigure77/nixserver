# Nixpkgs config + system state version.
{
  flake.nixosModules.nixpkgs = {lib, ...}: {
    nixpkgs.config.allowUnfree = lib.mkDefault false;
    system.stateVersion = "24.11";
  };
}
