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

  services.resolved = {
    extraConfig = ''
      DNSStubListener=no
    '';
  };

  containers = {
    nginx = {
      autoStart = true;
      privateNetwork = false;
      config = import ./containers/nginx.nix;
      bindMounts."/.acme" = {
        hostPath = config.age.secrets.acme.path;
        isReadOnly = true;
      };
    };

    open-webui = {
      autoStart = true;
      privateNetwork = true;
      config = import ./containers/open-webui.nix;
      forwardPorts = [
        {containerPort = 8080; hostPort = 8081; protocol = "tcp";}
      ];
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

  networking.firewall = {
    allowedTCPPorts = [53 80 443];
    allowedUDPPorts = [53];
  };
}
