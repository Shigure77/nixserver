# User-level packages and font config (no HM module for the apps; fontconfig for fonts).

{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    btop
    yazi
    duf
    fastfetch
    lazygit
    lazyssh
    lazydocker
    lazyjournal
    eza
    batman
    
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  fonts.fontconfig.enable = true;
}
