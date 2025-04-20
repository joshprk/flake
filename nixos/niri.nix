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

    services.displayManager.ly = {
      enable = true;
    };

    services.pipewire = {
      enable = true;
      pulse.enable = true;
    };

    security.pam.services.hyprlock = {};
    security.rtkit.enable = true;
  };
}
