{
  lib,
  pkgs,
  ...
}: {
  options.wallpaper = lib.mkOption {
    type = lib.types.package;
    readOnly = true;
    default = pkgs.fetchurl {
      url = "https://github.com/foxt/macOS-Wallpapers/blob/master/Mojave%20Night.jpg?raw=true";
      hash = "sha256-Zv7uvjSNACpI2Yck22bsA8gwVaju2Yght7y09xko9xw=";
    };
  };
}
