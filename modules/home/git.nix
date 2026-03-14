# Git user-level config (Home-Manager module).

{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Keion";
        email = "keioncollins@gmail.com";
      };
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };
}
