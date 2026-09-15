# GNOME + GDM desktop. Selected by desktop hosts only (currently m90q).
# GDM lock-screen/background image comes from this flake's assets (self).
{inputs, ...}: {
  flake.nixosModules.desktop = {pkgs, ...}: let
    lockScreenUri = "file://${inputs.self + "/assets/nix.png"}";
  in {
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;

    # Trim default GNOME apps; add/remove as desired.
    environment.gnome.excludePackages = with pkgs; [
      nautilus
      gnome-console
      gnome-extension-manager
      gnome-system-monitor
      gnome-logs
      gnome-disk-utility
    ];

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
