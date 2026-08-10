{
  config,
  lib,
  pkgs,
  ...
}: {
  options.features = {
    typography = lib.mkEnableOption "the typography feature";
  };

  config = lib.mkIf config.features.typography {
    fonts = {
      enableDefaultPackages = true;
      fontDir.enable = true;
      fontconfig.enable = true;
      fontconfig.defaultFonts = {
        monospace = ["IBM Plex Mono"];
        sansSerif = ["Inter"];
        serif = ["Source Serif 4"];
      };
      packages = with pkgs; [
        ibm-plex
        inter
        source-serif
      ];
    };

    # Fixes font, icon, and theme detection for non-Nix applications like Flatpak which assume FHS
    fileSystems = {
      "/usr/share/fonts" = {
        device = "/run/current-system/sw/share/X11/fonts";
        fsType = "fuse.bindfs";
        options = ["ro" "x-gvfs-hide" "resolve-symlinks"];
      };
      "/usr/share/icons" = {
        device = "/run/current-system/sw/share/icons";
        fsType = "fuse.bindfs";
        options = ["ro" "x-gvfs-hide" "resolve-symlinks"];
      };
      "/usr/share/themes" = {
        device = "/run/current-system/sw/share/themes";
        fsType = "fuse.bindfs";
        options = ["ro" "x-gvfs-hide" "resolve-symlinks"];
      };
    };

    system.fsPackages = with pkgs; [bindfs];
  };
}
