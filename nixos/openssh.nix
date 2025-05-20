{config, lib, pkgs, ...}: let
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

    settings = lib.mkOption {
      type = lib.types.attrs;
      description = "Configuration for `sshd_config(5)`.";
      default = {};
    };
  };

  config = lib.mkIf cfg.enable {
    modules.impermanence.extraDirectories = ["/etc/ssh"];

    services.openssh = {
      inherit (cfg) enable package;

      settings = lib.mkMerge [
        cfg.settings
        (lib.mkIf (cfg.secure) {
          PasswordAuthentication = false;
        })
      ];
    };

    services.fail2ban = lib.mkIf cfg.secure {
      enable = true;
    };
  };
}
