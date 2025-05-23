{config, lib, pkgs, ...}: let
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
      TERMINAL = "${cfg.package}";
    };

    programs.ghostty = {
      inherit (cfg) enable package;
      enableFishIntegration = config.programs.fish.enable;
      settings = {
        auto-update = "off";
        focus-follows-mouse = true;
        gtk-single-instance = true;
        shell-integration-features = "sudo";
      };
    };
  };
}
