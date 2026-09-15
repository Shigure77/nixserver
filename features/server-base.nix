# Bundle: the shared baseline every homelab host gets. Hosts select this by name.
{config, ...}: {
  flake.nixosModules.server-base.imports = with config.flake.nixosModules; [
    boot
    nix-settings
    nixpkgs
    openssh
    docker
    nfs
    users
    server-packages
  ];
}
