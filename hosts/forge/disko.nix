{...}: {
  disko.devices.disk.system = {
    device = "/dev/sda";
    type = "disk";
    content.type = "gpt";
    content.partitions.boot = {
      name = "boot";
      size = "512M";
      type = "EF00";
      content = {
        type = "filesystem";
        format = "vfat";
        mountpoint = "/boot";
        mountOptions = ["umask=0077" "noatime"];
      };
    };

    content.partitions.data = {
      name = "data";
      size = "100%";
      content.type = "btrfs";
      content.subvolumes = {
        "/nix" = {
          mountpoint = "/nix";
          mountOptions = ["compress=zstd" "noatime"];
        };
        "/home" = {
          mountpoint = "/home";
          mountOptions = ["compress=zstd" "noatime"];
        };
      };
    };
  };

  disko.devices.nodev."/" = {
    fsType = "tmpfs";
    mountOptions = ["size=50%" "defaults" "mode=755" "noatime"];
  };
}
