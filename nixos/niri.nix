{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.niri;
in {
  options.modules.niri = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable the niri module.";
      default = false;
    };

    package = lib.mkOption {
      type = lib.types.package;
      description = "The niri package to use.";
      default = pkgs.niri-unstable;
    };

    gnome-keyring = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable the Gnome Keyring";
      default = false;
    };

    polkit.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable polkit in the niri module.";
      default = true;
    };

    polkit.command = lib.mkOption {
      type = lib.types.str;
      description = "The command to use to start polkit.";
      default = "${pkgs.mate.mate-polkit}/libexec/polkit-mate-authentication-agent-1";
    };
  };

  config = lib.mkIf cfg.enable {
    # Sensible and minimal defaults for sodiboo/niri-flake
    modules.home.interactive = lib.mkDefault true;
    programs.niri.enable = true;

    services.gnome.gnome-keyring.enable = lib.mkForce cfg.gnome-keyring;
    security.polkit.enable = lib.mkForce cfg.polkit.enable;

    systemd.user.services.niri-flake-polkit = {
      enable = lib.mkForce cfg.polkit.enable;
      serviceConfig.ExecStart = lib.mkForce cfg.polkit.command;
    };

    services.pipewire = {
      enable = true;
      pulse.enable = true;
    };

    services.upower.enable = lib.mkDefault true;

    security.rtkit.enable = true;
    networking.networkmanager.enable = lib.mkDefault true;
  };
}
