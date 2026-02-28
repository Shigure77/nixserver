# NVF (Neovim), LazyVim-like (Home-Manager module).
# See https://nvf.notashelf.dev/ for more options.

{ config, pkgs, lib, nvf ? null, ... }:

{
  programs.nvf = lib.mkIf (nvf != null) {
    enable = true;
    enableManpages = true;
  };
}
