{
  config,
  lib,
  nixosConfig,
  ...
}: let
  cfg = config.user.niri;
in {
  options.user.niri = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable the niri home module.";
      default = nixosConfig.modules.niri.enable;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.niri = {
      inherit (nixosConfig.programs.niri) package;
      enable = true;
      settings = {
        binds = with config.lib.niri.actions; {
          "Mod+Q".action = spawn "$TERMINAL";
        };
      };
    };

    # set certain software to default to not get locked out
    modules.ghostty.enable = lib.mkDefault true;
  };
}
