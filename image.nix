# Configuration for the live-cd installer
# Imported by ./module.nix
{
  modulesPath,
  system,
  ...
}: {
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  networking = {
    networkmanager.enable = true;
  };

  nix.settings.experimental-features = [
    "flakes"
    "nix-command"
    "pipe-operators"
  ];

  nixpkgs.hostPlatform = system;
}
