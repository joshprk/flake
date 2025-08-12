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
      expandtab = true;
      tabstop = 2;
      softtabstop = 2;
      shiftwidth = 2;
      swapfile = false;
      undofile = true;

      cursorline = true;
      number = true;
      relativenumber = true;
      signcolumn = "number";
      laststatus = 3;
      wrap = false;
    };

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

    plugins.flash = {
      enable = true;
    };

    plugins.lspconfig = {
      enable = true;
    };

    plugins.mini-icons = {
      enable = true;
      mockDevIcons = true;
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
      combinePlugins.enable = true;
    };
  });

  environment.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
