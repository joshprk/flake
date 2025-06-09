{...}: {
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

  system.stateVersion = "25.11";
}
