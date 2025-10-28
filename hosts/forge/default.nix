{...}: {
  imports = [
    ./disko.nix
  ];

  networking.hostName = "forge";
  system.stateVersion = "25.11";

  users.users.root.openssh.authorizedKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBfJqj0prGFq3v6KMo/Ll1sC6y57HZ2Bn/Bqi76srII+"
  ];

  features = {};
}
