{...}: {
  imports = [
    ./disko.nix
  ];

  networking.hostName = "alpine";
  system.stateVersion = "25.11";

  features = {
    desktop = true;
  };

  modules.apps = {
    podman.enable = true;
  };

  modules.system = {
    nvidia.enable = true;
    nvidia.maxMemClock = 10001;
    nvidia.maxGpuClock = 1700;
    nvidia.prime.offload.enable = true;
    nvidia.prime.nvidiaBusId = "PCI:1:0:0";
    nvidia.prime.amdgpuBusId = "PCI:13:0:0";
  };
}
