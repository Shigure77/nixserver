# Stylix: system-wide theme (GTK, Qt, terminals, GDM, etc.).
# Only active when GDM is enabled (desktop hosts). Uses base16 scheme + optional wallpaper from flake assets.
# Keep nix-colors in modules/home/theme.nix for palette (e.g. GNOME Terminal); Stylix handles the rest.

{ config, lib, pkgs, self ? null, ... }:

lib.mkIf config.services.displayManager.gdm.enable {
  stylix.enable = true;
  # Dark base16 scheme from nixpkgs (change to another under share/themes/ if desired)
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/ayu-dark.yaml";
  # Wallpaper from flake assets when built with this flake
  stylix.image = lib.mkIf (self != null) (self + "/assets/nix-dark.png");
  stylix.polarity = "dark";

  stylix.fonts = {
    serif = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Serif";
    };
    sansSerif = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Sans";
    };
    monospace = {
      package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
      name = "JetBrainsMono Nerd Font";
    };
    emoji = {
      package = pkgs.noto-fonts-color-emoji;
      name = "Noto Color Emoji";
    };
  };
}
