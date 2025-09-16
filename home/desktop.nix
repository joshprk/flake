{
  config,
  lib,
  pkgs,
  ...
}: {
  packages = with pkgs; [
    hypridle
    hyprpaper
    vicinae
  ];

  files.".config/hypr/hypridle.conf".text = ''
    listener {
      timeout = 500
      on-timeout = niri msg action power-off-monitors
    }
  '';

  files.".config/hypr/hyprpaper.conf".text = let
    wallpaper = pkgs.fetchurl {
      url = "https://github.com/foxt/macOS-Wallpapers/blob/master/Mojave%20Night.jpg?raw=true";
      hash = "sha256-Zv7uvjSNACpI2Yck22bsA8gwVaju2Yght7y09xko9xw=";
    };
  in ''
    preload = ${wallpaper}
    wallpaper = , ${wallpaper}
  '';

  files.".config/mimeapps.list".text = ''
    [Default Applications]
    text/html=org.mozilla.firefox.desktop
    x-scheme-handler/http=org.mozilla.firefox.desktop
    x-scheme-handler/https=org.mozilla.firefox.desktop
    x-scheme-handler/about=org.mozilla.firefox.desktop
    x-scheme-handler/unknown=org.mozilla.firefox.desktop
    application/pdf=org.mozilla.firefox.desktop
  '';

  files.".config/vicinae/vicinae.json" = {
    generator = (pkgs.formats.json {}).generate "vicinae-json";
    value = {
      faviconService = "twenty";
      font = {
        size = 10;
      };
      popToRootOnClose = true;
      rootSearch = {
        searchFiles = false;
      };
      theme = {
        name = "vicinae-dark";
      };
      window = {
        csd = true;
        opacity = 0.95;
        rounding = 10;
      };
    };
  };
}
