# flake-parts declares flake.nixosModules but not homeModules; without a
# declaration, definitions from several feature files can't be merged.
{lib, ...}: {
  options.flake.homeModules = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.deferredModule;
    default = {};
    description = "Home-Manager modules, one per feature.";
  };
}
