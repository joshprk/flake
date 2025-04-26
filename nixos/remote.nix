{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.settings.remote;
in {
  options.settings = {
    remote = {
      enable = lib.mkEnableOption "the remote module";
      addToTailnet = lib.mkEnableOption "the Tailscale daemon";
      sshAccess = lib.mkEnableOption "remote access through SSH";

      moonlight = lib.mkOption {
        type = lib.types.nullOr (lib.types.enum ["client" "server"]);
        default = null;
        example = "server";
        description = ''
          Enables the Moonlight remote desktop software, 
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (lib.mkIf (cfg.moonlight == "client") moonlight-qt)
    ];

    services.sunshine = lib.mkIf (cfg.moonlight == "server") {
      enable = true;
    };

    services.openssh = lib.mkIf cfg.sshAccess {
      enable = true;
    };

    services.tailscale = lib.mkIf cfg.addToTailnet {
      enable = true;
      authKeyFile = config.sops.secrets.tailscale.path;
      extraUpFlags = ["--accept-routes"];
    };

    sops.secrets.tailscale = lib.mkIf cfg.addToTailnet {};
  };
}

