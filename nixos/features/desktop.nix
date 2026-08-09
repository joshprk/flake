{
  config,
  lib,
  pkgs,
  ...
}: {
  options.features = {
    desktop = lib.mkEnableOption "the desktop feature";
  };

  config = lib.mkIf config.features.desktop {
    boot.kernelPackages = lib.mkForce pkgs.linuxPackages_zen;

    fonts = {
      enableDefaultPackages = true;
      fontconfig.enable = true;
    };

    programs = {
      dconf.enable = true;
      niri.enable = true;
      noctalia = {
        enable = true;
        systemd.enable = true;
        recommendedServices.enable = true;
      };
    };

    services = {
      flatpak.enable = true;
      gnome.gnome-keyring.enable = true;
      pipewire = {
        enable = true;
        pulse.enable = true;
        wireplumber.enable = true;
      };
      power-profiles-daemon.enable = true;
      udisks2.enable = true;
      upower.enable = true;
      xserver = {
        enable = true;
        displayManager.startx.enable = true;
      };
    };

    security = {
      rtkit.enable = true;
      polkit.enable = true;
    };

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
    };
  };
}
