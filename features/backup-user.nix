# Dedicated, non-login system account that runs the backup staging jobs.
# Keys and secrets are NOT stored here (the Nix store is world-readable):
# the SSH key lives in /var/lib/backup/.ssh, created by hand.
{
  flake.nixosModules.backup-user = {pkgs, ...}: {
    users.groups.backup = {};

    users.users.backup = {
      isSystemUser = true;
      group = "backup";
      home = "/var/lib/backup";
      createHome = true;
      shell = "${pkgs.shadow}/bin/nologin";
      description = "Backup staging jobs";
    };

    # Staging root that Zerobyte later reads (see docs/BACKUP_PLAN.md).
    systemd.tmpfiles.rules = [
      "d /srv/backup-staging 0750 backup backup -"
    ];
  };
}
