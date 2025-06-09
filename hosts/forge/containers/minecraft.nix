{
  config,
  lib,
  pkgs,
  ...
}: {
  services.minecraft-server = {
    enable = true;
    package = pkgs.papermcServers.papermc-1_21_5;
    declarative = true;
    eula = true;

    serverProperties = {
      white-list = true;
      max-player = 10;
    };
  };

  system.stateVersion = "25.11";
}
