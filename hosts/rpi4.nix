# Raspberry Pi 4 (aarch64) — headless server.
{
  config,
  inputs,
  ...
}: {
  flake.nixosConfigurations.rpi4 = inputs.nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    modules =
      (with config.flake.nixosModules; [server-base])
      ++ [
        inputs.home-manager.nixosModules.home-manager
        inputs.nix-topology.nixosModules.default
        ./_rpi4/hardware.nix
        {
          networking.hostName = "rpi4";
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
