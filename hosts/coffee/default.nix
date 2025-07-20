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
    nvidia.enable = true;
  };
}
