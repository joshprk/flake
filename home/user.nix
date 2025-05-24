{...}: {
  /*
  Temporary module.
  This is used to enable home modules for the single-user.
  */
  user = {
    direnv.enable = true;
    env.enable = true;
    fish.enable = true;
    git.enable = true;
    ghostty.enable = true;
    nvim.enable = true;
    ripgrep.enable = true;
    stylix.enable = true;

    git.config = {
      user.name = "Joshua Park";
      user.email = "123624726+joshprk@users.noreply.github.com";
      init.defaultBranch = "main";
    };
  };
}
