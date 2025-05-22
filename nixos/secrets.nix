{config, lib, ...}: {
  options.modules.secrets = {
    pubkeyStore = lib.mkOption {
      type = with lib.types; attrsOf str;
      description = "A read-only table of named public SSH keys.";
      default = {
        root = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICOimZhc+sD7K1zHQgAX66KpB2L/daf6fxIix541Sb7I";
        joshua = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBYMjdyYJfwjRqHuyePy0xNRKYxeSuJ6e9I1g9F0eHsD";
      };
    };
  };
}
