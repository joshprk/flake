{config, lib, pkgs, ...}: let
  tsConfig = config.services.tailscale;
in {
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
      respond "Hi tailnet!"
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
