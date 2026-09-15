# System-wide server tooling (every host).
{
  flake.nixosModules.server-packages = {
    pkgs,
    lib,
    ...
  }: {
    environment.systemPackages = with pkgs;
      [
        btop
        yazi
        duf
        pciutils
        wget
        psmisc # provides killall
        fastfetch
        docker-compose
      ]
      ++ lib.optional (builtins.hasAttr "compose2nix" pkgs) pkgs.compose2nix;
  };
}
