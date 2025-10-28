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
        mountOptions = ["noatime" "umask=0077"];
      };
    };

    content.partitions.nix = {
      size = "100%";
      content = {
        name = "data";
        type = "luks";
        settings.allowDiscards = true;
        content.type = "btrfs";
        content.extraArgs = ["-f"];

        content.subvolumes."/home" = {
          mountOptions = ["noatime" "compress=zstd"];
          mountpoint = "/home";
        };

        content.subvolumes."/nix" = {
          mountOptions = ["noatime" "compress=zstd"];
          mountpoint = "/nix";
        };
      };
    };
  };

  disko.devices.nodev."/" = {
    fstype = "tmpfs";
    mountoptions = ["noatime" "size=50%" "defaults" "mode=755"];
  };
}
