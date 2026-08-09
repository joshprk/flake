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
    dhcpcd.enable = false;
    firewall.enable = true;
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      wifi.backend = "iwd";
    };
    nftables.enable = true;
    usePredictableInterfaceNames = false;
  };
}
