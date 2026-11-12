# Amp orbs on forge

`pods.amp-orbs = true` runs Amp and a nested Podman engine in one OCI container.
No host socket, dedicated user, or KVM is needed. The dispatch is Amp's Docker
example using Podman and ARM64. Each orb provides 1 GiB of private shared
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
The outer controller's default Podman network is `10.89.0.0/16`, while nested
Podman uses its own default `10.88.0.0/16` network. Keeping those subnets
distinct prevents the nested bridge from claiming the controller's gateway and
cutting it off from Amp. The dispatch overrides the upstream Podman image's
shared network and IPC defaults with bridge networking and a private IPC namespace
for each orb.
Services in different orbs can bind the same localhost port without competing.
Orbs still share a bridge: this is localhost isolation, not a firewall between
orbs. The upstream image disables cgroups; there are no per-orb CPU, memory,
or disk quotas. Private-network egress is not blocked.

Existing containers retain their original namespaces when started again. After
deploying this change, save any needed work and recreate those orbs through Amp
to pick up isolation; pause/resume alone is not sufficient. Do not delete the
storage volume to migrate them.
