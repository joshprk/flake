{...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "forge";
  system.stateVersion = "25.11";

  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICOimZhc+sD7K1zHQgAX66KpB2L/daf6fxIix541Sb7I"
    ];
  };

  services.openssh.enable = true;

  disko.devices.disk.system = {
    device = "/dev/sda";
    type = "disk";
    content.type = "gpt";
    content.partitions = {
      boot = {
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

      nix = {
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
  };

  disko.devices.disk.home = {
    device = "/dev/sdb";
    type = "disk";
    content.type = "gpt";
    content.partitions = {
      home = {
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
  };

  disko.devices.nodev."/" = {
    fsType = "tmpfs";
    mountOptions = ["size=8G" "defaults" "mode=755"];
  };

  zramSwap.enable = true;
}
