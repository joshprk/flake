{
  config,
  lib,
  ...
}: {
  config = {
    home.sessionVariables = {
      XCOMPOSECACHE = "${config.xdg.cacheHome}/X11/xcompose";
    };

    xdg.enable = true;
  };
}
