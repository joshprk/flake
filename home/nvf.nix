{pkgs, ...}: let
  nvfWithConfig = pkgs.nvf {
    vim = {
      autocomplete.blink-cmp.enable = true;
      autopairs.nvim-autopairs.enable = true;
      binds.whichKey = {
        enable = true;
        setupOpts.preset = "helix";
      };
      git.gitsigns = {
        enable = true;
        setupOpts.numhl = true;
      };
      hideSearchHighlight = true;
      languages = {
        python.enable = true;
        nix.enable = true;
        markdown.enable = true;
        rust.enable = true;
        typescript.enable = true;
        tsx.enable = true;
      };
      options = {
        expandtab = true;
        laststatus = 3;
        scrolloff = 7;
        shiftwidth = 2;
        signcolumn = "no";
        tabstop = 2;
        wrap = false;
      };
      telescope.enable = true;
      theme = {
        enable = true;
        name = "catppuccin";
        style = "mocha";
        transparent = true;
      };
      utility = {
        direnv.enable = true;
        motion.flash-nvim.enable = true;
        oil-nvim.enable = true;
      };
      undoFile.enable = true;
      visuals = {
        highlight-undo.enable = true;
        indent-blankline.enable = true;
        nvim-web-devicons.enable = true;
      };
    };
  };
in {
  packages = [nvfWithConfig];
  environment.sessionVariables.EDITOR = "nvim";
}
