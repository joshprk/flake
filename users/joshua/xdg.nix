{
  config,
  lib,
  pkgs,
  ...
}: {
  options.user = {
    xdg = {
      enable = lib.mkEnableOption "the XDG configuration";
    };
  };

  config = {
    xdg = {
      enable = true;
      mime.enable = true;
      userDirs.createDirectories = false;
      portal = {
        enable = true;
        xdgOpenUsePortal = true;

        configPackages = with pkgs; [
          xdg-desktop-portal-hyprland
          xdg-desktop-portal-gtk
        ];

        extraPortals = config.xdg.portal.configPackages;
      };

      mimeApps = {
        enable = true;
        defaultApplications = {

          "application/pdf" = ["zen.desktop"];
          "application/octet-stream" = ["nvim.desktop"];
          "application/x-zerosize" = ["nvim.desktop"];
          "text/plain" = ["nvim.desktop"];
        };
      };
    };

    home.sessionVariables = {
      CARGO_HOME = "${config.xdg.dataHome}/cargo";
      ERRFILE = "${config.xdg.cacheHome}/x11/xsession-errors";
      IPYTHONDIR = "${config.xdg.configHome}/ipython";
      XCOMPOSECACHE = "${config.xdg.cacheHome}/x11/xcompose";

      BROWSER = "zen";
      TERMINAL = "ghostty";
    };

    gtk.gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    xresources.path = "${config.xdg.configHome}/x11/resources";
  };
}
