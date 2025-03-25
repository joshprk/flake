{
  config,
  lib,
  ...
}: let
  cfg = config.settings.builtins;
in {
  options.settings = {
    builtins = {
      timeZone = lib.mkOption {
        default = "America/New_York";
        example = "America/Los_Angeles";
        description = "Which system timezone to use.";
      };

      updateCommand = lib.mkOption {
        default = true;
        example = false;
        description = "Whether to enable the update command.";
        type = lib.types.bool;
      };
    };
  };

  config = {
    environment.shellAliases = {
      update =
        lib.mkIf
        cfg.updateCommand
        "nixos-rebuild switch --use-remote-sudo --flake github:joshprk/flake";
    };

    time.timeZone = config.settings.builtins.timeZone;
  };
}
