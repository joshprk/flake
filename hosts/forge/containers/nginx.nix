{...}: {
  services.dnsmasq = {
    enable = true;
    settings = {
      address = "/forge.joshprk.me/100.89.59.104";
    };
  };

  services.nginx = {
    enable = true;
    statusPage = true;
    defaultListen = [{addr = "0.0.0.0";}];
    virtualHosts = {
      "forge.joshprk.me" = {
        forceSSL = true;
        enableACME = true;
        acmeRoot = null;
        locations."/".proxyPass = "http://localhost:80";
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "certs@joshprk.me";
    certs."forge.joshprk.me" = {
      domain = "*.joshprk.me";
      dnsProvider = "porkbun";
      environmentFile = "/.acme";
      dnsPropagationCheck = false;
    };
  };

  system.stateVersion = "25.11";
}
