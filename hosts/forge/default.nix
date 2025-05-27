{config, lib, pkgs, ...}: {
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

  services.nginx = let
    cfg' = config.services.nginx;
  in {
    enable = true;
    tailscaleAuth = {
      enable = true;
      user = "nginx";
      group = "nginx";
    };
    virtualHosts."vault.joshprk.me" = {
      forceSSL = false;
      enableACME = false;
      locations."/".extraConfig = ''
        auth_request /auth;
        proxy_pass http://192.168.100.1:8222;
      '';
      locations."/auth".extraConfig = ''
        internal;
        proxy_pass http://unix:${cfg'.tailscaleAuth.socketPath};
        proxy_pass_request_body off;
        proxy_set_header Host $http_host;
        proxy set_header Remote-Addr $remote_addr;
        proxy set_header Remote-Port $remote_port;
        proxy set_header Original-URI $request_uri;
      '';
    };
  };

  containers.vaultwarden = {
    autoStart = true;
    config = {...}: {
      services.vaultwarden = {
        enable = true;
      };
      nixpkgs.pkgs = pkgs;
      system.stateVersion = "25.11";     
    };
  };

  users.users.root = {
    openssh.authorizedKeys.keys = [config.modules.secrets.pubkeyStore.root];
  };

  zramSwap.enable = true;
}
