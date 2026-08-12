{pkgs, ...}: {
  packages = with pkgs; [direnv];

  xdg.config.files = {
    "direnv/direnv.toml" = {
      generator = (pkgs.formats.toml {}).generate "direnv-config";
      value = {
        global.disable_stdin = true;
        global.hide_env_diff = true;
        global.warn_timeout = "0ms";
      };
    };
    "direnv/lib/nix-direnv.sh".source = "${pkgs.nix-direnv}/share/nix-direnv/direnvrc";
  };
}
