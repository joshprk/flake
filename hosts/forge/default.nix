{config, ...}: {
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "forge";
  system.stateVersion = "25.11";

  modules = {
    impermanence.enable = true;
    home.enable = true;

    openssh = {
      enable = true;
      secure = true;
    };
  };

  users.users.root = {
    openssh.authorizedKeys.keys = [config.modules.secrets.publicKeyTable.master];
  };

  zramSwap.enable = true;
}
