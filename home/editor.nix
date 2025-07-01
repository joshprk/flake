{
  config,
  lib,
  pkgs,
  ...
}: {
  packages = with pkgs; [
    neovim
  ];

  dotfiles.".config/nvim/init.lua".text = ''
    vim.o.cindent = true
    vim.o.expandtab = true
    vim.o.tabstop = 2
    vim.o.softtabstop = 2
    vim.o.shiftwidth = 2
    vim.o.swapfile = false
    vim.o.undofile = true

    vim.o.cursorline = true
    vim.o.number = true
    vim.o.relativenumber = true

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  '';

  environment.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
