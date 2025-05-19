{config, ...}: {
  programs.fish = {
    enable = true;
  };

  programs.man.generateCaches = false;

  programs.git = {
    enable = true;
    userEmail = "joshuprk@gmail.com";
    userName = "Joshua Park";

    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
  };
}
