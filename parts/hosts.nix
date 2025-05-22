{
  inputs,
  self,
  lib,
  ...
}: {
  imports = with inputs; [
    home-manager.flakeModules.home-manager
  ];

  flake = {
    nixosConfigurations = let
      hostsDir = ../hosts;
      mkSystem = hostName:
        lib.nameValuePair hostName (lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            flake = self;
          };
          modules = [
            (lib.path.append hostsDir hostName)
            self.nixosModules.default
          ];
        });
    in
      lib.pipe hostsDir [
        builtins.readDir
        builtins.attrNames
        (map mkSystem)
        builtins.listToAttrs
      ];

    nixosModules.default.imports = let
      nixosModulesDir = ../nixos;
    in
      lib.pipe nixosModulesDir [
        builtins.readDir
        builtins.attrNames
        (map (lib.path.append nixosModulesDir))
      ];

    homeModules.default.imports = let
      homeModulesDir = ../home;
    in
      lib.pipe homeModulesDir [
        builtins.readDir
        builtins.attrNames
        (map (lib.path.append homeModulesDir))
      ];
  };
}
