{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./disko.nix
  ];

  features = {
    users = true;
  };

  networking.hostName = "forge";
  system.stateVersion = "25.11";

  modules.system = {
    network.exitNode = true;
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
  };

  networking.firewall = {
    allowedTCPPorts = [53 80 443];
    allowedUDPPorts = [53];
  };

  zramSwap.enable = true;
}
