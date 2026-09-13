{pkgs, ...}: let
  nvfWithConfig = pkgs.nvf {
    vim = {
      autocomplete.blink-cmp.enable = true;
      autopairs.nvim-autopairs.enable = true;
      binds.whichKey = {
        enable = true;
        setupOpts.preset = "helix";
      };
      enableLuaLoader = true;
      git.gitsigns = {
        enable = true;
        setupOpts = {
          numhl = true;
          attach_to_untracked = true;
        };
      };
      hideSearchHighlight = true;
      keymaps = [
        {
          key = "-";
          mode = "n";
          action = "<cmd>Oil<cr>";
        }
      ];
      languages = {
        enableTreesitter = true;
        python.enable = true;
        nix.enable = true;
        markdown.enable = true;
        rust.enable = true;
        typescript.enable = true;
        tsx.enable = true;
      };
      lsp.enable = true;
      options = {
        confirm = true;
        expandtab = true;
        laststatus = 3;
        scrolloff = 7;
        shiftwidth = 2;
        signcolumn = "no";
        tabstop = 2;
        wrap = false;
      };
      projects.project-nvim = {
        enable = true;
        setupOpts = {
          manual_mode = false;
          scope_chdir = "tab";
        };
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
        oil-nvim = {
          enable = true;
          gitStatus.enable = true;
        };
      };
      undoFile.enable = true;
      visuals = {
        indent-blankline = {
          enable = true;
          setupOpts.scope.enabled = false;
        };
        nvim-web-devicons.enable = true;
      };
    };
  };
in {
  packages = [nvfWithConfig];
  environment.sessionVariables.EDITOR = "nvim";
}
