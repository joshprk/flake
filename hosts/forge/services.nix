{pkgs, ...}: {
  containers.private = {
    autoStart = true;
    privateNetwork = true;
    config = {
      services.vaultwarden = {
        enable = true;
      };

      nixpkgs = {inherit pkgs;};
    };
  };

  services.caddy = {
    enable = true;
    virtualHosts."forge.joshprk.me".extraConfig = ''
      @tailscale {
        remote_ip 100.64.0.0/10
      }
      
      handle @tailscale {
        respond "You are authenticated!"
      }

      handle {
        respond "Access denied" 403
      }
    '';
  };

  networking.firewall = {
    allowedTCPPorts = [80 443];
  };
}
