{...}: {
  imports = [
    ./disko.nix
  ];

  networking.hostName = "alpine";
  system.stateVersion = "25.11";

  features = {
    desktop = true;
  };

  modules.system = {
    impermanence.enable = true;
    nvidia.enable = true;
  };
}
