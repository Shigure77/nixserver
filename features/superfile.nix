{
  flake.homeModules.superfile = {pkgs, ...}: {
    home.packages = [pkgs.superfile];
  };
}
