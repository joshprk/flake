{
  config,
  lib,
  pkgs,
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
    package = pkgs.niri-unstable;
    settings.binds = {
      "Mod+Q".action.spawn = "ghostty";
    };
  };
}
