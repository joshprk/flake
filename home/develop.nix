{
  config,
  lib,
  pkgs,
  ...
}: {
  packages = with pkgs; [
    direnv
    fd
    fzf
    git
    rclone
    ripgrep
  ];

  files.".config/git/config" = {
    generator = (pkgs.formats.toml {}).generate "gitconfig";
    value = {
      init.defaultBranch = "main";
      user.name = "Joshua Park";
      user.email = "git@joshprk.me";
    };
  };

  files.".config/direnv/direnv.toml" = {
    generator = (pkgs.formats.toml {}).generate "direnv-config";
    value = {
      global.disable_stdin = true;
      global.hide_env_diff = true;
      global.warn_timeout = "0ms";
    };
  };

  files.".config/direnv/lib/nix-direnv.sh" = {
    source = "${pkgs.nix-direnv}/share/nix-direnv/direnvrc";
  };

  files.".config/npm/npmrc".text = ''
    prefix=${config.xdg.data.directory}/npm
    cache=${config.xdg.cache.directory}/npm
    init-module=${config.xdg.config.directory}/npm/config/npm-init.js
    logs-dir=${config.xdg.state.directory}/npm/logs
  '';

  shell.init = let
    drive = "$HOME/Drive";
  in ''
    ${lib.getExe pkgs.direnv} hook fish | source

    function webdav
      if not mountpoint -q "${drive}"
        mkdir -p "${drive}"
        ${pkgs.rclone}/bin/rclone mount remote:/ "${drive}" --daemon
      else
        echo "error: webdav is already mounted"
        return 1
      end
    end

    function uwebdav
      if mountpoint -q "${drive}"
        fusermount -u "${drive}"
        rm -rf "${drive}"
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
