{
  config,
  lib,
  ...
}: let
  cfg = config.settings.nvim;
in {
  options.settings = {
    nvim = {
      enable = lib.mkEnableOption "the Nvim home module";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
    };
  };
}
