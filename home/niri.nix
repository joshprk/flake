{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}: let
  cfg = config.settings.niri;
in {
  options.settings = {
    niri = {
      enable = lib.mkEnableOption "the Niri home module";
      
      binds = lib.mkOption {
        type = lib.types.attrs;
        default = {};
        description = "Customized binds which are merged non-recursively.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      xwayland-satellite
    ];

    programs.niri.package = osConfig.programs.niri.package;

    programs.niri.settings = {
      prefer-no-csd = true;

      spawn-at-startup = [
        {command = ["${lib.getExe pkgs.xwayland-satellite}"];}
      ];

      environment = {
        DISPLAY = ":0";
      };

      layout = {
        gaps = 8;

        border = {
          enable = true;
          width = 1;
        };

        focus-ring = {
          enable = true;
          width = 1;
        };

        shadow = {
          enable = false;
        };

        tab-indicator = {
          hide-when-single-tab = true;
          place-within-column = true;
        };
      };

      input = {
        focus-follows-mouse.enable = true;
        warp-mouse-to-focus = true;
      };

      window-rules = [
        {
          geometry-corner-radius = let
            corners = ["bottom-left" "bottom-right" "top-left" "top-right"];
            radius = 8.0;
          in
            lib.genAttrs corners (lib.const radius);
          clip-to-geometry = true;
          draw-border-with-background = true;
        }
        {
          matches = [{app-id = "com.mitchellh.ghostty";}];
          default-column-width.proportion = 0.5;
        }
      ];

      binds = with config.lib.niri.actions; {
        "Mod+H".action = focus-column-left;
        "Mod+L".action = focus-column-right;
        "Mod+J".action = focus-window-down;
        "Mod+K".action = focus-window-up;
        "Mod+Shift+H".action = consume-or-expel-window-left;
        "Mod+Shift+L".action = consume-or-expel-window-right;
        "Mod+Shift+J".action = move-window-down-or-to-workspace-down;
        "Mod+Shift+K".action = move-window-up-or-to-workspace-up;
        "Mod+Comma".action = move-column-left;
        "Mod+Period".action = move-column-right;
        "Mod+Home".action = focus-column-first;

        "Mod+1".action = focus-workspace 1;
        "Mod+2".action = focus-workspace 2;
        "Mod+3".action = focus-workspace 3;
        "Mod+4".action = focus-workspace 4;
        "Mod+5".action = focus-workspace 5;
        "Mod+6".action = focus-workspace 6;
        "Mod+7".action = focus-workspace 7;
        "Mod+8".action = focus-workspace 8;
        "Mod+9".action = focus-workspace 9;

        "Mod+Tab".action = toggle-column-tabbed-display;
        "Mod+R".action = switch-preset-column-width;
        "Mod+Shift+R".action = switch-preset-window-height;
        "Mod+Ctrl+R".action = reset-window-height;
        "Mod+F".action = maximize-column;
        "Mod+Shift+F".action = fullscreen-window;
        "Mod+Ctrl+F".action = expand-column-to-available-width;
        "Mod+C".action = center-column;

        "Print".action = screenshot;
      } // cfg.binds;
    };

    programs.swaylock = {
      enable = true;

      settings = {
        color = "000000";
        font-size = 18;

        clock = true;
        timestr = "%R";
        datestr = "%a, %e of %B";

        fade-in = 0.2;

        indicator = true;
        indicator-radius = 240;
        indicator-thickness = 20;
        indicator-idle-visible = false;

        separator-color = "00000000";

        inside-color = "00000099";
        inside-clear-color = "ffd20400";
        inside-caps-lock-color = "009ddc00";
        inside-ver-color = "d9d8d800";
        inside-wrong-color = "ee2e2400";

        ring-color = "231f20D9";
        ring-clear-color = "231f20D9";
        ring-ver-color = "231f20D9";
        ring-wrong-color = "231f20D9";

        line-color = "00000000";
        line-clear-color = "ffd204FF";
        line-caps-lock-color = "009ddcFF";
        line-ver-color = "d9d8d8FF";
        line-wrong-color = "ee2e24FF";

        text-clear-color = "ffd20400";
        text-ver-color = "d9d8d800";
        text-wrong-color = "ee2e2400";

        bs-hl-color = "ee2e24FF";
        caps-lock-key-hl-color = "ffd204FF";
        caps-lock-bs-hl-color = "ee2e24FF";
        text-caps-lock-color = "009ddc";
      };
    };

    services.swayidle = {
      enable = true;

      events = [
        {
          event = "before-sleep";
          command = "${pkgs.swaylock}/bin/swaylock -fF";
        }
      ];

      timeouts = [
        {
          timeout = 500;
          command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
        }
      ];
    };
  };
}
