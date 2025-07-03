{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    dotfiles = lib.mkOption {
      type = with lib.types;
        attrsOf (submodule {
          options = {
            generator = lib.mkOption {
              type = with lib.types; nullOr raw;
              default = null;
            };

            value = lib.mkOption {
              type = with lib.types; nullOr raw;
              default = null;
            };

            source = lib.mkOption {
              type = with lib.types; nullOr path;
              default = null;
            };

            text = lib.mkOption {
              type = with lib.types; nullOr str;
              default = null;
            };
          };
        });
      default = {};
    };

    shell.init = lib.mkOption {
      type = lib.types.str;
      default = "";
    };
  };

  config = {
    packages = with pkgs; [
      fish
    ];

    dotfiles.".config/fish/config.fish".text = ''
      if not test -n "$__HJEM_ENV_INIT"
        source "${config.environment.loadEnv}"
        ${config.shell.init}
        set __HJEM_ENV_INIT 1
      end
    '';

    files =
      lib.mapAttrs (
        _: v:
          with v;
            if text != null
            then {inherit text;}
            else {
              source =
                if generator != null
                then generator value
                else source;
            }
      )
      config.dotfiles;
  };
}
