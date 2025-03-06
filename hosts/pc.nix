{...}: {
  settings = {
    profiles.desktop = true;

    impermanence.enable = true;
    secureboot.enable = true;

    games.enable = true;

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
