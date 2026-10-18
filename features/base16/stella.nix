# Base16 scheme: Stella (dark). Select `base16-stella` on a host to apply it.
{
  flake.nixosModules.base16-stella = {pkgs, ...}: {
    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/stella.yaml";
  };
}
