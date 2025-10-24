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

    files.".config/gtk-2.0/gtkrc" = {
      generator = (pkgs.formats.keyValue {}).generate "gtk-2.0-rc";
      value = cfg.settings;
    };

    files.".config/gtk-3.0/settings.ini" = {
      generator = (pkgs.formats.ini {}).generate "gtk-3.0-settings";
      value.Settings = config.files.".config/gtk-2.0/gtkrc".value;
    };

    files.".config/gtk-4.0/settings.ini" = {
      generator = (pkgs.formats.ini {}).generate "gtk-4.0-settings";
      value.Settings = config.files.".config/gtk-2.0/gtkrc".value;
    };

    files.".config/gtk-3.0/bookmarks".text = ''
      file://${config.directory}/Documents Documents
      file://${config.directory}/Downloads Downloads
    '';

    environment.sessionVariables = {
      GTK2_RC_FILES = "$HOME/.config/gtk-2.0/gtkrc:$HOME/.config/gtk-2.0/gtkrc.mine";
    };
  };
}
