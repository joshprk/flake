{pkgs, ...}: {
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

    programs.command-not-found.enable = false;

    nix.settings = {
      experimental-features = ["nix-command" "flakes"];
      use-xdg-base-directories = true;
    };
  };
}
