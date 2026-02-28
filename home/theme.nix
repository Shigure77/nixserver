# Theme configuration: Gruvbox Dark.
# Kept separate so you can switch theme later by changing this file or
# swapping the import for another theme module (e.g. home/theme-catppuccin.nix).

{ config, lib, pkgs, ... }:

{
  # Oh My Posh: use official gruvbox theme (dark).
  # Change useTheme here to switch prompt theme (e.g. "catppuccin", "powerline").
  programs.oh-my-posh = {
    enable = true;
    enableBashIntegration = true;
    useTheme = "gruvbox";
    # Optional: custom theme path if you use a custom .omp.json
    # theme = builtins.toPath ./gruvbox.omp.json;
  };

  # Bash: optional Gruvbox-dark-friendly terminal color hint.
  home.sessionVariables = {
    COLORFGBG = "15;235";
  };
}
