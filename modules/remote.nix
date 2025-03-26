{
  config,
  lib,
  ...
}: let
  cfg = config.settings.remote;
in {
  options.settings = {
    remote = {
      server = {
        enable = lib.mkEnableOption "the remote server module";
      };

      client = {
        enable = lib.mkEnableOption "the remote client module";
      };
    };
  };

  config = let
    server = {
      services.openssh = {
        enable = true;
        startWhenNeeded = true;
      };

      settings.impermanence.extraDirectories = [
        "/etc/ssh"
      ];
    };

    client = {
      services.tailscale = {
        enable = true;
        useRoutingFeatures = "server";
      };

      settings.impermanence.extraDirectories = [
        "/var/lib/tailscale"
      ];
    };
  in
    lib.mkMerge [
      (lib.mkIf cfg.server.enable server)
      (lib.mkIf cfg.client.enable client)
    ];
}
