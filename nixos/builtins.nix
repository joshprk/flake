{
  config,
  lib,
  pkgs,
  ...
}: {
  options.settings = {
    timeZone = lib.mkOption {
      type = lib.types.str;
      default = "America/New_York";
      example = "America/Los_Angeles";
      description = "Which system timezone to use.";
    };
  };

  config = {
    environment.shellAliases = {
      update = "${pkgs.writeShellScript "update-command" ''
        FLAKE="github:joshprk/flake"
        LAST_DRV="$(readlink /nix/var/nix/profiles/system)"

        nixos-rebuild switch --refresh --use-remote-sudo --flake $FLAKE

        NEW_DRV="$(readlink /nix/var/nix/profiles/system)"

        if [[ "$LAST_DRV" != "$NEW_DRV" ]]; then
          echo "---"
          nix store diff-closures \
            "/nix/var/nix/profiles/$LAST_DRV" \
            "/nix/var/nix/profiles/$NEW_DRV"
        fi
      ''}";
    };

    time.timeZone = config.settings.timeZone;
  };
}
