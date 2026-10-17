# Nixpkgs config + system state version.
{
  flake.nixosModules.nixpkgs = {lib, ...}: {
    nixpkgs.config.allowUnfree = lib.mkDefault true;
    system.stateVersion = "26.05";
  };
}
