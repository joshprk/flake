{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.settings.games;
in {
  options.settings = {
    games = {
      enable = lib.mkEnableOption "the games module";

      extraPackages = lib.mkOption {
        type = lib.types.listOf lib.types.attrs;
        default = [];
        description = ''
          Extra packages to install in the games sandbox.
        '';
      };
    };
  };

  config = let
    mkSandbox = lib.makeOverridable ({
      name,
      package,
      ...
    }:
      pkgs.buildFHSEnv {
        inherit (package) passthru;
        inherit name;

        targetPkgs = _: [package];

        runScript = name;
        mainProgram = lib.getExe package;

        chdirToPwd = false;
        dieWithParent = true;

        extraBwrapArgs = [
          ''--chdir $(if [[ "$PWD" != $HOME* ]]; then echo "$HOME"; else echo "$(echo "$PWD" | sed "s|$HOME/.local/share/games|$HOME|")"; fi)''
          "--bind $XDG_DATA_HOME/games $HOME"
          "--dir $HOME"
          "--dir XDG_CACHE_HOME"
          "--dir XDG_CONFIG_HOME"
          "--dir XDG_DATA_HOME"
          "--dir XDG_STATE_HOME"
        ];
      });
  in
    lib.mkIf cfg.enable {
      environment.systemPackages = builtins.map mkSandbox [
        {
          name = "protonup";
          package = pkgs.protonup;
        }
        {
          name = "steam-run";
          package = pkgs.steam-run;
        }
      ]
      ++ cfg.extraPackages;

      programs.steam = {
        enable = true;
        package = mkSandbox {
          name = "steam";
          package = pkgs.steam;
        };
      };
    };
}
