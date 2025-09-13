{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = lib.pipe ./. [
    lib.filesystem.listFilesRecursive
    (lib.filter (path: path != ./default.nix))
  ];

  options = {
    shell.init = lib.mkOption {
      type = lib.types.str;
      default = "";
    };
  };

  config = {
    packages = with pkgs; [
      fish
    ];

    files.".config/fish/config.fish".text = ''
      if not test -n "$__HJEM_ENV_INIT"
        source "${config.environment.loadEnv}"
        ${config.shell.init}
        set __HJEM_ENV_INIT 1
      end
    '';
  };
}
