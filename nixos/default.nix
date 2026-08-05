{flakeInputs, ...}: {
  imports = with flakeInputs; [
    disko.nixosModules.disko
    hjem.nixosModules.hjem
    impermanence.nixosModules.impermanence
    ./features/desktop.nix
    ./features/nvidia.nix
    ./home.nix
    ./network.nix
    ./secrets.nix
    ./system.nix
  ];
}
