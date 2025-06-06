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
      default = true;
    };

    addToTailnet = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to add this host to the Tailnet.";
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    modules.impermanence.extraDirectories = lib.mkIf cfg.addToTailnet [
      "/var/lib/tailscale"
    ];

    services.tailscale = lib.mkIf cfg.addToTailnet {
      enable = true;
      authKeyFile = config.age.secrets.tskey.path;
      extraUpFlags = ["--ssh"];
    };

    networking.firewall.checkReversePath = "loose";

    networking.networkmanager = lib.mkIf config.modules.home.interactive {
      enable = true;
      wifi = {
        backend = "iwd";
        powersave = true;
      };
    };

    networking.nftables.enable = true;
  };
}
