{config, lib, ...}: let
  cfg = config.user.nvim;
in {
  options.user.nvim = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable the Neovim home module.";
      default = false;
      apply = opt:
        lib.throwIfNot
        (builtins.hasAttr "nixvim" config.programs)
        "the neovim home module depends on nixvim"
        opt;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
      defaultEditor = true;

      withNodeJs = false;
      withPerl = false;
      withPython3 = false;
      withRuby = false;

      opts = {
        expandtab = true;
        tabstop = 2;
        softtabstop = 2;
        shiftwidth = 2;
      };
    };
  };
}
