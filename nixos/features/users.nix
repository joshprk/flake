{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.features;
in {
  options.features = {
    users = lib.mkEnableOption "the users feature";
  };

  config = lib.mkIf cfg.users {
    modules.apps = {
      docker.enable = true;
    };

    modules.system = {
      kernel.package = pkgs.linuxPackages_zen;
    };

    environment.shellAliases = {
      l = "ls -alh --group-directories-first";
      ll = "ls -l --group-directories-first";
      ls = "ls --color=tty --group-directories-first";
    };

    programs.fish = {
      enable = true;
    };

    hjem = {
      users.josh = {};
    };

    users = {
      users.root = {
        hashedPasswordFile = config.age.secrets.password.path;
      };

      users.josh = {
        isNormalUser = true;
        extraGroups = ["wheel"] ++ lib.optionals config.modules.apps.docker.enable ["docker"];
        hashedPasswordFile = config.age.secrets.password.path;
      };
      defaultUserShell = pkgs.fish;
    };
  };
}
