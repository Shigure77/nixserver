{
  description = "NixOS configuration for self-hosted servers (Raspberry Pi 3 B & 4, Lenovo ThinkCentre M90q Gen 3)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-topology = {
      url = "github:oddlama/nix-topology";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, nix-topology, nvf }: let
    # Build a NixOS system for a host (host module lives under hosts/<name>/).
    # system: "aarch64-linux" for Raspberry Pi, "x86_64-linux" for ThinkCentre M90q etc.
    mkSystem = hostName: hostModule: system: nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit nixos-hardware nix-topology nvf; username = "keion"; };
      modules = [
        hostModule
        home-manager.nixosModules.home-manager
        nix-topology.nixosModules.default
        {
          networking.hostName = hostName;
          home-manager.extraSpecialArgs = { inherit nvf; };
          home-manager.sharedModules = [ nvf.homeManagerModules.default ];
        }
      ];
    };
  in {
    nixosConfigurations = {
      rpi3 = mkSystem "rpi3" ./hosts/rpi3 "aarch64-linux";
      rpi4 = mkSystem "rpi4" ./hosts/rpi4 "aarch64-linux";
      m90q = mkSystem "m90q" ./hosts/m90q "x86_64-linux";
    };

    # Build topology: nix build .#topology.config.output (uses current system for pkgs)
    topology = import nix-topology {
      pkgs = import nixpkgs {
        system = builtins.currentSystem;
        overlays = [ nix-topology.overlays.default ];
      };
      modules = [
        { topology.nixosConfigurations = self.nixosConfigurations; }
      ];
    };
  };
}
