{
  config,
  lib,
  ...
}: {
  options.features.server = lib.mkEnableOption "the server feature";

  config = lib.mkIf config.features.server {
    environment = {
      enableAllTerminfo = true;
      persistence."/nix/persist".files =
        lib.concatMap (key: [
          key.path
          "${key.path}.pub"
        ])
        config.services.openssh.hostKeys;
    };

    security.sudo.wheelNeedsPassword = false;

    services = {
      fail2ban.enable = true;
      openssh = {
        enable = true;
        openFirewall = true;
      };
    };
  };
}
