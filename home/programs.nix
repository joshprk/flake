{config, ...}: {
  programs.zsh = {
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

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
  };

  programs.man.generateCaches = false;
}
