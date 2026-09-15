# Home-Manager baseline. stateVersion is a compatibility lock — set once, leave.
{
  flake.homeManagerModules.home-base = {
    home.stateVersion = "24.11";
  };
}
