{
  config,
  lib,
  ...
}: let
  cfg = config.modules.nvidia;
in {
  options.modules.nvidia = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable the NVIDIA module.";
      default = false;
    };

    package = lib.mkOption {
      type = lib.types.package;
      description = "The NVIDIA package to use.";
      default = config.boot.kernelPackages.nvidiaPackages.beta;
    };

    prime = lib.mkOption {
      type = lib.types.attrs;
      description = "Configuration for NVIDIA prime.";
      default = {};
    };

    tuning.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable tuning for NVIDIA.";
      default = false;
    };

    tuning.gpuClock = lib.mkOption {
      type = lib.types.ints.positive;
      description = "Maximum GPU clock in megahertz.";
    };

    tuning.memoryClock = lib.mkOption {
      type = lib.types.ints.positive;
      description = "Maximum memory clock in megahertz.";
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.nvidia = {
      inherit (cfg) package prime;
      modesetting.enable = true;
      powerManagement.enable = true;
      open = true;
      nvidiaSettings = false;
      nvidiaPersistenced = cfg.tuning.enable;
    };

    systemd.services.nvidia-tuning = lib.mkIf cfg.tuning.enable {
      description = "Tunes NVIDIA gpu and memory clocks.";
      wantedBy = ["multi-user.target"];
      script = let
        nvidia-smi = "/run/current-system/sw/bin/nvidia-smi";
        gpuClock = builtins.toString cfg.tuning.gpuClock;
        memoryClock = builtins.toString cfg.tuning.memoryClock;
      in ''
        ${nvidia-smi} --lock-gpu-clocks=0,${gpuClock}
        ${nvidia-smi} --lock-memory-clocks=0,${memoryClock}
      '';
    };

    services.xserver.videoDrivers = ["nvidia"];
  };
}
