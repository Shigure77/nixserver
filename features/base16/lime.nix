# Base16 scheme: Lime (dark). Select `base16-lime` on a host to apply it.
{
  flake.nixosModules.base16-lime = {pkgs, ...}: {
    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/lime.yaml";
  };
}
