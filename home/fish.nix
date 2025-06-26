{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.fish;
in {
  options.programs.fish = {
    enable = lib.mkEnableOption "the fish user module";

    package = lib.mkOption {
      type = lib.types.package;
      description = "The fish package to use.";
      default = pkgs.fish;
    };
  };

  config = lib.mkIf cfg.enable {
    packages = [cfg.package];

    files.".config/fish/config.fish".text = lib.mkBefore ''
      # Import session variables
      source ${config.environment.loadEnv}
    '';
  };
}
