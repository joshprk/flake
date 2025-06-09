{...}: {
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

    deploy = {
      enable = true;
      containers.internal = {
        autoStart = true;
        internal = true;
        binds = [
          "/run/agenix"
        ];
        forwardPorts = [
          {containerPort = 80; hostPort = 80; protocol = "tcp";}
          {containerPort = 443; hostPort = 443; protocol = "tcp";}
        ];
        routes."forge.joshprk.me" = ''
          respond "Hello world!"
        '';
        config = {};
      };
    };
  };

  # This is okay for Forge, but figure out a way to update when idle
  system.autoUpgrade = {
    enable = true;
    flake = "github:joshprk/flake";
  };

  zramSwap.enable = true;
}
