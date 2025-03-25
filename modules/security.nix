{
  config,
  lib,
  ...
}: let
  cfg = config.settings.security;
in {
  options.settings = {
    security = {
      secureBoot = lib.mkEnableOption "Lanzaboote secure boot";
    };
  };

  config = lib.mkIf cfg.secureBoot {
    boot = {
      initrd.systemd.enable = lib.mkForce true;
      bootspec.enable = lib.mkForce true;
      loader.systemd-boot.enable = lib.mkForce false;

      lanzaboote = {
        enable = true;
        pkiBundle = "/etc/secureboot";
      };
    };

    settings.impermanence.extraDirectories = [
      config.boot.lanzaboote.pkiBundle
    ];
  };
}
