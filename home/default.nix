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
    gh
    rclone
    ripgrep
    opencode
  ];

  files.".config/npm/npmrc".text = ''
    prefix=${config.xdg.data.directory}/npm
    cache=${config.xdg.cache.directory}/npm
    init-module=${config.xdg.config.directory}/npm/config/npm-init.js
    logs-dir=${config.xdg.state.directory}/npm/logs
  '';

  files.".config/mimeapps.list".text = ''
    [Default Applications]
    x-scheme-handler/http=userapp-Zen-3D4JE3.desktop
    x-scheme-handler/https=userapp-Zen-3D4JE3.desktop
    x-scheme-handler/chrome=userapp-Zen-3D4JE3.desktop
    text/html=userapp-Zen-3D4JE3.desktop
    application/x-extension-htm=userapp-Zen-3D4JE3.desktop
    application/x-extension-html=userapp-Zen-3D4JE3.desktop
    application/x-extension-shtml=userapp-Zen-3D4JE3.desktop
    application/xhtml+xml=userapp-Zen-3D4JE3.desktop
    application/x-extension-xhtml=userapp-Zen-3D4JE3.desktop
    application/x-extension-xht=userapp-Zen-3D4JE3.desktop

    [Added Associations]
    x-scheme-handler/http=userapp-Zen-3D4JE3.desktop;
    x-scheme-handler/https=userapp-Zen-3D4JE3.desktop;
    x-scheme-handler/chrome=userapp-Zen-3D4JE3.desktop;
  '';

  environment.sessionVariables = {
    BUN_INSTALL="${config.xdg.data.directory}/bun";
    CARGO_HOME = "${config.xdg.data.directory}/cargo";
    GOPATH = "${config.xdg.data.directory}/go";
    GOMODCACHE = "${config.xdg.cache.directory}/go/mod";
    KUBECACHEDIR = "${config.xdg.cache.directory}/kube";
    KUBECONFIG = "${config.xdg.config.directory}/kubeconfig";
    TALOSCONFIG = "${config.xdg.config.directory}/talos/config";
    PSQL_HISTORY = "${config.xdg.state.directory}/psql_history";
    PYTHON_HISTORY = "${config.xdg.state.directory}/python_history";
    NPM_CONFIG_USERCONFIG = "${config.xdg.config.directory}/npm/npmrc";
    NODE_REPL_HISTORY = "${config.xdg.data.directory}/node_repl_history";
    RUSTUP_HOME = "${config.xdg.data.directory}/rustup";
  };
}
