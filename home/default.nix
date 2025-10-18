{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = lib.pipe ./. [
    lib.filesystem.listFilesRecursive
    (lib.filter (path: path != ./default.nix))
  ];

  packages = with pkgs; [
    fd
    fzf
    rclone
    ripgrep
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    settings = {
      global.disable_stdin = true;
      global.hide_env_diff = true;
      global.warn_timeout = "0ms";
    };
  };

  programs.fish = {
    enable = true;
    shellInit = let
      drive = "$HOME/Drive";
    in ''
      function webdav
        if not mountpoint -q "${drive}"
          mkdir -p "${drive}"
          ${pkgs.rclone}/bin/rclone mount remote:/ "${drive}" \
            --vfs-cache-mode full \
            --daemon
        else
          echo "error: webdav is already mounted"
          return 1
        end
      end

      function uwebdav
        if mountpoint -q "${drive}"
          fusermount -u "${drive}"
        end
      end

      function today
        if mountpoint -q "${drive}"
          "$EDITOR" "${drive}/notes/$(date +%F).md"
        else
          echo "error: mount webdav before opening notes"
          return 1
        end
      end
    '';
  };

  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "main";
      user.name = "Joshua Park";
      user.email = "git@joshprk.me";
    };
  };

  programs.ghostty = {
    enable = true;
    settings = {
      auto-update = "off";
      font-family = "JetBrainsMono Nerd Font";
      font-size = 10.5;
      quit-after-last-window-closed = true;
      theme = "Catppuccin Mocha";
      window-padding-color = "extend";
      window-padding-x = 4;
      window-padding-y = 4;
    };
  };

  programs.vicinae = {
    enable = true;
    settings = {
      faviconService = "twenty";
      font = {
        size = 10;
      };
      popToRootOnClose = true;
      rootSearch = {
        searchFiles = false;
      };
      theme = {
        name = "vicinae-dark";
      };
      window = {
        csd = true;
        opacity = 0.95;
        rounding = 10;
      };
    };
  };
 
  services.hyprpaper = {
    enable = true;
  };

  gtk = {
    enable = true;
    settings = {
      gtk-theme-name = "Adwaita-dark";
      gtk-application-prefer-dark-theme = true;
    };
  };

  files.".config/npm/npmrc".text = ''
    prefix=${config.xdg.data.directory}/npm
    cache=${config.xdg.cache.directory}/npm
    init-module=${config.xdg.config.directory}/npm/config/npm-init.js
    logs-dir=${config.xdg.state.directory}/npm/logs
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

  environment.sessionVariables = {
    CARGO_HOME = "${config.xdg.data.directory}/cargo";
    GOPATH = "${config.xdg.data.directory}/go";
    GOMODCACHE = "${config.xdg.cache.directory}/go/mod";
    KUBECACHEDIR = "${config.xdg.cache.directory}/kube";
    KUBECONFIG = "${config.xdg.config.directory}/kubeconfig";
    TALOSCONFIG = "${config.xdg.config.directory}/talos/config";
    PYTHON_HISTORY = "${config.xdg.state.directory}/python_history";
    NPM_CONFIG_USERCONFIG = "${config.xdg.config.directory}/npm/npmrc";
    NODE_REPL_HISTORY = "${config.xdg.data.directory}/node_repl_history";
    RUSTUP_HOME = "${config.xdg.data.directory}/rustup";
  };
}
