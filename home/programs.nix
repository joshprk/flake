{config, ...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    dotDir = ".config/zsh";
    history.path = "${config.xdg.dataHome}/zsh/zsh_history";
    completionInit = ''
      autoload -U compinit
      [ -d ${config.xdg.cacheHome}/zsh ] || mkdir -p ${config.xdg.cacheHome}/zsh
      zstyle ':completion:*' cache-path ${config.xdg.cacheHome}/zsh/zcompcache
      compinit -d ${config.xdg.cacheHome}/zsh/zcompdump
    '';
  };

  programs.git = {
    enable = true;
    userEmail = "joshuprk@gmail.com";
    userName = "Joshua Park";

    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
  };
}
