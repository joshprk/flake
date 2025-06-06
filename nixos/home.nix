{
  config,
  lib,
  pkgs,
  flake,
  ...
}: let
  cfg = config.modules.home;
in {
  /*
  * Single-user home setup.
  *
  * Easily extensible to a multi-user setup later, but flakes are more likely
  * to be stabilized than finding someone who'd want to use my systems.
  */
  options.modules.home = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable the home module.";
      default = false;
      apply = opt:
        lib.throwIfNot
        (builtins.hasAttr "home-manager" config)
        "the home module requires home-manager"
        opt;
    };

    interactive = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable the interactive home modules.";
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.joshua = {
      isNormalUser = true;
      extraGroups = ["wheel"];
      shell = pkgs.fish;
      hashedPasswordFile = config.age.secrets.pass-joshua.path;
    };

    home-manager.users.joshua = {
      home.username = "joshua";
      home.homeDirectory = "/home/joshua";
      home.stateVersion = "25.11";
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      sharedModules = [flake.homeModules.default];
    };

    programs.fish = {
      enable = true;
      interactiveShellInit = ''
         function fish_command_not_found
           set p "command-not-found"
           if test -x $p -a -f "/nix/var/nix/profiles/per-user/root/channels/nixos/programs.sqlite"
            $p $argv
             if test $status -eq 126
               $argv
             else
              return 127
            end
          else
            echo "$argv[1]: command not found" >&2
            return 127
          end
        end
      '';
    };

    services.dbus = {
      enable = true;
      implementation = "broker";
    };

    services.greetd = lib.mkIf (cfg.interactive && config.modules.niri.enable) {
      enable = true;
      settings = rec {
        initial_session.command = "${config.modules.niri.package}/bin/niri-session";
        initial_session.user = "joshua";
        default_session = initial_session;
      };
    };
  };
}
