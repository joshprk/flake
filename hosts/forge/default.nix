{...}: {
  imports = [
    ./disko.nix
  ];

  networking.hostName = "forge";
  system.stateVersion = "25.11";

  features = {};
}
