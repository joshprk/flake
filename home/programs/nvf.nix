{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.nvf;
in {
  options.programs.nvf = lib.mkOption {
    type = lib.types.attrs;
    readOnly = true;
    default = {
      vim.lsp = {
        enable = true;
        trouble.enable = true;
      };

      vim.languages = {
        python.enable = true;
        nix.enable = true;
        markdown.enable = true;
        rust.enable = true;
      };

      vim.options = {
        cursorline = true;
        cursorlineopt = "both";
        expandtab = true;
        scrolloff = 7;
        signcolumn = "no";
        shiftwidth = 2;
        tabstop = 2;
        laststatus = 3;
        wrap = false;
      };

      vim.hideSearchHighlight = true;

      vim.clipboard = {
        enable = true;
        registers = "unnamedplus";
        providers.wl-copy.enable = true;
      };

      vim.undoFile = {
        enable = true;
      };

      vim.extraPlugins.catppuccin = {
        package = pkgs.vimPlugins.catppuccin-nvim;
        setup = ''
          require("catppuccin").setup {
            flavour = "mocha",
            term_colors = true,
            no_italic = true,
            integrations = {
              gitsigns = true,
              telescope = true,
              noice = true,
              notify = true,
              which_key = true,
            },
          }
          vim.cmd.colorscheme "catppuccin"
        '';
      };

      vim.keymaps = [
        {
          key = "<esc><esc>";
          mode = ["t"];
          silent = true;
          action = "<C-\\><C-n>";
        }
        {
          key = "<";
          mode = ["x"];
          action = "<gv";
        }
        {
          key = ">";
          mode = ["x"];
          action = ">gv";
        }
        {
          key = "<leader>w";
          mode = ["n" "x" "o"];
          action = "<cmd>set wrap!<cr>";
        }
      ];

      vim.autocomplete = {
        blink-cmp.enable = true;
      };

      vim.autopairs.nvim-autopairs = {
        enable = true;
      };

      vim.binds = {
        whichKey.enable = true;
        whichKey.setupOpts.preset = "helix";
      };

      vim.filetree = {
        nvimTree.enable = true;
        nvimTree.openOnSetup = false;
        nvimTree.mappings.toggle = "<leader>tt";
      };

      vim.git = {
        enable = true;
        gitsigns.setupOpts = {
          signcolumn = false;
          numhl = true;
        };
      };

      vim.notify = {
        nvim-notify.enable = true;
      };

      vim.projects = {
        project-nvim.enable = true;
        project-nvim.setupOpts.manual_mode = false;
      };

      vim.snippets = {
        luasnip.enable = true;
      };

      vim.telescope = {
        enable = true;
      };

      vim.terminal = {
        toggleterm.enable = true;
      };

      vim.ui = {
        noice.enable = true;
      };

      vim.utility = {
        direnv.enable = true;
        smart-splits.enable = true;
        motion.flash-nvim.enable = true;
      };

      vim.visuals = {
        highlight-undo.enable = true;
        indent-blankline.enable = true;
        nvim-web-devicons.enable = true;
      };
    };
  };

  config = {
    packages = [
      (pkgs.nvf cfg)
    ];

    environment.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };
}
