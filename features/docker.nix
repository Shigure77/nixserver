# Docker daemon + start on boot.
{
  flake.nixosModules.docker = {
    virtualisation.docker = {
      enable = true;
      enableOnBoot = true;
    };
  };
}
