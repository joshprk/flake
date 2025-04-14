{
  config,
  lib,
  osConfig,
  ...
}: {
  home.username = "joshua";
  home.stateVersion = "25.05";

  /* temporary configuration until modules */
  programs.ghostty = {
    enable = true;
  };

  programs.git = {
    enable = true;
  };

  programs.niri = {
    inherit (osConfig.programs.niri) package;
    settings.binds = {
      "Mod+Q".action.spawn = "ghostty";
    };
  };
}
