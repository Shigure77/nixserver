# User-level CLI packages + fontconfig.
{
  flake.homeManagerModules.user-packages = {pkgs, ...}: {
    home.packages = with pkgs; [
      btop
      yazi
      duf
      fastfetch
      eza
      bat
      nerd-fonts.jetbrains-mono
    ];

    # Set your terminal/IDE font to "JetBrainsMono Nerd Font" for icons.
    fonts.fontconfig.enable = true;
  };
}
