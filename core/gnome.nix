# GNOME + GDM. Import from a host that should have a desktop (e.g. hosts/m90q/default.nix).
# To exclude default apps, add or remove entries in environment.gnome.excludePackages.

{ config, lib, pkgs, ... }:

{
  services.xserver = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  # Remove default GNOME apps you don't want (add/remove as needed)
  environment.gnome.excludePackages = with pkgs; [
    nautilus
    gnome-console
    gnome-extension-manager
    gnome-system-monitor
    gnome-logs
    gnome-disk-utility
  ];
}
