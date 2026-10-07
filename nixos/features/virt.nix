{
  config,
  lib,
  pkgs,
  ...
}: {
  options.features.virt = lib.mkEnableOption "the virt feature";

  config = lib.mkIf config.features.virt {
    environment.systemPackages = with pkgs; [gnome-boxes];

    networking.firewall.interfaces.virbr0 = {
      allowedTCPPorts = [53];
      allowedUDPPorts = [53 67];
    };

    virtualisation.libvirtd.enable = true;
  };
}
