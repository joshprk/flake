{
  lib,
  inputs,
  ...
}: {
  flake.nixosConfigurations =
    ./hosts
    |> builtins.readDir
    |> lib.mapAttrs' (n: _v: rec {
      name = lib.removeSuffix ".nix" n;
      value = lib.nixosSystem {
        specialArgs.flakeInputs = inputs;
        specialArgs.homeModule = ./home;
        specialArgs.hostSpec = ./specs/${name}.json;
        modules = [./nixos ./hosts/${n}];
      };
    });

  perSystem = {pkgs, ...}: {
    packages.image = let
      nixos = pkgs.nixos ({modulesPath, ...}: {
        imports = ["${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"];
        nix.settings.experimental-features = ["flakes" "nix-command" "pipe-operators"];
      });
    in
      nixos.config.system.build.isoImage;

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
