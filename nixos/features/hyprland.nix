{
  config,
  lib,
  pkgs,
  ...
}: let
  hyprlandSession = pkgs.writeShellScript "hyprland-session" ''
    systemctl --user reset-failed
    systemctl --user import-environment

    if command -v dbus-update-activation-environment >/dev/null 2>&1; then
      dbus-update-activation-environment --all
    fi

    status=0

    systemctl --user --wait start hyprland.service || status=$?
    systemctl --user stop graphical-session.target

    exit "$status"
  '';
in {
  options.features = {
    hyprland = lib.mkEnableOption "the Hyprland feature";
  };

  config = lib.mkIf config.features.hyprland {
    programs.hyprland = {
      enable = true;
      package = pkgs.hyprland.overrideAttrs (oldAttrs: {
        passthru = (oldAttrs.passthru or {}) // {providedSessions = ["hyprland"];};
        postInstall = ''
          ${oldAttrs.postInstall or ""}
          rm "$out/share/wayland-sessions/hyprland-uwsm.desktop"
          substituteInPlace "$out/share/wayland-sessions/hyprland.desktop" \
            --replace-fail "Exec=$out/bin/start-hyprland" "Exec=${hyprlandSession}"
        '';
      });
    };

    systemd.user.services.hyprland = {
      restartIfChanged = false;
      enableDefaultPath = false;
      unitConfig = {
        Description = "A tiling Wayland compositor";
        BindsTo = "graphical-session.target";
        Before = ["graphical-session.target" "xdg-desktop-autostart.target"];
        Wants = [
          "graphical-session-pre.target"
          "graphical-session.target"
          "xdg-desktop-autostart.target"
        ];
        After = "graphical-session-pre.target";
      };
      serviceConfig = {
        Slice = "session.slice";
        ExecStart = lib.getExe' config.programs.hyprland.package "start-hyprland";
      };
    };
  };
}
