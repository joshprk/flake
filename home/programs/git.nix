{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.git;
in {
  options.programs.git = {
    enable = lib.mkEnableOption "the git program";
    package = lib.mkPackageOption pkgs "git" {};

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
    };
  };

  config = lib.mkIf cfg.enable {
    packages = [cfg.package];

    xdg.config.files."git/config" = {
      generator = (pkgs.formats.toml {}).generate "gitconfig";
      value = cfg.settings;
    };
  };
}
