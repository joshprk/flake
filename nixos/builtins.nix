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
        LAST_DRV="$(readlink /nix/var/nix/profiles/system --canonicalize)"

        nixos-rebuild switch --refresh --use-remote-sudo --flake $FLAKE

        NEW_DRV="$(readlink /nix/var/nix/profiles/system --canonicalize)"

        if [[ "$LAST_DRV" != "$NEW_DRV" ]]; then
          DIFF=$(nix store diff-closures "$LAST_DRV" "$NEW_DRV")

          if [[ "$DIFF" != "" ]]; then
            echo "---"
            echo "$DIFF"
          fi
        fi
      ''}";
    };

    time.timeZone = config.settings.timeZone;
  };
}
