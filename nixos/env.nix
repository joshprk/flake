{
  config,
  lib,
  ...
}: let
  cfg = config.modules.env;
in {
  options.modules.env = {
    timeZone = lib.mkOption {
      type = with lib.types; nullOr str;
      description = "The time zone used when displaying times and dates.";
      default = "America/New_York";
    };
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

    time.timeZone = cfg.timeZone;
  };
}
