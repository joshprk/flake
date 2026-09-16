{pkgs, ...}: {
  xdg.config.files."noctalia/config.toml" = {
    generator = (pkgs.formats.toml {}).generate "noctalia-config";
    value = {
      bar.default.background_opacity = 0.0;
      bar.default.center = [];
      bar.default.end = [
        "tray"
        "media"
        "bluetooth"
        "notifications"
        "clipboard"
        "network"
        "volume"
        "brightness"
        "battery"
        "clock"
      ];
      bar.default.margin_ends = 0;
      bar.default.radius = 0;
      bar.default.start = ["control-center" "launcher"];
      bar.default.widget_spacing = 20;
      idle.behavior_order = ["screen-off" "idle-behavior"];
      idle.behavior."idle-behavior" = {
        action = "lock_and_suspend";
        enabled = true;
        timeout = 900.0;
      };
      idle.behavior."screen-off" = {
        action = "screen_off";
        enabled = true;
        timeout = 600.0;
      };
      location.auto_locate = true;
      # Allows pam_u2f authentication
      lockscreen.allow_empty_password = true;
      shell.button_borders = false;
      shell.card_borders = false;
      shell.corner_radius_scale = 2.0;
      shell.input_borders = false;
      shell.panel = {
        borders = false;
        control_center_placement = "floating";
        control_center_position = "top_right";
        transparency_mode = "solid";
      };
      shell.polkit_agent = true;
      shell.popup_borders = false;
      shell.screen_corners = {
        enabled = true;
        size = 8;
      };
      shell.setup_wizard_enabled = false;
      theme.community_palette = "Paradise";
      theme.source = "community";
      theme.templates.builtin_ids = ["gtk3" "gtk4" "ghostty"];
      wallpaper.default.path = pkgs.fetchurl {
        url = "https://github.com/foxt/macOS-Wallpapers/blob/master/Mojave%20Night.jpg?raw=true";
        hash = "sha256-Zv7uvjSNACpI2Yck22bsA8gwVaju2Yght7y09xko9xw=";
      };
      widget.battery.show_label = false;
      widget.bluetooth.hide_when_no_connected_device = true;
      widget.brightness.show_label = false;
      widget.control-center.interactive = false;
      widget.clock.format = "{:%a %b %-d %-I:%M %p}";
      widget.media.album_art_only = true;
      widget.media.hide_when_no_media = true;
      widget.network.show_label = false;
      widget.volume.show_label = false;
    };
  };
}
