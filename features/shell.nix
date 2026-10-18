{...}: let
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
    rm = "rm -ir";
    grep = "rg";
    rsync = "rsync -auhPA --info=progress2";

    # Modern replacements
    cat = "bat -pp";
    top = "btop";
    df = "duf";
    man = "tldr";
    find = "fd";

    # history
    h10 = "history 10";
    h20 = "history 20";
    h40 = "history 40";
    hfzf = "history | fzf";
    h = "history";

    # docker
    dockup = "docker compose up -d";
    dockdown = "docker compose down";
    dockpull = "docker compose pull";
    lazy = "lazydocker";
    dockerservicenodes = "docker service ps $(docker service ls -q)";

    # ssh
    misato = "ssh misato";
    ryuko = "ssh ryuko";
    mephiston = "ssh mephiston";

    # Nix 
    nrs = "sudo nixos-rebuild switch --flake ~/nixserver#\${HOSTNAME}";
    nrt = "sudo nixos-rebuild test --flake ~/nixserver#\${HOSTNAME}";
    nrb = "sudo nixos-rebuild boot --flake ~/nixserver#\${HOSTNAME}";
    garbage = "nix-collect-garbage --delete-older-than 3d";
    se = "sudoedit";
    nixhardware = "nixos-generate-config --show-hardware-config > ~/nixtalia/hardware/$(hostname).generated.nix";
  };

  # Fastfetch on interactive login.
  greeting = ''
    if command -v fastfetch &>/dev/null && [[ -t 0 ]]; then
      fastfetch
    fi
  '';
in {
  flake.homeModules.shell = {
    programs.bash = {
      enable = true;
      enableCompletion = true;
      inherit shellAliases;
      initExtra = greeting;
    };

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      inherit shellAliases;
      initContent = greeting;
    };
  };
}
