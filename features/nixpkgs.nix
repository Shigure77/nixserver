# Nixpkgs config + system state version.
{
  flake.nixosModules.nixpkgs = {lib, ...}: {
    nixpkgs.config.allowUnfree = true;
    system.stateVersion = "26.05";
  };
}