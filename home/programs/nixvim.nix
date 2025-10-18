{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.nixvim;
in {
  options.programs.nixvim = {
    enable = lib.mkEnableOption "the nixvim program";
    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
    };
  };

  config = lib.mkIf cfg.enable {
    packages = lib.singleton (pkgs.nixvim.makeNixvim cfg.settings);

    environment.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };
}
