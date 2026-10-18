# Base16 scheme: Serendipity Sunset (dark). Select `base16-serendipity-sunset` on a host to apply it.
{
  flake.nixosModules.base16-serendipity-sunset = {pkgs, ...}: {
    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/serendipity-sunset.yaml";
  };
}
