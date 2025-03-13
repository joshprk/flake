{
  config,
  lib,
  options,
  homeManagerModules,
  ...
}: let
  cfg = config.settings.home;
in {
  options.settings = {
    home = {
      enable = lib.mkEnableOption "the home module";

      directory = lib.mkOption {
        type = lib.types.path;
        default = ../users;
        description = ''
          Which directory to look for user-specific home manager modules.
        '';
      };

      users = lib.mkOption {
        type = options.users.users.type;
        default = {};
        description = ''
          Alias of `users.users`.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.sessionVariables = {
      CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
    };

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
      backupFileExtension = "bk";
      sharedModules = homeManagerModules;

      extraSpecialArgs = {};

      users = let
        getDir = dir: builtins.toPath "${cfg.directory}/${dir}";
        mkEntry = user: {
          name = user;
          value = import (getDir user);
        };
        names = builtins.attrNames cfg.users;
        filtered =
          builtins.filter (name: builtins.pathExists (getDir name)) names;
        entries = map mkEntry filtered;
      in
        builtins.listToAttrs entries;
    };

    # TODO: make automatic
    programs.zsh.enable = true;

    users = {
      inherit (cfg) users;
      mutableUsers = false;
    };

    nix.settings = {
      use-xdg-base-directories = true;
    };
  };
}
