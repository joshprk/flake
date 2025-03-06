{
  config,
  lib,
  ...
}: let
  cfg = config.settings.nvidia;
in {
  options.settings = {
    nvidia = {
      enable = lib.mkEnableOption "the NVIDIA module";

      package = lib.mkOption {
        type = lib.types.package;
        default = config.boot.kernelPackages.nvidiaPackages.beta;
        description = ''
          Which NVIDIA driver package to use.
        '';
      };

      tuning = {
        enable = lib.mkEnableOption "tuning for NVIDIA GPUs";

        gpuClock = lib.mkOption {
          type = lib.types.int;
          description = ''
            Maximum GPU clock in megahertz.
          '';
        };

        memoryClock = lib.mkOption {
          type = lib.types.int;
          description = ''
            Maximum memory clock in megahertz.
          '';
        };
      };

      prime = lib.mkOption {
        type = lib.types.attrs;
        default = {};
        description = ''
          Configuration for NVIDIA Prime.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    hardware = {
      graphics = {
        enable = true;
      };

      nvidia = {
        inherit (cfg) prime;

        modesetting.enable = true;
        powerManagement.enable = true;

        open = true;
        package = cfg.package;
        nvidiaSettings = false;
        nvidiaPersistenced = cfg.tuning.enable;
      };
    };

    services.xserver.videoDrivers = [
      "nvidia"
    ];

    systemd.services.nvidia-tuning = lib.mkIf cfg.tuning.enable {
      description = ''
        Tunes NVIDIA GPU and memory clocks.
      '';

      wantedBy = [
        "multi-user.target"
      ];

      script = let
        nvidia-smi = "/run/current-system/sw/bin/nvidia-smi";
        gpuClock = builtins.toString cfg.tuning.gpuClock;
        memoryClock = builtins.toString cfg.tuning.memoryClock;
      in ''
        ${nvidia-smi} --lock-gpu-clocks=0,${gpuClock}
        ${nvidia-smi} --lock-memory-clocks=0,${memoryClock}
      '';
    };
  };
}
