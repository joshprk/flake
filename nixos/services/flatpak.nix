{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.services.flatpak;
in {
  options.modules.services.flatpak = {
    enable = lib.mkEnableOption "the flatpak module";

    remotes = lib.mkOption {
      type = with lib.types; attrsOf str;
      description = "An attrset of Flatpak remotes.";
      default = {
        flathub = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      };
    };

    apps = lib.mkOption {
      type = with lib.types; listOf (submodule {
        options = {
          remote = lib.mkOption {
            type = str;
          };

          name = lib.mkOption {
            type = str;
          };
        };
      });
      description = "A list of applications which are automatically installed.";
      default = [];
    };
  };

  config = lib.mkIf cfg.enable {
    modules.system = {
      impermanence.extraDirectories = ["/var/lib/flatpak"];
    };

    services.flatpak = {
      enable = true;
    };

    systemd.services.flatpak-add-remotes = {
      wantedBy = ["multi-user.target"];
      path = [config.services.flatpak.package];
      script =
        cfg.remotes
        |> builtins.mapAttrs (n: v:
          "flatpak remote-add --if-not-exists ${n} ${v}"
        )
        |> builtins.attrValues
        |> lib.concatStringsSep "\n";
    };

    systemd.services.flatpak-install = {
      wantedBy = ["multi-user.target"];
      after = ["network-online.target"];
      wants = ["network-online.target"];
      path = [config.services.flatpak.package];
      serviceConfig.IOSchedulingClass = "2";
      serviceConfig.IOSchedulingPriority = "6";
      script = let
        installScript =
          cfg.apps
          |> map (v: "flatpak install ${v.remote} ${v.name}")
          |> lib.concatStringsSep "\n";
      in ''
        ${installScript}
        flatpak remove --unused
      '';
    };
  };
}
