{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./disko.nix
  ];

  networking.hostName = "forge";
  system.stateVersion = "25.11";

  services.openssh = {
    enable = true;
  };

  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBfJqj0prGFq3v6KMo/Ll1sC6y57HZ2Bn/Bqi76srII+"
    ];
  };

  hjem = {
    extraModules = lib.mkForce [];
    linker = lib.mkForce null;
  };

  features = {};
}
