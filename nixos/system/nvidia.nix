{
  config,
  lib,
  pkgs,
  flake,
  ...
}: let
  cfg = config.modules.system.nvidia;
  tuneMem = cfg.maxMemClock != null;
  tuneGpu = cfg.maxGpuClock != null;
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
      nvidiaPersistenced = tuneMem || tuneGpu;
      open = true;
    };

    systemd.services.nvidia-tuning = lib.mkIf (tuneMem || tuneGpu) {
      description = "NVIDIA system tuning actions";
      wantedBy = ["multi-user.target"];
      script = let
        smi = "/run/current-system/sw/bin/nvidia-smi";
      in
        [
          {
            cond = tuneMem;
            value = "${smi} --lock-memory-clocks=0,${cfg.maxMemClock}";
          }
          {
            cond = tuneGpu;
            value = "${smi} --lock-gpu-clocks=0,${cfg.maxGpuClock}";
          }
        ]
        |> lib.filter (v: v.cond)
        |> map (v: v.value)
        |> lib.concatStringsSep "\n";
    };
  };
}
