{localInputs, ...}: {
  perSystem = {
    config,
    lib,
    pkgs,
    ...
  }: {
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
