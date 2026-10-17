{
  flake.homeModules.qdirstat = {pkgs, ...}: {
    home.packages = [pkgs.qdirstat];
  };
}
