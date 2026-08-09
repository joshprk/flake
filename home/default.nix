{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./dconf.nix
    ./nvf.nix
  ];

  packages = with pkgs; [
    fish
    git
  ];

  xdg.config.files = {
    "fish/conf.d/10-environment.fish".text =
      lib.concatMapAttrsStringSep "\n"
      (n: v: "set -gx ${lib.escapeShellArg n} ${lib.escapeShellArg (toString v)}")
      config.environment.sessionVariables;
    "git/config" = {
      generator = (pkgs.formats.toml {}).generate "gitconfig";
      value = {
        init.defaultBranch = "main";
        user.name = "Joshua Park";
        user.email = "git@joshprk.me";
      };
    };
    "niri/config.kdl".source = ./files/niri.kdl;
    "Yubico/u2f_keys".source = ./files/u2f_keys;
  };
}
