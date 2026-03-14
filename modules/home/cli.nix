# CLI and shell configuration (bash). Theme-agnostic; theming is in theme.nix.

{ config, lib, pkgs, ... }:

{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    # Oh My Posh and other integrations are enabled in configuration.nix / theme.nix
    initExtra = ''
      # Fastfetch on interactive shell (optional; can be disabled if too slow)
      if command -v fastfetch &>/dev/null && [[ -t 0 ]]; then
        fastfetch
      fi
    '';
  };
}
