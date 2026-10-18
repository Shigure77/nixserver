# Stylix: system-wide theming. autoEnable (default) themes every supported app,
# incl. Home-Manager ones via the auto-imported HM integration.
{inputs, ...}: {
  flake.nixosModules.stylix = {
    pkgs,
    lib,
    ...
  }: {
    imports = [inputs.stylix.nixosModules.stylix];

    stylix = {
      enable = true;
      polarity = "dark";
      # Keep Qt on qtct; "follow system" would pick the unsupported gnome platform.
      homeManagerIntegration.followSystem = false;
      # Default; a features/base16/* module overrides it when selected.
      base16Scheme = lib.mkDefault "${pkgs.base16-schemes}/share/themes/ayu-dark.yaml";
    };
  };
}
