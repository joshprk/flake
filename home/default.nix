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
    xwayland-satellite
  ];

  environment.sessionVariables = {
    EDITOR = "nvim";
  };
}
