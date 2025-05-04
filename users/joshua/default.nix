{
  config,
  lib,
  ...
}: {
  home.username = "joshua";
  home.stateVersion = "25.05";

  settings = {
    niri.enable = true;
    firefox.enable = true;
    nvim.enable = true;
    zsh.enable = true;
  };

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
      auto-update = "off";
      focus-follows-mouse = true;
      gtk-single-instance = true;
      shell-integration-features = "sudo";
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
