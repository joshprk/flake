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
        mountOptions = ["umask=0077"];
      };
    };

    content.partitions.data = {
      name = "data";
      size = "100%";
      content = {
        type = "filesystem";
        format = "luks";
        settings = {
          allowDiscards = true;
          #keyFile = "";
        };
        content.type = "btrfs";
        content.extraArgs = ["-f"];
        content.subvolumes."/home" = {
          mountOptions = ["compress=zstd" "noatime"];
          mountpoint = "/home";
        };
        content.subvolumes."/nix" = {
          mountOptions = ["compress=zstd" "noatime"];
          mountpoint = "/nix";
        };
      };
    };
  };

  disko.devices.nodev."/" = {
    fsType = "tmpfs";
    mountOptions = ["size=50%" "defaults" "mode=755"];
  };
}
