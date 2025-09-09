{localInputs, ...}: {
  perSystem = {
    config,
    lib,
    pkgs,
    ...
  }: {
    ## Preserved to serve as an example in the future.
    ## Remove when a package is added.
    /*
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
    */
  };
}
