{
  config,
  lib,
  pkgs,
  ...
}: {
  packages = with pkgs; [fish];

  xdg.config.files = {
    "fish/conf.d/10-environment.fish".text =
      lib.concatMapAttrsStringSep "\n"
      (n: v: "set -gx ${lib.escapeShellArg n} ${lib.escapeShellArg (toString v)}")
      config.environment.sessionVariables;
  };
}
