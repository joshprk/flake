{...}: {
  imports = [];

  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "alpine";
  system.stateVersion = "25.11";

  zramSwap.enable = true;
}
