{pkgs, ...}: {
  packages = with pkgs; [btop];

  xdg.config.files."btop/btop.conf".text = ''
    theme_background = false
  '';
}
