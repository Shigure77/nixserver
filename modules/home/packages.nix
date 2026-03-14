# User-level packages and font config (no HM module for the apps; fontconfig for fonts).

{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    btop
    yazi
    duf
    fastfetch
    eza
    bat
    nerd-fonts.jetbrains-mono
  ];

  fonts.fontconfig.enable = true;
  # For Nerd Font symbols (icons) to show: set your terminal/IDE font to "JetBrainsMono Nerd Font".
}
