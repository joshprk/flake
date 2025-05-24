{inputs, ...}: {
  perSystem = {
    self',
    pkgs,
    ...
  }: {
    devShells.flake = pkgs.mkShellNoCC {
      packages = with pkgs; [
        alejandra
        git
        statix
        sops
      ];
    };

    devShells.default = self'.devShells.flake;
  };
}
