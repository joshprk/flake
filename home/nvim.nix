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

      plugins.blink-cmp = {
        enable = true;

        lazyLoad.settings.event = [
          "InsertEnter"
          "CmdlineEnter"
        ];
      };

      plugins.bufferline = {
        enable = true;

        lazy.settings.event = [
          "DeferredUIEnter"
        ];

        settings = {
          options = {
            mode = "buffers";
            always_show_bufferline = true;
          };
        };
      };

      plugins.lualine = {
        enable = true;

        lazyLoad.settings.event = [
          "VimEnter"
          "BufReadPost"
          "BufNewFile"
        ];
      };

      plugins.noice = {
        enable = true;

        lazyLoad.settings.event = [
          "DeferredUIEnter"
        ];

        settings.presets = {
          bottom_search = false;
          command_palette = true;
        };
      };

      performance = {
        enable = true;
        nvimRuntime = true;
      };
    };
  };
}
