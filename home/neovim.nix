{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.nixvim = {
    enable = true;
    settings = {
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
        scrolloff = 10;

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
        # Snacks.picker shortcuts
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
          action.__raw = "function() require('snacks').picker.git_files() end";
          key = "<Leader>fg";
          mode = ["n"];
          options.desc = "Find files (git-files)";
        }
        {
          action.__raw = "function() require('snacks').picker.projects() end";
          key = "<Leader>fp";
          mode = ["n"];
          options.desc = "Projects";
        }
        # AI plugins
        {
          action.__raw = ''function() require('codecompanion').toggle() end'';
          key = "<Leader>aa";
          mode = ["n" "v"];
          options.desc = "Toggle (CodeCompanion)";
        }
        # Miscellaneous plugins
        {
          action = "<Cmd>WhichKey<CR>";
          key = "<Leader>?";
          mode = ["n"];
          options.desc = "Buffer Keymaps";
        }
        # Clear hlsearch on escape
        {
          action = "<Cmd>nohlsearch<CR>";
          key = "<Esc>";
          mode = ["n"];
        }
        # Exit terminal mode on escape
        {
          action = "<C-\\><C-n>";
          key = "<Esc><Esc>";
          mode = ["t"];
        }
        # Save using <ctrl> s
        {
          action = "<Cmd>write<CR>";
          key = "<C-s>";
          mode = ["n" "i" "x" "s"];
        }
        # Better indenting
        {
          action = "<gv";
          key = "<";
          mode = ["v"];
        }
        {
          action = ">gv";
          key = ">";
          mode = ["v"];
        }
        # Move to window using <ctrl> hjkl
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
        # Resize splits using <ctrl> arrow keys
        {
          action = "<Cmd>resize +2<Cr>";
          key = "<C-Up>";
          mode = ["n"];
        }
        {
          action = "<Cmd>resize -2<Cr>";
          key = "<C-Down>";
          mode = ["n"];
        }
        {
          action = "<Cmd>vertical resize +2<Cr>";
          key = "<C-Left>";
          mode = ["n"];
        }
        {
          action = "<Cmd>vertical resize -2<Cr>";
          key = "<C-Right>";
          mode = ["n"];
        }
        # Move tabs with <Shift> hl
        {
          action = "gT";
          key = "<S-h>";
          mode = ["n"];
        }
        {
          action = "gt";
          key = "<S-l>";
          mode = ["n"];
        }
      ];

      autoCmd = [
        # Notify user on file saved
        {
          callback.__raw = "function() vim.notify('File saved') end";
          event = "BufWritePost";
          pattern = "*";
        }
        # Restore cursor position for new buffers
        {
          command = ''silent! normal! g`"zv'';
          event = "BufReadPost";
          pattern = "*";
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
        terraform_lsp.enable = true;
      };

      colorschemes.catppuccin = {
        enable = true;
        settings = {
          no_italic = true;
          lsp_styles = {
            underlines = {
              errors = ["undercurl"];
              hints = ["undercurl"];
              warnings = ["undercurl"];
              information = ["undercurl"];
            };
          };
          integrations = {
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
        settings = {
          strategies = {
            chat.adapter = "openrouter";
            inline.adapter = "openrouter";
            cmd.adapter = "openrouter";
          };
          adapters.http.openrouter.__raw = ''
            function()
              return require('codecompanion.adapters').extend('openai_compatible', {
                env = {
                  url = "https://openrouter.ai/api",
                  api_key = "OPENROUTER_API_KEY",
                  chat_url = "/v1/chat/completions",
                },
                schema = {
                  model = {
                    default = "openai/gpt-oss-20b:free",
                  },
                },
              })
            end
          '';
        };
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

      diagnostic.settings = {
        signs.text = ["󰅙" "" "󰋼" "󰌵"];
      };

      plugins.mini-icons = {
        enable = true;
        mockDevIcons = true;
      };

      plugins.mini-pairs = {
        enable = true;
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
    };
  };
}
