# Bash: interactive shell + aliases. Theme-agnostic (theming lives in theme.nix).
{
  flake.homeManagerModules.shell = {
    programs.bash = {
      enable = true;
      enableCompletion = true;

      shellAliases = {
        # Listing (eza)
        ll = "eza -alh";
        ls = "eza";
        tree = "eza --tree --level=2 --long --icons --git";
        treelong = "eza --tree --git-ignore";

        # Navigation / misc (quoted keys required for names like .. and ...)
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        c = "clear";
        h = "history";
        cdp = "pwd | xclip -selection clipboard";
        cfp = "(){ readlink -f $1 | xclip -selection clipboard }";
        rm = "rm -ir";
        grep = "grep --color=auto";
        rsync = "rsync -auhPA --info=progress2";

        # Modern replacements
        cat = "bat";
        top = "btop";
        df = "duf";
        man = "batman";

        # Nix
        nrs = "sudo nixos-rebuild switch";
        hms = "home-manager switch --impure --flake ~/.config/nixos/#user";
        garbage = "nix-collect-garbage --delete-older-than 3d";
        se = "sudoedit";
        nixhardware = "nixos-generate-config --show-hardware-config > /home/keion/NixOmarchy/hardware-configuration.nix";
      };

      # Fastfetch on interactive login (disable if too slow on a Pi).
      initExtra = ''
        if command -v fastfetch &>/dev/null && [[ -t 0 ]]; then
          fastfetch
        fi
      '';
    };
  };
}
