_: {
  services = {
    tailscale = {
      enable = true;
      openFirewall = true;
      disableUpstreamLogging = true;
      extraUpFlags = ["--ssh"];
    };
    resolved = {
      enable = true;
      settings.Resolve = {
        DNSOverTLS = true;
        DNSSEC = true;
      };
    };
  };

  networking = {
    firewall = {
      enable = true;
      checkReversePath = "loose";
    };
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      wifi.backend = "iwd";
    };
    dhcpcd.enable = false;
    nftables.enable = true;
    usePredictableInterfaceNames = false;
  };
}
