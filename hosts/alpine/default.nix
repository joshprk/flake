{...}: {
  imports = [];

  networking.hostName = "alpine";
  system.stateVersion = "25.11";

  zramSwap.enable = true;
}
