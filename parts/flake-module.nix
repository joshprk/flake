localInputs: {config, lib, ...}: {
  imports = [
    localInputs.agenix-rekey.flakeModule
    ./deploy.nix
  ];

  config = {
    _module.args = {
      inherit localInputs;
    };

    perSystem = {config, pkgs, ...}: {
      devShells.default = pkgs.mkShellNoCC {
        packages = [config.agenix-rekey.package];
      };

      agenix-rekey = {
        homeConfigurations = {};
      };
    };

    systems = lib.mkDefault lib.systems.flakeExposed;
  };
}
