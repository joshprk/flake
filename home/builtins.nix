{
  config,
  lib,
  ...
}: {
  config = {
    home.sessionVariables = {
      CARGO_HOME = "${config.xdg.dataHome}/cargo";
      NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
      XCOMPOSECACHE = "${config.xdg.cacheHome}/X11/xcompose";
    };

    home.file = {
      "${config.xdg.configHome}/npm/npmrc".text = ''
        prefix=${config.xdg.dataHome}/npm
        cache=${config.xdg.cacheHome}/npm
        init-module=${config.xdg.configHome}/npm/config/npm-init.js
        logs-dir=${config.xdg.stateHome}/npm/logs
      '';
    };

    xdg.enable = true;
  };
}
