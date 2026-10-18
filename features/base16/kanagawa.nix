# Base16 scheme: Kanagawa (dark). Select `base16-kanagawa` on a host to apply it.
{
  flake.nixosModules.base16-kanagawa = {pkgs, ...}: {
    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/kanagawa.yaml";
  };
}
