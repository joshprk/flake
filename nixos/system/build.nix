{
  config,
  lib,
  pkgs,
  flake,
  ...
}: let
  cfg = config.modules.system.build;
in {
  options.modules.system.build = {
    nix-features = lib.mkOption {
      type = with lib.types; listOf str;
      description = "A list of experimental features to enable.";
      default = [
        "flakes"
        "nix-command"
        "pipe-operators"
      ];
    };
  };

  config = {
    nix = {
      channel = {
        enable = true;
      };

      settings = {
        extra-experimental-features = cfg.nix-features;
        use-xdg-base-directories = true;
      };
    };

    nixpkgs = {
      config = {
        inherit (config.nixpkgs) overlays;
        allowUnfree = true;
        cudaSupport = true;
      };

      overlays = [flake.overlays.default];
    };
  };
}
