{
  config,
  lib,
  pkgs,
  flake,
  ...
}: let
  inherit (config.networking) hostName;
  cfg = config.modules.system.facter;
in {
  options.modules.system.facter = {
    reportPath = lib.mkOption {
      type = lib.types.path;
      description = "The facter reports directory.";
      default = flake.paths.hosts + "/${hostName}/facter.json";
      readOnly = true;
    };
  };

  config = {
    facter = {inherit (cfg) reportPath;};
  };
}
