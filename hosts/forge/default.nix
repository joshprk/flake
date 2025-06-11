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
    networking.exitNode = true;

    deploy = {
      enable = true;

      containers.internal = {
        autoStart = true;
        internal = true;
        binds = [
          config.age.secrets.restic-gdrive.path
          config.age.secrets.restic-pass.path
          config.age.secrets.vault-env.path
        ];
        openPorts = [
          {port = 53; protocol = "udp";}
          {port = 80; protocol = "tcp";}
          {port = 443; protocol = "tcp";}
        ];
        routes."forge.joshprk.me" = ''
          respond "Hello tailnet!"
        '';
        routes."vault.joshprk.me" = ''
          reverse_proxy 127.0.0.1:8222
        '';
        config = ./containers/internal.nix;
      };

      containers.minecraft = {
        autoStart = false;
        internal = true;
        openPorts = [
          {port = 25565; protocol = "tcp";}
          {port = 25565; protocol = "udp";}
        ];
        config = ./containers/minecraft.nix;
      };
    };
  };

  zramSwap.enable = true;
}
