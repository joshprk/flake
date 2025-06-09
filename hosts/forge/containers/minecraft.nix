{
  config,
  lib,
  pkgs,
  ...
}: {
  services.minecraft-server = {
    enable = true;
    package = pkgs.papermcServers.papermc-1_21_5;
    eula = true;
    declarative = true;

    serverProperties = {
      max-players = 10;
      white-list = false;
    }
    ;
  };

  system.stateVersion = "25.11";
}
