{
  config,
  lib,
  ...
}: {
  options.features.secureBoot = lib.mkEnableOption "the secureBoot feature";

  config = lib.mkIf config.features.secureBoot {
    boot.loader.limine.secureBoot = {
      enable = true;
      autoGenerateKeys = true;
      autoEnrollKeys.enable = true;
    };

    services.tailscale.extraDaemonFlags = ["--encrypt-state"];
  };
}
