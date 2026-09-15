# nix-topology output: `nix build .#topology.config.output`.
# Faithful port of the pre-Dendritic output. Modernization option: switch to
# nix-topology's flake-parts `flakeModule` (perSystem `topology.<system>`).
{
  inputs,
  config,
  ...
}: {
  flake.topology = import inputs.nix-topology {
    pkgs = import inputs.nixpkgs {
      system = builtins.currentSystem;
      overlays = [inputs.nix-topology.overlays.default];
    };
    modules = [
      {topology.nixosConfigurations = config.flake.nixosConfigurations;}
    ];
  };
}
