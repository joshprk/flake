{
  hostName = "LT";
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
      prime = {
        offload.enable = true;
        nvidiaBusId = "PCI:1:0:0";
        amdgpuBusId = "PCI:53:0:0";
      };
    };

    services.tlp = {
      enable = true;
    };

    zramSwap.enable = true;
  };
}
