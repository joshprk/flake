{flakeInputs, ...}: {
  imports = with flakeInputs; [
    disko.nixosModules.disko
    helium.nixosModules.default
    hjem.nixosModules.hjem
    impermanence.nixosModules.impermanence
    ./features/containers.nix
    ./features/desktop.nix
    ./features/hyprland.nix
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
    hyprland.overlays.hyprland-packages
  ];
}
