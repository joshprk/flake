{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.settings.games;

  sandbox = pkgs.buildFHSEnv {
    name = "sandbox";

    targetPkgs = pkgs: with pkgs; [
      steam-unwrapped
    ];

    chdirToPwd = false;
    dieWithParent = true;

    extraBwrapArgs = [
      ''--chdir $(if [[ "$PWD" != $HOME* ]]; then echo "$HOME"; else echo "$(echo "$PWD" | sed "s|$HOME/.local/share/games|$HOME|")"; fi)''
      "--bind $XDG_DATA_HOME/games $HOME"
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
    };
  };
}
