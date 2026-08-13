{
  networking.hostName = "alpine";
  system.stateVersion = "26.11";

  features = {
    desktop = true;
    nvidia = true;
  };

  hardware.nvidia.prime = {
    offload.enable = true;
    nvidiaBusId = "PCI:1:0:0";
    amdgpuBusId = "PCI:13:0:0";
  };

  disko.devices.disk.disk0 = {
    device = "/dev/nvme0n1";
    type = "disk";
    content.type = "gpt";
    content.partitions.boot = {
      size = "512M";
      type = "EF00";
      content = {
        type = "filesystem";
        format = "vfat";
        mountpoint = "/boot";
        mountOptions = ["noatime" "umask=0077"];
      };
    };
    content.partitions.system = {
      size = "100%";
      content = {
        name = "system";
        type = "luks";
        settings.allowDiscards = true;
        content.type = "btrfs";
        content.subvolumes.home = {
          mountpoint = "/home";
          mountOptions = ["noatime" "compress=zstd"];
        };
        content.subvolumes.nix = {
          mountpoint = "/nix";
          mountOptions = ["noatime" "compress=zstd"];
        };
      };
    };
  };

  disko.devices.nodev."/" = {
    fsType = "tmpfs";
    mountOptions = ["noatime" "size=50%" "defaults" "mode=755"];
  };

  zramSwap.enable = true;
}
