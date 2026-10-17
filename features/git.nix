# Git user config.
{
  flake.homeModules.git = {
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
