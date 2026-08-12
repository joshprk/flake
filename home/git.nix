{pkgs, ...}: {
  packages = with pkgs; [git];

  xdg.config.files."git/config" = {
    generator = (pkgs.formats.gitIni {}).generate "gitconfig";
    value = {
      init.defaultBranch = "main";
      user.name = "Joshua Park";
      user.email = "git@joshprk.me";
    };
  };
}
