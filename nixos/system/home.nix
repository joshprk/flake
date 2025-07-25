{
  config,
  lib,
  pkgs,
  var,
  ...
}: {
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
    implementation = lib.mkDefault "broker";
  };

  services.userborn = {
    enable = lib.mkDefault true;
    passwordFilesLocation = lib.mkDefault "/var/lib/nixos";
  };

  hjem = {
    extraModules = var.homeModules;
  };

  users = {
    mutableUsers = lib.mkDefault false;
  };
}
