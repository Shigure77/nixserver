# Stylix: system-wide theming. autoEnable (default) themes every supported app,
# incl. Home-Manager ones via the auto-imported HM integration.
{inputs, ...}: {
  flake.nixosModules.stylix = {pkgs, ...}: {
    imports = [inputs.stylix.nixosModules.stylix];

    stylix = {
      enable = true;
      polarity = "dark";
      # Keep Qt on qtct; "follow system" would pick the unsupported gnome platform.
      homeManagerIntegration.followSystem = false;
      # Swap for another scheme under share/themes/.
      base16Scheme = "${pkgs.base16-schemes}/share/themes/ayu-dark.yaml";
    };
  };
}
