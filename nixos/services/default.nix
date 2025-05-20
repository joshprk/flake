{
  config,
  lib,
  options,
  ...
}: let
  cfg = config.modules.services;
in {
  options.modules.services = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable the services module.";
      default = false;
    };

    instances = lib.mkOption {
      type = lib.types.attrs;
      description = "Alias for `containers`.";
      default = {};
    };
  };

  imports = lib.pipe ./. [
    builtins.readDir
    builtins.attrNames
    (builtins.filter (n: n != "default.nix"))
    (map (lib.path.append ./.))
  ];

  config = lib.mkIf cfg.enable {
    containers = cfg.instances;
  };
}
