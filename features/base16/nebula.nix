# Base16 scheme: Nebula (dark). Select `base16-nebula` on a host to apply it.
{
  flake.nixosModules.base16-nebula = {pkgs, ...}: {
    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/nebula.yaml";
  };
}
