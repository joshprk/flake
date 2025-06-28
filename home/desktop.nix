{
  config,
  lib,
  pkgs,
  ...
}: {
  packages = with pkgs; [
    ghostty
    xwayland-satellite
    waybar
  ];

  dotfiles.".config/waybar/config" = {
    generator = (pkgs.formats.json {}).generate "waybar-config";
    value = {
      layer = "top";
      modules-left = ["niri/workspaces"];
      modules-right = ["tray" "battery" "clock"];
    };
  };
}
