# Theme: base16 Icy (dark) via nix-colors.
# From https://github.com/icyphox/base16-icy-scheme (same palette as nix-colors.colorSchemes.icy).
# Change colorScheme to switch (e.g. nix-colors.colorSchemes.dracula).
# Use config.colorScheme.palette.base00 … base0F in other modules.

{ config, lib, pkgs, nix-colors, ... }:

let
  scheme = nix-colors.colorSchemes.icy;
  p = scheme.palette;
  paletteList = [
    p.base00 p.base01 p.base02 p.base03 p.base04 p.base05 p.base06 p.base07
    p.base08 p.base09 p.base0A p.base0B p.base0C p.base0D p.base0E p.base0F
  ];
  hex = c: "#${c}";
in
{
  colorScheme = scheme;

  # Apply Icy to GNOME Terminal so the theme is visible (nix-colors only sets the palette otherwise).
  programs.gnome-terminal = {
    enable = true;
    themeVariant = "dark";
    profile."b1dcc9dd-5262-4d8d-a863-c897e6d979b9" = {
      default = true;
      visibleName = "Icy";
      colors = {
        foregroundColor = hex p.base05;
        backgroundColor = hex p.base00;
        boldColor = null;
        palette = map hex paletteList;
        cursor = null;
        highlight = null;
      };
      font = "JetBrainsMono Nerd Font 12";
    };
  };
}
