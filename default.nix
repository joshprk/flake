{
  inputs,
  systemModules,
  homeModules,
  overlays,
  ...
}: let
  nixpkgs = inputs.nixpkgs;
  lib = inputs.nixpkgs.lib;
  forAllSystems = lib.genAttrs lib.systems.flakeExposed;

  hostPath = ./hosts;
  hardwarePath = ./hardware;
  userPath = ./users;
  modulePath = ./modules;
  homePath = ./home;

  hostFiles =
    builtins.attrNames
    (lib.filterAttrs (_: type: type == "regular") (builtins.readDir hostPath));
  userFiles =
    builtins.attrNames
    (lib.filterAttrs (_: type: type == "directory") (builtins.readDir userPath));
  modules = map (file: import file) (lib.filesystem.listFilesRecursive modulePath);
  userModules = map (file: import file) (lib.filesystem.listFilesRecursive homePath);
in {
  nixosConfigurations =
    builtins.listToAttrs
    (
      map
      (file: let
        host = import (lib.path.append hostPath file);
        hardware = import (lib.path.append hardwarePath file);
        hostModules = host.modules or (inputs: []);

        getUsers = moduleInputs: let
          filterByHostGroup = {
            name,
            value,
          }:
            lib.lists.any
            (g: builtins.elem g (host.hostGroups or ["default"]))
            (value.hostGroups or ["default"]);
          readUserConfig = file: {
            name = file;
            value = import (lib.path.append userPath file) moduleInputs;
          };
        in
          builtins.listToAttrs
          (builtins.filter filterByHostGroup (map readUserConfig userFiles));

        getSystemUsers = users: let
          attrsToRemove = ["config" "stateVersion" "hostGroups"];
        in
          builtins.mapAttrs
          (_: attrs: builtins.removeAttrs attrs attrsToRemove)
          users;

        getHomeManagerConfig = users: {
          useGlobalPkgs = true;
          useUserPackages = true;
          sharedModules = homeModules ++ userModules;
          users =
            builtins.mapAttrs
            (userName: attrs: inputs:
              (attrs.config inputs)
              // {
                imports =
                  builtins.filter
                  (f: f != lib.path.append userPath "${userName}/default.nix")
                  (
                    lib.filesystem.listFilesRecursive
                    (lib.path.append userPath userName)
                  );
                home.stateVersion = attrs.stateVersion;
              })
            (lib.filterAttrs (_: attrs: attrs.isNormalUser or false) users);
        };

        nixConfig = {
          registry.nixpkgs.flake = nixpkgs;
          settings = {
            experimental-features = lib.mkDefault ["nix-command" "flakes"];
            use-xdg-base-directories = lib.mkDefault true;
          };
        };

        nixpkgsConfig = {
          overlays = overlays host.system;
          allowUnfree = true;
        };
      in {
        name = host.hostName;
        value = lib.nixosSystem {
          inherit (host) system;
          modules =
            systemModules
            ++ modules
            ++ (hostModules inputs)
            ++ [
              (moduleInputs: let
                users = getUsers moduleInputs;
              in {
                imports = [hardware host.config];
                home-manager = getHomeManagerConfig users;
                nix = nixConfig;
                networking.hostName = host.hostName;
                nixpkgs.config = nixpkgsConfig;
                nixpkgs.overlays = moduleInputs.config.nixpkgs.config.overlays;
                system.stateVersion = host.stateVersion;
                users.users = getSystemUsers users;
              })
            ];
        };
      })
      hostFiles
    );

  formatter =
    forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
}
