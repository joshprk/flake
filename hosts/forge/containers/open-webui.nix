{...}: {
  services.open-webui = {
    enable = true;
    port = 8080;
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  system.stateVersion = "25.11";
}
