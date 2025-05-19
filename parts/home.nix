{self, lib, ...}: {
  /*
   * Single-user home setup.
   *
   * Easily extensible to a multi-user setup later, but flakes are more likely
   * to be stabilized than finding someone who'd want to use my systems.
   */
  flake = {
    nixosModules.default.imports = lib.singleton ({pkgs, ...}: {
      users.users.joshua = {
        isNormalUser = true;
	extraGroups = ["wheel"];
	shell = pkgs.fish;
	hashedPassword = "$y$j9T$U5SE4t9DYmwelV9Lv4cM2.$6c9GIjBWUFVS2cQ2PNFS7lvuSbVlX/W8d9zZkRI.XcB";
	openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBYMjdyYJfwjRqHuyePy0xNRKYxeSuJ6e9I1g9F0eHsD"
	];
      };

      programs.fish.enable = true;

      home-manager.users.joshua = {
        home.username = "joshua";
	home.homeDirectory = "/home/joshua";
        home.stateVersion = "25.11";
      };

      home-manager.sharedModules = lib.singleton self.homeModules.default;
    });
  };
}
