{
  config,
  lib,
  pkgs,
  users ? {},
  srcPath,
  ...
}: let
  cfg = config.settings.home;
in {
  options.settings = {
    home = {
      enable = lib.mkEnableOption "the home module";
      enableZsh = lib.mkEnableOption "Zsh as the default user shell";

      wheel = lib.mkOption {
        readOnly = true;
        type = lib.types.listOf lib.types.str;
        default = ["joshua"];
        description = "A list of usernames which are given superuser access.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager = {inherit users;};

    sops = {
      defaultSopsFile = lib.path.append srcPath "secrets/default.yaml";
      age.keyFile = "/nix/keys";
      secrets = {
        "users/joshua".neededForUsers = true;
      };
    };

    users.defaultUserShell = lib.mkIf cfg.enableZsh pkgs.zsh;
    programs.zsh.enable = lib.mkIf cfg.enableZsh true;

    users.users = let
      mkUser = name: {
        inherit name;
        value = {
          inherit name;
          isNormalUser = true;
          initialPassword = "";
          hashedPasswordFile =
            lib.mkIf
            (builtins.hasAttr "users/${name}" config.sops.secrets)
            config.sops.secrets."users/${name}".path;
          extraGroups = lib.optional (builtins.elem name cfg.wheel) "wheel";
        };
      };

      regularUsers = lib.pipe users [
        (builtins.attrNames)
        (map mkUser)
        builtins.listToAttrs
      ];
    in
      regularUsers;
  };
}
