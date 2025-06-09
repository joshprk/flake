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
    networking.exitNode = true;

    deploy = {
      enable = true;
      containers.internal = {
        autoStart = true;
        internal = true;
        openPorts = [
          {port = 80; protocol = "tcp";}
          {port = 443; protocol = "tcp";}
          {port = 53; protocol = "udp";}
        ];
        routes."forge.joshprk.me" = ''
          respond "Hello world!"
        '';
        config = ./containers/internal.nix;
      };
    };
  };

  zramSwap.enable = true;
}
