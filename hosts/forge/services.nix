{
  config,
  lib,
  pkgs,
  ...
}: let
  tsConfig = config.services.tailscale;
in {
  # Internal services which are accessible only through private routes
  containers.private = {
    autoStart = true;
    config = {
      services.vaultwarden = {
        enable = true;
        environmentFile = config.age.secrets.vault-env.path;

        config = {
          DOMAIN = "https://vault.joshprk.me";
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

    # Ensure private routes block all external requests
    virtualHosts = let
      mkInternal = _: v: v // {
        extraConfig = ''
          @denied not remote_ip private_ranges 100.64.0.0/10
          abort @denied
          ${v.extraConfig}
        '';
      };
    in
      builtins.mapAttrs mkInternal {
        "forge.joshprk.me".extraConfig = ''
          respond "Hi tailnet!"
        '';
        "vault.joshprk.me".extraConfig = ''
          reverse_proxy 127.0.0.1:8222
        '';
      };

    environmentFile = config.age.secrets.caddy-env.path;
  };

  services.dnsmasq = {
    enable = true;
    resolveLocalQueries = false;

    settings = {
      address = [
        "/forge.joshprk.me/100.87.235.15"
        "/vault.joshprk.me/100.87.235.15"
      ];
      server = [
        "1.1.1.1"
        "1.0.0.1"
      ];
      no-resolv = true;
    };
  };

  services.tailscale = {
    extraUpFlags = ["--advertise-exit-node"];
    useRoutingFeatures = "server";
  };

  networking.firewall.interfaces.${tsConfig.interfaceName} = {
    allowedTCPPorts = [80 443];
    allowedUDPPorts = [53];
  };
}
