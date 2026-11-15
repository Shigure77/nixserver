{
  flake.homeModules.devops = {pkgs, ...}: {
    home.packages = with pkgs; [
      just
      ansible
      ansible-lint
      pre-commit
      act # run gh actions locally
      curlie # curlie and xh are friendlier curl figure out which is better
      xh
      infisical
      sqlite
      webhook # adnanh/webhook binary (the service is in backup-user.nix)
      shellcheck
      python314

    ];
  };
}
