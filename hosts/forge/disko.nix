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

  disko.devices.disk.home = {
    device = "/dev/sdb";
    type = "disk";
    content.type = "gpt";

    content.partitions.home = {
      name = "home";
      size = "100%";
      content = {
        type = "filesystem";
        format = "btrfs";
        mountpoint = "/home";
        mountOptions = ["compress=zstd" "noatime"];
      };
    };
  };

  disko.devices.nodev."/" = {
    fsType = "tmpfs";
    mountOptions = ["size=8G" "defaults" "mode=755"];
  };
}
