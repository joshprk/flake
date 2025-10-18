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
        # Text editing options
        clipboard = "unnamedplus";
        cindent = true;
        breakindent = true;
        ignorecase = true;
        smartcase = true;
        expandtab = true;
        tabstop = 2;
        softtabstop = 2;
        shiftwidth = 2;
        scrolloff = 10;
        sidescrolloff = 8;
        wrap = false;

        # Persistence options
        swapfile = false;
        undofile = true;
        confirm = true;

        # UI options
        cursorline = true;
        number = true;
        relativenumber = true;
        signcolumn = "number";
        switchbuf = "newtab";
        splitright = true;
        splitbelow = true;
        laststatus = 3;
        updatetime = 750;
      };

      globals = {
        mapleader = " ";
        maplocalleader = " ";
      };

      keymaps = [
        # Snacks.picker shortcuts
        {
          action.__raw = "function() require('snacks').picker.files() end";
          key = "<leader><space>";
          mode = ["n"];
          options.desc = "Find Files";
        }
        {
          action.__raw = "function() require('snacks').picker.buffers() end";
          key = "<leader>,";
          mode = ["n"];
          options.desc = "Buffers";
        }
        {
          action.__raw = "function() require('snacks').picker.grep() end";
          key = "<leader>/";
          mode = ["n"];
          options.desc = "Grep";
        }
        {
          action.__raw = "function() require('snacks').picker.command_history() end";
          key = "<leader>:";
          mode = ["n"];
          options.desc = "Command History";
        }
        {
          action.__raw = "function() require('snacks').picker.notifications() end";
          key = "<leader>n";
          mode = ["n"];
          options.desc = "Notification History";
        }
        {
          action.__raw = "function() require('snacks').picker.git_files() end";
          key = "<leader>fg";
          mode = ["n"];
          options.desc = "Find files (git-files)";
        }
        {
          action.__raw = "function() require('snacks').picker.projects() end";
          key = "<leader>fp";
          mode = ["n"];
          options.desc = "Projects";
        }
        # AI plugins
        {
          action.__raw = ''function() require('codecompanion').toggle() end'';
          key = "<leader>aa";
          mode = ["n" "v"];
          options.desc = "Toggle (CodeCompanion)";
        }
        # Miscellaneous plugins
        {
          action = "<cmd>WhichKey<cr>";
          key = "<leader>?";
          mode = ["n"];
          options.desc = "Keymaps";
        }
        # Tab helpers
        {
          action = "<cmd>tablast<cr>";
          key = "<leader><tab>l";
          mode = ["n"];
          options.desc = "Last Tab";
        }
        {
          action = "<cmd>tabonly<cr>";
          key = "<leader><tab>o";
          mode = ["n"];
          options.desc = "Close Other Tabs";
        }
        {
          action = "<cmd>tabfirst<cr>";
          key = "<leader><tab>f";
          mode = ["n"];
          options.desc = "First Tab";
        }
        {
          action = "<cmd>tabnew<cr>";
          key = "<leader><tab><tab>";
          mode = ["n"];
          options.desc = "New Tab";
        }
        {
          action = "<cmd>tabclose<cr>";
          key = "<leader><tab>d";
          mode = ["n"];
          options.desc = "Close Tab";
        }
        # Clear hlsearch on escape
        {
          action = "<cmd>nohlsearch<cr>";
          key = "<Esc>";
          mode = ["n"];
        }
        # Exit terminal mode on escape
        {
          action = "<c-\\><c-n>";
          key = "<Esc><Esc>";
          mode = ["t"];
        }
        # Save using <ctrl> s
        {
          action = "<cmd>write<cr>";
          key = "<c-s>";
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
          action = "<c-w><c-h>";
          key = "<c-h>";
          mode = ["n"];
        }
        {
          action = "<c-w><c-l>";
          key = "<c-l>";
          mode = ["n"];
        }
        {
          action = "<c-w><c-j>";
          key = "<c-j>";
          mode = ["n"];
        }
        {
          action = "<c-w><c-k>";
          key = "<c-k>";
          mode = ["n"];
        }
        # Resize splits using <ctrl> arrow keys
        {
          action = "<cmd>resize +2<cr>";
          key = "<c-Up>";
          mode = ["n"];
        }
        {
          action = "<cmd>resize -2<cr>";
          key = "<c-Down>";
          mode = ["n"];
        }
        {
          action = "<cmd>vertical resize +2<cr>";
          key = "<c-Left>";
          mode = ["n"];
        }
        {
          action = "<cmd>vertical resize -2<cr>";
          key = "<c-Right>";
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
        # Resize splits if window size changes
        {
          callback.__raw = ''
            function()
              local current_tab = vim.fn.tabpagenr()
              vim.cmd('tabdo wincmd =')
              vim.cmd('tabnext ' .. current_tab)
            end
          '';
          event = "VimResized";
          pattern = "*";
        }
        # Ensure intermediary directories exist before file write
        {
          callback.__raw = ''
            function(event)
              if event.match:match('^%w%w+:[\\/][\\/]') then return end
              local file = vim.uv.fs_realpath(event.match) or event.match
              vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
            end
          '';
          event = "BufWritePre";
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
