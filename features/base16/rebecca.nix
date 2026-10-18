# Base16 scheme: Rebecca (dark). Select `base16-rebecca` on a host to apply it.
{
  flake.nixosModules.base16-rebecca = {pkgs, ...}: {
    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/rebecca.yaml";
  };
}
