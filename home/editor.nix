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
      wrap = false;
    };

    lsp.servers = {
      basedpyright = {
        enable = true;
      };

      nil_ls = {
        enable = true;
      };
    };

    plugins.blink-cmp = {
      enable = true;
      settings = {
        keymap.preset = "super-tab";
      };
    };

    plugins.lspconfig = {
      enable = true;
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
