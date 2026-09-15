# Lenovo ThinkCentre M90q Gen 3 (x86_64) — the desktop host.
{
  config,
  inputs,
  ...
}: {
  flake.nixosConfigurations.m90q = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules =
      (with config.flake.nixosModules; [
        server-base
        theme
        desktop
      ])
      ++ [
        inputs.home-manager.nixosModules.home-manager
        inputs.stylix.nixosModules.stylix
        inputs.nix-topology.nixosModules.default
        ./_m90q/hardware.nix
        {
          networking.hostName = "m90q";
          home-manager.users.keion.imports = with config.flake.homeManagerModules; [
            home-base
            shell
            git
            neovim
            user-packages
            theme
            desktop-apps
          ];
        }
      ];
  };
}
