# NFS client placeholder. Declare mounts per host or here; see README "NFS".
{
  flake.nixosModules.nfs = {
    boot.supportedFilesystems = [ "nfs" ];
    fileSystems."/mnt/mainpool/keion" = {
      device = "192.168.0.51:/mnt/mainpool/keion";
      fsType = "nfs";
      options = [
        "_netdev"
        "nofail"
        "x-systemd.automount"
        "x-systemd.idle-timeout=600"
        "x-systemd.mount-timeout=10s"
      ];
    };    
    fileSystems."/mnt/cstore" = {
      device = "192.168.0.51:/mnt/cstore/cstore";
      fsType = "nfs";
      options = [
        "_netdev"
        "nofail"
        "x-systemd.automount"
        "x-systemd.idle-timeout=600"
        "x-systemd.mount-timeout=10s"
      ];
    };
  };
}
