{
  lib,
  openssl,
  writers,
  ...
}:
writers.writeBashBin "wizard" {} ''
  set -euo pipefail

  if [[ $EUID -ne 0 ]]; then
    echo "wizard: this script must be run as root" >&2
    exit 1
  fi

  if [[ $# -lt 1 ]]; then
    echo "wizard: no hostname provided" >&2
    exit 1
  fi

  flake="${./..}#$1"
  password=$(${lib.getExe openssl} rand -hex 32)

  echo "wizard: running disko"

  disko \
    --mode destroy,format,mount \
    --yes-wipe-all-disks \
    --flake "$flake" \
    < <(yes "$password")

  for device in /dev/mapper/*; do
    if cryptsetup status "$device" >/dev/null 2>&1; then
      dm_name=$(basename "$(readlink -f "$device")")
      luks_part="/dev/$(ls "/sys/class/block/$dm_name/slaves")"

      echo "wizard: enrolling $luks_part to tpm"

      if echo -n "$password" | systemd-cryptenroll \
        --tpm2-device=auto \
        --tpm2-pcrs=0,2,7,12 \
        --unlock-key-file=/dev/stdin \
        "$luks_part"; then
        echo "wizard: successfully enrolled $luks_part"
      else
        echo "wizard: failed to enroll $luks_part" >&2
      fi
    fi
  done

  echo "wizard: running nixos-install"

  unset password
  nixos-install --no-root-password --flake "$flake"

  echo "wizard: completed installation"
''
