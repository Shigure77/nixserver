# `nix fmt` -> alejandra (authoritative formatter).
{
  perSystem = {pkgs, ...}: {
    formatter = pkgs.alejandra;
  };
}
