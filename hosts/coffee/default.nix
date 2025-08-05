{...}: {
  imports = [
    ./disko.nix
  ];

  networking.hostName = "coffee";
  system.stateVersion = "25.11";

  features = {
    desktop = true;
  };

  modules.system = {
    nvidia.enable = true;
    nvidia.maxMemClock = 12001;
    nvidia.maxGpuClock = 1700;
    nvidia.prime.offload.enable = true;
    nvidia.prime.nvidiaBusId = "PCI:1:0:0";
    nvidia.prime.amdgpuBusId = "PCI:53:0:0";
  };
}
