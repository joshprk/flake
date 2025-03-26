{
  config,
  lib,
  ...
}: let
  cfg = config.user.waybar;
in {
  options.user = {
    waybar = {
      enable = lib.mkEnableOption "the Waybar home module";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 30;
          modules-left = [];
          modules-center = [];
          modules-right = [];
        };
      };

      style = ''
        window#waybar {
          font-family: "Inter";
          font-size: 12px;
          background: transparent;
          border: none;
          color: @theme_text_color;
          background: alpha(@theme_base_color, 0.1);
        }
      '';
    };
  };
}
