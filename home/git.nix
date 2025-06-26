{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.git;
in {
  options.programs.git = {
    enable = lib.mkEnableOption "the git user module";

    package = lib.mkOption {
      type = lib.types.package;
      description = "The git package to use.";
      default = pkgs.git;
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      description = "The git settings to use.";
      apply = (pkgs.formats.toml {}).generate "gitconfig";
      default = {};
    };
  };

  config = lib.mkIf cfg.enable {
    packages = [cfg.package];

    files.".config/git/config" = {
      source = cfg.settings;
    };
  };
}
