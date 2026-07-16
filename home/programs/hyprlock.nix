{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.hyprlock;
in {
  options.programs.hyprlock = {
    package = lib.mkPackageOption pkgs "hyprlock" {};
  };

  config = {
    packages = [
      cfg.package
    ];

    xdg.config.files."hypr/hyprlock.conf".text = ''
      $font = JetBrainsMono Nerd Font
      $font_color = rgb(230, 230, 225)

      general {
        hide_cursor = false
      }

      animations {
        enabled = true
        bezier = snappy, 0.05, 0.9, 0.1, 1
        animation = fadeIn, 1, 3, snappy
        animation = fadeOut, 1, 3, snappy
        # animation = inputFieldDots, 1, 0, snappy
      }

      background {
        monitor =
        path = ${config.services.hyprpaper.wallpaper}
      }

      input-field {
        monitor =
        size = 12%, 3%
        outline_thickness = 1
        inner_color = rgba(0, 0, 0, 0.0) # no fill

        outer_color = rgba(255, 255, 255, 0.2)
        check_color = rgba(255, 255, 255, 0.45)
        fail_color = rgba(255, 90, 90, 0.5)

        font_color = $font_color
        fade_on_empty = true
        rounding = 100

        font_family = $font
        placeholder_text = <span foreground="##8a8a8a">Password</span>
        fail_text = $PAMFAIL$FPRINTFAIL

        dots_size = 0.2
        dots_spacing = 0.2

        position = 0, -80
        halign = center
        valign = center
      }

      # DATE
      label {
        monitor =
        text = cmd[update:60000] date +"%A, %d %B %Y"
        font_size = 25
        font_family = $font
        color = $font_color

        position = 0, 200
        halign = center
        valign = center
      }

      # TIME
      label {
        monitor =
        text = $TIME
        font_size = 135
        font_family = $font
        color = $font_color

        position = 0, 70
        halign = center
        valign = center
      }
    '';
  };
}
