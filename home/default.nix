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

  files.".config/npm/npmrc".text = ''
    prefix=${config.xdg.data.directory}/npm
    cache=${config.xdg.cache.directory}/npm
    init-module=${config.xdg.config.directory}/npm/config/npm-init.js
    logs-dir=${config.xdg.state.directory}/npm/logs
  '';

  files.".config/mimeapps.list".text = ''
    [Default Applications]
    text/xml=app.zen_browser.zen.desktop
    text/html=app.zen_browser.zen.desktop
    x-scheme-handler/http=app.zen_browser.zen.desktop
    x-scheme-handler/https=app.zen_browser.zen.desktop
    x-scheme-handler/about=app.zen_browser.zen.desktop
    x-scheme-handler/unknown=app.zen_browser.zen.desktop
    application/xhtml+xml=app.zen_browser.zen.desktop
    application/x-xpinstall=app.zen_browser.zen.desktop
    application/pdf=app.zen_browser.zen.desktop
    application/json=app.zen_browser.zen.desktop
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
