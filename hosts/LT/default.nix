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
      prime = {
        offload.enable = true;
        nvidiaBusId = "PCI:1:0:0";
        amdgpuBusId = "PCI:53:0:0";
      };
    };
  };

  networking.hostName = "LT";
  system.stateVersion = "25.05";
  nixpkgs.hostPlatform = "x86_64-linux";

  services.tlp.enable = true;

  services.tailscale = {
    enable = true;
    authKeyFile = config.sops.secrets.tailscale.path;

    extraUpFlags = [
      "--accept-routes"
    ];
  };

  sops.secrets.tailscale = {};

  zramSwap.enable = true;
}
