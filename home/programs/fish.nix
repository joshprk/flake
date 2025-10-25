{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.fish;
in {
  options.programs.fish = {
    package = lib.mkPackageOption pkgs "fish" {};

    shellInit = lib.mkOption {
      type = lib.types.lines;
      default = "";
    };
  };

  config = {
    packages = [
      cfg.package
    ];

    xdg.config.files."fish/config.fish".text = ''
      if not test -n "$__HJEM_ENV_INIT"
        source "${config.environment.loadEnv}"
        ${cfg.shellInit}
        set __HJEM_ENV_INIT 1
      end
    '';
  };
}
