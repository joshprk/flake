{
  config,
  lib,
  pkgs,
  ...
}: {
  packages = with pkgs; [
    firefox
    git
    ghostty
    neovim
    ripgrep
  ];

  environment.sessionVariables = {
    EDITOR = "nvim";
  };
}
