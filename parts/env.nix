{inputs, ...}: {
  perSystem = {
    self',
    pkgs,
    ...
  }: {
    devShells.flake = pkgs.mkShellNoCC {
      packages = with pkgs; [
        alejandra
        statix
      ];
    };

    devShells.default = self'.devShells.flake;
  };
}
