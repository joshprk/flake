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

  dotfiles.".config/systemd/user/hello-user.service" = {
    generator = (pkgs.formats.ini {}).generate "hello-user.service";
    value = {
      Unit.Description = "Checks if user systemd services works";
      Service.ExecStart = "${pkgs.coreutils}/bin/echo Hello world";
      Install.WantedBy = "default.target";
    };
  };
}
