# Base16 scheme: Tarot (dark). Select `base16-tarot` on a host to apply it.
{
  flake.nixosModules.base16-tarot = {pkgs, ...}: {
    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/tarot.yaml";
  };
}
