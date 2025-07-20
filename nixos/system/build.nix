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
    };

    nixpkgs = {
      config = {
        inherit (config.nixpkgs) overlays;
        allowUnfree = lib.mkDefault true;
        cudaSupport = lib.mkDefault true;
      };
      overlays = var.overlays;
    };

    system = {
      disableInstallerTools = lib.mkDefault true;
    };
  };
}
