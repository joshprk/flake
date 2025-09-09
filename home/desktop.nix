{
  config,
  lib,
  pkgs,
  ...
}: {
  packages = with pkgs; [
    ghostty
    hypridle
    hyprpaper
    xwayland-satellite
  ];

  files.".config/niri/config.kdl".text = ''
    environment {
      ELECTRON_OZONE_PLATFORM_HINT "wayland"
    }

    spawn-at-startup "hypridle"
    spawn-at-startup "hyprpaper"

    screenshot-path "~/Pictures/screenshot-%Y-%m-%d-at-%H-%M.png"

    input {
      touchpad {
        tap
        dwt
        natural-scroll
      }

      warp-mouse-to-focus mode="center-xy"
      focus-follows-mouse max-scroll-amount="0%"
    }

    layout {
      gaps 16
      center-focused-column "never"
      always-center-single-column

      struts {
        left 16
        right 16
        top 16
        bottom 16
      }

      preset-column-widths {
        proportion 0.33333
        proportion 0.50000
        proportion 0.66667
      }

      default-column-width {
        proportion 0.5;
      }

      border {
        width 1
        active-color "#505050"
        inactive-color "#505050"
        urgent-color "#505050"
      }

      focus-ring {
        off
      }

      shadow {
        on
        softness 30
        spread 5
        offset x=0 y=5
        draw-behind-window false
        color "#0007"
      }

      background-color "transparent"
    }

    layer-rule {
      match namespace="^hyprpaper$"
      place-within-backdrop true
    }

    window-rule {
      match app-id=r#"firefox$"# title="^Picture-in-Picture$"
      open-floating true
    }

    window-rule {
      tiled-state true
      geometry-corner-radius 12
      clip-to-geometry true
      draw-border-with-background false
      opacity 0.95
    }

    binds {
      Mod+Shift+Slash { show-hotkey-overlay; }
      Mod+T { spawn "ghostty"; }
      XF86AudioRaiseVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+"; }
      XF86AudioLowerVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-"; }
      XF86AudioMute allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
      XF86AudioMicMute allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"; }
      Mod+O repeat=false { toggle-overview; }
      Mod+Left { focus-column-left; }
      Mod+Down { focus-window-down; }
      Mod+Up { focus-window-up; }
      Mod+Right { focus-column-right; }
      Mod+H { focus-column-left; }
      Mod+J { focus-window-down; }
      Mod+K { focus-window-up; }
      Mod+L { focus-column-right; }
      Mod+Shift+Left { move-column-left; }
      Mod+Shift+Down { move-window-down; }
      Mod+Shift+Up { move-window-up; }
      Mod+Shift+Right { move-column-right; }
      Mod+Shift+H { move-column-left; }
      Mod+Shift+J { move-window-down; }
      Mod+Shift+K { move-window-up; }
      Mod+Shift+L { move-column-right; }
      Mod+Home { focus-column-first; }
      Mod+End { focus-column-last; }
      Mod+Ctrl+Home { move-column-to-first; }
      Mod+Ctrl+End { move-column-to-last; }
      Mod+Ctrl+Left { focus-monitor-left; }
      Mod+Ctrl+Down { focus-monitor-down; }
      Mod+Ctrl+Up { focus-monitor-up; }
      Mod+Ctrl+Right { focus-monitor-right; }
      Mod+Ctrl+H { focus-monitor-left; }
      Mod+Ctrl+J { focus-monitor-down; }
      Mod+Ctrl+K { focus-monitor-up; }
      Mod+Ctrl+L { focus-monitor-right; }
      Mod+Shift+Ctrl+Left { move-column-to-monitor-left; }
      Mod+Shift+Ctrl+Down { move-column-to-monitor-down; }
      Mod+Shift+Ctrl+Up { move-column-to-monitor-up; }
      Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }
      Mod+Shift+Ctrl+H { move-column-to-monitor-left; }
      Mod+Shift+Ctrl+J { move-column-to-monitor-down; }
      Mod+Shift+Ctrl+K { move-column-to-monitor-up; }
      Mod+Shift+Ctrl+L { move-column-to-monitor-right; }
      Mod+Page_Down { focus-workspace-down; }
      Mod+Page_Up { focus-workspace-up; }
      Mod+U { focus-workspace-down; }
      Mod+I { focus-workspace-up; }
      Mod+Ctrl+Page_Down { move-column-to-workspace-down; }
      Mod+Ctrl+Page_Up { move-column-to-workspace-up; }
      Mod+Ctrl+U { move-column-to-workspace-down; }
      Mod+Ctrl+I { move-column-to-workspace-up; }
      Mod+Shift+Page_Down { move-workspace-down; }
      Mod+Shift+Page_Up { move-workspace-up; }
      Mod+Shift+U { move-workspace-down; }
      Mod+Shift+I { move-workspace-up; }
      Mod+WheelScrollDown cooldown-ms=150 { focus-workspace-down; }
      Mod+WheelScrollUp cooldown-ms=150 { focus-workspace-up; }
      Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
      Mod+Ctrl+WheelScrollUp cooldown-ms=150 { move-column-to-workspace-up; }
      Mod+WheelScrollRight { focus-column-right; }
      Mod+WheelScrollLeft { focus-column-left; }
      Mod+Ctrl+WheelScrollRight { move-column-right; }
      Mod+Ctrl+WheelScrollLeft { move-column-left; }
      Mod+Shift+WheelScrollDown { focus-column-right; }
      Mod+Shift+WheelScrollUp { focus-column-left; }
      Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }
      Mod+Ctrl+Shift+WheelScrollUp { move-column-left; }
      Mod+1 { focus-workspace 1; }
      Mod+2 { focus-workspace 2; }
      Mod+3 { focus-workspace 3; }
      Mod+4 { focus-workspace 4; }
      Mod+5 { focus-workspace 5; }
      Mod+6 { focus-workspace 6; }
      Mod+7 { focus-workspace 7; }
      Mod+8 { focus-workspace 8; }
      Mod+9 { focus-workspace 9; }
      Mod+Shift+1 { move-column-to-workspace 1; }
      Mod+Shift+2 { move-column-to-workspace 2; }
      Mod+Shift+3 { move-column-to-workspace 3; }
      Mod+Shift+4 { move-column-to-workspace 4; }
      Mod+Shift+5 { move-column-to-workspace 5; }
      Mod+Shift+6 { move-column-to-workspace 6; }
      Mod+Shift+7 { move-column-to-workspace 7; }
      Mod+Shift+8 { move-column-to-workspace 8; }
      Mod+Shift+9 { move-column-to-workspace 9; }
      Mod+BracketLeft { consume-or-expel-window-left; }
      Mod+BracketRight { consume-or-expel-window-right; }
      Mod+Comma { consume-window-into-column; }
      Mod+Period { expel-window-from-column; }
      Mod+R { switch-preset-column-width; }
      Mod+Shift+R { switch-preset-window-height; }
      Mod+Ctrl+R { reset-window-height; }
      Mod+F { maximize-column; }
      Mod+Shift+F { fullscreen-window; }
      Mod+Ctrl+F { expand-column-to-available-width; }
      Mod+C { center-column; }
      Mod+Ctrl+C { center-visible-columns; }
      Mod+Minus { set-column-width "-10%"; }
      Mod+Equal { set-column-width "+10%"; }
      Mod+Shift+Minus { set-window-height "-10%"; }
      Mod+Shift+Equal { set-window-height "+10%"; }
      Mod+V { toggle-window-floating; }
      Mod+Shift+V { switch-focus-between-floating-and-tiling; }
      Mod+W { toggle-column-tabbed-display; }
      Print { screenshot; }
      Ctrl+Print { screenshot-screen; }
      Alt+Print { screenshot-window; }
      Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }
      Mod+Shift+E { quit; }
      Ctrl+Alt+Delete { quit; }
      Mod+Shift+P { power-off-monitors; }
    }
  '';

  files.".config/ghostty/config" = {
    generator = (pkgs.formats.keyValue {
      listsAsDuplicateKeys = true;
      mkKeyValue = lib.generators.mkKeyValueDefault {} " = ";
    }).generate "ghostty-config";
    value = {
      font-family = "Lilex Nerd Font";
      font-size = 11;
      window-padding-color = "extend";
      window-padding-x = 4;
      window-padding-y = 4;
    };
  };

  files.".config/hypr/hypridle.conf".text = ''
    listener {
      timeout = 500
      on-timeout = niri msg action power-off-monitors
    }
  '';

  files.".config/hypr/hyprpaper.conf".text = let
    wallpaper = pkgs.fetchurl {
      url = "https://github.com/foxt/macOS-Wallpapers/blob/master/Mojave%20Night.jpg?raw=true";
      hash = "sha256-Zv7uvjSNACpI2Yck22bsA8gwVaju2Yght7y09xko9xw=";
    };
  in ''
    preload = ${wallpaper}
    wallpaper = , ${wallpaper}
  '';

  files.".config/mimeapps.list".text = ''
    [Default Applications]
    text/html=org.mozilla.firefox.desktop
    x-scheme-handler/http=org.mozilla.firefox.desktop
    x-scheme-handler/https=org.mozilla.firefox.desktop
    x-scheme-handler/about=org.mozilla.firefox.desktop
    x-scheme-handler/unknown=org.mozilla.firefox.desktop
    application/pdf=org.mozilla.firefox.desktop
  '';
}
