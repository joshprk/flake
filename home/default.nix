{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./modules/dconf.nix
    ./direnv.nix
    ./fish.nix
    ./ghostty.nix
    ./git.nix
    ./noctalia.nix
    ./nvf.nix
  ];

  packages = with pkgs; [
    codex
    gh
    ripgrep
    tree
    wl-clipboard
    zmx
  ];

  environment.sessionVariables = {
    BUN_INSTALL = "${config.xdg.data.directory}/bun";
    BUN_INSTALL_CACHE_DIR = "${config.xdg.cache.directory}/bun";
    CARGO_HOME = "${config.xdg.data.directory}/cargo";
    CODEX_HOME = "${config.xdg.data.directory}/codex";
    GOPATH = "${config.xdg.data.directory}/go";
    GOMODCACHE = "${config.xdg.cache.directory}/go/mod";
    KUBECACHEDIR = "${config.xdg.cache.directory}/kube";
    KUBECONFIG = "${config.xdg.config.directory}/kubeconfig";
    TALOSCONFIG = "${config.xdg.config.directory}/talos/config";
    PSQL_HISTORY = "${config.xdg.state.directory}/psql_history";
    PYTHON_HISTORY = "${config.xdg.state.directory}/python_history";
    NPM_CONFIG_USERCONFIG = "${config.xdg.config.directory}/npm/npmrc";
    NODE_REPL_HISTORY = "${config.xdg.data.directory}/node_repl_history";
    REDISCLI_HISTFILE = "${config.xdg.data.directory}/redis/rediscli_history";
    REDISCLI_RCFILE = "${config.xdg.config.directory}/redis/redisclirc";
    RUFF_CACHE_DIR = "${config.xdg.cache.directory}/ruff";
    RUSTUP_HOME = "${config.xdg.data.directory}/rustup";
  };

  xdg.config.files = {
    "hypr/hyprland.lua".source = ./files/hyprland.lua;
    "npm/npmrc".text = ''
      prefix=${config.xdg.data.directory}/npm
      cache=${config.xdg.cache.directory}/npm
      init-module=${config.xdg.config.directory}/npm/config/npm-init.js
      logs-dir=${config.xdg.state.directory}/npm/logs
    '';
    "Yubico/u2f_keys".source = ./files/u2f_keys;
  };
}
