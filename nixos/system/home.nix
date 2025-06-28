{
  config,
  lib,
  pkgs,
  options,
  flake,
  ...
}: let
  cfg = config.modules.system.home;
in {
  # Module magic. To avoid infinite recursion, `users.users` is aliased onto
  # `modules.system.home` and merged with another option such that `hjem`
  # option exists.
  imports = lib.singleton {
    options.modules.system.home = options.users.users;
  };

  options.modules.system.home = lib.mkOption {
    type = with lib.types;
      attrsOf (submodule {
        options.hjem = lib.mkOption {
          type = lib.types.deferredModule;
          description = "The hjem module for this user.";
          default = {};
        };
      });
  };

  config = {
    programs.bash = {
      interactiveShellInit = ''
        XDG_STATE_HOME="''${XDG_STATE_HOME:-$HOME/.local/state}"
        [ -d "$XDG_STATE_HOME"/bash ] || mkdir -p "$XDG_STATE_HOME"/bash
        export HISTFILE="$XDG_STATE_HOME"/bash/history
      '';
    };

    programs.fish = {
      interactiveShellInit = ''
        function fish_command_not_found
          echo "$argv[1]: command not found"
        end
      '';
    };

    services.dbus = {
      implementation = "broker";
    };

    services.userborn = {
      enable = true;
      passwordFilesLocation = "/var/lib/nixos";
    };

    hjem = {
      extraModules = [flake.homeModules.default];
      users = lib.mapAttrs (_: v: v.hjem) cfg;
    };

    users = {
      mutableUsers = false;
      users = lib.mapAttrs (_: v: lib.removeAttrs v ["hjem"]) cfg;
    };
  };
}
