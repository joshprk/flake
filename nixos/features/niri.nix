{
  config,
  lib,
  ...
}: {
  options.features = {
    niri = lib.mkEnableOption "the niri feature";
  };

  config = lib.mkIf config.features.niri {
    environment.etc."niri/config.kdl".source = ../files/niri.kdl;

    programs.niri = {
      enable = true;
      useNautilus = true;
    };
  };
}
