#!/usr/bin/env bash
set -euo pipefail

case "$ORB_OPERATION" in
  spawn)
    image="$ORB_IMAGE"
    podman image inspect "${ORB_SNAPSHOT_ID-}" >/dev/null 2>&1 && image="$ORB_SNAPSHOT_ID"
    podman start "$ORB_ID" 2>/dev/null ||
      podman run --init --platform linux/arm64 -d --name "$ORB_ID" \
        "$image" sleep infinity
    podman exec -d --env ORB_TOKEN "$ORB_ID" amp orb bootstrap
    ;;
  pause)
    podman stop "$ORB_ID"
    [ -z "${ORB_SNAPSHOT_ID-}" ] || podman commit "$ORB_ID" "$ORB_SNAPSHOT_ID"
    ;;
  delete)
    podman rm -f "$ORB_ID"
    ;;
esac
