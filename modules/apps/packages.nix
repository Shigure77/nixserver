{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    ghostty
    alacritty
    lazydocker
    lazygit
    lazyjournal
  ];

}