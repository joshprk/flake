{config, lib, pkgs, ...}: let
  cfg = config.user.fish;
in {
  options.user.fish = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable the fish home module.";
      default = false;
    };
    
    package = lib.mkOption {
      type = lib.types.package;
      description = "The fish package to use.";
      default = pkgs.fish;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.fish = {
      inherit (cfg) enable package;
    };

    programs.man.generateCaches = false;
  };
}
