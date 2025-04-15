{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.settings.games;

  sandbox = pkgs.buildFHSEnv {
    name = "games";

    targetPkgs = pkgs: with pkgs; [
      steam-unwrapped
    ];

    chdirToPwd = false;
    dieWithParent = true;

    extraBwrapArgs = [
      "--chdir $HOME/.local/share/games"
      "--bind $XDG_DATA_HOME/games $HOME"
      "--dir $HOME/.local/share/games"
      "--dir $HOME"
    ];
  };
in {
  options.settings = {
    games = {
      enable = lib.mkEnableOption "the games module";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [sandbox];

    programs.steam = {
      enable = true;
      package = pkgs.runCommand "steam" {nativeBuildInputs = [sandbox];} ''
        steam
      '';
    };
  };
}
