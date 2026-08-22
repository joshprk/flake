{
  config,
  lib,
  ...
}: {
  options.features = {
    hyprland = lib.mkEnableOption "the Hyprland feature";
  };

  config = lib.mkIf config.features.hyprland {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };
  };
}
