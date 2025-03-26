{
  config,
  lib,
  pkgs,
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

      zshDefaultShell = lib.mkOption {
        default = true;
        example = false;
        description = "Whether to enable Zsh shell by default.";
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

    programs.dconf.enable =
      lib.mkIf
      ((builtins.length (builtins.attrNames config.home-manager.users)) > 0)
      true;

    programs.zsh.enable = lib.mkIf cfg.zshDefaultShell;
    users.defaultUserShell = lib.mkIf cfg.zshDefaultShell pkgs.zsh;

    time.timeZone = config.settings.builtins.timeZone;
  };
}
