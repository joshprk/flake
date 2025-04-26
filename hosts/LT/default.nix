{
  config,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  settings = {
    linux.enable = true;
    games.enable = true;
    niri.enable = true;
    impermanence.enable = true;

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

    remote = {
      enable = true;
      addToTailnet = true;
    };
  };

  networking.hostName = "LT";
  system.stateVersion = "25.05";
  nixpkgs.hostPlatform = "x86_64-linux";

  services.tlp.enable = true;

  zramSwap.enable = true;
}
