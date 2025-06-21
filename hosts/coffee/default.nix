{...}: {
  imports = [
    ./disko.nix
  ];

  networking.hostName = "coffee";
  system.stateVersion = "25.11";
}
