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
        mountOptions = ["umask=0077"];
      };
    };

    content.partitions.nix = {
      name = "nix";
      size = "100%";
      content = {
        type = "filesystem";
        format = "btrfs";
        mountpoint = "/nix";
        mountOptions = ["compress=zstd" "noatime"];
      };
    };
  };

  disko.devices.disk.data = {
    device = "/dev/sdb";
    type = "disk";
    content.type = "gpt";

    content.partitions.data = {
      name = "home";
      size = "100%";
      content.type = "btrfs";
      content.subvolumes = {
        "/home" = {
          mountpoint = "/home";
          mountOptions = ["compress=zstd" "noatime"];
        };
        "/containers" = {
          mountpoint = "/var/lib/nixos-containers";
          mountOptions = ["compress=zstd" "noatime"];
        };
      };
    };
  };

  disko.devices.nodev."/" = {
    fsType = "tmpfs";
    mountOptions = ["size=8G" "defaults" "mode=755"];
  };
}
