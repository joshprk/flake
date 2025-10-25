{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.rclone;
in {
  options.programs.rclone = {
    package = lib.mkPackageOption pkgs "rclone" {};

    webdavPath = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      default = "$HOME/store";
    };
  };

  config = {
    packages = [
      cfg.package
    ];

    programs.fish.shellInit = ''
      function webdav
        if not mountpoint -q "${cfg.webdavPath}"
          mkdir -p "${cfg.webdavPath}"
          ${lib.getExe' cfg.package "rclone"} mount remote:/ "${cfg.webdavPath}" \
            --vfs-cache-mode full \
            --daemon
        else
          echo "error: webdav is already mounted"
          return 1
        end
      end

      function uwebdav
        if mountpoint -q "${cfg.webdavPath}"
          fusermount -u "${cfg.webdavPath}"
        end
      end

      function today
        if mountpoint -q "${cfg.webdavPath}"
          "$EDITOR" "${cfg.webdavPath}/notes/$(date +%F).md"
        else
          echo "error: mount webdav before opening notes"
          return 1
        end
      end
    '';
  };
}
