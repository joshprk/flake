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
    modules.services = {
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

    services.flatpak = {
      enable = true;
    };

    services.greetd = let
      session = {
        command = "niri-session 2>/dev/null";
        user = "joshua";
      };
    in {
      enable = true;
      settings = {
        initial_session = session;
        default_session = session;
      };
    };

    services.upower = {
      enable = true;
    };

    security.rtkit = {
      enable = true;
    };

    users = {
      defaultUserShell = pkgs.fish;
    };
  };
}
