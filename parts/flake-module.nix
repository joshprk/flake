localInputs:

{lib, ...}: {
  imports = [
    ./deploy.nix
  ];

  config = {
    _module.args = {inherit localInputs;};
    systems = lib.mkDefault lib.systems.flakeExposed;
  };
}
