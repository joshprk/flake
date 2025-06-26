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
    impermanence.enable = true;
    nvidia.enable = true;
  };
}
