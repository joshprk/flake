{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.git;
in {
  options.programs.git = {
    package = lib.mkPackageOption pkgs "git" {};

    settings = lib.mkOption {
      type = lib.types.attrs;
      readOnly = true;
      default = {
        init.defaultBranch = "main";
        user.name = "Joshua Park";
        user.email = "git@joshprk.me";
      };
    };
  };

  config = {
    packages = [
      cfg.package
    ];

    xdg.config.files."git/config" = {
      generator = (pkgs.formats.toml {}).generate "gitconfig";
      value = cfg.settings;
    };
  };
}
