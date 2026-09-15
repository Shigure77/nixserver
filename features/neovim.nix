# Neovim via nvf. Feature imports the upstream HM module itself (colocated).
# Options: https://nvf.notashelf.dev/
{inputs, ...}: {
  flake.homeManagerModules.neovim = {
    imports = [inputs.nvf.homeManagerModules.default];
    programs.nvf = {
      enable = true;
      enableManpages = true;
    };
  };
}
