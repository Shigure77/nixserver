# Desktop GUI apps (user-level). Selected by desktop hosts only (momo).
{
  flake.homeModules.desktop-apps = {pkgs, ...}: {
    # Enabled via their HM modules (not just installed) so Stylix can theme them.
    programs.ghostty.enable = true;
    programs.alacritty.enable = true;
    programs.kitty.enable = true;

    home.packages = with pkgs; [
      lazydocker
      lazygit
      lazyjournal
    ];

    programs.vscode = {
      package = pkgs.vscodium;
      profiles.default.extensions = with pkgs.vscode-extensions; [
        ms-python.python
        ms-azuretools.vscode-docker
        ms-vscode-remote.remote-ssh
        mikestead.dotenv
        editorconfig.editorconfig
        jnoortheen.nix-ide
        redhat.vscode-yaml
      ];
    };
  };
}
