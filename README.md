A modular NixOS configuration.

## Structure

This configuration is structured as a directed acyclic graph minimizes
unnecessary dependencies between individual configurations while encouraging
the use of common modules.

The `hosts` folder contains modules which single-handedly define systems,
either in the form of regular `.nix` files or folders with `default.nix` entry
points. This allows a CI workflow to orchestrate new system nodes without
complex parsing or AST traversal by simply creating a new module in the `hosts`
folder. The `users` folder follows a similar paradigm.

All modules in the `nixos` folder are imported to all NixOS configurations, as
well as any overlays or NixOS modules defined in `flake.nix`. These only affect
evaluation time and not the overall size of the final system build if options
are used correctly.

Because of this unique structure, it is very easy to copy the structure of this
config. In order to do so, simply delete all files in the `hosts` and `users`
folders and add your own configurations as a module per each system or user.

## Features

There are also some nice features pertaining to my personal configuration which
may be of interest for copying into your own configuration.

- Filesystem impermanence with tmpfs root and btrfs /nix, /home
- Niri window manager configuration
- Nixvim user configuration
- Nvidia underclocking
- Isolated gaming filesystem sandbox
- XDG specification compliant home directory
- Secrets transparently managed by sops-nix
- Cached development shells using nix-direnv
- Secure boot support through Lanzaboote
- LUKS encryption with automatic TPM unlock
- Update command to keep multiple systems in sync
