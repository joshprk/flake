{
  config,
  lib,
  pkgs,
  ...
}: let
  compileDconfDb = dir:
    pkgs.runCommand "dconf-db" {
      nativeBuildInputs = [(lib.getBin pkgs.dconf)];
    } "dconf compile $out ${dir}";

  createKeyFile = cfg: pkgs.writeTextDir "keyfile" (lib.generators.toDconfINI cfg);
  buildDconfBin = cfg: compileDconfDb (createKeyFile cfg);
in {
  options.dconf = lib.mkOption {
    type = with lib.types; nullOr attrs;
    default = null;
  };

  config = lib.mkIf (config.dconf != null) {
    xdg.config.files."dconf/user" = {
      generator = buildDconfBin;
      value = config.dconf;
    };
  };
}
