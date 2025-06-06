{...}: {
  imports = [
    ./disko.nix
    ./services.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "forge";
  system.stateVersion = "25.11";

  modules = {
    home.enable = true;
    openssh.enable = true;
    impermanence.enable = true;
  };

  # This is okay for Forge, but figure out a way to update when idle
  system.autoUpgrade = {
    enable = true;
    flake = "github:joshprk/flake";
  };

  zramSwap.enable = true;
}
