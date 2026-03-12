# Home Manager common config (imported for each user in hosts/*/users.nix).

{ ... }:

{
  imports = [
    ./theme.nix
    ./aliases.nix
    ./cli.nix
    ./git.nix
    ./nvf.nix
    ./packages.nix
  ];
}
