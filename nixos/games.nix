{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.settings.games;

  mkSandbox = lib.makeOverridable (package:
    pkgs.buildFHSEnv {
      inherit (package) name passthru;

      targetPkgs = pkgs: with pkgs; [package];
      mainProgram = lib.getExe package;
      runScript = package.name;

      chdirToPwd = false;
      dieWithParent = true;

      extraBwrapArgs = [
        "--chdir $HOME/.local/share/games"
        "--bind $XDG_DATA_HOME/games $HOME"
        "--dir $HOME/.local/share/games"
        "--dir $HOME"
      ];
    });
in {
  options.settings = {
    games = {
      enable = lib.mkEnableOption "the games module";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
      package = mkSandbox pkgs.steam;
    };
  };
}
