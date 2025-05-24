{inputs, ...}: {
  perSystem = {
    self',
    pkgs,
    system,
    ...
  }: {
    _module.args.pkgs = with inputs;
      import nixpkgs {
        inherit system;
        overlays = [self.overlays.default];
      };

    devShells.flake = pkgs.mkShellNoCC {
      packages = with pkgs; [
        agenix-rekey
        age-plugin-fido2-hmac
        alejandra
        git
        statix
      ];
    };

    devShells.default = self'.devShells.flake;
  };
}
