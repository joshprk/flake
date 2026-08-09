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
    nameservers = ["1.1.1.1" "1.0.0.1"];
    useNetworkd = true;
    nftables.enable = true;
    wireless.iwd.enable = true;
  };

  systemd.network.enable = true;
}
