# System-wide (NixOS), not per-user: every account on the machine gets these.
{
  flake.nixosModules.shell-tools = {pkgs, ...}: {

    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      #flake = "/home/user/my-nixos-config"; # sets NH_OS_FLAKE variable for you
    };

    environment.systemPackages = with pkgs; [
      eza # ls/tree replacement
      bat # cat replacement
      bat-extras.batman # man replacement (batman)
      btop # top replacement
      duf # df replacement
      xclip # clipboard
      fzf
      fd # find replacement
      zoxide # cd replacement
      ripgrep
      fd
      tealdeer # simplified man pages tldr alt 
      psmisc # provides killall

      # networking/
      dig
      nmap
      bandwhich # checks bandwidth from apps
      mtr # ping and tracert
      gping
      lsof # utility to show openfiles
      pciutils
      usbutils

      # files/data
      unzip
      p7zip
      unrar
      rsync
      trash-cli
      wget

      # nix stuff
      nix-direnv
      nix-output-monitor # pipe nom into a build command
      deadnix # finds dead nix code
      # comma  # runs any package without installing
      compose2nix
    ];
  };
}
