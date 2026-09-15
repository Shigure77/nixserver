# Git user config.
{
  flake.homeManagerModules.git = {
    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "Keion";
          email = "keioncollins@gmail.com";
        };
        init.defaultBranch = "main";
        pull.rebase = false;
      };
    };
  };
}
