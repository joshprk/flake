{
  config,
  lib,
  pkgs,
  ...
}: {
  packages = with pkgs; [
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
