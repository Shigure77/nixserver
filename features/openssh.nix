# OpenSSH server: key-only-ish (root only via key), firewall opened.
{
  flake.nixosModules.openssh = {
    services.openssh = {
      enable = true;
      settings.PermitRootLogin = "prohibit-password";
      openFirewall = true;
    };
  };
}
