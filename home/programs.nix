{config, ...}: {
  programs.fish = {
    enable = true;
  };

  programs.git = {
    enable = true;
    userEmail = "joshuprk@gmail.com";
    userName = "Joshua Park";

    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  programs.nix-index = {
    enable = true;
    enableFishIntegration = config.programs.fish.enable;
  };

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
  };

  programs.man.generateCaches = false;
}
