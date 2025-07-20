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

      wireless = {
        iwd.enable = lib.mkDefault true;
      };

      nftables.enable = lib.mkDefault true;
      hostName = lib.mkDefault var.hostName;
      useNetworkd = lib.mkDefault true;
    };
  };
}
