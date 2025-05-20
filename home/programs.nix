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

    withNodeJs = false;
    withPerl = false;
    withPython3 = false;
    withRuby = false;

    opts = {
      expandtab = true;
      tabstop = 2;
      softtabstop = 2;
      shiftwidth = 2;
    };
  };
}
