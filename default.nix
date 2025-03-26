{
  inputs,
  systemModules,
  homeModules,
  ...
}: let
  nixpkgs = inputs.nixpkgs;
  lib = inputs.nixpkgs.lib;
  forAllSystems = lib.genAttrs lib.systems.flakeExposed;

  hostPath = ./hosts;
  hardwarePath = ./hardware;
  homePath = ./users;
  modulePath = ./modules;

  hostFiles =
    builtins.attrNames
    (lib.filterAttrs (_: type: type == "regular") (builtins.readDir hostPath));
  userFiles =
    builtins.attrNames
    (lib.filterAttrs (_: type: type == "directory") (builtins.readDir homePath));
  modules = map (file: import file) (lib.filesystem.listFilesRecursive modulePath);
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
          filterByHostGroup = {name, value}:
            lib.lists.any
            (g: builtins.elem g (host.hostGroups or ["default"]))
            (value.hostGroups or ["default"]);
          readUserConfig = file: {
            name = file;
            value = import (lib.path.append homePath file) moduleInputs;
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
          sharedModules = homeModules;
          users =
            builtins.mapAttrs
            (userName: attrs: inputs:
              (attrs.config inputs)
              // {
                imports =
                  builtins.filter
                  (f: f != lib.makePath [homePath userName "default.nix"])
                  (lib.listFilesRecursive (lib.path.append homePath userName));
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
                imports = [hardware];
                home-manager = getHomeManagerConfig users;
                nix = nixConfig;
                networking.hostName = host.hostName;
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
