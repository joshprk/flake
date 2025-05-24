{
  config,
  lib,
  ...
}: let
  cfg = config.modules.networking;
in {
  options.modules.networking = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable the networking module.";
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    services.resolved = {
      enable = true;
    };

    networking.networkmanager = {
      enable = true;
      wifi = {
        backend = "iwd";
        powersave = true;
      };
    };

    networking.nftables.enable = true;
  };
}
