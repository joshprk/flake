# AGENTS.md

## Background

This Nix flake builds personal NixOS systems, as well as some helpful packages which bootstrap
these systems.

## Folders

- `hosts/`: contains host-specific settings
- `nixos/`: contains common nixos modules
- `nixos/features`: contains opt-in nixos modules
- `specs/`: contains hardware specifications of hosts
- `home/`: contains reusable hjem modules

## Upstream dependencies

Use targeted searches for exact options and open only the matching documentation section.

- `hjem` provides tools to create symlinked dotfiles for user homes
  docs: https://hjem.feel-co.org/options.html
- `nvf` allows the building a Neovim configuration using Nix options
  docs: https://nvf.notashelf.dev/options.html
- `treefmt` is a formatting multiplexer
  docs: https://flake.parts/options/treefmt-nix.html

## Code style

- Prefer dotted for simple, single options (i.e. `zramSwap.enable = true;`).
- Prefer nested sets when configuring related options (i.e. hardware.nvidia = {...}).
- Keep options grouped under top-level namespaces (i.e. `boot`, `services`, `programs`).
- Use comments concisely and sparingly for temporary, security-related, or non-obvious decisions.

## Checks

Before submitting changes:

```
nix fmt
nix flake check
```
