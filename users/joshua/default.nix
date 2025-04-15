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

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    config = {
      global.warn_timeout = "0";
      global.hide_env_diff = true;
    };
  };

  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      gtk-single-instance = true;
    };
  };

  programs.git = {
    enable = true;
    userEmail = "joshuprk@gmail.com";
    userName = "Joshua Park";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  programs.ripgrep = {
    enable = true;
  };
}
