{
  config,
  lib,
  ...
}: {
  options.features.niri = lib.mkEnableOption "the niri feature";

  config = lib.mkIf config.features.niri {
    programs.niri = {
      enable = true;
      useNautilus = true;
    };
  };
}
