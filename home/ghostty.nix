{
  lib,
  pkgs,
  ...
}: {
  xdg.config.files."ghostty/config" = {
    generator = (pkgs.formats.keyValue {
      listsAsDuplicateKeys = true;
      mkKeyValue = lib.generators.mkKeyValueDefault {} " = ";
    }).generate "ghostty-config";
    value = {
      auto-update = "off";
      font-family = "IBM Plex Mono";
      font-size = 9;
      theme = "noctalia";
      window-padding-color = "extend";
    };
  };
}
