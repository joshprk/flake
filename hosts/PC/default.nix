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
  };

  networking.interfaces.eno1.wakeOnLan = {
    enable = true;
  };

  virtualisation.oci-containers.containers = {
    backend = "podman";

    steam-headless = {
      image = "docker.io/josh5/steam-headless:latest";
      autoStart = false;

      ports = [
        "8080:8080"
        "27036:27036"
        "27037:27037"
        "27031:27031/udp"
        "27036:27036/udp"
      ];

      volumes =  [
        "$USER/.local/share/games/.local/share/Steam/steamapps:/mnt/games"
      ];

      extraOptions = [
        "--network=host"
        "--device=/dev/dri"
        "--device=/dev/input"
      ];
    };
  };

  zramSwap.enable = true;
}
