{
  self,
  inputs,
  ...
}: {
  perSystem = {
    self',
    lib,
    pkgs,
    system,
    ...
  }: {
    _module.args.pkgs = with inputs;
      import nixpkgs {
        inherit system;
        overlays = [self.overlays.default];
      };

    devShells.default = pkgs.mkShellNoCC {
      packages = with pkgs; [
        self'.formatter
        agenix-rekey
        age-plugin-fido2-hmac
        git
        sbctl
      ];
    };

    formatter = pkgs.alejandra;
  };
}
