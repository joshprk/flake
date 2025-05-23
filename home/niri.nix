{
  config,
  lib,
  pkgs,
  nixosConfig,
  ...
}: let
  cfg = config.user.niri;
in {
  options.user.niri = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable the niri home module.";
      default = nixosConfig.modules.niri.enable;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.niri = {
      inherit (nixosConfig.programs.niri) enable package;
      settings = {
        prefer-no-csd = true;

        spawn-at-startup = [
          {command = ["${pkgs.xwayland-satellite}/bin/xwayland-satellite"];}
        ];

        hotkey-overlay.skip-at-startup = true;

        environment = {
          DISPLAY = ":0";
          NIXOS_OZONE_WL = "1";
        };

        layout = {
          gaps = 12;
          always-center-single-column = true;
          border = {
            enable = true;
            width = 1;
          };
          focus-ring = {
            enable = true;
            width = 1;
          };
          shadow = {
            enable = true;
            draw-behind-window = true;
          };
          tab-indicator = {
            position = "left";
            corner-radius = 20.0;
            width = 4.0;
            gap = -9.0;
            gaps-between-tabs = 8.0;
            length.total-proportion = 0.15;
            hide-when-single-tab = true;
            place-within-column = true;
          };
        };

        input = {
          focus-follows-mouse = {
            enable = true;
            max-scroll-amount = "0%";
          };
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

        binds = with config.lib.niri.actions; let
          move-window-to-workspace = idx: {
            spawn = [
              "niri"
              "msg"
              "action"
              "move-window-to-workspace"
              "${builtins.toString idx}"
            ];
          };
        in {
          "Mod+H".action = focus-column-left;
          "Mod+L".action = focus-column-right;
          "Mod+J".action = focus-window-down;
          "Mod+K".action = focus-window-up;
          "Mod+Shift+H".action = move-column-left;
          "Mod+Shift+L".action = move-column-right;
          "Mod+Shift+J".action = move-window-down;
          "Mod+Shift+K".action = move-window-up;
          "Mod+Ctrl+H".action = consume-or-expel-window-left;
          "Mod+Ctrl+L".action = consume-or-expel-window-right;

          "Mod+1".action = focus-workspace 1;
          "Mod+2".action = focus-workspace 2;
          "Mod+3".action = focus-workspace 3;
          "Mod+4".action = focus-workspace 4;
          "Mod+5".action = focus-workspace 5;
          "Mod+6".action = focus-workspace 6;
          "Mod+7".action = focus-workspace 7;
          "Mod+8".action = focus-workspace 8;
          "Mod+9".action = focus-workspace 9;

          "Mod+Shift+1".action = move-window-to-workspace 1;
          "Mod+Shift+2".action = move-window-to-workspace 2;
          "Mod+Shift+3".action = move-window-to-workspace 3;
          "Mod+Shift+4".action = move-window-to-workspace 4;
          "Mod+Shift+5".action = move-window-to-workspace 5;
          "Mod+Shift+6".action = move-window-to-workspace 6;
          "Mod+Shift+7".action = move-window-to-workspace 7;
          "Mod+Shift+8".action = move-window-to-workspace 8;
          "Mod+Shift+9".action = move-window-to-workspace 9;

          "Mod+Tab".action = toggle-overview;
          "Mod+Space".action = toggle-column-tabbed-display;
          "Mod+R".action = switch-preset-column-width;
          "Mod+Shift+R".action = switch-preset-window-height;
          "Mod+Ctrl+R".action = reset-window-height;
          "Mod+F".action = maximize-column;
          "Mod+Shift+F".action = fullscreen-window;
          "Mod+Ctrl+F".action = expand-column-to-available-width;
          "Mod+C".action = center-column;
          "Mod+W".action = close-window;
          "Mod+T".action = toggle-window-floating;
          "Mod+Shift+T".action = switch-focus-between-floating-and-tiling;

          "Ctrl+Alt+L".action.spawn = ["loginctl" "lock-session"];
          "Print".action = screenshot;
          "Mod+Q".action = spawn "ghostty";
        };
      };
    };

    # set certain software to default to not get locked out
    user.ghostty.enable = lib.mkDefault true;
  };
}
