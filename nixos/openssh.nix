{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.openssh;
in {
  options.modules.openssh = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable the openssh module.";
      default = false;
    };

    secure = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable hardening for openssh.";
      default = false;
    };

    package = lib.mkOption {
      type = lib.types.package;
      description = "The openssh package to use.";
      default = pkgs.openssh;
    };

    extraSettings = lib.mkOption {
      type = lib.types.attrs;
      description = "Configuration for `sshd_config(5)`.";
      default = {};
    };
  };

  config = lib.mkIf cfg.enable {
    modules.impermanence.extraDirectories = ["/etc/ssh"];

    services.openssh = {
      inherit (cfg) enable package;
      openFirewall = false;
      settings = lib.mkMerge [
        {PasswordAuthentication = false;}
        cfg.extraSettings
      ];
    };

    networking.firewall.interfaces = let
      tsConfig = config.services.tailscale;
    in lib.mkIf tsConfig.enable {
      ${tsConfig.interfaceName}.allowedTCPPorts = config.services.openssh.ports;
    };

    services.fail2ban.enable = true;
  };
}
