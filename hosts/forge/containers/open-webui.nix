{...}: {
  services.open-webui = {
    enable = true;
    port = 8080;
  };

  system.stateVerison = "25.11";
}
