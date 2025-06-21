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
    wireless = lib.mkEnableOption "wireless network components";
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
      llmnr = "false";
    };

    networking = {
      firewall = {
        allowedUDPPorts =
          lib.optionals
          config.services.tailscale.enable
          [config.services.tailscale.port];
        checkReversePath = "loose";
      };

      networkmanager = lib.mkIf cfg.wireless {
        enable = true;
        wifi = {
          backend = "iwd";
          powersave = true;
        };
      };

      nftables.enable = true;
      useNetworkd = true;
    };

    systemd.network = {
      enable = config.networking.useNetworkd;
      wait-online.enable = !cfg.wireless;
    };
  };
}
