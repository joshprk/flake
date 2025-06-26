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
      openFirewall = true;
      useRoutingFeatures = lib.mkIf cfg.exitNode "server";
      extraUpFlags =
        (lib.optionals cfg.exitNode ["--advertise-exit-node"])
        ++ ["--ssh"];
      # Use when secrets are provisioned
      # authKeyFile = config.age.secrets.tailscale.path;
    };

    services.resolved = {
      enable = lib.mkDefault true;
      dnsovertls = "true";
      dnssec = "true";
    };

    systemd.network = {
      enable = config.networking.useNetworkd;

      networks = lib.mkIf config.networking.useDHCP {
        "99-ethernet-default-dhcp" = {
          dhcpV4Config.UseDNS = false;
          dhcpV6Config.UseDNS = false;
        };

        "99-wireless-client-dhcp" = {
          dhcpV4Config.UseDNS = false;
          dhcpV6Config.UseDNS = false;
        };
      };
    };

    networking = {
      firewall = {
        checkReversePath = "loose";
      };

      nameservers = [
        "1.1.1.1"
        "1.0.0.1"
      ];

      wireless = {
        iwd.enable = true;
      };

      nftables.enable = true;
      useNetworkd = true;
    };
  };
}
