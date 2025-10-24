{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.direnv;
in {
  options.programs.direnv = {
    package = lib.mkPackageOption pkgs "direnv" {};
    nix-direnv.enable = lib.mkEnableOption "the nix-direnv plugin";
    nix-direnv.package = lib.mkPackageOption pkgs "nix-direnv" {};

    settings = lib.mkOption {
      type = lib.types.attrs;
      readOnly = true;
      default = {
        global.disable_stdin = true;
        global.hide_env_diff = true;
        global.warn_timeout = "0ms";
      };
    };
  };

  config = {
    packages = [
      cfg.package
    ];

    programs.fish.shellInit = ''
      ${lib.getExe cfg.package} hook fish | source
    '';

    xdg.config.files."direnv/direnv.toml" = {
      generator = (pkgs.formats.toml {}).generate "direnv-config";
      value = cfg.settings;
    };

    xdg.config.files."direnv/lib/nix-direnv.sh" = lib.mkIf cfg.nix-direnv.enable {
      source = "${cfg.nix-direnv.package}/share/nix-direnv/direnvrc";
    };
  };
}
