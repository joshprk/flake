{pkgs, ...}: let
  nvfWithConfig = pkgs.nvf {
    vim.options.expandtab = true;
    vim.options.shiftwidth = 2;
    vim.options.tabstop = 2;
  };
in {
  packages = [nvfWithConfig];
  environment.sessionVariables.EDITOR = "nvim";
}
