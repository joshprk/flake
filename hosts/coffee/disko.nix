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
      size = "100%";
      content = {
        name = "data";
        type = "luks";
        settings = {
          allowDiscards = true;
          # keyFile = "."; # make declarative later through sops-nix
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
