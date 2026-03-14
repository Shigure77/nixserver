# Core system-wide modules (imported by each host).

{ ... }:

{
  imports = [
    ./boot.nix
    ./nix.nix
    ./packages.nix
    ./openssh.nix
    ./docker.nix
    ./nfs.nix
    ./nixpkgs.nix
    ./users.nix
  ];
}
