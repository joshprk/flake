<h2 id="header" align="center">
  joshprk/flake
</h2>

<div align="center">
  A Nix flake that declares all my systems.
</div>

<br />

Want to use this configuration for yourself?

1. Delete all my hosts in `hosts/` and create a minimal `default.nix` and
   `disko.nix` for your own host
2. Delete all my secrets in `secrets/` and provision a new public identity
3. Change the GitHub repository link in `parts/nixos.nix`
4. Run `nix run .#install` on a live installation image to bootstrap everything
   automatically

If you need help, feel free to open up an issue.

### Features

The file structure tries to keep it simple as much as possible:

- `home/`: My [hjem](https://github.com/feel-co/hjem) configuration. It
  currently hosts a single user, but you can modify the flake for multi-user.
- `hosts/`: System configurations. Each host is defined like a channel-based
  classic configuration.
- `nixos/`: System modules. All system functionality comes from here---even
  `home/` and `secrets/`.
- `parts/`: Flake-specific tooling, such as an automated installer.
- `secrets/`: All secrets used in the flake encrypted with a Yubikey.

This flake currently hosts the following systems:

- `alpine`: desktop computer
- `coffee`: laptop computer
- `forge`: cloud remote
