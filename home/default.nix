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
    waybar
  ];

  environment.sessionVariables = {
    EDITOR = "nvim";
  };
}
