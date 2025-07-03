{
  config,
  lib,
  pkgs,
  options,
  flake,
  inputs,
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
    # This is necessary to cleanup files from previous state properly. 
    modules.system = {
      impermanence.extraDirectories = lib.mkIf (config.hjem.linker != null) [
        "/var/lib/hjem"
      ];
    };

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

    systemd.user.services.hjem-services = let
      userFiles =
        config.hjem.users
        |> lib.mapAttrs (_: v: with v;
          v.files
          |> builtins.attrNames
          |> lib.filter (lib.hasPrefix ".config/systemd/user")
        );
      manifest =
        userFiles
        |> builtins.toJSON
        |> builtins.toFile "user-service-manifest";
    in {
      after = ["nixos-activation.target"];
      wantedBy = ["default.target"];
      script = ''
        MANIFEST_FILE=${manifest}
        rm -rf $HOME/.config/systemd/user/*.wants
        ${lib.getExe pkgs.jq} -r --arg user "$USER" '.[$user][]' "$MANIFEST_FILE" | while read unitpath; do
          unit=$(basename "$unitpath")
          if [ -f "$HOME/$unitpath" ]; then
            systemctl --user enable "$unit" || true
            echo "$USER: activated $unit"
          else
            echo "$USER: tried to activate $unit which does not exist"
          fi
        done
      '';
    };

    hjem = {
      extraModules = [flake.homeModules.default];
      linker = inputs.hjem.packages.${pkgs.system}.smfh;
      users = lib.mapAttrs (_: v: v.hjem) cfg;
    };

    users = {
      mutableUsers = false;
      users = lib.mapAttrs (_: v: lib.removeAttrs v ["hjem"]) cfg;
    };
  };
}
