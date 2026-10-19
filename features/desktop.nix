# GNOME + GDM desktop. Selected by desktop hosts only (currently momo).
# Wallpaper (stylix.image) and GDM lock-screen come from this flake's assets.
{inputs, ...}: {
  flake.nixosModules.desktop = {pkgs, ...}: let
    lockScreenUri = "file://${inputs.self + "/assets/nix.png"}";
  in {
    stylix.image = inputs.self + "/assets/nix-dark.png";

    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;

    programs.dconf.profiles.gdm.databases = [
      {
        settings."org/gnome/desktop/screensaver" = {
          picture-uri = lockScreenUri;
          picture-uri-dark = lockScreenUri;
        };
      }
    ];
  };
}
