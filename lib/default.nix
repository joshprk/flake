inputs: let
  self = inputs.self.lib or inputs.self;
  nixpkgs = inputs.nixpkgs;
  lib = nixpkgs.lib;
  specialArgs = {inherit self lib inputs;};
in {
  __functor = self: args: self.mkFlake (args // {inherit self;});

  common = import ./common.nix specialArgs;
  hosts = import ./hosts.nix specialArgs;

  inherit
    (self.common)
    forAllSystems
    ensureDefaults
    readModulesDir
    wrapLazy
    ;

  inherit
    (self.hosts)
    nixosSystem
    ;

  mkFlake = {
    self ? inputs.self,
    src,
    nixosModules ? [],
    homeManagerModules ? [],
    overlays ? [],
    formatter ? pkgs: pkgs.alejandra,
    ...
  }: {
    lib = self;

    nixosConfigurations = let
      defaultNixosModules =
        nixosModules
        ++ (lib.pipe "nixos" [
          (lib.path.append src)
          self.readModulesDir
        ]);

      defaultHomeManagerModules =
        homeManagerModules
        ++ (lib.pipe "home" [
          (lib.path.append src)
          self.readModulesDir
        ]);
    in
      lib.pipe "hosts" [
        (lib.path.append src)
        self.readModulesDir
        (map
          (self.nixosSystem {
            inherit overlays;
            nixosModules = defaultNixosModules;
            homeManagerModules = defaultHomeManagerModules;
            users = lib.pipe "users" [
              (lib.path.append src)
              self.readModulesDir
              (map
                (homeModule: {
                  name = (homeModule (builtins.functionArgs homeModule)).home.username;
                  value = homeModule;
                })
              )
              builtins.listToAttrs
            ];
            srcPath = src;
          })
        )
        builtins.listToAttrs
      ];

    formatter =
      self.forAllSystems (system: formatter nixpkgs.legacyPackages.${system});
  };
}
