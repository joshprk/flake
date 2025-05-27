{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "forge";
  system.stateVersion = "25.11";

  modules = {
    home.enable = true;
    openssh.enable = true;
    impermanence.enable = true;
  };

  services.caddy = {
    enable = true;
    virtualHosts."forge.joshprk.me".extraConfig = ''
      reverse_proxy ${config.containers.vaultwarden.hostAddress}:8222
    '';
  };

  containers.vaultwarden = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.100.1";
    config = {...}: {
      services.vaultwarden = {
        enable = true;
        config = {
          ROCKET_ADDRESS = "0.0.0.0";
          ROCKET_PORT = 8222;
        };
      };
      nixpkgs.pkgs = pkgs;
      system.stateVersion = "25.11";
    };
  };

  networking.firewall.interfaces."tailscale0" = {
    allowedTCPPorts = [80 443];
  };

  users.users.root = {
    openssh.authorizedKeys.keys = [config.modules.secrets.pubkeyStore.root];
  };

  zramSwap.enable = true;
}
