# Nix daemon settings: flakes + nix-command on every host.
{
  flake.nixosModules.nix-settings = {
    nix.settings.experimental-features = ["nix-command" "flakes"];
  };
}
