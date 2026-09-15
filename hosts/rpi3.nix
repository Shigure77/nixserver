# Raspberry Pi 3 B (aarch64) — headless server.
{
  config,
  inputs,
  ...
}: {
  flake.nixosConfigurations.rpi3 = inputs.nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    modules =
      (with config.flake.nixosModules; [server-base])
      ++ [
        inputs.home-manager.nixosModules.home-manager
        inputs.nix-topology.nixosModules.default
        ./_rpi3/hardware.nix
        {
          networking.hostName = "rpi3";
          home-manager.users.keion.imports = with config.flake.homeManagerModules; [
            home-base
            shell
            git
            neovim
            user-packages
          ];
        }
      ];
  };
}
