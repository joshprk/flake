{
  hostName = "PC";
  hostGroups = ["default"];
  system = "x86_64-linux";
  stateVersion = "24.11";

  config = {
    config,
    lib,
    pkgs,
    ...
  }: {
    settings.linux.enable = true;
    settings.impermanence.enable = true;

    settings.desktop = {
      enable = true;
      hyprland = true;
    };

    settings.security = {
      secureboot = true;
    };

    settings.nvidia = {
      enable = true;
      tuning = {
        enable = true;
        gpuClock = 1700;
        memoryClock = 10001;
      };
    };

    zramSwap.enable = true;
  };
}
