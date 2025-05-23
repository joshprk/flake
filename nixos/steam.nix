{config, lib, pkgs, ...}: let
  cfg = config.modules.steam;
in {
  options.modules.steam = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable the Steam module.";
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
      package = pkgs.steam; # need to sandbox
      extraCompatPackages = with pkgs; [proton-ge-bin];
    };
  };
}
