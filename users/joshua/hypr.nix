{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.user.hypr;
in {
  options.user = {
    hypr = {
      enable = lib.mkEnableOption "the Hypr configuration";
    };
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        "$MOD" = "SUPER";
        "$LAUNCHER" = "";
        "$TERM" = "ghostty";
        "$SNIP" = lib.concatStrings [
          "pgrep hyprshot && "
          "exit 0 || "
          "hyprshot --freeze --mode=region --raw --clipboard-only | "
          "swappy -f -"
        ];
        "$WEB" = "zen";

        exec-once = [
          "hyprctl setcursor ${builtins.toString config.stylix.cursor.size}"
        ];

        monitor = ", highrr, auto, 1";

        layerrule = [
          "blur, gtk-layer-shell"
          "noanim, selection"
        ];

        general = {
          gaps_in = 5;
          gaps_out = 10;
          resize_on_border = true;
          no_focus_fallback = true;
        };

        decoration = {
          rounding = 5;
          active_opacity = 0.92;
          inactive_opacity = 0.92;
          fullscreen_opacity = 1.00;
          blur.enabled = true;
        };

        input = {
          focus_on_close = 1;
          touchpad = {
            disable_while_typing = false;
            natural_scroll = true;
          };
        };

        gestures = {
          workspace_swipe = true;
        };

        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          focus_on_activate = true;
          vrr = 2;
        };

        ecosystem = {
          no_donation_nag = true;
        };

        experimental = {
          wide_color_gamut = true;
          xx_color_management_v4 = true;
        };

        bind = [
          "$MOD, $MOD_L, exec, $LAUNCHER"
          "$MOD, Q, exec, $TERM"
          ", Print, exec, $SNIP"
          "$MOD, W, exec, $WEB"
          "$MOD, T, togglefloating"
          "$MOD, code:10, workspace, 1"
          "$MOD, code:11, workspace, 2"
          "$MOD, code:12, workspace, 3"
          "$MOD, code:13, workspace, 4"
          "$MOD, code:14, workspace, 5"
          "$MOD, code:15, workspace, 6"
          "$MOD, code:16, workspace, 7"
          "$MOD, code:17, workspace, 8"
          "$MOD, code:18, workspace, 9"
          "$MOD SHIFT, code:10, movetoworkspace, 1"
          "$MOD SHIFT, code:11, movetoworkspace, 2"
          "$MOD SHIFT, code:12, movetoworkspace, 3"
          "$MOD SHIFT, code:13, movetoworkspace, 4"
          "$MOD SHIFT, code:14, movetoworkspace, 5"
          "$MOD SHIFT, code:15, movetoworkspace, 6"
          "$MOD SHIFT, code:16, movetoworkspace, 7"
          "$MOD SHIFT, code:17, movetoworkspace, 8"
          "$MOD SHIFT, code:18, movetoworkspace, 9"
          "$MOD, H, movefocus, l"
          "$MOD, J, movefocus, d"
          "$MOD, K, movefocus, u"
          "$MOD, L, movefocus, r"
          "$MOD SHIFT, H, movewindow, l"
          "$MOD SHIFT, J, movewindow, d"
          "$MOD SHIFT, K, movewindow, u"
          "$MOD SHIFT, L, movewindow, r"
          "$MOD, TAB, cyclenext"
          "$MOD, TAB, bringactivetotop"
          "$MOD, F, fullscreen"
        ];

        binde = [
          "$MOD CTRL, H, resizeactive, -10 0"
          "$MOD CTRL, J, resizeactive, 0 10"
          "$MOD CTRL, K, resizeactive, 0 -10"
          "$MOD CTRL, L, resizeactive, 10 0"
        ];

        bindm = [
          "$MOD, mouse:272, movewindow"
        ];
      };
    };

    services.hypridle = {
      enable = true;
      settings = {
        listener = [
          {
            timeout = 500;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };
  };
}
