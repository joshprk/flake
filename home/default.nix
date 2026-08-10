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
    llm-agents.codex
    fish
    git
  ];

  environment.sessionVariables.CODEX_HOME = "${config.xdg.data.directory}/codex";

  xdg.config.files = {
    "fish/conf.d/10-environment.fish".text =
      lib.concatMapAttrsStringSep "\n"
      (n: v: "set -gx ${lib.escapeShellArg n} ${lib.escapeShellArg (toString v)}")
      config.environment.sessionVariables;
    "git/config" = {
      generator = (pkgs.formats.gitIni {}).generate "gitconfig";
      value = {
        init.defaultBranch = "main";
        user.name = "Joshua Park";
        user.email = "git@joshprk.me";
      };
    };
    "ghostty/config" = {
      generator = (pkgs.formats.keyValue {
        listsAsDuplicateKeys = true;
        mkKeyValue = lib.generators.mkKeyValueDefault {} " = ";
      }).generate "ghostty-config";
      value = {};
    };
    "noctalia/config.toml" = {
      generator = (pkgs.formats.toml {}).generate "noctalia-config";
      value = {};
    };
    "niri/config.kdl".source = ./files/niri.kdl;
    "Yubico/u2f_keys".source = ./files/u2f_keys;
  };
}
