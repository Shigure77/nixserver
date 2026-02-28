# OpenSSH server (NixOS module).

{ config, pkgs, ... }:

{
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "prohibit-password";
    openFirewall = true;
  };
}
