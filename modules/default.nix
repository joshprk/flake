{
  config,
  lib,
  ...
}: let
  cfg = config.settings.builtins;
in {
  options.settings = {
    builtins = {
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
  };
}
