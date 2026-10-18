# Base16 scheme: Jabuti (dark). Select `base16-jabuti` on a host to apply it.
{
  flake.nixosModules.base16-jabuti = {pkgs, ...}: {
    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/jabuti.yaml";
  };
}
