# Base16 scheme: Rosé Pine (dark). Select `base16-rose-pine` on a host to apply it.
{
  flake.nixosModules.base16-rose-pine = {pkgs, ...}: {
    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
  };
}
