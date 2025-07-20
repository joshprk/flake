{...}: {
  perSystem = {pkgs, ...}: {
    packages.deploy = pkgs.callPackage ../pkgs/deploy {};
  };
}
