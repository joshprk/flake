{...}: {
  services.open-webui = {
    enable = true;
    port = 8080;
  };

  system.stateVersion = "25.11";
}
