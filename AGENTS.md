# AGENTS.md

## Background

This Nix flake builds personal NixOS systems, as well as some helpful packages which bootstrap
these systems.

## Folders

- `hosts/`: contains host-specific settings
- `nixos/`: contains common nixos modules
- `nixos/features/`: contains opt-in nixos modules
- `specs/`: contains hardware specifications of hosts
- `home/`: contains personal configuration

## Upstream dependencies

Use targeted searches for exact options and open only the matching documentation section.

- `hjem` provides tools to create symlinked dotfiles for user homes
    * docs: https://hjem.feel-co.org/options.html
- `hyprland` is a tiling Wayland compositor
    * docs: https://wiki.hypr.land/
- `noctalia` is a native Wayland desktop shell
    * docs: https://docs.noctalia.dev/noctalia/
- `niri` is a scrollable-tiling Wayland compositor
    * docs: https://niri-wm.github.io/niri/
- `nvf` allows the building a Neovim configuration using Nix options
    * docs: https://nvf.notashelf.dev/options.html
- `treefmt` is a formatting multiplexer
    * docs: https://flake.parts/options/treefmt-nix.html

To search available packages, use the command: `nh search <QUERY>`. For NixOS options, use the
command `nh search options <QUERY>`. You must request permission to avoid sandbox errors.

## Code style

- Prefer dotted assignments for simple nested options (i.e. `zramSwap.enable = true;`).
- Prefer nested sets when configuring many related options (i.e. hardware.nvidia = {...}).
- Keep options grouped under top-level namespaces (i.e. `boot`, `services`, `programs`).
- Use comments concisely and sparingly for temporary, security-related, or non-obvious decisions.

## Checks

Before submitting code changes:

```
# Request permission to avoid sandbox errors
nix fmt && nix flake check
```
