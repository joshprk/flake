{config, ...}: {
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

  users.users.root = {
    openssh.authorizedKeys.keys = [config.modules.secrets.pubkeyStore.root];
    password = "recover";
  };

  zramSwap.enable = true;
}
