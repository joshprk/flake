{
  networking.hostName = "forge";
  system.stateVersion = "26.11";

  features = {
    containers = true;
    server = true;
  };

  pods.amp-orbs = true;

  services.resolved.settings.Resolve = {
    DNS = ["1.1.1.1#one.one.one.one" "9.9.9.9#dns.quad9.net"];
    Domains = ["~."];
  };

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

    content.partitions.data = {
      name = "data";
      size = "100%";
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

  disko.devices.nodev."/" = {
    fsType = "tmpfs";
    mountOptions = ["noatime" "size=50%" "defaults" "mode=755"];
  };

  zramSwap.enable = true;
}
