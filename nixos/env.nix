{...}: {
  options.modules.env = {
  };

  config = {
    environment = {
      variables = {
        NIXOS_OZONE_WL = "1";
      };
      enableAllTerminfo = true;
    };

    programs.bash.interactiveShellInit = ''
      [ -d "$XDG_STATE_HOME"/bash ] || mkdir -p "$XDG_STATE_HOME"/bash
      export HISTFILE="$XDG_STATE_HOME"/bash/history
    '';
  };
}
