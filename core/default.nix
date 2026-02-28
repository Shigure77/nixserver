# Core system-wide modules (imported by each host).

{ ... }:

{
  imports = [
    ./boot.nix
    ./packages.nix
    ./openssh.nix
    ./docker.nix
    ./nfs.nix
    ./nixpkgs.nix
  ];
}
