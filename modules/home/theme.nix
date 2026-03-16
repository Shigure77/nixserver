# Theme: nix-colors scheme. Other modules use config.colorScheme.palette (e.g. base00 … base0F).
# Switch scheme: change the colorSchemes.<name> below (e.g. dracula, gruvbox-dark-medium).

{ pkgs, config, nix-colors, ... }:

{

  imports = [
   nix-colors.homeManagerModules.default
  ];

  home.packages = with pkgs; [
    nix-colors.packages.${system}.default
  ];

  colorScheme = nix-colors.colorSchemes.icy;

  programs.gnome-terminal = {
    enable = true;
    themeVariant = "dark";
    profile."b1dcc9dd-5262-4d8d-a863-c897e6d979b9" = {
      default = true;
      visibleName = "Icy";
      colors = with config.colorScheme.palette; {
        foregroundColor = "#${base05}";
        backgroundColor = "#${base00}";
        boldColor = null;
        palette = map (c: "#${c}") [ base00 base01 base02 base03 base04 base05 base06 base07 base08 base09 base0A base0B base0C base0D base0E base0F ];
        cursor = null;
        highlight = null;
      };
      font = "JetBrainsMono Nerd Font 12";
    };
  };
}
