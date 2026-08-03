{
  config,
  lib,
  pkgs,
  hostSpec,
  ...
}: {
  environment = {
    defaultPackages = lib.mkDefault [];
    persistence."/nix/persist" = {
      enable = true;
      hideMounts = true;
      directories = ["/var/log" "/var/lib"];
      files = ["/etc/machine-id"];
    };
  };

  boot = {
    consoleLogLevel = 0;
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    kernelParams = ["quiet" "udev.log_level=3"];
    initrd = {
      systemd.enable = true;
      verbose = false;
    };
    loader.limine = {
      enable = true;
      enrollConfig = true;
      maxGenerations = 5;
      secureBoot = {
        enable = true;
        autoGenerateKeys = true;
        autoEnrollKeys.enable = true;
      };
    };
    plymouth.enable = true;
  };

  programs.command-not-found = {
    enable = false;
  };

  programs.nh = {
    enable = true;
  };

  hardware.facter = {
    enable = true;
    reportPath = lib.mkIf (builtins.pathExists hostSpec) hostSpec;
  };

  nix.settings = {
    experimental-features = [
      "auto-allocate-uids"
      "flakes"
      "nix-command"
      "pipe-operators"
    ];
    auto-allocate-uids = true;
    use-xdg-base-directories = true;
  };

  nixpkgs.config = {
    allowUnfree = true;
    cudaSupport = config.hardware.nvidia.enabled;
  };

  system = {
    disableInstallerTools = true;
    etc.overlay = {
      enable = true;
      mutable = true;
    };
  };

  time.timeZone = "America/New_York";
}
