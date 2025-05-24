{
  config,
  lib,
  pkgs,
  nixosConfig,
  ...
}: let
  cfg = config.user.stylix;
in {
  options.user.stylix = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable stylix home module.";
      default = nixosConfig.modules.home.interactive;
    };

    image = lib.mkOption {
      type = lib.types.package;
      description = "The image package to use.";
      default = pkgs.fetchurl {
        url = lib.concatStrings [
          "https://github.com/KDE/plasma-workspace-wallpapers"
          "/blob/master/DarkestHour/contents/images/2560x1600.jpg?raw=true"
        ];
        sha256 = "sha256-jjcD+uOjwhex/Cs5m3Bs03IFhCaNBxuhU+SAnapV8c4=";
      };
    };

    base16Scheme = lib.mkOption {
      type = lib.types.str;
      description = "The base16scheme configuration to use.";
      default = "${pkgs.base16-schemes}/share/themes/tomorrow-night.yaml";
    };

    font.name = lib.mkOption {
      type = lib.types.str;
      description = "The font name of `config.user.stylix.font.package`.";
      default = "Inter";
    };

    font.package = lib.mkOption {
      type = lib.types.package;
      description = "The font package to use.";
      default = pkgs.inter;
    };

    fontMono.name = lib.mkOption {
      type = lib.types.str;
      description = "The font name of `config.user.stylix.fontMono.package`.";
      default = "JetBrainsMono Nerd Font";
    };

    fontMono.package = lib.mkOption {
      type = lib.types.package;
      description = "The monospace package to use.";
      default = pkgs.nerd-fonts.jetbrains-mono;
    };

    iconTheme.light = lib.mkOption {
      type = lib.types.str;
      description = "The light icon theme name to use.";
      default = "Adwaita";
    };

    iconTheme.dark = lib.mkOption {
      type = lib.types.str;
      description = "The dark icon theme name to use";
      default = "Adwaita";
    };

    iconTheme.package = lib.mkOption {
      type = lib.types.package;
      description = "The icon theme package to use.";
      default = pkgs.adwaita-icon-theme;
    };

    cursor.name = lib.mkOption {
      type = lib.types.str;
      description = "The cursor name of `config.user.stylix.cursor.package`.";
      default = "catppuccin-mocha-dark-cursors";
    };

    cursor.package = lib.mkOption {
      type = lib.types.package;
      description = "The cursor package to use.";
      default = pkgs.catppuccin-cursors.mochaDark;
    };

    cursor.size = lib.mkOption {
      type = lib.types.int;
      description = "The cursor size of `config.user.stylix.cursor.package`.";
      default = 24;
    };
  };

  config = lib.mkIf cfg.enable {
    stylix = {
      inherit (cfg) enable image base16Scheme;
      targets = {
        nixvim.enable = false;
      };
      fonts = {
        sansSerif = {inherit (cfg.font) name package;};
        monospace = {inherit (cfg.fontMono) name package;};
        serif = config.stylix.fonts.sansSerif;
        emoji = config.stylix.fonts.sansSerif;
      };
      cursor = {inherit (cfg.cursor) name package size;};
      iconTheme = cfg.iconTheme // {enable = true;};
    };

    services.hyprpaper.enable = true;

    home.file = {
      ".themes/adw-gtk3".enable = false;
      ".icons/${config.stylix.cursor.name}".enable = false;
      ".icons/default/index.theme".enable = false;
    };
  };
}
