# Theme: base16 Icy (dark) via nix-colors.
# Change colorScheme to switch (e.g. nix-colors.colorSchemes.dracula).
# Use config.colorScheme.palette.base00 … base0F in other modules.

{ config, lib, pkgs, nix-colors, ... }:

{
  colorScheme = nix-colors.colorSchemes.icy;
}
