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
    settings.home.enable = lib.mkForce true;

    programs.niri = {
      enable = true;
      package = pkgs.niri-unstable;
    };
  };
}
