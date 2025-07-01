{
  config,
  lib,
  pkgs,
  flake,
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
      home.joshua = {
        isNormalUser = true;
        extraGroups = ["wheel"];
        hashedPasswordFile = config.age.secrets.password.path;
      };
    };

    modules.system = {
      kernel.package = pkgs.linuxPackages_zen;
    };

    programs.fish = {
      enable = true;
    };

    users = {
      defaultUserShell = pkgs.fish;
    };
  };
}
