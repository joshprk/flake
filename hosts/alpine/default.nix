{...}: {
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "alpine";
  system.stateVersion = "25.11";

  modules = {
    home.enable = true;
    home.interactive = true;
    kernel.secureBoot = true;
    impermanence.enable = true;
    niri.enable = true;
    nvidia = {
      enable = true;
      tuning = {
        enable = true;
        gpuClock = 1700;
        memoryClock = 10001;
      };
      prime = {
        offload.enable = true;
        nvidiaBusId = "PCI:1:0:0";
        amdgpuBusId = "PCI:13:0:0";
      };
    };
    openssh.enable = true;
    steam.enable = true;
  };

  zramSwap.enable = true;
}
