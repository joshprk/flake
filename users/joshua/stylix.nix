{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.user.stylix;
in {
  options.user = {
    stylix = {
      enable = lib.mkEnableOption "the Stylix configuration";
    };
  };

  config = lib.mkIf cfg.enable {
    stylix = {
      enable = true;
      polarity = "dark";
      base16Scheme =
        "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

      image = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/kx/wallhaven-kx9ql7.jpg";
        sha256 = "sha256-D0P9pTc5LVheYuhzTg1w9cUdK2TjsJf+tKn6Diwdxss=";
      };

      cursor = {
        name = "catppuccin-mocha-dark-cursors";
        package = pkgs.catppuccin-cursors.mochaDark;
        size = 24;
      };

      fonts = {
        serif = {
          package = pkgs.inter;
          name = "Inter";
        };

        sansSerif = config.stylix.fonts.serif; 
        emoji = config.stylix.fonts.serif;

        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono NerdFont";
        };
      };

      iconTheme = {
        enable = true;
        package = pkgs.candy-icons;
        dark = "candy-icons";
        light = "candy-icons";
      };

      targets = {
        nixvim.enable = false;
      };
    };

    # fixes home directory artifacts
    home.file = {
      ".icons/default/index.theme".enable = false;
      ".icons/${config.home.pointerCursor.name}".enable = false;
      ".themes/adw-gtk3".enable = false;
    };
  };
}
