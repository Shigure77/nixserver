# Terminal aliases. Add your own below; remove or change the examples as needed.
# Use shellAliases for simple aliases; for arguments use shellInit + functions in initExtra (cli.nix).

{ config, lib, pkgs, ... }:

{
  programs.bash.shellAliases = {
    # List commands 
    ll = "eza -alh";
    ls = "eza";
    tree = "eza --tree --git-ignore"

    # Terminal Misc
    ".." = "cd ..";
    "..." = "cd ../..";
    c = "clear";
    h = "history";
    cdp = "pwd | xclip -selection clipboard"; # copy pwd to clipboard
    cfp = "(){ readlink -f $1 | xclip -selection clipboard }"; # copy file path to clipboard
    rm = "rm -ir"
    grep = "grep --color=auto"

    #Utlitities
    cat = "bat";
    top = "btop";
    df = "duf";
    man = "batman";

    #nix commands
    nrs = "sudo nixos-rebuild switch";
    hms = "home-manager switch --impure --flake ~/.config/nixos/#user";
    garbage = "doas nix-collect-garbage --delete-older-than 3d";
    alias se = "sudoedit"
  };
}
