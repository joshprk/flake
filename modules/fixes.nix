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
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.mouseWakeup {
      services.udev.extraRules = ''
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", GROUP="wheel", MODE="0660"
        ACTION=="add", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c094", ATTR{power/wakeup}="disabled"
        ACTION=="add", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c547", ATTR{power/wakeup}="disabled"
      '';
    })
  ];
}
