{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.apps.hyprland;
in {
  options.modules.apps.hyprland = {
    enable = lib.mkEnableOption "the hyprland module";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      catppuccin-cursors.mochaDark
      nautilus
    ];

    programs.dconf.profiles.user = {
      databases = [
        {
          lockAll = true;
          settings = {
            "org/gnome/desktop/interface" = {
              color-scheme = "prefer-dark";
              clock-format = "12h";
              clock-show-weekday = true;
            };
          };
        }
      ];
    };

    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };

    services.gnome.gnome-keyring = {
      enable = false;
    };

    services.gvfs = {
      enable = true;
    };

    services.logind = {
      settings.Login = {
        HandlePowerKeyLongPress = "poweroff";
        HandlePowerKey = "suspend";
      };
    };

    services.pipewire = {
      enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    services.power-profiles-daemon = {
      enable = true;
    };

    services.udisks2 = {
      enable = true;
    };

    services.upower = {
      enable = true;
    };

    fonts.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
    ];

    xdg.icons = {
      enable = true;
      fallbackCursorThemes = ["catppuccin-mocha-dark-cursors"];
    };

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
    };

    security = {
      rtkit.enable = true;
      polkit.enable = true;
    };
  };
}
