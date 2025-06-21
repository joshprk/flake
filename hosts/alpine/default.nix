{...}: {
  imports = [
    ./disko.nix
  ];

  networking.hostName = "alpine";
  system.stateVersion = "25.11";
}
