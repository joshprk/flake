{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.features;
in {
  options.features = {
    desktop = lib.mkEnableOption "the desktop feature";
  };

  config = lib.mkIf cfg.desktop {
    modules.apps = {
      docker.enable = true;
      flatpak.enable = true;
      niri.enable = true;
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

    zramSwap.enable = true;
  };
}
