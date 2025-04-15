{
  config,
  lib,
  pkgs,
  ...
}: {
  home.username = "joshua";
  home.stateVersion = "25.05";

  settings.niri = {
    enable = true;
    binds = {
      "Mod+Q".action.spawn = "ghostty";
      "Mod+W".action.spawn = "firefox";
    };
  };

  settings.firefox.enable = true;
  settings.nvim.enable = true;
  settings.zsh.enable = true;

  programs.ghostty = {
    enable = true;
  };

  programs.git = {
    enable = true;
    userEmail = "joshuprk@gmail.com";
    userName = "Joshua Park";
  };
}
