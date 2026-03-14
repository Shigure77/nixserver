# GNOME desktop: wallpaper (nix-dark.png) and dark mode.
# Only applies when the flake is used (nixserverFlake in home-manager extraSpecialArgs).

{ config, lib, nixserverFlake ? null, ... }:

lib.mkIf (nixserverFlake != null) {
  programs.dconf.enable = true;
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
    "org/gnome/desktop/background" = {
      picture-uri = "file://${toString (nixserverFlake + "/assets/nix-dark.png")}";
      picture-uri-dark = "file://${toString (nixserverFlake + "/assets/nix-dark.png")}";
    };
    "org/gnome/desktop/screensaver" = {
      picture-uri = "file://${toString (nixserverFlake + "/assets/nix.png")}";
      picture-uri-dark = "file://${toString (nixserverFlake + "/assets/nix.png")}";
    };
  };
}
