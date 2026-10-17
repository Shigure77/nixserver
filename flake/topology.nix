# nix-topology output per system: `nix build .#topology.x86_64-linux.config.output`.
# Per-system (not builtins.currentSystem) because flake evaluation is pure.
{
  inputs,
  config,
  lib,
  ...
}: {
  flake.topology = lib.genAttrs config.systems (system:
    import inputs.nix-topology {
      pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [inputs.nix-topology.overlays.default];
      };
      modules = [
        {topology.nixosConfigurations = config.flake.nixosConfigurations;}
      ];
    });
}
