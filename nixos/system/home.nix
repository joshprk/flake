{
  config,
  lib,
  pkgs,
  flake,
  ...
}: let
  cfg = config.modules.system.home;
in {
  options.modules.system.home = {};

  config = {
    programs.bash = {
      interactiveShellInit = ''
        [ -d "$XDG_STATE_HOME"/bash ] || mkdir -p "$XDG_STATE_HOME"/bash
        export HISTFILE="$XDG_STATE_HOME"/bash/history
      '';
    };

    services.dbus = {
      implementation = "broker";
    };

    services.userborn = {
      enable = true;
      passwordFilesLocation = "/var/lib/nixos";
    };

    users = {
      mutableUsers = false;
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      sharedModules = [flake.homeModules.default];
    };
  };
}
