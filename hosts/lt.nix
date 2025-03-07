{...}: {
  settings = {
    profiles.desktop = true;
    games.enable = true;

    impermanence.enable = true;
    secureboot.enable = true;

    nvidia = {
      enable = true;
      prime = {
        offload.enable = true;
        nvidiaBusId = "PCI:1:0:0";
        amdgpuBusId = "PCI:53:0:0";
      };
    };
  };

  services.tlp = {
    enable = true;
  };

  zramSwap.enable = true;
}
