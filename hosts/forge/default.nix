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

  modules.system = {
    network.exitNode = true;
    network.disableResolvedStub = true;
  };

  services.openssh = {
    enable = true;
  };

  containers = {
    nginx = {
      autoStart = true;
      privateNetwork = false;
      config = {...}: {
        services.nginx = {
          enable = true;
          statusPage = true;
        };

        nixpkgs = {inherit pkgs;};
        system.stateVersion = "25.11";
      };
    };
  };

  hjem = {
    extraModules = lib.mkForce [];
    linker = lib.mkForce null;
  };

  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGeVLsuetKBY7566XGnq3lmvVf9Lgs/ACu5Y1lXadaAw"
    ];
  };
}
