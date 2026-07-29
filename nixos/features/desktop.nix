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
    boot.kernelPackages = pkgs.linuxPackages_zen;

    fonts = {
      enableDefaultPackages = true;
      fontconfig.enable = true;
    };

    programs.dconf = {
      enable = true;
    };

    services = {
      flatpak.enable = true;
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

    security.rtkit = {
      enable = true;
    };

    security.polkit = {
      enable = true;
    };

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [xdg-desktop-portal-gtk];
      xdgOpenUsePortal = true;
      config.common.default = ["gtk"];
    };
  };
}
