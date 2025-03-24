{
  hostName = "PC";
  hostGroups = ["default"];
  system = "x86_64-linux";
  stateVersion = "24.11";

  config = {
    config,
    lib,
    pkgs,
    ...
  }: {

  };
}
