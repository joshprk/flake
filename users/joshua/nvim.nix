{
  config,
  lib,
  ...
}: let
  cfg = config.users.nvim;
in {
  options.user = {
    nvim = {
      enable = lib.mkEnableOption "the Neovim home module";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
      defaultEditor = true;

      opts = {
        expandtab = true;
        tabstop = 2;
        softtabstop = 2;
        shiftwidth = 2;
        wrap = false;

        cursorline = true;
        number = true;
        relativenumber = true;
        signcolumn = "number";

        hidden = false;
        splitright = true;
        splitbelow = true;

        laststatus = 3;
      };

      globals = {
        mapleader = " ";
        maplocalleader = ",";
      };

      highlight = {
        DiagnosticUnderlineError.undercurl = true;
        DiagnosticUnderlineHint.undercurl = true;
        DiagnosticUnderlineInfo.undercurl = true;
        DiagnosticUnderlineOk.undercurl = true;
        DiagnosticUnderlineWarn.undercurl = true;
      };

      keymaps = [
        {
          action = ''"+ygv'';
          key = "<C-c>";
          mode = ["v"];
          options.silent = true;
        }
        {
          action = "<Cmd>FzfLua live_grep<CR>";
          key = "<leader><Space>";
          mode = ["n"];
          options.desc = "Open live grep";
        }
        {
          action = ''<Cmd>lua require("flash").jump()<CR>'';
          key = "f";
          mode = ["n" "x" "o"];
        }
        {
          action = ''<Cmd>lua require("flash").treesitter()<CR>'';
          key = "F";
          mode = ["n" "x" "o"];
        }
        {
          action = "<Cmd>bnext<CR>";
          key = "<Tab>";
          mode = ["n"];
        }
        {
          action = "<Cmd>bprev<CR>";
          key = "<C-Tab>";
          mode = ["n"];
        }
      ];

      autoCmd = [];

      colorschemes = {
        catppuccin = {
          enable = true;
          settings = {
            no_italic = true;
            transparent_background = true;
            custom_highlights = config.programs.nixvim.highlight;
          };
        };
      };

      plugins.blink-cmp = {
        enable = true;
        settings = {
          keymap.preset = "super-tab";
        };
      };

      plugins.flash = {
        enable = true;
      };

      plugins.fzf-lua = {
        enable = true;
      };

      plugins.lsp = {
        enable = true;
        servers = {
          clangd = {
            enable = true;
          };

          nil_ls = {
            enable = true;
          };

          pyright = {
            enable = true;
          };

          rust_analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
            installRustfmt = false;
          };
        };
      };

      plugins.lualine = {
        enable = true;
      };

      plugins.mini = {
        enable = true;
        mockDevIcons = true;
        modules = {
          git = {};
          icons = {};
          tabline = {
            tabpage_section = "none";
          };
        };

        luaConfig.post = ''
          local signs = {
            DiagnosticSignError = { text = "󰅙", },
            DiagnosticSignWarn = { text = "", },
            DiagnosticSignHint = { text = "", },
            DiagnosticSignInfo = { text = "", },
          }

          for i, v in pairs(signs) do
            vim.fn.sign_define(i, v)
          end
        '';
      };

      plugins.noice = {
        enable = true;
        settings = {
          presets.command_palette = true;
        };
      };

      plugins.treesitter = {
        enable = true;
      };

      plugins.which-key = {
        enable = true;
        settings.preset = "helix";
      };
    };
  };
}
