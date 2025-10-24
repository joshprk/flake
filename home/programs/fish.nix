{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.fish;
in {
  options.programs.fish = {
    package = lib.mkPackageOption pkgs "fish" {};

    shellInit = lib.mkOption {
      type = lib.types.lines;
      default = let
        drive = "$HOME/Drive";
      in ''
        function webdav
          if not mountpoint -q "${drive}"
            mkdir -p "${drive}"
            ${pkgs.rclone}/bin/rclone mount remote:/ "${drive}" \
              --vfs-cache-mode full \
              --daemon
          else
            echo "error: webdav is already mounted"
            return 1
          end
        end

        function uwebdav
          if mountpoint -q "${drive}"
            fusermount -u "${drive}"
          end
        end

        function today
          if mountpoint -q "${drive}"
            "$EDITOR" "${drive}/notes/$(date +%F).md"
          else
            echo "error: mount webdav before opening notes"
            return 1
          end
        end
      '';
    };
  };

  config = {
    packages = [
      cfg.package
    ];

    xdg.config.files."fish/config.fish".text = ''
      if not test -n "$__HJEM_ENV_INIT"
        source "${config.environment.loadEnv}"
        ${cfg.shellInit}
        set __HJEM_ENV_INIT 1
      end
    '';
  };
}
