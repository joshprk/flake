{
  config,
  lib,
  pkgs,
  var,
  ...
}: let
  cfg = config.modules.system.build;
in {
  imports = var.nixosModules;

  options.modules.system.build = with lib; {
    features = mkOption {
      type = with types; listOf str;
      description = "A list of experimental features to enable.";
      default = [
        "auto-allocate-uids"
        "flakes"
        "nix-command"
        "pipe-operators"
      ];
    };
  };

  config = {
    programs.nh = {
      enable = lib.mkDefault true;
    };

    facter = {
      reportPath =
        if builtins.pathExists "${var.host}/facter.json"
        then "${var.host}/facter.json"
        else lib.mkDefault null;
    };

    nix.settings = {
      extra-experimental-features = lib.mkDefault cfg.features;
      auto-allocate-uids = lib.mkDefault true;
      use-xdg-base-directories = lib.mkDefault true;
      trusted-users = [
        "@wheel"
      ];
      trusted-substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos-cuda.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
      ];
    };

    nixpkgs = {
      inherit (var) overlays;
      config = {
        inherit (config.nixpkgs) overlays;
        allowUnfree = lib.mkDefault true;
        cudaSupport = lib.mkDefault config.modules.system.nvidia.enable;
      };
    };

    system = {
      disableInstallerTools = lib.mkDefault true;
    };
  };
}
