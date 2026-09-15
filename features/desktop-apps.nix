# Desktop GUI apps (user-level). Selected by desktop hosts only (m90q).
{
  flake.homeManagerModules.desktop-apps = {pkgs, ...}: {
    home.packages = with pkgs; [
      ghostty
      alacritty
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
