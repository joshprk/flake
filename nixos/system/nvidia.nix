{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.system.nvidia;
in {
  options.modules.system.nvidia = {
    enable = lib.mkEnableOption "the nvidia module";

    package = lib.mkOption {
      type = lib.types.package;
      default = config.boot.kernelPackages.nvidiaPackages.beta;
      description = "Which nvidia driver package to use.";
    };

    maxGpuClock = lib.mkOption {
      type = with lib.types; nullOr ints.positive;
      description = "Maximum GPU clock in megahertz.";
      apply = opt:
        if opt != null
        then builtins.toString opt
        else opt;
      default = null;
    };

    maxMemClock = lib.mkOption {
      type = with lib.types; nullOr ints.positive;
      description = "Maximum memory clock in megahertz.";
      apply = opt:
        if opt != null
        then builtins.toString opt
        else opt;
      default = null;
    };

    prime = lib.mkOption {
      type = with lib.types; attrs;
      default = {};
      description = "Configuration for nvidia prime.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.xserver = {
      videoDrivers = ["nvidia"];
    };

    hardware.nvidia = {
      inherit (cfg) package prime;
      modesetting.enable = true;
      powerManagement.enable = true;
      nvidiaSettings = false;
      nvidiaPersistenced = cfg.maxGpuClock != null || cfg.maxMemClock != null;
      open = true;
    };
    
    systemd.services.nvidia-tune-gpu = lib.mkIf (cfg.maxGpuClock != null) {
      description = "NVIDIA GPU clock tuning";
      wantedBy = ["multi-user.target"];
      script = ''
        /run/current-system/sw/bin/nvidia-smi -lgc 0,${cfg.maxGpuClock}
      '';
    };

    systemd.services.nvidia-tune-mem = lib.mkIf (cfg.maxMemClock != null) {
      description = "NVIDIA memory clock tuning";
      wantedBy = ["mutli-user.target"];
      script = ''
        /run/crurent-system/sw/bin/nvidia-smi -lmc 0,${cfg.maxMemClock}
      '';
    };
  };
}
