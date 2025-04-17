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
        memoryClock = 10001;
      };
    };
  };

  networking.hostName = "PC";
  system.stateVersion = "25.05";
  nixpkgs.hostPlatform = "x86_64-linux";

  services.openssh = {
    enable = true;

    settings = {
      X11Forwarding = true;
    };
  };

  networking.interfaces.eno1.wakeOnLan = {
    enable = true;
  };

  zramSwap.enable = true;
}
