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

      hotkey-overlay = {
        skip-at-startup = true;
      };

      environment = {
        DISPLAY = ":0";
        NIXOS_OZONE_WL = "1";
      };

      layout = {
        gaps = 8;
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
          matches = [
            {app-id = "com.mitchellh.ghostty";}
          ];

          default-column-width.proportion = 0.5;
        }
        {
          matches = [
            {app-id = "polkit-mate-authentication-agent-1";}
            {app-id = "Rofi";}
          ];

          open-floating = true;
          open-focused = true;
        }
        {
          matches = [
            {
              app-id = "firefox$";
              title = "^Picture-in-Picture$";
            }
          ];

          open-floating = true;

          default-floating-position = {
            x = 32;
            y = 32;
            relative-to = "top-right";
          };
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
        "Mod+Ctrl+H".action = move-column-left;
        "Mod+Ctrl+L".action = move-column-right;
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

        "Mod+Tab".action = toggle-overview;
        "Mod+Shift+Tab".action = toggle-column-tabbed-display;
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

        "Print".action = screenshot;
        "Ctrl+Alt+L".action.spawn = ["loginctl" "lock-session"];
        "Mod+Super_L".action.spawn = ["sh" "-c" "pkill rofi || rofi -show drun"];

        /*
        "XF86MonBrightnessUp".action.spawn = swayosd "--brightness=raise";
        "XF86MonBrightnessDown".action.spawn = swayosd "--brightness=lower";
        "XF86AudioLowerVolume".action.spawn = swayosd "--output-volume=lower";
        "XF86AudioRaiseVolume".action.spawn = swayosd "--output-volume=raise";
        "XF86AudioMute".action.spawn = swayosd "--output-volume=mute-toggle";
        */
      } // cfg.binds;
    };

    programs.hyprlock = {
      enable = true;
      
      settings = {
        general = {
          hide_cursor = true;
        };

        background = [
          {color = "rgb(0, 0, 0)";}
        ];

        input-field = [
          {
            monitor = "";
            size = "200, 50";
            position = "0, -80";
            dots_center = true;
            fade_on_empty = false;
            font_color = "rgb(255, 255, 255)";
            font_family = "Inter";
            inner_color = "rgb(0, 0, 0)";
            outer_color = "rgb(255, 255, 255)";
            rounding = 8;
            outline_thickness = 2;
            placeholder_text = "";
          }
        ];

        label = [
          {
            monitor = "";
            text = ''cmd[update:30000] echo "$TIME12"'';
            color = "rgb(255, 255, 255)";
            position = "0, 40";
            font_size = 32;
            font_family = "Inter";
            halign = "center";
            valign = "center";
          }
        ];
      };
    };

    programs.rofi = {
      enable = true;
    };

    services.hyprpaper = {
      enable = true;
    };

    services.hypridle = {
      enable = true;

      settings = {
        general = {
          before_sleep_command = "loginctl lock-session";
          lock_cmd = "pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
        };

        listener = [
          {
            timeout = 300;
            on-timeout = "${pkgs.niri}/bin/niri msg action power-off-monitors";
          }
          {
            timeout = 300;
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 480;
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };

    services.dunst = {
      enable = true;
    };

    # WALLPAPER: KDE Darkest Hour
    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/tomorrow-night.yaml";

      image = pkgs.fetchurl {
        url = "https://github.com/KDE/plasma-workspace-wallpapers/blob/master/DarkestHour/contents/images/2560x1600.jpg?raw=true";
        sha256 = "sha256-jjcD+uOjwhex/Cs5m3Bs03IFhCaNBxuhU+SAnapV8c4=";
      };

      fonts = {
        sansSerif = {
          package = pkgs.inter;
          name = "Inter";
        };

        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font";
        };

        serif = config.stylix.fonts.sansSerif;
        emoji = config.stylix.fonts.sansSerif;
      };

      cursor = {
        name = "catppuccin-mocha-dark-cursors";
        package = pkgs.catppuccin-cursors.mochaDark;
        size = 24;
      };

      iconTheme = {
        enable = true;
        package = pkgs.candy-icons;
        light = "candy-icons";
        dark = "candy-icons";
      };

      targets = {
        firefox.profileNames = ["default"];

        hyprlock.enable = false;
        nixvim.enable = false;
      };
    };

    home.file = {
      ".themes/adw-gtk3".enable = false;
      ".icons/${config.stylix.cursor.name}".enable = false;
      ".icons/default/index.theme".enable = false;
    };

    gtk.gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    xresources.path = "${config.xdg.configHome}/X11/xresources";
  };
}
