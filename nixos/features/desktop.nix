{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.features;
in {
  options.features = {
    desktop = lib.mkEnableOption "the desktop feature";
  };

  config = lib.mkIf cfg.desktop {
    modules.services = {
      niri.enable = true;
    };

    modules.system.home.joshua = {
      isNormalUser = true;
      extraGroups = ["wheel"];
      hashedPasswordFile = config.age.secrets.password.path;
      hjem = {
        packages = with pkgs; [
          ghostty
          firefox
          neovim
        ];

        programs.git = {
          enable = true;
          settings = {
            init.defaultBranch = "main";
            user.name = "Joshua Park";
            user.email = "git@joshprk.me";
          };
        };
      };
    };

    modules.system = {
      kernel.package = pkgs.linuxPackages_zen;
    };

    programs.fish = {
      enable = true;
    };

    services.greetd = {
      enable = true;
      settings = let
        session = {
          command = "niri-session 2>/dev/null";
          user = "joshua";
        };
      in {
        initial_session = session;
        default_session = session;
      };
    };

    users = {
      defaultUserShell = pkgs.fish;
    };
  };
}
