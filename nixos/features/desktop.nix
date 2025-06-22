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
    modules.services = {
      niri.enable = true;
    };

    modules.system = {
      kernel.package = pkgs.linuxPackages_zen;
    };

    programs.fish = {
      enable = true;
    };

    users = {
      users.joshua = {
        isNormalUser = true;
        extraGroups = ["wheel"];
        hashedPasswordFile = config.age.secrets.password.path;
      };

      defaultUserShell = pkgs.fish;
    };
  };
}
