{
  config,
  lib,
  ...
}: {
  networking.hostName = "PC";
  system.stateVersion = "25.05";
  nixpkgs.hostPlatform = "x86_64-linux";
}
