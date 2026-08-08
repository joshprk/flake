{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./dconf.nix
    ./nvf.nix
  ];

  packages = with pkgs; [
    fish
    git
  ];

  xdg.config.files."fish/config.fish".text = ''
    if not test -n "$__HJEM_ENV_INIT"
      source "${config.environment.loadEnv}"
      set __HJEM_ENV_INIT 1
    end
  '';

  xdg.config.files."git/config" = {
    generator = (pkgs.formats.toml {}).generate "gitconfig";
    value = {
      init.defaultBranch = "main";
      user.name = "Joshua Park";
      user.email = "git@joshprk.me";
    };
  };

  xdg.config.files."niri/config.kdl" = {
    source = ./niri.kdl;
  };

  xdg.config.files."Yubico/u2f_keys" = {
    source = ./u2f_keys;
  };
}
