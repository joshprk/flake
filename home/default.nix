{pkgs, ...}: {
  imports = [
    ./dconf.nix
    ./nvf.nix
  ];

  packages = with pkgs; [
    git
  ];

  xdg.config.files."git/config" = {
    generator = (pkgs.formats.toml {}).generate "gitconfig";
    value = {
      init.defaultBranch = "main";
      user.name = "Joshua Park";
      user.email = "git@joshprk.me";
    };
  };

  xdg.config.files."Yubico/u2f_keys" = {
    source = ./u2f_keys;
  };
}
