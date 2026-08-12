{flakeInputs, ...}: {
  imports = with flakeInputs; [
    disko.nixosModules.disko
    hjem.nixosModules.hjem
    impermanence.nixosModules.impermanence
    nix-flatpak.nixosModules.nix-flatpak
    ./features/containers.nix
    ./features/desktop.nix
    ./features/nvidia.nix
    ./features/typography.nix
    ./home.nix
    ./network.nix
    ./system.nix
  ];

  nixpkgs.overlays = with flakeInputs; let
    nvfWithPkgs = pkgs: mod:
      (nvf.lib.neovimConfiguration {
        inherit pkgs;
        modules = [mod];
      }).neovim;
  in [
    (final: _: {nvf = nvfWithPkgs final.pkgs;})
  ];
}
