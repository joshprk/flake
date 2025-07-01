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
    nix-direnv
  ];

  dotfiles.".config/git/config" = {
    generator = (pkgs.formats.toml {}).generate "gitconfig";
    value = {
      init.defaultBranch = "main";
      user.name = "Joshua Park";
      user.email = "git@joshprk.me";
    };
  };

  dotfiles.".config/direnv/direnv.toml" = {
    generator = (pkgs.formats.toml {}).generate "direnv-config";
    value = {
      global.disable_stdin = true;
      global.hide_env_diff = true;
      global.warn_timeout = "0ms";
    };
  };

  dotfiles.".config/npm/npmrc".text = ''
    prefix=.config/npm
    cache=.cache/npm
    init-module=.config/npm/config/npm-init.js
    logs-dir=.local/state/npm/logs
  '';

  shell.init = ''
    ${lib.getExe pkgs.direnv} hook fish | source
  '';

  environment.sessionVariables = {
    CARGO_HOME = ".local/share/cargo";
    GOPATH = ".local/share/go";
    GOMODCACHE = ".cache/go/mod";
    PYTHON_HISTORY = ".local/state/python_history";
    NPM_CONFIG_USERCONFIG = ".config/npm/npmrc";
    NODE_REPL_HISTORY = ".local/share/node_repl_history";
    RUSTUP_HOME = ".local/share/rustup";
  };
}
