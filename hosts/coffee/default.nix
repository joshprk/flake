{...}: {
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "coffee";
  system.stateVersion = "25.11";

  zramSwap.enable = true;
}
