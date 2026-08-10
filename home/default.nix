{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./dconf.nix
  ];

  packages = with pkgs; [
    llm-agents.codex
    direnv
    fish
    git
    ripgrep
    (nvf {
      vim.options.expandtab = true;
      vim.options.shiftwidth = 2;
      vim.options.tabstop = 2;
    })
  ];

  environment.sessionVariables = {
    CODEX_HOME = "${config.xdg.data.directory}/codex";
    EDITOR = "nvim";
  };

  xdg.config.files = {
    "direnv/direnv.toml" = {
      generator = (pkgs.formats.toml {}).generate "direnv-config";
      value = {
        global.disable_stdin = true;
        global.hide_env_diff = true;
        global.warn_timeout = "0ms";
      };
    };
    "direnv/lib/nix-direnv.sh".source = "${pkgs.nix-direnv}/share/nix-direnv/direnvrc";
    "fish/conf.d/10-environment.fish".text =
      lib.concatMapAttrsStringSep "\n"
      (n: v: "set -gx ${lib.escapeShellArg n} ${lib.escapeShellArg (toString v)}")
      config.environment.sessionVariables;
    "fish/config.fish".text = ''
      if status is-interactive
        ${lib.getExe pkgs.direnv} hook fish | source
      end
    '';
    "git/config" = {
      generator = (pkgs.formats.gitIni {}).generate "gitconfig";
      value = {
        init.defaultBranch = "main";
        user.name = "Joshua Park";
        user.email = "git@joshprk.me";
      };
    };
    "ghostty/config" = {
      generator = (pkgs.formats.keyValue {
        listsAsDuplicateKeys = true;
        mkKeyValue = lib.generators.mkKeyValueDefault {} " = ";
      }).generate "ghostty-config";
      value = {
        font-family = "IBM Plex Mono";
        font-size = 9;
        theme = "noctalia";
      };
    };
    "noctalia/config.toml" = {
      generator = (pkgs.formats.toml {}).generate "noctalia-config";
      value = {
        # Allows pam_u2f authentication
        bar.default.background_opacity = 0.5;
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
          "session"
          "clock"
        ];
        bar.default.margin_ends = 0;
        bar.default.radius = 0;
        bar.default.start = ["control-center" "launcher" "workspaces"];
        bar.default.widget_spacing = 12;
        idle.behavior."screen-off" = {
          action = "screen_off";
          enabled = true;
          timeout = 660.0;
        };
        lockscreen.allow_empty_password = true;
        shell.button_borders = false;
        shell.card_borders = false;
        shell.corner_radius_scale = 0.5;
        shell.input_borders = false;
        shell.panel.transparency_mode = "glass";
        shell.polkit_agent = true;
        shell.popup_borders = false;
        shell.setup_wizard_enabled = false;
        theme.community_palette = "Paradise";
        theme.source = "community";
        theme.templates.builtin_ids = ["gtk3" "gtk4" "ghostty" "niri"];
        wallpaper.default.path = pkgs.fetchurl {
          url = "https://github.com/foxt/macOS-Wallpapers/blob/master/Mojave%20Night.jpg?raw=true";
          hash = "sha256-Zv7uvjSNACpI2Yck22bsA8gwVaju2Yght7y09xko9xw=";
        };
        widget.battery.show_label = false;
        widget.bluetooth.hide_when_no_connected_device = true;
        widget.brightness.show_label = false;
        widget.clock.format = "{:%a %b %-d %-I:%M %p}";
        widget.media.album_art_only = true;
        widget.media.hide_when_no_media = true;
        widget.network.show_label = false;
        widget.volume.show_label = false;
      };
    };
    "niri/config.kdl".source = ./files/niri.kdl;
    "Yubico/u2f_keys".source = ./files/u2f_keys;
  };
}
