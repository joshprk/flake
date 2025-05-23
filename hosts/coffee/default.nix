{...}: {
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "coffee";
  system.stateVersion = "25.11";

  modules = {
    impermanence.enable = true;
    niri.enable = true;
    home = {
      enable = true;
      interactive = true;
    };
    openssh = {
      enable = true;
      secure = true;
    };
    nvidia = {
      enable = true;
      tuning = {
        enable = true;
        gpuClock = 1700;
        memoryClock = 6000;
      };
      prime = {
        offload.enable = true;
        nvidiaBusId = "PCI:1:0:0";
        amdgpuBusId = "PCI:53:0:0";
      };
    };
  };

  services.tlp.enable = true;
  zramSwap.enable = true;
}
