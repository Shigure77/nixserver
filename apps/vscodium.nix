{ config, lib, pkgs, ... }:
{
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
}