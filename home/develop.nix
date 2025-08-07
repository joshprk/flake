{
  config,
  lib,
  pkgs,
  ...
}: {
  packages = with pkgs; [
    direnv
    git
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
    prefix=${config.directory}/.config/npm
    cache=${config.directory}/.cache/npm
    init-module=${config.directory}/.config/npm/config/npm-init.js
    logs-dir=${config.directory}/.local/state/npm/logs
  '';

  shell.init = ''
    ${lib.getExe pkgs.direnv} hook fish | source
  '';

  environment.sessionVariables = {
    CARGO_HOME = "${config.directory}/.local/share/cargo";
    GOPATH = "${config.directory}/.local/share/go";
    GOMODCACHE = "${config.directory}/.cache/go/mod";
    KUBECACHEDIR = "${config.directory}/.cache/kube";
    KUBECONFIG = "${config.directory}/.config/kube";
    TALOSCONFIG = "${config.directory}/.config/talos/config";
    PYTHON_HISTORY = "${config.directory}/.local/state/python_history";
    NPM_CONFIG_USERCONFIG = "${config.directory}/.config/npm/npmrc";
    NODE_REPL_HISTORY = "${config.directory}/.local/share/node_repl_history";
    RUSTUP_HOME = "${config.directory}/.local/share/rustup";
  };
}
