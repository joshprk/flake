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
        mountOptions = ["noatime" "umask=0077"];
      };
    };

    content.partitions.nix = {
      size = "100%";
      content = {
        name = "nix";
        type = "luks";
        settings.allowDiscards = true;
        content.type = "btrfs";
        content.extraArgs = ["-f"];
        content.mountpoint = "/nix";
        content.mountOptions = ["noatime" "compress=zstd"];
      };
    };
  };

  disko.devices.disk.data = {
    device = "/dev/nvme1n1";
    type = "disk";
    content.type = "gpt";

    content.partitions.home = {
      size = "100%";
      content = {
        name = "home";
        type = "luks";
        settings.allowDiscards = true;
        content.type = "btrfs";
        content.extraArgs = ["-f"];
        content.mountpoint = "/home";
        content.mountOptions = ["noatime" "compress=zstd"];
      };
    };
  };

  disko.devices.nodev."/" = {
    fsType = "tmpfs";
    mountOptions = ["noatime" "size=50%" "defaults" "mode=755"];
  };
}
