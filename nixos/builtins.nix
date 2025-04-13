{
  config,
  lib,
  ...
}: {
  options.settings = {
    timeZone = lib.mkOption {
      type = lib.types.str;
      default = "America/New_York";
      example = "America/Los_Angeles";
      description = "Which system timezone to use.";
    };
  };

  config = {
    environment.shellAliases = {
      update = "nixos-rebuild switch --refresh --use-remote-sudo --flake github:joshprk/flake";
    };

    time.timeZone = config.settings.timeZone;
  };
}
