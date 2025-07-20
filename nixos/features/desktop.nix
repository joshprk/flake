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
        password = "password";
      };
      defaultUserShell = pkgs.fish;
    };

    zramSwap.enable = true;
  };
}
