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
