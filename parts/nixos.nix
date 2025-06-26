{
  self,
  lib,
  inputs,
  ...
}: {
  flake = {
    nixosConfigurations =
      self.paths.hosts
      |> builtins.readDir
      |> builtins.attrNames
      |> map (name: {
        name = lib.removeSuffix ".nix" name;
        value = inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            flake = inputs.self;
          };

          modules = [
            self.nixosModules.default
            (self.paths.hosts + "/${name}")
          ];
        };
      })
      |> builtins.listToAttrs;

    nixosModules.default = {
      imports = lib.filesystem.listFilesRecursive self.paths.nixos;
    };

    homeModules.default = {
      imports = lib.filesystem.listFilesRecursive self.paths.home;
    };

    paths = {
      git = "https://github.com/joshprk/flake?ref=main";
      key = "/nix/state/key";
      home = ../home;
      hosts = ../hosts;
      nixos = ../nixos;
      secrets = ../secrets;
    };
  };
}
