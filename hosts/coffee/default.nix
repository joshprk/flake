{...}: {
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "coffee";
  system.stateVersion = "25.11";

  modules = {
    impermanence.enable = true;
    home = {
      enable = true;
      interactive = true;
    };
  };

  zramSwap.enable = true;
}
