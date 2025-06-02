{...}: {
  disko.devices.disk.system = {
    device = "/dev/nvme0n1";
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

    content.partitions.nix = {
      size = "100%";
      content = {
        name = "nix";
        type = "luks";
        settings.allowDiscards = true;
        content.type = "filesystem";
        content.format = "btrfs";
        content.mountpoint = "/nix";
        content.mountOptions = ["compress=zstd" "noatime"];
      };
    };
  };

  disko.devices.disk.data = {
    device = "/dev/nvme1n1";
    type = "disk";
    content.type = "gpt";
    content.partitions.data = {
      size = "100%";
      content = {
        name = "data";
        type = "luks";
        settings.allowDiscards = true;
        content.type = "filesystem";
        content.format = "btrfs";
        content.mountpoint = "/home";
        content.mountOptions = ["compress=zstd" "noatime"];
      };
    };
  };

  disko.devices.nodev."/" = {
    fsType = "tmpfs";
    mountOptions = ["size=50%" "defaults" "mode=755" "noatime"];
  };
}
