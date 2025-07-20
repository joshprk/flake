{pkgs, ...}: {
  imports = [];

  config = {
    packages = with pkgs; [
      git
      ghostty
      neovim
    ];
  };
}
