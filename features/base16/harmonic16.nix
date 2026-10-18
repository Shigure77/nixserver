# Base16 scheme: Harmonic16 Dark (dark). Select `base16-harmonic16` on a host to apply it.
{
  flake.nixosModules.base16-harmonic16 = {pkgs, ...}: {
    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/harmonic16-dark.yaml";
  };
}
