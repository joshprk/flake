{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.settings.niri;
in {
  options.settings = {
    niri = {
      enable = lib.mkEnableOption "the Niri module";
    };
  };

  config = lib.mkIf cfg.enable {
    settings = {
      home = {
        enable = lib.mkForce true;
        enableZsh = lib.mkDefault true;
      };

      networking.enable = lib.mkDefault true;
    };

    programs.niri = {
      enable = true;
      package = pkgs.niri-unstable;
    };

    services.pipewire = {
      enable = true;
      pulse.enable = true;
    };

    services.upower.enable = true;

    systemd.user.services.niri-flake-polkit = {
      serviceConfig.ExecStart =
        lib.mkForce
        "${pkgs.mate.mate-polkit}/libexec/polkit-mate-authentication-agent-1";
    };

    security.pam.services.hyprlock = {};
    security.rtkit.enable = true;
  };
}
