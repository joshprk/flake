{
  config,
  lib,
  ...
}: let
  cfg = config.settings.networking;
in {
  options.settings = {
    networking = {
      enable = lib.mkEnableOption "the networking module";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.networkmanager = {
      enable = lib.mkDefault true;
      ensureProfiles.profiles = {};
    };
  };
}
