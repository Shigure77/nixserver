# GNOME + GDM. Import from a host that should have a desktop (e.g. hosts/m90q/default.nix).
# Lock screen and wallpaper use assets/ when the flake is built with --flake . (self in specialArgs).
# To exclude default apps, add or remove entries in environment.gnome.excludePackages.

{ config, lib, pkgs, self ? null, ... }:

let
  lockScreenUri = lib.optionalString (self != null) "file://${toString (self + "/assets/nix.png")}";
in
{
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Remove default GNOME apps you don't want (add/remove as needed)
  environment.gnome.excludePackages = with pkgs; [
    nautilus
    gnome-console
    gnome-extension-manager
    gnome-system-monitor
    gnome-logs
    gnome-disk-utility
  ];

  # GDM lock screen background (nix.png)
  programs.dconf.profiles.gdm.databases = lib.mkIf (self != null) [
    {
      settings."org/gnome/desktop/screensaver" = {
        picture-uri = lockScreenUri;
        picture-uri-dark = lockScreenUri;
      };
    }
  ];
}
