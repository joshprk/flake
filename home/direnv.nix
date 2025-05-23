{config, lib, pkgs, ...}: let
  cfg = config.user.direnv;
in {
  options.user.direnv = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable the direnv home module.";
      default = false;
    };

    package = lib.mkOption {
      type = lib.types.package;
      description = "The direnv package to use.";
      default = pkgs.direnv;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      config.global = {
        warn_timeout = "0";
        hide_env_diff = true;
      };
      silent = true;
    };
  };
}
