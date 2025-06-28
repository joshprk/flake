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
    vim.o.expandtab = true
    vim.o.tabstop = 2
    vim.o.softtabstop = 2
    vim.o.shiftwidth = 2
  '';

  environment.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
