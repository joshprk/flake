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

    exitNode = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to make this host a Tailnet exit node.";
      default = false;
      apply =
        lib.throwIfNot
        cfg.addToTailnet
        "tailscale must be enabled for this node to be an exit node";
    };
  };

  config = lib.mkIf cfg.enable {
    modules.impermanence.extraDirectories = lib.mkIf cfg.addToTailnet [
      "/var/lib/tailscale"
    ];

    services.tailscale = lib.mkIf cfg.addToTailnet {
      enable = true;
      useRoutingFeatures = lib.mkIf cfg.exitNode "server";
      authKeyFile = config.age.secrets.tskey.path;
      extraUpFlags =
        ["--ssh"]
        ++ lib.optional cfg.exitNode "--advertise-exit-node";
    };

    networking.firewall = {
      allowedUDPPorts = [config.services.tailscale.port];
      checkReversePath = "loose";
    };

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
