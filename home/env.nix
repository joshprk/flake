{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.user.env;
in {
  options.user.env = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable the environment home module.";
      default = false;
    };
  };

  config = let
    inherit (config.home) sessionVariables;
    inherit (config) xdg;
  in
    lib.mkIf cfg.enable {
      home.sessionVariables = {
        CARGO_HOME = "${xdg.dataHome}/cargo";
        CUDA_CACHE_PATH = "${xdg.cacheHome}/nv";
        DISCORD_USER_DATA_DIR = "${xdg.dataHome}";
        DOCKER_CONFIG = "${xdg.configHome}/docker";
        MIX_XDG = "true";
        FFMPEG_DATADIR = "${xdg.configHome}/ffmpeg";
        GOMODCACHE = "${xdg.cacheHome}/go/mod";
        GTK_RC_FILES = "${xdg.configHome}/gtk-1.0/gtkrc";
        MYPY_CACHE_DIR = "${xdg.cacheHome}/mypy";
        NODE_REPL_HISTORY = "${xdg.dataHome}/node_repl_history";
        NPM_CONFIG_USERCONFIG = "${xdg.configHome}/npm/npmrc";
        OPAMROOT = "${xdg.dataHome}/opam";
        NUGET_PACKAGES = "${xdg.cacheHome}/NuGetPackages";
        NVM_DIR = "${xdg.dataHome}/nvm";
        PSQLRC = "${xdg.configHome}/pg/psqlrc";
        PSQL_HISTORY = "${xdg.stateHome}/psql_history";
        PGPASSFILE = "${xdg.configHome}/pg/pgpass";
        PGSERVICEFILE = "${xdg.configHome}/pg/pg_service.conf";
        PYTHON_HISTORY = "${xdg.stateHome}/python_history";
        PYTHONPYCACHEPREFIX = "${xdg.cacheHome}/python";
        PYTHONUSERBASE = "${xdg.dataHome}/python";
        PYTHON_EGG_CACHE = "${xdg.cacheHome}/python-eggs";
        PLTUSERHOME = "${xdg.dataHome}/racket";
        INPUTRC = "${xdg.configHome}/readline/inputrc";
        REDISCLI_HISTFILE = "${xdg.dataHome}/redis/rediscli_history";
        REDISCLI_RCFILE = "${xdg.cacheHome}/redis/redisclirc";
        RUFF_CACHE_DIR = "${xdg.cacheHome}/ruff";
        RUSTUP_HOME = "${xdg.dataHome}/rustup";
        SCREENRC = "${xdg.cacheHome}/screen/screenrc";
        SCREENDIR = "$XDG_RUNTIME_DIR/screen";
        SQLITE_HISTORY = "${xdg.stateHome}/sqlite_history";
        WGETRC = "${xdg.configHome}/wgetrc";
        WINEPREFIX = "${xdg.dataHome}/wineprefixes/default";
        XAUTHORITY = "$XDG_RUNTIME_DIR/Xauthority";
        XINITRC = "${xdg.configHome}/X11/xinitrc";
        XSERVERRC = "${xdg.configHome}/X11/xserverrc";
      };

      home.file = {
        "${sessionVariables.NPM_CONFIG_USERCONFIG}".text = ''
          prefix=${xdg.dataHome}/npm
          cache=${xdg.cacheHome}/npm
          init-module=${xdg.configHome}/npm/config/npm-init.js
          logs-dir=${xdg.stateHome}/npm/logs
        '';
      };

      home.preferXdgDirectories = true;

      programs.go = {
        goBin = lib.mkDefault ".local/bin.go";
        goPath = lib.mkDefault ".local/share/go";
        telemetry = lib.mkDefault "off";
      };

      services.pass-secret-service = {
        storePath = lib.mkDefault "${xdg.dataHome}/password-store";
      };

      gtk = {
        gtk2.configLocation = lib.mkDefault "${xdg.configHome}/gtk-2.0/gtkrc";
      };

      xdg.enable = lib.mkDefault true;
      xresources.path = "${xdg.configHome}/X11/xresources";
    };
}
