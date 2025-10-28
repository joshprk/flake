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
    packages.bootstrap = pkgs.writeShellScriptBin "flake-bootstrap" ''
      if [ ! -f /nix/var/agenix/host_key ]; then
        ${lib.getExe' pkgs.age "age-keygen"} -o /nix/var/agenix/host_key
      else
        echo "error: host_key already exists"
        exit 1
      fi
    '';
  };
}
