{...}: {
  settings = {
    profiles.desktop = true;
    fixes.mouseWakeup = true;

    impermanence.enable = true;
    secureboot.enable = true;

    games.enable = true;
    virt.enable = true;

    remote = {
      server.enable = true;
    };

    nvidia = {
      enable = true;
      tuning = {
        enable = true;
        gpuClock = 1700;
        memoryClock = 10001;
      };
    };
  };

  zramSwap.enable = true;
}
