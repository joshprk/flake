# Amp orbs on forge

`pods.amp-orbs = true` runs Amp and a nested Podman engine in one OCI container.
No host socket, dedicated user, or KVM is needed. The dispatch is Amp's Docker
example using Podman and ARM64. The outer container provides 1 GiB of shared
memory for browser workloads.

Create `/nix/secrets/amp-orbs` as a root-owned, mode `0600` environment file:

```ini
AMP_ORB_PROVIDER_TOKEN=<provider token>
```

Nix builds the controller image from a pinned upstream Podman image, nixpkgs'
Amp CLI, and `dispatch.sh`. The service loads that image; it does not build or
download the controller at startup. Apply the configuration and inspect
`journalctl -u podman-amp-orbs`. Stop any old controller using this token first.
Existing host-level orbs are not migrated.

## Lifecycle and storage

- `spawn`: start an existing orb or create one from a project image, then run
  detached `amp orb bootstrap`.
- `pause`: stop the orb, retaining its disk; optionally commit a project image.
  RAM, Terminal sessions, and Desktop processes do not survive.
- `delete`: remove the orb and disk. Shared project images remain.

The named volume `amp-orbs-storage` holds the nested engine's containers and
images. It survives controller replacement and lives in host Podman's persistent
volume storage. Host auto-pruning stays enabled: it cannot see nested orbs.
Do not prune volumes with `--volumes` while the controller is absent or run
pruning inside the controller. Controller configuration/logs are disposable.
Restarting or replacing the controller stops nested processes; saved disks remain.

The outer container uses `--privileged` and must be trusted with host-root
authority. Inner orbs are not privileged and do not receive the provider token.
The upstream Podman image supplies its own defaults, including disabled cgroups
and sharing the outer container's network and IPC namespaces. Services in
different orbs can therefore compete for ports. There are no per-orb CPU,
memory, or disk quotas. Private-network egress is not blocked.
