{
  config,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  settings = {
    niri.enable = true;
    impermanence.enable = true;
  };

  networking.hostName = "PC";
  system.stateVersion = "25.05";
  nixpkgs.hostPlatform = "x86_64-linux";
}
