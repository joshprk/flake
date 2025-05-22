{config, lib, pkgs, ...}: let
  cfg = config.user.ripgrep;
in {
  options.user.ripgrep = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable the ripgrep home module.";
      default = false;
    };

    package = lib.mkOption {
      type = lib.types.package;
      description = "The ripgrep package to use.";
      default = pkgs.ripgrep;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.ripgrep.enable = true;
    programs.ripgrep.package = cfg.package;
  };
}
