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
    waybar
  ];

  dotfiles.".config/niri/config.kdl".text = ''
    environment {
      DISPLAY ":0"
      ELECTRON_OZONE_PLATFORM_HINT "wayland"
    }

    spawn-at-startup "hypridle"
    spawn-at-startup "hyprpaper"
    spawn-at-startup "waybar"
    spawn-at-startup "xwayland-satellite"

    screenshot-path "~/Pictures/screenshot-%Y-%m-%d-at-%H-%M.png"

    input {
      touchpad {
        tap
        dwt
        natural-scroll
      }
    }

    layout {
      gaps 16
      center-focused-column "never"

      preset-column-widths {
        proportion 0.3333333
        proportion 0.5000000
        proportion 0.6666666
      }

      default-column-width {
        proportion 0.5;
      }

      focus-ring {
        width 1
        active-color "#7fc8ff"
        inactive-color "#505050"
      }

      shadow {
        softness 30
        spread 5
        offset x=0 y=5
        color "#0007"
      }
    }

    window-rule {
      match app-id=r#"firefox$"# title="^Picture-in-Picture$"
      open-floating true
    }

    window-rule {
      geometry-corner-radius 14
      clip-to-geometry true
    }

    binds {
      Mod+Shift+Slash { show-hotkey-overlay; }
      Mod+Q { spawn "ghostty"; }
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

  dotfiles.".config/hypr/hypridle.conf".text = ''
    listener {
      timeout = 500
      on-timeout = niri msg action power-off-monitors
    }
  '';

  dotfiles.".config/hypr/hyprpaper.conf".text = let
    wallpaper = pkgs.fetchurl {
      url = "https://media.githubusercontent.com/media/pop-os/cosmic-wallpapers/189c2c63d31da84ebb161acfd21a503f98a1b4c7/original/orion_nebula_nasa_heic0601a.jpg";
      hash = "sha256-dQD3AvBIjUqN8sWr63ypEHp8p5mOBEFyfLr3lGWwI4g=";
    };
  in ''
    preload = ${wallpaper}
    wallpaper = , ${wallpaper}
  '';

  dotfiles.".config/waybar/config" = {
    generator = (pkgs.formats.json {}).generate "waybar-config";
    value = {
      layer = "top";
      modules-left = ["niri/workspaces"];
      modules-right = ["tray" "battery" "clock"];
    };
  };

  dotfiles.".config/waybar/style.css".text = ''
    /* Base Variables */
    * {
        font-family: "Inter", system-ui, sans-serif;
        font-size: 13px;
        font-weight: 400;
        min-height: 0;
        border: none;
        border-radius: 0;
    }

    /* Main Window */
    window#waybar {
        background: rgba(24, 25, 28, 0.85);
        color: #ffffff;
        border-bottom: 1px solid rgba(255, 255, 255, 0.08);
        box-shadow: 0 1px 8px rgba(0, 0, 0, 0.3);
    }

    /* Module Base Classes */
    .module {
        padding: 4px 12px;
        margin: 0;
        background: transparent;
        color: rgba(255, 255, 255, 0.9);
        transition: all 0.2s ease;
    }

    .module:hover {
        background: rgba(255, 255, 255, 0.05);
        color: #ffffff;
    }

    .module-accent {
        color: #0969da;
    }

    .module-warning {
        color: #fb8500;
    }

    .module-critical {
        color: #dc3545;
    }

    .module-success {
        color: #28a745;
    }

    .module-separator {
        border-right: 1px solid rgba(255, 255, 255, 0.06);
    }

    /* Workspaces */
    #workspaces {
        background: transparent;
        margin: 0;
        padding: 0;
    }

    #workspaces button {
        padding: 4px 10px;
        margin: 0;
        background: transparent;
        color: rgba(255, 255, 255, 0.6);
        border: none;
        transition: all 0.2s ease;
        font-weight: 500;
    }

    #workspaces button:hover {
        background: rgba(255, 255, 255, 0.05);
        color: rgba(255, 255, 255, 0.8);
    }

    #workspaces button.active {
        background: rgba(9, 105, 218, 0.1);
        color: #0969da;
        border-bottom: 2px solid #0969da;
    }

    #workspaces button.urgent {
        background: rgba(220, 53, 69, 0.1);
        color: #dc3545;
        border-bottom: 2px solid #dc3545;
    }

    /* Left Modules */
    #custom-launcher {
        padding: 4px 12px;
        color: rgba(255, 255, 255, 0.9);
        font-size: 14px;
        font-weight: 500;
    }

    #custom-launcher:hover {
        color: #0969da;
    }

    /* Center Modules */
    #clock {
        padding: 4px 18px;
        color: #ffffff;
        font-weight: 500;
        font-size: 14px;
    }

    #clock:hover {
        color: #0969da;
    }

    /* Right Modules */
    #tray {
        padding: 4px 8px;
    }

    #tray > .passive {
        color: rgba(255, 255, 255, 0.6);
    }

    #tray > .active {
        color: #ffffff;
    }

    #tray > .urgent {
        color: #dc3545;
    }

    /* System Modules */
    #cpu {
        padding: 4px 10px;
        color: rgba(255, 255, 255, 0.8);
    }

    #cpu.warning {
        color: #fb8500;
    }

    #cpu.critical {
        color: #dc3545;
    }

    #memory {
        padding: 4px 10px;
        color: rgba(255, 255, 255, 0.8);
    }

    #memory.warning {
        color: #fb8500;
    }

    #memory.critical {
        color: #dc3545;
    }

    #temperature {
        padding: 4px 10px;
        color: rgba(255, 255, 255, 0.8);
    }

    #temperature.critical {
        color: #dc3545;
    }

    /* Battery */
    #battery {
        padding: 4px 10px;
        color: rgba(255, 255, 255, 0.8);
    }

    #battery.charging {
        color: #28a745;
    }

    #battery.warning:not(.charging) {
        color: #fb8500;
    }

    #battery.critical:not(.charging) {
        color: #dc3545;
        animation: blink 1s linear infinite alternate;
    }

    @keyframes blink {
        to { color: rgba(220, 53, 69, 0.5); }
    }

    /* Network */
    #network {
        padding: 4px 10px;
        color: rgba(255, 255, 255, 0.8);
    }

    #network.disconnected {
        color: #dc3545;
    }

    #network.wifi {
        color: #0969da;
    }

    #network.ethernet {
        color: #28a745;
    }

    /* Audio */
    #pulseaudio {
        padding: 4px 10px;
        color: rgba(255, 255, 255, 0.8);
    }

    #pulseaudio.muted {
        color: rgba(255, 255, 255, 0.4);
    }

    #pulseaudio:hover {
        color: #0969da;
    }

    /* Backlight */
    #backlight {
        padding: 4px 10px;
        color: rgba(255, 255, 255, 0.8);
    }

    #backlight:hover {
        color: #0969da;
    }

    /* Custom Modules */
    #custom-notification {
        padding: 4px 10px;
        color: rgba(255, 255, 255, 0.8);
    }

    #custom-notification.notification {
        color: #0969da;
    }

    #custom-power {
        padding: 4px 12px;
        color: rgba(255, 255, 255, 0.8);
        font-weight: 500;
    }

    #custom-power:hover {
        color: #dc3545;
    }

    /* Tooltips */
    tooltip {
        border-radius: 6px;
        background: rgba(24, 25, 28, 0.95);
        color: #ffffff;
        border: 1px solid rgba(255, 255, 255, 0.1);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.4);
        padding: 8px 12px;
        font-size: 12px;
    }

    tooltip label {
        color: #ffffff;
    }

    /* Module Grouping */
    .modules-left {
        margin-left: 0;
    }

    .modules-center {
        margin: 0;
    }

    .modules-right {
        margin-right: 0;
    }

    /* Separators between module groups */
    .modules-left > *:last-child {
        border-right: 1px solid rgba(255, 255, 255, 0.06);
        margin-right: 8px;
    }

    .modules-center {
        margin: 0 8px;
    }

    /* Hover Effects */
    .module:hover {
        background: rgba(255, 255, 255, 0.05);
        transition: background 0.2s ease;
    }

    /* Focus/Active States */
    .module:focus,
    .module.active {
        background: rgba(9, 105, 218, 0.1);
        color: #0969da;
    }
  '';
}
