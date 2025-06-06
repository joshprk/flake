{...}: {
  services.caddy = {
    enable = true;
    virtualHosts."forge.joshprk.me".extraConfig = ''
      respond "Hello world!"
    '';
  };

  networking.firewall = {
    allowedTCPPorts = [80 443];
  };
}
