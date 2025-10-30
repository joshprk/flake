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

      bindMounts."/.acme-env" = {
        hostPath = config.age.secrets.acme.path;
        isReadOnly = true;
      };

      config = {...}: {
        services.dnsmasq = {
          enable = true;
          settings = {
            address = "/forge.joshprk.me/100.89.59.104";
          };
        };

        services.nginx = {
          enable = true;
          statusPage = true;
          defaultListen = [{addr = "0.0.0.0";}];
          virtualHosts = {
            "forge.joshprk.me" = {
              forceSSL = true;
              enableACME = true;
              acmeRoot = null;
              locations."/".proxyPass = "http://localhost:80";
            };
          };
        };

        security.acme = {
          acceptTerms = true;
          defaults.email = "certs@joshprk.me";
          certs."forge.joshprk.me" = {
            domain = "*.joshprk.me";
            dnsProvider = "porkbun";
            environmentFile = "/.acme-env";
            dnsPropagationCheck = false;
          };
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

  networking.firewall = {
    allowedTCPPorts = [53 80 443];
    allowedUDPPorts = [53];
  };
}
