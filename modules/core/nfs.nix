# NFS client (NixOS module).

{ config, pkgs, ... }:

{
  # fileSystems."/mnt/tomoyo" = {
  #   device = "server:/tomoyo";
  #   fsType = "nfs";
  # };
  
  # optional, but ensures rpc-statsd is running for on demand mounting
  #boot.supportedFilesystems = [ "nfs" ];

}
