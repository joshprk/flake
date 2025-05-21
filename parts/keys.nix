{lib, ...}: let
  keys = {
    master = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICOimZhc+sD7K1zHQgAX66KpB2L/daf6fxIix541Sb7I";
    joshua = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBYMjdyYJfwjRqHuyePy0xNRKYxeSuJ6e9I1g9F0eHsD";
  };
in {
  options.keys = lib.mkOption {
    type = lib.types.attrsOf lib.types.str;
    description = "Global read-only public key store";
    default = keys;
    readOnly = true;
  };
}
