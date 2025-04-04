{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = ["noatime" "defaults" "mode=755"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/12CE-A600";
    fsType = "vfat";
    options = ["noatime" "fmask=0022" "dmask=0022"];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/400ea83d-e787-4e5f-bf1f-38ffca4ab6ca";
    fsType = "btrfs";
    options = ["noatime" "compress=zstd" "subvol=@nix"];
  };

  boot.initrd.luks.devices."nixos-enc".device = "/dev/disk/by-uuid/4f9b1206-d7eb-4787-bb8a-af08b57e585e";

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/400ea83d-e787-4e5f-bf1f-38ffca4ab6ca";
    fsType = "btrfs";
    options = ["noatime" "compress=zstd" "subvol=@home"];
  };

  swapDevices = [];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp9s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
