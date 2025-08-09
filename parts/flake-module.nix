localInputs: {
  config,
  lib,
  ...
}: {
  imports = [
    localInputs.agenix-rekey.flakeModule
    ./deploy.nix
  ];

  config = {
    _module.args = {
      inherit localInputs;
    };

    perSystem = {
      config,
      pkgs,
      ...
    }: {
      devShells.default = pkgs.mkShellNoCC {
        packages = with pkgs; [
          config.agenix-rekey.package
          age-plugin-fido2-hmac
        ];
      };

      agenix-rekey = {
        homeConfigurations = {};
      };
    };

    systems = lib.mkDefault lib.systems.flakeExposed;
  };
}
