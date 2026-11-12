{
  services = {
    tailscale = {
      enable = true;
      openFirewall = true;
      disableUpstreamLogging = true;
      extraSetFlags = ["--accept-dns" "--ssh"];
    };
    resolved.enable = true;
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
