{
  config,
  lib,
  inputs,
  ...
}: {
  flake.nixosConfigurations =
    ./hosts
    |> builtins.readDir
    |> lib.mapAttrs' (n: v: rec {
      name = lib.removeSuffix ".nix" n;
      value = lib.nixosSystem {
        specialArgs = {
          flakeInputs = inputs;
          homeModule = ./home;
          hostSpec = ./specs/${name}.json;
        };
        modules = [./nixos ./hosts/${n}];
      };
    });

  flake.overlays = {
    shared-nvf = final: prev: {
      nvf = cfg:
        (inputs.nvf.lib.neovimConfiguration {
          pkgs = prev;
          modules = [cfg];
        }).neovim;
    };
  };

  perSystem = {pkgs, ...}: let
    mkSystem = cfg: lib.nixosSystem {modules = [cfg];};
    mkImage = cfg: (mkSystem cfg).config.system.build.isoImage;
  in {
    packages.image = mkImage ({modulesPath, ...}: {
      imports = ["${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"];
      networking.networkmanager.enable = true;
      nixpkgs.hostPlatform = pkgs.stdenv.hostPlatform.system;
      nix.settings.experimental-features = [
        "flakes"
        "nix-command"
        "pipe-operators"
      ];
    });

    packages.install = pkgs.writers.writeBashBin "flake-install" {} ''
      set -euo pipefail

      if [[ $EUID -ne 0 ]]; then
        echo "install: this script must be run as root" >&2
        exit 1
      fi

      if [[ $# -lt 1 ]]; then
        echo "install: no hostname provided" >&2
        exit 1
      fi

      flake="${./.}#$1"
      password=$(${lib.getExe pkgs.openssl} rand -hex 32)

      echo "install: running disko"

      disko \
        --mode destroy,format,mount \
        --yes-wipe-all-disks \
        --flake "$flake" \
        < <(yes "$password")

      for device in /dev/mapper/*; do
        if cryptsetup status "$device" >/dev/null 2>&1; then
          dm_name=$(basename "$(readlink -f "$device")")
          luks_part="/dev/$(ls "/sys/class/block/$dm_name/slaves")"

          echo "install: enrolling $luks_part to tpm"

          if systemd-cryptenroll \
            --tpm2-device=auto \
            --tpm2-pcrs=0,2,7,12 \
            --unlock-key-file=<(printf '%s' "$password") \
            "$luks_part"; then
            echo "install: successfully enrolled $luks_part"
          else
            echo "install: failed to enroll $luks_part" >&2
          fi

          echo "install: enrolling recovery key for $luks_part"

          if systemd-cryptenroll \
            --unlock-key-file=<(printf '%s' "$password") \
            --recovery-key \
            "$luks_part"; then
            echo "install: successfully enrolled recovery key for $luks_part"
          else
            echo "install: failed to enroll recovery key for $luks_part" >&2
          fi
        fi
      done

      echo "install: running nixos-install"

      unset password
      nixos-install --no-root-password --flake "$flake"

      echo "install: completed installation"
    '';
  };
}
