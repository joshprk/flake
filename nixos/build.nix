{
  config,
  lib,
  pkgs,
  flake,
  inputs,
  ...
}: let
  cfg = config.modules.build;
in {
  options.modules.build = {
    flakePath = lib.mkOption {
      type = lib.types.str;
      description = "Defines where the updated flake should be fetched from.";
      default = "github:joshprk/flake";
    };
  };

  config = {
    environment.shellAliases = {
      update = "${pkgs.writeShellScript "update-command" ''
        FLAKE="${cfg.flakePath}"
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

    nixpkgs = {
      config = {
        allowUnfree = true;
        cudaSupport = true;
      };
      flake.setNixPath = true;
      overlays = [flake.overlays.default];
    };

    nix.settings = {
      experimental-features = ["nix-command" "flakes"];
      use-xdg-base-directories = true;
      trusted-users = ["@wheel"];
    };

    nix.registry = {
      nixpkgs.flake = inputs.nixpkgs;
    };

    system.configurationRevision = flake.rev or flake.dirtyRev or "unknown-dirty";
  };
}
