{
  config,
  lib,
  pkgs,
  ...
}: {
  packages = with pkgs; [
    firefox
    neovim
    ripgrep
  ];

  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "main";
      user.name = "Joshua Park";
      user.email = "git@joshprk.me";
    };
  };

  programs.ghostty = {
    enable = true;
  };
}
