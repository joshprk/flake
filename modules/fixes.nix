{
  config,
  lib,
  ...
}: let
  cfg = config.settings.fixes;
in {
  options.settings = {
    fixes = {
      mouseWakeup = lib.mkEnableOption "the mouse wakeup fix";
      webhid = lib.mkEnableOption "the WebHID fix";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.mouseWakeup {
      services.udev.extraRules = ''
        ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c547", ATTR{power/wakeup}="disabled"
      '';
    })
    (lib.mkIf cfg.webhid {
      services.udev.extraRules = ''
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", GROUP="wheel", MODE="0660"
      '';
    })
  ];
}
