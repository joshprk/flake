{
  config,
  lib,
  pkgs,
  ...
}: {
  packages = with pkgs; [
    ghostty
  ];

  files.".config/ghostty/config" = {
    generator = (pkgs.formats.keyValue {
      listsAsDuplicateKeys = true;
      mkKeyValue = lib.generators.mkKeyValueDefault {} " = ";
    }).generate "ghostty-config";
    value = {
      font-family = "Lilex Nerd Font";
      font-size = 11;
      theme = "catppuccin-mocha";
      window-padding-color = "extend";
      window-padding-x = 4;
      window-padding-y = 4;
    };
  };
}
