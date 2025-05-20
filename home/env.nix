{config, lib, ...}: let
  cfg = config.user.env;
in {
  options.user.env = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable the environment home module.";
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    xdg.enable = true;
  };
}
