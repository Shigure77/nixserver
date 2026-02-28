# NFS client (NixOS module).

{ config, pkgs, ... }:

{
  services.nfs.client.enable = true;
}
