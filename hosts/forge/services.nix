{config, lib, pkgs, ...}: let
  tsConfig = config.services.tailscale;
in {
  containers.private = {
    autoStart = true;
    config = {
      services.vaultwarden = {
        enable = true;
        config = {
          ROCKET_ADDRESS = "127.0.0.1";
          ROCKET_PORT = 8222;
        };
      };
      nixpkgs = {inherit pkgs;};
    };
  };

  services.caddy = {
    enable = true;
    virtualHosts."forge.joshprk.me".extraConfig = ''
      handle_path /vault/* {
        reverse_proxy 127.0.0.1:8222
      }

      handle_path / {
        respond "Hi tailnet!"
      }
    '';
  };

  services.dnsmasq = {
    enable = true;
    resolveLocalQueries = false;
    settings = {
      address = "/forge.joshprk.me/100.107.152.76";
      no-resolv = true;
    };
  };

  services.tailscale.permitCertUid = "caddy";

  networking.firewall.interfaces.${tsConfig.interfaceName} = {
    allowedTCPPorts = [80 443];
    allowedUDPPorts = [53];
  };
}
