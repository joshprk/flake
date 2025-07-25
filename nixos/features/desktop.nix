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

    programs.fish = {
      enable = true;
    };

    hjem = {
      users.joshua = {};
    };

    users = {
      users.joshua = {
        isNormalUser = true;
        extraGroups = ["wheel"];
        hashedPasswordFile = config.age.secrets.password.path;
      };
      defaultUserShell = pkgs.fish;
    };

    zramSwap.enable = true;
  };
}
