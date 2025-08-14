{
  config,
  lib,
  pkgs,
  ...
}: {
  packages = lib.singleton (pkgs.makeNixvim {
    withPython3 = false;
    withRuby = false;

    opts = {
      cindent = true;
      breakindent = true;
      expandtab = true;
      tabstop = 2;
      softtabstop = 2;
      shiftwidth = 2;
      swapfile = false;
      undofile = true;
      confirm = true;
      ignorecase = true;
      smartcase = true;
      scrolloff = 5;

      cursorline = true;
      number = true;
      relativenumber = true;
      signcolumn = "number";
      laststatus = 3;
      wrap = false;

      switchbuf = "newtab";
      splitright = true;
      splitbelow = true;
    };

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    keymaps = [
      {
        action.__raw = "function() require('mini.files').open() end";
        key = "<Leader><Tab>";
        mode = ["n" "x" "o"];
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
        action = "<C-w><C-h>";
        key = "<C-h>";
        mode = ["n"];
      }
      {
        action = "<C-w><C-l>";
        key = "<C-l>";
        mode = ["n"];
      }
      {
        action = "<C-w><C-j>";
        key = "<C-j>";
        mode = ["n"];
      }
      {
        action = "<C-w><C-k>";
        key = "<C-k>";
        mode = ["n"];
      }
    ];

    lsp.servers = {
      basedpyright = {
        enable = true;
        settings = {
          python.pythonPath = ".venv/bin/python";
        };
      };

      nixd = {
        enable = true;
      };
    };

    colorschemes.nord = {
      enable = true;
      settings = {
        disable_background = true;
        italic = false;
      };
    };

    plugins.blink-cmp = {
      enable = true;
      settings = {
        keymap.preset = "super-tab";
      };
    };

    plugins.codecompanion = {
      enable = true;
    };

    plugins.flash = {
      enable = true;
    };

    plugins.gitsigns = {
      enable = true;
      settings = {
        signcolumn = false;
        numhl = true;
        linehl = false;
        word_diff = false;
      };
    };

    plugins.lspconfig = {
      enable = true;
    };

    plugins.mini = {
      enable = true;
      mockDevIcons = true;
      modules = {
        files = {
          mappings.close = "<Esc>";
        };
        icons = {};
      };
    };

    plugins.snacks = {
      enable = true;
      settings = {
        bigfile.enabled = true;
        picker.enabled = true;
        terminal.enabled = true;
      };
    };

    performance = {
      byteCompileLua = {
        enable = true;
        configs = true;
        initLua = true;
        luaLib = true;
        nvimRuntime = true;
        plugins = true;
      };

      combinePlugins = {
        enable = true;
        standalonePlugins = with pkgs.vimPlugins; [
          codecompanion-nvim
        ];
      };
    };
  });

  environment.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
