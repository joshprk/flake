{
  config,
  lib,
  pkgs,
  ...
}: {
  packages = lib.singleton (pkgs.nixvim.makeNixvim {
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
      updatetime = 750;
    };

    keymaps = [
      {
        action.__raw = "function() require('snacks').picker.files() end";
        key = "<Leader><Space>";
        mode = ["n"];
        options.desc = "Find Files";
      }
      {
        action.__raw = "function() require('snacks').picker.buffers() end";
        key = "<Leader>,";
        mode = ["n"];
        options.desc = "Buffers";
      }
      {
        action.__raw = "function() require('snacks').picker.grep() end";
        key = "<Leader>/";
        mode = ["n"];
        options.desc = "Grep";
      }
      {
        action.__raw = "function() require('snacks').picker.command_history() end";
        key = "<Leader>:";
        mode = ["n"];
        options.desc = "Command History";
      }
      {
        action.__raw = "function() require('snacks').picker.notifications() end";
        key = "<Leader>n";
        mode = ["n"];
        options.desc = "Notification History";
      }
      {
        action = "<Cmd>CodeCompanionChat<CR>";
        key = "<Leader>ai";
        mode = ["n"];
        options.desc = "CodeCompanion";
      }
      {
        action = "<Cmd>WhichKey<CR>";
        key = "<Leader>?";
        mode = ["n"];
        options.desc = "Buffer Keymaps";
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
          analysis = {
            typeCheckingMode = "basic";
            autoImportCompletions = true;
            autoSearchPaths = true;
            useLibraryCodeForTypes = true;
            diagnosticMode = "openFilesOnly";
          };
        };
      };

      nixd.enable = true;
      ruff.enable = true;
    };

    colorschemes.catppuccin = {
      enable = true;
      settings = {
        no_italic = true;
        integrations = {
          native_lsp.underlines = {
            errors = ["undercurl"];
            hints = ["undercurl"];
            warnings = ["undercurl"];
            information = ["undercurl"];
          };
          noice = true;
          snacks.enabled = true;
          which_key = true;
        };
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

    plugins.mini-icons = {
      enable = true;
      mockDevIcons = true;
    };

    plugins.noice = {
      enable = true;
      settings = {
        presets.command_palette = true;
      };
    };

    plugins.project-nvim = {
      enable = true;
    };

    plugins.snacks = {
      enable = true;
      settings = {
        bigfile.enabled = true;
        indent = {
          enabled = true;
          animate.enabled = false;
          scope.enabled = false;
        };
        input.enabled = true;
        picker.enabled = true;
      };
    };

    plugins.which-key = {
      enable = true;
      settings = {
        preset = "helix";
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
