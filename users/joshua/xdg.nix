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
      portal = rec {
        enable = true;
        xdgOpenUsePortal = true;

        extraPortals = with pkgs; [
          xdg-desktop-portal-hyprland
          xdg-desktop-portal-gtk
        ];

        configPackages = extraPortals;
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
      XCOMPOSECACHE = "${config.xdg.cacheHome}/x11/xcompose";
      IPYTHONDIR = "${config.xdg.configHome}/ipython";

      BROWSER = "zen";
      TERMINAL = "ghostty";
    };

    gtk.gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    xresources.path = "${config.xdg.configHome}/x11/resources";
  };
}
