{
  config,
  lib,
  pkgs,
  var,
  ...
}: let
  cfg = config.modules.system.network;
in {
  options.modules.system.network = {
    exitNode = lib.mkEnableOption "exit node networking";
  };

  config = {
    services.tailscale = {
      enable = lib.mkDefault true;
      openFirewall = lib.mkDefault true;
      useRoutingFeatures = lib.mkIf cfg.exitNode (lib.mkDefault "server");
      extraUpFlags =
        (lib.optionals cfg.exitNode ["--advertise-exit-node"])
        ++ ["--ssh"];
      authKeyFile = config.age.secrets.tailscale.path;
    };

    services.resolved = {
      enable = lib.mkDefault true;
      dnsovertls = lib.mkDefault "true";
      dnssec = lib.mkDefault "true";
    };

    systemd.network = {
      enable = lib.mkDefault config.networking.useNetworkd;
    };

    networking = {
      firewall = {
        checkReversePath = lib.mkDefault "loose";
      };

      nameservers = [
        "1.1.1.1"
        "1.0.0.1"
      ];

      wireless = {
        iwd.enable = true;
      };

      nftables.enable = true;
      hostName = var.hostName;
      useNetworkd = true;
    };
  };
}
