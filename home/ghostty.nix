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
      auto-update = "off";
      font-family = "JetBrainsMono Nerd Font";
      font-size = 10.5;
      quit-after-last-window-closed = true;
      theme = "Catppuccin Mocha";
      window-padding-color = "extend";
      window-padding-x = 4;
      window-padding-y = 4;
    };
  };
}
