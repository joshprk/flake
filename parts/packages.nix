{localInputs, ...}: {
  perSystem = {
    config,
    lib,
    pkgs,
    ...
  }: {
    packages.deploy = pkgs.callPackage ../pkgs/deploy {
      disko = localInputs.disko.packages.${pkgs.system}.default;
      facter = config.packages.facter;
    };

    packages.facter = pkgs.fetchFromGitHub {
      owner = "nix-community";
      repo = "nixos-facter";
      rev = "main";
      hash = "sha256-4kER7CyFvMKVpKxCYHuf9fkkYVzVK9AWpF55cBNzPc0=";
    };
  };
}
