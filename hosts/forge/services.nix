{config, lib, pkgs, ...}: let
  tsConfig = config.services.tailscale;
in {
  containers.private = {
    autoStart = true;
    config = {
      services.vaultwarden = {
        enable = true;
        config = {
          DOMAIN = "https://forge.joshprk.me";
          ROCKET_ADDRESS = "127.0.0.1";
          ROCKET_PORT = 8222;
        };
      };
      nixpkgs = {inherit pkgs;};
    };
  };

  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = ["github.com/caddy-dns/porkbun@v0.3.1"];
      hash = "sha256-7TqepCX9F5AMAUJrH8wxdnrr3JMezhowyIPlfFYUQG8=";
    };
    globalConfig = ''
      acme_dns porkbun {
        api_key {env.PORKBUN_API_KEY}
        api_secret_key {env.PORKBUN_SEC_KEY}
      }
    '';
    virtualHosts."forge.joshprk.me".extraConfig = ''
      respond "Hi tailnet!"
    '';
    virtualHosts."vault.joshprk.me".extraConfig = ''
      reverse_proxy 127.0.0.1:8222
    '';
    environmentFile = config.age.secrets.caddy-env.path;
  };

  services.dnsmasq = {
    enable = true;
    resolveLocalQueries = false;
    settings = {
      address = [
        "/forge.joshprk.me/100.107.152.76"
        "/vault.joshprk.me/100.107.152.76"
      ];
      server = [
        "1.1.1.1"
        "1.0.0.1"
      ];
      no-resolv = true;
    };
  };

  services.tailscale.permitCertUid = "caddy";

  networking.firewall.interfaces.${tsConfig.interfaceName} = {
    allowedTCPPorts = [80 443];
    allowedUDPPorts = [53];
  };
}
