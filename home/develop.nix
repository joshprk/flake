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

  files.".config/direnv/lib/hm-nix-direnv.sh" = {
    source = "${pkgs.nix-direnv}/share/nix-direnv/direnvrc";
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
    CARGO_HOME = "$HOME/.local/share/cargo";
    GOPATH = "$HOME/.local/share/go";
    GOMODCACHE = "$HOME/.cache/go/mod";
    PYTHON_HISTORY = "$HOME/.local/state/python_history";
    NPM_CONFIG_USERCONFIG = "$HOME/.config/npm/npmrc";
    NODE_REPL_HISTORY = "$HOME/.local/share/node_repl_history";
    RUSTUP_HOME = "$HOME/.local/share/rustup";
  };
}
