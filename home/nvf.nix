{pkgs, ...}: let
  nvf = pkgs.nvf {
    vim.options = {
      expandtab = true;
      shiftwidth = 2;
      tabstop = 2;
    };
  };
in {
  packages = [nvf];
}
