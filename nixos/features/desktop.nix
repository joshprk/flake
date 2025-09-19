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
        extraGroups = ["wheel"];
        hashedPasswordFile = config.age.secrets.password.path;
      };
      defaultUserShell = pkgs.fish;
    };

    zramSwap.enable = true;
  };
}
