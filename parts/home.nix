{inputs, self, lib, ...}: {
  /*
   * Single-user home setup.
   *
   * Easily extensible to a multi-user setup later, but flakes are more likely
   * to be stabilized than finding someone who'd want to use my systems.
   */

  imports = with inputs; [
    home-manager.flakeModules.home-manager
  ];

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

      programs.fish = {
        enable = true;
	interactiveShellInit = ''
          function fish_command_not_found
            set p "command-not-found"
            if test -x $p -a -f "/nix/var/nix/profiles/per-user/root/channels/nixos/programs.sqlite"
              $p $argv
              if test $status -eq 126
                $argv
              else
                return 127
              end
            else
              echo "$argv[1]: command not found" >&2
              return 127
      	    end
	  end
      	'';
      };

      home-manager.users.joshua = {
        home.username = "joshua";
	home.homeDirectory = "/home/joshua";
        home.stateVersion = "25.11";
      };

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        sharedModules = lib.singleton self.homeModules.default;
      };
    });
  };
}
