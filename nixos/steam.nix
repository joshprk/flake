{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.steam;
in {
  options.modules.steam = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable the Steam module.";
      default = false;
    };

    directory = lib.mkOption {
      type = lib.types.str;
      description = "Which path to contain Steam files in.";
      default = "$XDG_DATA_HOME/steam";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
      package = let
        overlay = prev:
          pkgs.buildFHSEnv (prev
            // {
              extraBwrapArgs =
                prev.extraBwrapArgs
                ++ [
                  "--bind ${cfg.directory} $HOME"
                  "--chdir ${cfg.directory}"
                  "--dir ${cfg.directory}"
                ];
              chdirToPwd = false;
              dieWithParent = true;
            });
      in
        pkgs.steam.override {buildFHSEnv = overlay;};
      extraCompatPackages = with pkgs; [proton-ge-bin];
    };
  };
}
