{
  config,
  lib,
  pkgs,
  ...
}: {
  services.dnsmasq = {
    enable = true;
    resolveLocalQueries = false;

    settings = {
      server = ["1.1.1.1" "1.0.0.1"];
      address = [
        "/forge.joshprk.me/100.87.235.15"
        "/vault.joshprk.me/100.87.235.15"
      ];
      no-resolv = true;
    };
  };

  services.vaultwarden = {
    enable = true;
    environmentFile = "/run/agenix/vault-env";

    config = {
      DOMAIN = "https://vault.joshprk.me";
      SIGNUPS_ALLOWED = false;
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
    };
  };

  system.stateVersion = "25.11";
}
