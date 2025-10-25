{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.gtk;
in {
  options.gtk = {
    settings = lib.mkOption {
      type = lib.types.attrs;
      readOnly = true;
      default = {
        gtk-theme-name = "Adwaita-dark";
        gtk-application-prefer-dark-theme = true;
      };
    };
  };

  config = {
    packages = with pkgs; [
      adwaita-icon-theme
    ];

    xdg.config.files."gtk-2.0/gtkrc" = {
      generator = (pkgs.formats.keyValue {}).generate "gtk-2.0-rc";
      value = cfg.settings;
    };

    xdg.config.files."gtk-3.0/gtk.css".text = ''
      headerbar entry,
      headerbar spinbutton,
      headerbar button,
      headerbar separator {
          margin-top: 2px; /* same as headerbar side padding for nicer proportions */
          margin-bottom: 2px;
      }
    '';

    xdg.config.files."gtk-3.0/settings.ini" = {
      generator = (pkgs.formats.ini {}).generate "gtk-3.0-settings";
      value.Settings = config.xdg.config.files."gtk-2.0/gtkrc".value;
    };

    xdg.config.files."gtk-4.0/settings.ini" = {
      generator = (pkgs.formats.ini {}).generate "gtk-4.0-settings";
      value.Settings = config.xdg.config.files."gtk-2.0/gtkrc".value;
    };

    xdg.config.files."gtk-3.0/bookmarks".text = ''
      file://${config.directory}/Documents Documents
      file://${config.directory}/Downloads Downloads
    '';

    environment.sessionVariables = {
      GTK2_RC_FILES = "$HOME/.config/gtk-2.0/gtkrc:$HOME/.config/gtk-2.0/gtkrc.mine";
    };
  };
}
