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
        }
        {
          action = "<Cmd>tabnext<CR>";
          key = "s";
          mode = ["n"];
        }
        {
          action = "<Cmd>tabprev<CR>";
          key = "S";
          mode = ["n"];
        }
        {
          action = "<Cmd>FzfLua<CR>";
          key = "<Leader><Space>";
          mode = ["n" "x" "o"];
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

      plugins.bufferline = {
        enable = true;

        settings = let
          style_preset = preset: {
            __raw = ''require("bufferline").style_preset.${preset}'';
          };
        in {
          options = {
            mode = "tabs";

            style_preset = [
              (style_preset "minimal")
              (style_preset "no_bold")
              (style_preset "no_italic")
            ];

            get_element_icon = {
              __raw = ''
                function(element)
                  local provider = require("nvim-web-devicons")
                  local icon, hl = provider.get_icon_by_filetype(
                    element.filetype,
                    { default = true }
                  )
                  return " " .. icon, hl
                end
              '';
            };

            indicator.style = "underline";
            show_buffer_close_icons = false;
            show_close_icon = false;
            separator_style = ["" ""];
            tab_size = 6;
            enforce_regular_tabs = false;
            always_show_bufferline = true;
          };
        };
      };

      plugins.fzf-lua = {
        enable = true;
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

          clangd.enable = true;
          pyright.enable = true;
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

      plugins.toggleterm = {
        enable = true;
        
        settings = {
          direction = "float";
          open_mapping = "[[<Leader>q]]";
          persist_mode = true;
        };
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
