# Theming, colocated: Stylix (NixOS, system-wide) + nix-colors palette (HM).
# Selected by desktop hosts only. Wallpaper/assets come from this flake (self).
{inputs, ...}: {
  flake.nixosModules.theme = {pkgs, ...}: {
    stylix.enable = true;
    # Dark base16 scheme from nixpkgs; swap for another under share/themes/.
    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/ayu-dark.yaml";
    stylix.image = inputs.self + "/assets/nix-dark.png";
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
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };
  };

  flake.homeManagerModules.theme = {
    config,
    pkgs,
    ...
  }: {
    imports = [inputs.nix-colors.homeManagerModules.default];

    home.packages = [inputs.nix-colors.packages.${pkgs.system}.default];
    colorScheme = inputs.nix-colors.colorSchemes.icy;

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
          palette = map (c: "#${c}") [base00 base01 base02 base03 base04 base05 base06 base07 base08 base09 base0A base0B base0C base0D base0E base0F];
          cursor = null;
          highlight = null;
        };
        font = "JetBrainsMono Nerd Font 12";
      };
    };
  };
}
