{
  config,
  lib,
  ...
}: let
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

        cursorline = true;
        number = true;
        relativenumber = true;
        signcolumn = "number";
        ignorecase = true;
        smartcase = true;

        wrap = false;
        hidden = false;
        splitright = true;
        splitbelow = true;
        scrolloff = 5;

        swapfile = false;
        undofile = true;
        laststatus = 3;
        confirm = true;
      };

      globals = {
        loaded_netrwPlugin = 1;
        loaded_netrwSettings = 1;
        loaded_netrwFileHandlers = true;
        loaded_netrw_gitignore = true;
        loaded_netrw = 1;
        loaded_tutor = 1;
        loaded_tutor_mode_plugin = 1;
        loaded_2html_plugin = 1;
        loaded_gzip = 1;
        loaded_tar = 1;
        loaded_tarPlugin = 1;
        loaded_zip = 1;
        loaded_zipPlugin = 1;

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

      autoCmd = [
        {
          command = ''silent! normal! g`"zv'';
          event = ["BufReadPost"];
          pattern = ["*"];
        }
        {
          command = "if exists(':rshada') | rshada | wshada | endif";
          event = ["CursorHold" "TextYankPost" "FocusGained" "FocusLost"];
          pattern = ["*"];
        }
      ];

      keymaps = [
        {
          action = ''"+ygv'';
          key = "<C-c>";
          mode = ["v"];
        }
        {
          action = "<Cmd>nohlsearch<CR>";
          key = "<Esc>";
          mode = ["n"];
        }
        {
          action = "<C-\\><C-n>";
          key = "<Esc><Esc>";
          mode = ["t"];
        }
        {
          action = "<Cmd>tabnext<CR>";
          key = "<Tab>";
          mode = ["n"];
        }
        {
          action = "<Cmd>tabprev<CR>";
          key = "<S-Tab>";
          mode = ["n"];
        }
        {
          action = "<Cmd>FzfLua<CR>";
          key = "<Leader><Tab>";
          mode = ["n" "x" "o"];
          options.desc = " Open FzfLua";
        }
        {
          action = "<Cmd>FzfLua buffers<CR>";
          key = "<Leader><Space>";
          mode = ["n" "x" "o"];
          options.desc = " Buffers";
        }
        {
          action.__raw = ''function() require("flash").jump() end'';
          key = "<Leader>f";
          mode = ["n" "x" "o"];
          options.desc = " Flash";
        }
        {
          action.__raw = ''function() require("flash").treesitter() end'';
          key = "<Leader>F";
          mode = ["n" "x" "o"];
          options.desc = " Flash Treesitter";
        }
        {
          action.__raw = ''function() require("mini.files").open() end'';
          key = "<C-e>";
          mode = ["n" "x" "o"];
          options.desc = "󰱼 Open Files";
        }
        {
          action = "<Cmd>ToggleTerm<CR>";
          key = "<Leader>.";
          mode = ["n" "x" "o"];
          options.desc = " Open Terminal";
        }
      ];

      colorschemes = {
        catppuccin = {
          enable = true;
          lazyLoad.enable = true;
          settings = {
            no_italic = true;
            transparent_background = true;
            custom_highlights = config.programs.nixvim.highlight;
          };
        };
      };

      diagnostic.settings = {
        signs = {
          text = {
            "vim.diagnostic.severity.ERROR" = "󰅙";
            "vim.diagnostic.severity.WARN" = "";
            "vim.diagnostic.severity.HINT" = "";
            "vim.diagnostic.severity.INFO" = "";
          };
        };
        virtual_text = true;
      };

      plugins.blink-cmp = {
        enable = true;
        settings = {
          keymap.preset = "super-tab";
        };
      };

      plugins.bufferline = {
        enable = true;
        lazyLoad.settings.event = "VimEnter";

        settings.options = {
          style_preset = let
            style_preset = preset: {
              __raw = ''require("bufferline").style_preset.${preset}'';
            };
          in [
            (style_preset "minimal")
            (style_preset "no_bold")
            (style_preset "no_italic")
          ];

          get_element_icon.__raw = ''
            function(element)
              local provider = require("nvim-web-devicons")
              local icon, hl = provider.get_icon_by_filetype(
                element.filetype,
                { default = true }
              )
              return " " .. icon, hl
            end
          '';

          mode = "tabs";
          indicator.style = "underline";
          show_buffer_close_icons = false;
          show_close_icon = false;
          separator_style = ["" ""];
          tab_size = 6;
          enforce_regular_tabs = false;
          always_show_bufferline = true;
        };
      };

      plugins.dropbar = {
        enable = true;
        lazyLoad.settings.event = "DeferredUIEnter";
      };

      plugins.flash = {
        enable = true;
        lazyLoad.settings.event = "DeferredUIEnter";
      };

      plugins.fzf-lua = {
        enable = true;
        lazyLoad.settings.cmd =
          ["FzfLua"]
          ++ (
            lib.optionals
            config.programs.nixvim.plugins.noice.enable ["Noice fzf"]
          );
      };

      plugins.lsp = {
        enable = true;
        servers = {
          astro.enable = true;
          clangd.enable = true;
          pyright.enable = true;
          nixd.enable = true;
          ts_ls.enable = true;
        };
      };

      plugins.lualine = {
        enable = true;
        lazyLoad.settings.event = "VimEnter";

        settings.options = {
          globalstatus = true;
        };
      };

      plugins.lz-n = {
        enable = true;
      };

      plugins.noice = {
        enable = true;
        lazyLoad.settings.event = "DeferredUIEnter";

        settings.presets = {
          bottom_search = false;
          command_palette = true;
        };
      };

      plugins.mini = {
        enable = true;
        mockDevIcons = true;

        modules = {
          ai = {n_lines = 500;};
          diff = {style = "number";};
          files = {};
          icons = {};
          surround = {};
        };
      };

      plugins.toggleterm = {
        enable = true;
        lazyLoad.settings.event = "DeferredUIEnter";
      };

      plugins.treesitter = {
        enable = true;
        lazyLoad.settings.event = "DeferredUIEnter";

        settings = {
          folding = true;
          highlight.enable = true;
          indent.enable = true;
        };
      };

      plugins.which-key = {
        enable = true;
        lazyLoad.settings.event = "DeferredUIEnter";

        settings = {
          preset = "helix";
        };
      };

      performance.byteCompileLua = {
        enable = true;
        configs = true;
        initLua = true;
        nvimRuntime = true;
        plugins = true;
      };

      performance.combinePlugins.enable = true;
      luaLoader.enable = true;
    };
  };
}
