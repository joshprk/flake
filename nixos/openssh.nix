{config, lib, pkgs, ...}: {
  options.user.openssh = {
    enable = lib.mkOption {
      type = lib.types.boolean;
      description = "Whether to enable the openssh module.";
      default = false;
    };

    secure = lib.mkOption {
      type = lib.types.boolean;
      description = "Whether to enable hardening for openssh.";
      default = false;
    };

    package = lib.mkOption {
      type = lib.types.package;
      description = "The openssh package to use.";
      default = pkgs.openssh;
    };

    settings = lib.mkOption {
      types = lib.types.attrs;
      description = "Configuration for `sshd_config(5)`.";
      default = {};
    };
  };

  config = lib.mkIf cfg.enable {
    modules.impermanence.extraDirectories = ["/etc/ssh"];

    services.openssh = {
      inherit (cfg) enable package settings;
    };

    services.fail2ban = lib.mkIf cfg.secure {
      enable = true;
    };
  };
}
