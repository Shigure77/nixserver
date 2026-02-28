# Git user-level config (Home-Manager module).

{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Keion";
    userEmail = "you@example.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };
}
