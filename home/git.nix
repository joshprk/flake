{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.user.git;
in {
  options.user.git = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable the Git home module.";
      default = false;
    };

    package = lib.mkOption {
      type = lib.types.package;
      description = "The git package to use.";
      default = pkgs.git;
    };

    config = lib.mkOption {
      type = lib.types.attrs;
      description = "Configuration to write to gitconfig.";
      default = {};
    };
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      inherit (cfg) enable package;
      extraConfig = cfg.config;
    };
  };
}
