# momo: Lenovo ThinkCentre M90q Gen 3 (x86_64) — the desktop host.
{
  config,
  inputs,
  ...
}: {
  flake.nixosConfigurations.momo = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules =
      (with config.flake.nixosModules; [
        server-base
        stylix
        fonts
        desktop
      ])
      ++ [
        inputs.home-manager.nixosModules.home-manager
        inputs.nix-topology.nixosModules.default
        ./_momo/hardware.nix
        {
          networking.hostName = "momo";
          home-manager.users.keion.imports = with config.flake.homeModules; [
            home-base
            shell
            git
            neovim
            desktop-apps
            gh
            qdirstat
            superfile
          ];
        }
      ];
  };
}
