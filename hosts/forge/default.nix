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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGeVLsuetKBY7566XGnq3lmvVf9Lgs/ACu5Y1lXadaAw"
    ];
  };

  hjem = {
    extraModules = lib.mkForce [];
    linker = lib.mkForce null;
  };

  features = {};
}
