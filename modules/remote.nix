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

  config = lib.mkMerge [
    (lib.mkIf cfg.server.enable {
      services.openssh = {
        enable = true;
        startWhenNeeded = true;
      };

      settings.impermanence.extraDirectories = [
        "/etc/ssh"
      ];
    })
    (lib.mkIf cfg.client.enable {
      services.tailscale = {
        enable = true;
        authKeyFile = config.sops.secrets."tailscale".path;
        useRoutingFeatures = "server";
      };

      settings.impermanence.extraDirectories = [
        "/var/lib/tailscale"
      ];
    })
  ];
}
