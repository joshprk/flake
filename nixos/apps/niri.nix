{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.apps.niri;
in {
  options.modules.apps.niri = {
    enable = lib.mkEnableOption "the niri module";
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

    programs.niri = {
      enable = true;
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

      extraConfig.pipewire."92-quantum" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.quantum" = 1024;
          "default.clock.min-quantum" = 1024;
          "default.clock.max-quantum" = 1024;
        };
      };

      extraConfig.pipewire-pulse."92-quantum" = {
        context.modules = [
          {
            name = "libpipewire-module-protocol-pulse";
            args = {
              pulse.min.req = "1024/48000";
              pulse.default.req = "1024/48000";
              pulse.max.req = "1024/48000";
              pulse.min.quantum = "1024/48000";
              pulse.max.quantum = "1024/48000";
            };
          }
        ];
        stream.properties = {
          node.latency = "32/48000";
          resample.quality = 1;
        };
      };
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
      configPackages = [config.programs.niri.package];
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-gnome
      ];
      xdgOpenUsePortal = true;
    };

    security = {
      rtkit.enable = true;
      polkit.enable = true;
    };
  };
}
