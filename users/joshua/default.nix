{...}: {
  isNormalUser = true;
  initialPassword = "password";
  hostGroups = ["default"];
  extraGroups = ["wheel"];
  stateVersion = "24.11";

  config = {
    config,
    lib,
    ...
  }: {
    user.hypr.enable = true;
    user.nvim.enable = true;
    user.programs.enable = true;
    user.stylix.enable = true;
    user.waybar.enable = true;
    user.xdg.enable = true;
  };
}
