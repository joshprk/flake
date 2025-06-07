{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.user.ghostty;
in {
  options.user.ghostty = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable the Ghostty user module.";
      default = false;
    };

    package = lib.mkOption {
      type = lib.types.package;
      description = "The Ghostty package to use.";
      default = pkgs.ghostty;
    };
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables = {
      TERMINAL = "${cfg.package}/bin/ghostty";
    };

    programs.ghostty = {
      inherit (cfg) enable package;
      settings = {
        auto-update = "off";
        focus-follows-mouse = true;
        gtk-single-instance = true;
        shell-integration-features = "sudo";
      };

      enableBashIntegration = lib.mkDefault config.programs.bash.enable;
      enableFishIntegration = lib.mkDefault config.programs.fish.enable;
      enableZshIntegration = lib.mkDefault config.programs.zsh.enable;
    };
  };
}
