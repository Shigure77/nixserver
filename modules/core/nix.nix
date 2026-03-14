# Nix daemon/settings: enable flakes and nix-command on all hosts.

{ ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
