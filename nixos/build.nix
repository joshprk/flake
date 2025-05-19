{config, lib, pkgs, ...}: let
  cfg = config.modules.build;
in {
  options.modules.build = {
    flakePath = {
      type = lib.types.str;
      description = "Defines where the updated flake should be fetched from.";
      default = "github:joshprk/flake";
    };
  };

  config = {
    environment.shellAliases = {
      update = "${pkgs.writeShellScript "update-command" ''
        FLAKE="${config.modules.build.flakePath}"
        LAST_DRV="$(readlink /nix/var/nix/profiles/system --canonicalize)"
        nixos-rebuild switch --refresh --use-remote-sudo --flake $FLAKE
        NEW_DRV="$(readlink /nix/var/nix/profiles/system --canonicalize)"
        if [[ "$LAST_DRV" != "$NEW_DRV" ]]; then
          DIFF=$(nix store diff-closures "$LAST_DRV" "$NEW_DRV")
          if [[ "$DIFF" != "" ]]; then
            echo "---\n$DIFF"
          fi
        fi
      ''}";
    };

    nix.settings = {
      experimental-features = ["nix-command" "flakes"];
      use-xdg-base-directories = true;
    };
  };
}
