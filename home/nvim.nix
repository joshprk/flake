{
  config,
  lib,
  ...
}: let
  cfg = config.settings.nvim;
in {
  options.settings = {
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

        cursorline = true;
        number = true;
        relativenumber = true;
        signcolumn = "number";

        wrap = false;
        hidden = false;
        splitright = true;
        splitbelow = true;

        swapfile = false;
        undofile = true;

        laststatus = 3;
      };

      globals = {
        loaded_ruby_provider = 0;
        loaded_perl_provider = 0;
        loaded_python_provider = 0;

        loaded_netrwPlugin = 1;
        loaded_netrwSettings = 1;
        loaded_netrwFileHandlers = true;
        loaded_netrw_gitignore = true;
        loaded_netrw = 1;

        mapleadeer = " ";
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
        }
      ];

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

      plugins.lsp = {
        enable = true;

        servers = {
          nil_ls = {
            enable = true;

            settings = {
              nix.flake.autoArchive = true;
            };
          };

          pyright = {
            enable = true;
          };
        };
      };

      plugins.lualine = {
        enable = true;
      };

      plugins.noice = {
        enable = true;

        settings.presets = {
          bottom_search = false;
          command_palette = true;
        };
      };

      plugins.mini = {
        enable = true;
        mockDevIcons = true;

        modules = {
          icons = {};
          tabline = {tabpage_section="none";};
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

      plugins.which-key = {
        enable = true;
        settings.preset = "helix";
      };

      performance.byteCompileLua = {
        enable = true;
        nvimRuntime = true;
      };
    };
  };
}
