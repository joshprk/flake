{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.system.network;
in {
  options.modules.system.network = {
    exitNode = lib.mkEnableOption "exit node networking";
  };

  config = {
    modules.system = {
      impermanence.extraDirectories = ["/var/lib/tailscale"];
    };

    services.tailscale = {
      enable = lib.mkDefault true;
      useRoutingFeatures = lib.mkIf cfg.exitNode "server";
      extraUpFlags =
        (lib.optionals cfg.exitNode ["--advertise-exit-node"])
        ++ ["--ssh"];
      # Add this when secrets are set up.
      # authKeyFile = ...;
    };

    services.resolved = {
      enable = lib.mkDefault true;
      dnsovertls = "true";
    };

    networking = {
      firewall = {
        allowedUDPPorts =
          lib.optionals
          config.services.tailscale.enable
          [config.services.tailscale.port];
        checkReversePath = "loose";
      };

      nameservers = [
        "1.1.1.1"
        "1.0.0.1"
        "8.8.8.8"
        "8.8.4.4"
      ];

      wireless = {
        iwd.enable = true;
      };

      nftables.enable = true;
      useNetworkd = true;
    };

    systemd.network = {
      enable = config.networking.useNetworkd;
    };
  };
}
